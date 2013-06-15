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
    ;------------------move-checking-functions----------;
    (deffunction is-actor-in-range(?x ?y ?tX ?tY ?range)
       (bind ?tmp (abs (- ?x ?tX)))
       	(if (> ?tmp ?range) then
       		(return 0)
       	else
       		(bind ?tmp (abs (- ?y ?tY)))
       		(if (> ?tmp ?range) then
       			(return 0)
       		else
       			(return 1)
       		)
       	)
    )
    ;------------------move-checking-functions----------;
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
	;------------------move-rules-----------------------;
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

		(defrule move-actor
			"rule applies moving of an actor on the clisp side"
			?move	<-	(moveActor (actor ?actor-id) (from ?ff-id) (to ?tf-id))
			?actor 	<-	(actor (id ?actor-id) (type ?actor-name) (moveRange ?range))
			(and
				(field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes))
				(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied no))
			    (test (= 1 (is-actor-in-range ?x ?y ?tX ?tY ?range)))       ;can actor be moved
			)
			=>
			(retract ?move)
			(assert (occupyField (field ?tf-id)))
			(assert (freeField (field ?ff-id)))
			(modify ?actor 	(atField ?tf-id))
			(printout t ?actor-id "/" ?actor-name " moved from [" ?ff-id "=[" ?x ":" ?y "]] to [" ?tf-id "=[" ?tX ":" ?tY "]] with range " ?range "." crlf)
		)

		(defrule clean-invalid-moves
			"rule retracts all invalid moves"
			?move	<-	(moveActor (actor ?actor-id) (from ?ff-id) (to ?tf-id))
			?actor 	<-	(actor (id ?actor-id) (type ?actor-name) (moveRange ?range))
			(and
				(field (id ?ff-id) (x ?x)   (y ?y)  (occupied no))
				(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes))
				(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes))
			    (test (= 0 (is-actor-in-range ?x ?y ?tX ?tY ?range)))       ;can actor be moved
			)
			=>
			(retract ?move)
			(printout t "Move from " ?ff-id " to " ?tf-id " is invalid." crlf)
		)
	;------------------move-rules-----------------------;
;----------------------rules----------------------------;
