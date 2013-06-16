(defglobal ?*true* 	= yes)
(defglobal ?*false* = no)

(deftemplate actorNeighbour
	"template that describes actors neighbour"
	(slot actor
		(type STRING))
	(slot neighbour
		(type STRING))
	(slot field
		(type INTEGER))
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

(deftemplate moveActor
	"template to move the actor"
	(slot actor 	
		(type STRING))
	(slot from	
		(type INTEGER))
	(slot to	
		(type INTEGER))
)

(deftemplate occupyField
	(slot field
		(type INTEGER))
)

(deftemplate freeField
	(slot field
		(type INTEGER))
)

(deftemplate actor
    (slot logicDone
        (type INTEGER)
        (default 0))
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
	    (allowed-symbols yes no))
    ;-----------------corruption-properties-----------;
)

;----------------------functions------------------------;
    ;-------------------utility-------------------------;
    (deffunction countFacts (?template)
        (length (find-all-facts ((?fct ?template)) TRUE))
    )
    (deffunction findFieldByXY (?x ?y)
    	(do-for-fact ((?field field)) (and (eq ?field:x :x) (eq ?field:y ?y))
    		(return ?field:id)
    	)
    )
    ;-------------------utility-------------------------;
    ;------------------move-drawing-functions-----------;
    (deffunction applyRangeMod(?actor ?range ?rm)
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
        (printout t "Applying range mode=" ?tmp crlf)
        (return ?tmp)
    )

    (defgeneric affectRangeByWeather)
    (defmethod affectRangeByWeather ((?range INTEGER) (?actor-type SYMBOL) (?id STRING))
        (return ?range)
    )

    (deffunction isActorInRange(?x ?y ?tX ?tY ?range)
       (bind ?tmp (abs (- ?x ?tX)))
       	(if (> ?tmp ?range) then
       		(return 0)
       	else
       		(bind ?tmp (abs (- ?y ?tY)))
       		(if (> ?tmp ?range) then
       			(return 0)
       		else then
       			(return 1)
       		)
       	)
    )

    (deffunction isActorInRangeByField (?ff-id ?tf-id ?range)
        (do-for-fact
            ((?ff field) (?tf field))
            (and
                (eq ?ff:id ?ff-id) (eq ?tf:id ?tf-id))
            (return (isActorInRange ?ff:x ?ff:y ?tf:x ?tf:y ?range))
        )
        (return 0)
    )

    (deffunction isMoveDrawn(?actor-isMoveChanged)
        (if
            (eq ?actor-isMoveChanged ?*false*)
        then
            (return 1)
        else then
            (return 0)
        )
    )

    ;generic method
    (defgeneric nextFieldId)

    ;1. specialized impl one - however still generic, it requires first two arguments to be passed
    (defmethod nextFieldId ( (?currentNextField-Id INTEGER) (?actor-type SYMBOL) ($?actor-id STRING) )
        (printout t "NFI::RANDOM" crlf)
        (do-for-fact
            ((?field field))
            (and
                (eq     ?field:occupied     ?*false*)
                (neq    ?field:id           ?currentNextField-Id)
            )
            (printout t "NFI::FISHES nextFieldId=" ?field:id crlf)
            (return ?field:id)
        )
    )

    ;2. specialized impl - requires first two arguments to be passed, will be called only if ?actor-type is *-fish
    (defmethod nextFieldId(
        (?currentNextField-Id INTEGER)
        (?actor-type SYMBOL (or
                                (eq ?actor-type herbivore_fish) (eq ?actor-type predator_fish)))
        ($?actor-id STRING))

        (do-for-fact
            ((?waterField field))
            (and
                (eq ?waterField:occupied    ?*false*)
                (eq ?waterField:water       ?*true*)
                (neq ?waterField:id         ?currentNextField-Id)
            )
            (printout t "NFI::FISHES nextFieldId=" ?waterField:id crlf)
            (return ?waterField:id)
        )
    )

    ;3. specialized impl - requires first two arguments to be passed, will be called only if ?actor-type is angler,poacher or forester
    (defmethod nextFieldId(
        (?currentNextField-Id INTEGER)
        (?actor-type SYMBOL (or
                                (eq ?actor-type angler) (eq ?actor-type poacher) (eq ?actor-type forester)))
        ($?actor-id STRING))

        (do-for-fact
            ((?landField field))
            (and
                (eq ?landField:occupied     ?*false*)
                (eq ?landField:water        ?*false*)
                (neq ?landField:id          ?currentNextField-Id)
            )
            (printout t "NFI::ANGLER/POACHER/FORESTER nextFieldId=" ?landField:id crlf)
            (return ?landField:id)
        )
    )

    (deffunction findFieldToMoveRec(
                ?fromField-id
                ?toField-id
                ?actor-moveRange
                ?actor-id
                ?actor-type
                ?fieldFound)
        (while (or (= ?fromField-id ?toField-id) (= ?toField-id -1))
            (bind ?toField-id (nextFieldId ?toField-id ?actor-type ?actor-id))
        )
        (if (neq ?fieldFound ?*true*)
            then
                (do-for-fact
                    ((?ff field) (?tf field))
                    (and
                        (> ?tf:id -1)
                        (eq ?tf:id ?toField-id)
                        (eq ?ff:id ?fromField-id)
                    )
                    (if (and
                            (= 1 (isActorInRange ?ff:x ?ff:y ?tf:x ?tf:y ?actor-moveRange) )
                            (eq ?tf:occupied ?*false*)
                        )
                        then
		                    (printout t "Next::Found field, field-id=" ?toField-id crlf)
                            (bind ?fieldFound ?*true*)
                            (return (findFieldToMoveRec ?fromField-id ?toField-id ?actor-moveRange ?actor-id ?actor-type ?fieldFound))
                        else then
		                    (printout t "Next::Looking for next field, field-id=" ?toField-id " not good" crlf)
                            (bind ?toField-id (nextFieldId ?toField-id ?actor-type ?actor-id))
                            (return (findFieldToMoveRec ?fromField-id ?toField-id ?actor-moveRange ?actor-id ?actor-type ?fieldFound))
                    )
                )
            else
		        (printout t "Final::Found field, field-id=" ?toField-id crlf)
                (return ?toField-id)
        )
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
    	?actor <- (actor (id ?a-id) (type ?a-type) (hp ?hp) (isAlive ?isAlive) (cash ?cash))
    	(test (eq yes ?isAlive))
    	(or
    	    (test (< ?hp 0))
    	    (test (< ?cash 0))
    	)
    	=>
    	(retract ?actor)
		(printout t ?a-id "/" ?a-type " is no longer alive..." crlf)
    )
    ;------------------kill-rules------------------------;
	;------------------move-rules------------------------;
	;
	; Moving rules behaves as follow, there can be only one
	; moveActor fact at the time - only one valid, because only
	; valid one will be included. 
	; Invalid moves will be deleted
	; For example
	; Actor  in atField -> ID=1
	; You want o move him from field ID=1 to field ID=2
	; This move is valid, because actor occupies field ID=1
	; but if we would like to move actor from field ID=2 to field ID=4
	; this would be impossible, because actor occupies field ID=1
		(defrule occupy-field
			?tof	<- (occupyField (field ?f-id))
			?f		<- (field (id ?f-id) (occupied no))
			=>
			(retract ?tof)
			(modify	?f (occupied ?*true*))
		)

		(defrule free-field
			?tof	<- (freeField (field ?f-id))
			?f		<- (field (id ?f-id) (occupied yes))
			=>
			(retract ?tof)
			(modify	?f (occupied ?*false*))
		)

		(deffunction moveActor (?actor-id ?fromField-id ?toField-id)
		    (do-for-fact
                ((?ff field) (?tf field) (?ac actor))
                (and
                    (eq  ?ac:id ?actor-id)
                    (eq  ?tf:id ?toField-id)
                    (eq  ?ff:id ?fromField-id)
                    (eq ?ff:occupied ?*true*)
                    (eq ?tf:occupied ?*false*)
                )
                (assert             (occupyField (field ?tf:id)))
                (assert             (freeField (field ?ff:id)))
                (modify ?ac 	    (atField ?tf:id))
                (printout t ?ac:id "/" ?ac:type " moved from [" ?ff:id "=[" ?ff:x ":" ?ff:y "]] to [" ?tf:id "=[" ?tf:x ":" ?tf:y "]] with range " ?ac:moveRange "." crlf)
                (return 1)
            )
            (return -1)
		)
        ;------------------find-neighbours------------------;
        (deffunction findNeighbour (?actor-id ?neighbour-id ?range)
            (do-for-fact
                ((?neighbour actor) (?actor actor))
                (and
                    (neq ?neighbour:id ?actor-id)
                    (eq ?neighbour:id ?neighbour-id)
                    (eq ?actor:id ?actor-id))
                (if (= 1 (isActorInRangeByField ?actor:atField ?neighbour:atField ?range)) then
                    (printout t "FN:: actorId=" ?actor:id ", neighbourId=" ?neighbour:id ", fieldId=" ?neighbour:atField crlf)
                    (assert (actorNeighbour (actor ?actor:id) (neighbour ?neighbour-id) (field ?neighbour:atField)))
                else then
                    (printout t "FN_OUT_OF_RANGE:: actorId=" ?actor:id ", neighbourId=" ?neighbour:id ", fieldId=" ?neighbour:atField crlf)
                )
            )
        )
        (deffunction findNeighbours (?actor-id ?actor-range)
            (bind ?count 0)
            (delayed-do-for-all-facts ((?neighbour actor))
                (printout t "FNS:: actorId=" ?actor-id ", possibleNeighbourId=" ?neighbour:id ",actorRange=" ?actor-range crlf)
                (findNeighbour ?actor-id ?neighbour:id ?actor-range)
                (bind ?count (+ ?count 1))
            )
            (return ?count)
        )
        ;------------------find-neighbours------------------;
        ;------------------create-move-rule------------------;
        (deffunction createMove(?actor-id)
            (do-for-fact
                ((?actor actor))
                (eq ?actor:id ?actor-id)
                (if (= 1 (isMoveDrawn ?actor:isMoveChanged)) then
                    (bind ?rangeMode ?actor:moveRange)
                    (bind ?toField-id ?actor:atField)

                    (bind   ?rangeMod       (applyRangeMod ?actor ?actor:moveRange (affectRangeByWeather ?actor:moveRange ?actor:type ?actor:id)))
                    (bind   ?toField-id     (findFieldToMoveRec ?actor:atField -1 ?rangeMod ?actor:id ?actor:type ?*false*))
                    (modify ?actor          (isMoveChanged ?*true*) (moveRange ?rangeMod))

                    (moveActor ?actor:id ?actor:atField ?toField-id)
                )
            )
        )
        (defrule doBeforeLogic
            (declare (auto-focus TRUE))
            ?actor <- (actor (id ?a-id) (logicDone 0))
            =>
            (modify ?actor (logicDone 1))
            (createMove ?a-id)
            (printout t "doBeforeLogic, actor-id=" ?a-id  crlf)
        )
        (defrule doAfterLogic
            (declare (salience -10))
            ?actor <- (actor (id ?a-id) (moveRange ?a-moveRange) (logicDone 1))
            =>
            (modify ?actor (logicDone 2))
            (findNeighbours ?a-id ?a-moveRange)
            (printout t "doAfterLogic, actor-id=" ?a-id  crlf)
        )
        ;------------------create-move-rule------------------;
	;------------------move-rules-----------------------;
;----------------------rules----------------------------;

