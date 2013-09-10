;Angler is an actor, who tries to catch fish

(deftemplate canAttack "Fish is in range, angler could attack it"
	(slot anglerId)
	(slot targetId)
	(slot targetHP)
)

(deftemplate bestAttack "This fish is the weakest, attack it!"
	(slot anglerID)
	(slot targetID)
)

(defrule AnglerCanAttackFish "Check if fish is in range"
	(declare (salience -100))
	?anglerActor <- (actor 	(id ?AnglerActorID)
							(atField ?anglerFID)
							(attackRange ?anglerAR)
							)
	?targetActor <- (actor 	(id ?TargetActorID)
							(type ?targetType)
							(atField ?targetFID)
							(hp ?healthPts)
							(isAlive yes)
							)
	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
	(or 
		(test (eq ?targetType predator_fish))
		(test (eq ?targetType herbivore_fish)))
	?anglerField <- (field (id ?anglerFID)(x ?ax)(y ?ay))
	?targetField <- (field (id ?targetFID)(x ?tx)(y ?ty))
	(test (>= ?anglerAR (sqrt (+ (* (- ?ax ?tx)(- ?ax ?tx)) (* (- ?ay ?ty)(- ?ay ?ty))))))
	(not (canAttack	(anglerId ?AnglerActorID) (targetId ?TargetActorID)))
	(not (AnglerTired))
	=>
	(assert (canAttack (anglerId ?AnglerActorID) (targetId ?TargetActorID) (targetHP ?healthPts)))
)

(defrule WhichFishAnglerShouldAttack "Decide which fish is the weakest"
	(declare (salience -1000))
	?anglerActor <- (actor 	(id ?AnglerActorID))
	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
    (canAttack (anglerId ?AnglerActorID) (targetId ?TargetActorID) (targetHP ?healthPts))
    (not (canAttack (targetHP ?otherHealthPts&:(< ?otherHealthPts ?healthPts))))
    (not (AnglerTired))
    => 
    (assert (bestAttack (anglerID ?AnglerActorID) (targetID ?TargetActorID)))
 )
 
(defrule TryToAttackFish "Try and fail to catch a fish"
	(declare (salience -10000))
 	(bestAttack (anglerID ?AnglerActorID) (targetID ?TargetActorID))
 	?anglerActor <- (actor 	(id ?AnglerActorID)
 							(attackPower ?angAP)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(hp ?healthPts))
 	(test (< ?angAP ?healthPts))
 	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
 	(not (AnglerTired))
 	=>
 	(assert (AnglerTired))
 	(modify ?targetActor (hp (- ?healthPts ?angAP)))
 	(modify ?anglerActor (actionDone yes))
)

(defrule TryToAttackFishWithSuccess "Catch a fish"
	(declare (salience -10000))
 	(bestAttack (anglerID ?AnglerActorID) (targetID ?TargetActorID))
 	?anglerActor <- (actor 	(id ?AnglerActorID)
 							(attackPower ?angAP)
 							(effectivity_2 ?eff2)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(hp ?healthPts))
 	(test (>= ?angAP ?healthPts))
 	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
 	(not (AnglerTired))
 	=>
 	(assert (AnglerTired))
    (modify ?targetActor (hp -1))
    (modify ?anglerActor (effectivity_2 (+ ?eff2 1.0))(actionDone yes))
)
;-----------------------------------------------------------------------------------------;
; finding the most corrupt forester in area;
;-----------------------------------------------------------------------------------------;
(deftemplate anglerCanBribe "Forester is in range, angler could bribe him"
	(slot anglerId)
	(slot targetId)
	(slot targetCT)
)

(deftemplate anglerBestBribe "This forester is the weakest, bribe him!"
	(slot anglerID)
	(slot targetID)
)

(defrule anglerCanBribeForester "Check if forester in range"
	(declare (salience -100))
	?anglerActor <- (actor (id ?AnglerActorID)
							(atField ?anglerFID)
							(visionRange ?anglerVR)
							(cash ?a-cash)
							(validId ?vId)
							)
	?targetActor <- (actor 	(id ?TargetActorID)
							(type ?targetType)
							(atField ?targetFID)
							(corruptionThreshold ?ct)
							)
	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
	(test (eq ?targetType forester))
	(test (>= ?a-cash ?ct))
	(test (eq ?vId no))
	?anglerField <- (field (id ?anglerFID)(x ?ax)(y ?ay))
	?targetField <- (field (id ?targetFID)(x ?tx)(y ?ty))
	(test (>= ?anglerVR (sqrt (+ (* (- ?ax ?tx)(- ?ax ?tx)) (* (- ?ay ?ty)(- ?ay ?ty))))))
	(not (anglerCanBribe	(anglerId ?AnglerActorID) (targetId ?TargetActorID)))
	(not (AnglerTired))
	=>
	(assert (anglerCanBribe (anglerId ?AnglerActorID) (targetId ?TargetActorID) (targetCT ?ct)))
)

(defrule WhichForesterPoacherShouldBribe "Decide, which forester is the best to bribe"
	(declare (salience -1000))
	?anglerActor <- (actor 	(id ?AnglerActorID))
	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
    (anglerCanBribe (anglerId ?AnglerActorID) (targetId ?TargetActorID) (targetCT ?ct))
    (not (anglerCanBribe (targetCT ?otherCTs&:(< ?otherCTs ?ct))))
    (not (AnglerTired))
    => 
    (assert (anglerBestBribe (anglerID ?AnglerActorID) (targetID ?TargetActorID)))
)
 
(defrule BuyID "Buy new valid ID from forester"
	(declare (salience -10000))
 	(anglerBestBribe  (anglerID ?AnglerActorID) (targetID ?TargetActorID))
 	(test (eq (sub-string 1 13 ?AnglerActorID) "AnglerActorTS"))
 	?anglerActor <- (actor (id ?AnglerActorID)
 							(cash ?a-cash)
 							(validId ?vID)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(tookBribe ?tb)
 							(cash ?t-cash)
 							(corruptionThreshold ?ct)
 							)
 	(not (AnglerTired))
 	=>
 	(assert (AnglerTired))
 	(modify ?targetActor (cash (+ ?t-cash ?ct))(tookBribe yes))
 	(modify ?anglerActor (cash (- ?a-cash ?ct)) (validId yes)(actionDone yes))
)