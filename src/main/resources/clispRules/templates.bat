(defglobal
    ?*true* 	                = yes
    ?*false*                    = no
    ?*LOW-PRIORITY*             = -10000
    ?*HIGH-PRIORITY*            = 10000

    ?*sun*                      = no
    ?*rain*                     = no
    ?*storm*                    = no
    ?*pressure*                 = no

    ?*fishRangeMod*             = 2
    ?*birdRangeMod*             = 4
    ?*foresterRangeMod*         = 3
    ?*anglerPoacherRangeMod*    = 1

    ?*maxRange*                 = 6
    ?*lakeWidth*                = 0
    ?*lakeHeight*               = 0
)

(deftemplate doWeather
    (slot done
        (type SYMBOL)
        (allowed-symbols yes no)
        (default no))
    (multislot random
		(type SYMBOL)
		(allowed-symbols sun storm rain pressure)
		(default sun))
)

(deftemplate field
	"template for field"
    (slot id	
		(type INTEGER))
	(slot x 
		(type INTEGER))
	(slot y	
		(type INTEGER))
	(slot occupied	
		(type SYMBOL)	
		(allowed-symbols yes no))
	(slot water
		(type SYMBOL)
		(allowed-symbols yes no))
)

(deftemplate actor
    ;-----------------computing----------------------;
    (slot logicDone
        (type INTEGER)
        (default 0))
    (slot actionDone
        (type SYMBOL)
        (allowed-symbols yes no none)
        (default none))
    ;-----------------computing----------------------;

    ;-----------------description--------------------;
	(slot id		
		(type STRING))           ;ID actora + getName()
	(slot type
		(type SYMBOL)
		(allowed-symbols 
			bird herbivore_fish predator_fish poacher forester angler))         	;actors type, check for Java#LakeActors enum for possible values
    ;-----------------description--------------------;

    ;-----------------location----------------------;
	(slot atField
		(type INTEGER))            ;location field-id
    (slot wasField
        (type INTEGER)
        (default -1))
	(slot isMoveChanged
	    (type SYMBOL)
	    (allowed-symbols yes no))
    ;-----------------location----------------------;

    ;-----------------generic-abilities--------------;
    (slot canAttack
		(type SYMBOL)
		(allowed-symbols yes no))
    (slot canFly
		(type SYMBOL)
		(allowed-symbols yes no))
    (slot canSwim
		(type SYMBOL)
		(allowed-symbols yes no))
    ;-----------------generic-abilities--------------;

    ;-----------------generic-properties--------------;
    (slot weight
        (type INTEGER))
    (slot hp
		(type INTEGER))           		;behavior different for each actor
    (slot isAlive
		(type SYMBOL)
		(allowed-symbols yes no))
    (slot visionRange
		(type INTEGER))  				;how far can we look in to the void
    (slot attackRange
		(type INTEGER))  				;can we attack from distance
    (slot attackPower
		(type INTEGER))  				;how good we are in killing
    (slot moveRange
		(type INTEGER))    				;how far can we go
	(slot hunger	
		(type INTEGER))
	(slot howManyFishes
		(type INTEGER))
    ;-----------------generic-properties--------------;

    ;-----------------attack-properties---------------;
    (slot targetId
		(type INTEGER))     			;id of the actor we want to attack
    (slot targetHit
		(type SYMBOL)
		(allowed-symbols yes no))    	;was actor hit
	(slot aggressive
		(type SYMBOL)					;is actor aaggresive	
		(allowed-symbols yes no))
    ;-----------------attack-properties---------------;

    ;-----------------corruption-properties-----------;
    (slot cash
		(type INTEGER))                 ;can we pay over threshold
    (slot corruptionThreshold
		(type INTEGER))  				;threshold over which poacher can be payed off
    (slot validId
		(type SYMBOL)
		(allowed-symbols yes no))       ;if angler/poacher has no ID - fee, decrement cash
	(slot tookBribe
	    (type SYMBOL)
	    (allowed-symbols yes no)
	    (default no))
    ;-----------------corruption-properties-----------;
)

;----------------------functions------------------------;
    ;-------------------utility-------------------------;
    (deffunction countFacts (?template)
        (length (find-all-facts ((?fct ?template)) TRUE))
    )
    (deffunction findFieldByXY (?x ?y)
    	(do-for-fact ((?field field))
    	    (and
    	        (eq ?field:x ?x)
    	        (eq ?field:y ?y)
    	    )
    		(return ?field:id)
    	)
    )
    ;-------------------utility-------------------------;
    ;------------------move-drawing-functions-----------;
    (deffunction applyRangeMod(?range ?rm)
        (bind ?tmp 0)
        (if (= ?rm 0) then
            (bind ?tmp ?rm)
        else then
            (if (< ?rm 0) then
                (bind ?tmp 0)
            else then
                (bind ?tmp ?rm)
            )
            (if (> ?tmp ?*maxRange*) then (bind ?tmp ?*maxRange*))
        )
        ;(printout t "Applying range mode=" ?tmp crlf)
        (return ?tmp)
    )

    (defgeneric affectRangeByWeather)
    (defmethod affectRangeByWeather ((?range INTEGER) (?actor-type SYMBOL) (?id STRING))
        (return ?range)
    )

    (deffunction euclideanDistance(?x ?y ?tX ?tY)
        (return (sqrt (+ (abs (- ?x ?tX)) (abs (- ?y ?tY)) )))
    )

    (deffunction isActorInRange(?x ?y ?tX ?tY ?range)
        (if ( >= ?range (euclideanDistance ?x ?y ?tX ?tY) ) then
            (return 1)
        else then
            (return 0)
        )
    )

    (deffunction isActorInRangeByField (?ff-id ?tf-id ?range)
        (do-for-fact
            ((?ff field) (?tf field))
            (and
                (eq ?ff:id ?ff-id)
                (eq ?tf:id ?tf-id)
            )
            (return (isActorInRange ?ff:x ?ff:y ?tf:x ?tf:y ?range))
        )
        (return 0)
    )

    ;generic method
    (defgeneric nextFieldId)

    ;1. specialized impl one - however still generic, it requires first two arguments to be passed
    (defmethod nextFieldId ( (?currentNextField-Id INTEGER) (?actor-type SYMBOL) ($?actor-id STRING) )
        (bind ?nextField -1)
        (while (= ?nextField -1)
            (bind ?nextField (random ?currentNextField-Id (countFacts field)))
            (do-for-fact
                ((?field field))
                (and
                    (eq     ?field:occupied     ?*false*)
                    (eq     ?field:id           ?nextField)
                )
                ;(printout t "NFI::RANDOM nextFieldId=" ?field:id crlf)
                (return ?field:id)
            )
        )
        (return ?nextField)
    )

    ;2. specialized impl - requires first two arguments to be passed, will be called only if ?actor-type is *-fish
    (defmethod nextFieldId(
        (?currentNextField-Id INTEGER)
        (?actor-type SYMBOL (or
                                (eq ?actor-type herbivore_fish) (eq ?actor-type predator_fish)))
        ($?actor-id STRING))

        (bind ?nextField -1)
        (while (= ?nextField -1)
            (bind ?nextField (random ?currentNextField-Id (countFacts field)))
            (do-for-fact
                ((?waterField field))
                (and
                    (eq ?waterField:occupied    ?*false*)
                    (eq ?waterField:water       ?*true*)
                    (eq ?waterField:id          ?nextField)
                )
                ;(printout t "NFI::FISHES nextFieldId=" ?waterField:id crlf)
                (return ?waterField:id)
            )
        )

        (return -1)
    )

    ;3. specialized impl - requires first two arguments to be passed, will be called only if ?actor-type is angler,poacher or forester
    (defmethod nextFieldId(
        (?currentNextField-Id INTEGER)
        (?actor-type SYMBOL (or
                                (eq ?actor-type angler) (eq ?actor-type poacher) (eq ?actor-type forester)))
        ($?actor-id STRING))

        (bind ?nextField -1)
        (while (= ?nextField -1)
            (bind ?nextField (random ?currentNextField-Id (countFacts field)))
            (do-for-fact
            ((?landField field) (?landField2 field))
                (and
                    (eq ?landField:occupied     ?*false*)
                    (eq ?landField:water        ?*false*)
                    (eq ?landField:id           ?nextField)
                )
                ;(printout t "NFI::ANGLER/POACHER/FORESTER nextFieldId=" ?landField:id crlf)
                (return ?landField:id)
            )
        )
        (return -1)
    )

    ;------------------move-drawing-functions-----------;
    ;------------------type-checking--------------------;
    (deffunction check_type_pred(?actor-type)
    	(if  (eq ?actor-type predator_fish)
    		then (return 1)
    	)
    	(return 0)
    )
    (deffunction check_type_herbi(?actor-type)
    	(if  (eq ?actor-type herbivore_fish)
    		then (return 1)
    	)
    	(return 0)
    )
    ;------------------type-checking--------------------;
;----------------------functions------------------------;

;----------------------rules----------------------------;
    ;------------------kill-rules------------------------;
    (defrule kill
        (declare (salience ?*HIGH-PRIORITY*))
    	?actor <- (actor (id ?a-id) (atField ?a-af) (type ?a-type) (hp ?hp) (isAlive ?isAlive) (cash ?cash))
    	(test
            (or
                (< ?hp 0)
                (< ?cash 0)
            )
    	)
    	=>
    	(retract ?actor)
    	(do-for-fact ((?field field))
    	    (eq ?field:id ?a-af)
    	    (modify ?field (occupied ?*false*))
    	)
		(printout t ?a-id "/" ?a-type " is no longer alive..." crlf)
    )
    (defrule killByBribe
        (declare (salience ?*HIGH-PRIORITY*))
    	?actor <- (actor (id ?a-id) (type ?a-type) (hp ?hp) (cash ?cash) (isAlive yes) (tookBribe yes))
    	=>
        (modify ?actor (hp (- ?hp 10)) (tookBribe ?*false*))
		(printout t ?a-id "/" ?a-type " has took bribe, decrementing his HP" crlf)
    )
    ;------------------kill-rules------------------------;
	;------------------move-rules------------------------;
        ;------------------create-move-rule------------------;
        (deftemplate doBeforeMove
            (slot actor (type STRING))
        )
        (defrule doMove_step1
            (declare (salience 6665))
            ?dbm        <-  (doBeforeMove   (actor ?a-id))
            ?vActor     <-  (actor          (id ?a-id)
                                            (moveRange ?a-mr)
                                            (type ?a-t)
                                            (logicDone 1)
                                            (isMoveChanged no)
                            )
            =>
            (retract ?dbm)
            (if (<> ?a-mr 0) then
                (bind   ?rangeMod       (applyRangeMod ?a-mr (affectRangeByWeather ?a-mr ?a-t ?a-id)))
                (modify ?vActor         (moveRange ?rangeMod) (logicDone 2))
            else then
                (modify ?vActor (logicDone 2))
            )

            ;(printout t "doMove_step1, actor-id=" ?a-id  crlf)
        )
        (defrule doMove_step2_zeroRange
            (declare (salience 6664))
            ?actor      <-  (actor  (id ?a-id)
                                    (atField ?ff-id)
                                    (wasField ?a-wf)
                                    (moveRange ?a-mr)
                                    (type ?a-t)
                                    (logicDone 2)
                                    (isMoveChanged no)
                            )
            ?fromField  <-  (field  (id ?ff-id)
                                    (x ?ff-x)
                                    (y ?ff-y)
                                    (occupied yes)
                            )
            (test (= ?a-mr 0))
            =>
            (modify ?actor
                (logicDone 3)
                (isMoveChanged ?*true*)
            )
            (printout t ?a-id "/" ?a-t " not moved, has 0 move range" crlf)
        )
        (defrule doMove_step2
            (declare (salience 6663))
            ?actor      <-  (actor  (id ?a-id)
                                    (atField ?ff-id)
                                    (wasField ?a-wf)
                                    (moveRange ?a-mr)
                                    (type ?a-t)
                                    (logicDone 2)
                                    (isMoveChanged no)
                            )
            ?fromField  <-  (field  (id ?ff-id)
                                    (x ?ff-x)
                                    (y ?ff-y)
                                    (occupied yes)
                            )
            (test (<> ?a-mr 0))
            =>
            (bind ?tf-id (nextFieldId 0 ?a-t ?a-id))
            (if (> ?tf-id 0) then
                (do-for-fact ( (?toField field) )
                    (eq ?toField:id ?tf-id)
                    (modify ?toField
                        (occupied ?*true*)
                    )
                    (modify ?fromField
                        (occupied ?*false*)
                    )
                    (modify ?actor
                        (atField ?tf-id)
                        (wasField ?ff-id)
                        (logicDone 3)
                        (isMoveChanged ?*true*)
                    )
                    (printout t ?a-id "/" ?a-t " moved from [" ?ff-id "=[" ?ff-x ":" ?ff-y "]] to [" ?tf-id "=[" ?toField:x ":" ?toField:y "]] with range " ?a-mr "." crlf)
                )
            else then
                (modify ?actor
                    (logicDone 3)
                    (isMoveChanged ?*true*)
                )
                (printout t ?a-id "/" ?a-t " not moved, no available field" crlf)
            )

        )
        ;------------------create-move-rule------------------;
	;------------------move-rules-----------------------;

    ;-----------------------main-loop--------------------;
        (defrule doWeatherLogic
            (declare (salience 7777))
            ?dw   <-  (doWeather (random $?conditions))
            =>
            (bind ?max (length$ ?conditions))
            (bind ?index (random 0 ?max))
            (bind ?condition (nth$ ?index ?conditions))

            ;reset
            (bind ?*sun* ?*false*)
            (bind ?*rain* ?*false*)
            (bind ?*storm* ?*false*)
            ;reset

            (if (eq ?condition rain) then
                (bind ?*rain* ?*true*)
            )
            (if (eq ?condition storm) then
                (bind ?*storm* ?*true*)
            )
            (if (eq ?condition sun) then
                (bind ?*sun* ?*true*)
            )
            (if (eq ?condition nil) then
                (bind ?*sun* ?*true*)
                (bind ?condition sun)
            )

            (bind ?*pressure* (random 900 1400))

            (retract ?dw)
            (printout t "doWeatherLogic, condition=" ?condition crlf)
        )
        (defrule doBeforeLogic
            (declare (salience 6666))
            ?actor <- (actor (id ?a-id) (logicDone 0))
            =>
            (assert (doBeforeMove (actor ?a-id)))
            (modify ?actor (logicDone 1))
            (printout t "doBeforeLogic, actor-id=" ?a-id  crlf)
        )
        (defrule doAfterLogic
            (declare (salience 5555))
            ?actor  <- (actor   (id ?a-id)
                                (logicDone 3)
                                (actionDone none)
                       )
            =>
            (modify ?actor
                (logicDone 4)
                (actionDone no)
            )
            (printout t "doAfterLogic, actor-id=" ?a-id  crlf)
        )
    ;-----------------------main-loop--------------------;
;----------------------rules----------------------------;

