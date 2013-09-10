
(deftemplate poacherCanAttack "Fish is in range, angler could attack it"
	(slot poacherId)
	(slot targetId)
	(slot targetHP)
)

(deftemplate poacherBestAttack "This fish is the weakest, attack it!"
	(slot poacherID)
	(slot targetID)
)

(defrule poacherCanAttackFish "Check if fish is in range"
	(declare (salience -100))
	?poacherActor <- (actor (id ?PoacherActorID)
							(atField ?poacherFID)
							(attackRange ?poacherAR)
							)
	?targetActor <- (actor 	(id ?TargetActorID)
							(type ?targetType)
							(atField ?targetFID)
							(hp ?healthPts)
							(isAlive yes)
							)
	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
	(or 
		(test (eq ?targetType predator_fish))
		(test (eq ?targetType herbivore_fish)))
	?poacherField <- (field (id ?poacherFID)(x ?px)(y ?py))
	?targetField <- (field (id ?targetFID)(x ?tx)(y ?ty))
	(test (>= ?poacherAR (sqrt (+ (* (- ?px ?tx)(- ?px ?tx)) (* (- ?py ?ty)(- ?py ?ty))))))
	(not (poacherCanAttack	(poacherId ?PoacherActorID) (targetId ?TargetActorID)))
	(not (PoacherTired))
	=>
	(assert (poacherCanAttack (poacherId ?PoacherActorID) (targetId ?TargetActorID) (targetHP ?healthPts)))
)

(defrule WhichFishPoacherShouldAttack "Decide, which fish is the best to attack"
	(declare (salience -1000))
	?poacherActor <- (actor 	(id ?PoacherActorID))
	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
    (poacherCanAttack (poacherId ?PoacherActorID) (targetId ?TargetActorID) (targetHP ?healthPts))
    (not (poacherCanAttack (targetHP ?otherHealthPts&:(< ?otherHealthPts ?healthPts))))
    (not (PoacherTired))
    => 
    (assert (poacherBestAttack (poacherID ?PoacherActorID) (targetID ?TargetActorID)))
 )
 
(defrule TryToAttackFishWithSuccessPoacher "Attack and catch"
	(declare (salience -10000))
 	(poacherBestAttack (poacherID ?PoacherActorID) (targetID ?TargetActorID))
 	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
 	?poacherActor <- (actor (id ?PoacherActorID)
 							(attackPower ?poaAP)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(hp ?healthPts))
 	(test (< ?poaAP ?healthPts))
 	(not (PoacherTired))
 	=>
 	(assert (PoacherTired))
 	(modify ?targetActor (hp (- ?healthPts ?poaAP)))
)

(defrule TryToAttackFishPoacher "Attack, but fail"
	(declare (salience -10000))
 	(poacherBestAttack (poacherID ?PoacherActorID) (targetID ?TargetActorID))
 	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
 	?poacherActor <- (actor (id ?PoacherActorID)
 							(attackPower ?poaAP)
 							(effectivity_2 ?eff2)
 							(actionDone ?ad)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(hp ?healthPts))
 	(test (>= ?poaAP ?healthPts))
 	(not (PoacherTired))
 	=>
 	(assert (PoacherTired))
    (modify ?targetActor (hp -1))
    (modify ?poacherActor (effectivity_2 (+ ?eff2 1.0))(actionDone yes))
)
;-----------------------------------------------------------------------------------------;
; finding the most corrupt forester in area;
;-----------------------------------------------------------------------------------------;
(deftemplate poacherCanBribe "Forester in range, poacher could bribe him"
	(slot poacherId)
	(slot targetId)
	(slot targetCT)
)

(deftemplate poacherBestBribe "This forester is most corrupt, bribe him!"
	(slot poacherID)
	(slot targetID)
)

(defrule poacherCanBribeForester "Check if forester is in range"
	(declare (salience -100))
	?poacherActor <- (actor (id ?PoacherActorID)
							(atField ?poacherFID)
							(visionRange ?poacherVR)
							(cash ?p-cash)
							(validId ?vId)
							)
	?targetActor <- (actor 	(id ?TargetActorID)
							(type ?targetType)
							(atField ?targetFID)
							(corruptionThreshold ?ct)
							)
	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
	(test (eq ?targetType forester))
	(test (>= ?p-cash ?ct))
	(test (eq ?vId no))
	?poacherField <- (field (id ?poacherFID)(x ?px)(y ?py))
	?targetField <- (field (id ?targetFID)(x ?tx)(y ?ty))
	(test (>= ?poacherVR (sqrt (+ (* (- ?px ?tx)(- ?px ?tx)) (* (- ?py ?ty)(- ?py ?ty))))))
	(not (poacherCanBribe	(poacherId ?PoacherActorID) (targetId ?TargetActorID)))
	(not (PoacherTired))
	=>
	(assert (poacherCanBribe (poacherId ?PoacherActorID) (targetId ?TargetActorID) (targetCT ?ct)))
)

(defrule WhichForesterPoacherShouldBribe "Decide, which forester is best to bribe"
	(declare (salience -1000))
	?poacherActor <- (actor 	(id ?PoacherActorID))
	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
    (poacherCanBribe (poacherId ?PoacherActorID) (targetId ?TargetActorID) (targetCT ?ct))
    (not (poacherCanBribe (targetCT ?otherCTs&:(< ?otherCTs ?ct))))
    (not (PoacherTired))
    => 
    (assert (poacherBestBribe (poacherID ?PoacherActorID) (targetID ?TargetActorID)))
 )
 
(defrule BuyID "Now bribe forester and buy new valid ID"
	(declare (salience -10000))
 	(poacherBestBribe  (poacherID ?PoacherActorID) (targetID ?TargetActorID))
 	(test (eq (sub-string 1 14 ?PoacherActorID) "PoacherActorTS"))
 	?poacherActor <- (actor (id ?PoacherActorID)
 							(cash ?p-cash)
 							(validId ?vID)
 							)
 	?targetActor <- (actor  (id ?TargetActorID)
 							(tookBribe ?tb)
 							(cash ?t-cash)
 							(corruptionThreshold ?ct)
 							)
 	(not (PoacherTired))
 	=>
 	(assert (PoacherTired))
 	(modify ?targetActor (cash (+ ?t-cash ?ct))(tookBribe yes))
 	(modify ?poacherActor (cash (- ?p-cash ?ct)) (validId yes)(actionDone yes))
)
;-----------------------------;
;find new field id;
;-----------------------------;
(defmethod nextFieldId
        (
            (?currentNextField-Id   INTEGER)
            (?actor-type            SYMBOL (eq ?actor-type poacher))
            (?actor-id              STRING ( eq (sub-string 1 14 ?actor-id) "PoacherActorTS"))
        )
	    (do-for-fact ( (?poacher actor) (?forester actor) (?fieldP field) (?fieldF field) (?field field) )
            (and
                (eq     ?poacher:type   poacher)
                (eq     ?poacher:id   	?actor-id)
                (eq     ?fieldP:id      ?poacher:atField)
                (eq     ?forester:type  forester)
                (eq     ?fieldF:id  	?forester:atField)
                
                (<=		(sqrt (+ (* (- ?fieldF:x ?fieldP:x)(- ?fieldF:x ?fieldP:x)) (* (- ?fieldF:y ?fieldP:y)(- ?fieldF:y ?fieldP:y)))) ?poacher:visionRange)
                (<=		(sqrt (+ (* (- ?field:x ?fieldP:x)(- ?field:x ?fieldP:x)) (* (- ?field:y ?fieldP:y)(- ?field:y ?fieldP:y)))) ?poacher:moveRange)
                
                (or
                	(and
                		(>= ?fieldF:x ?fieldP:x)
                		(>= ?fieldP:x ?field:x)
                	)
                	(and
                		(<= ?fieldF:x ?fieldP:x)
                		(<= ?fieldP:x ?field:x)
                	)
                )
                (or
                	(and
                		(>= ?fieldF:y ?fieldP:y)
                		(>= ?fieldP:y ?field:y)
                	)
                	(and
                		(<= ?fieldF:y ?fieldP:y)
                		(<= ?fieldP:y ?field:y)
                	)
                )
               (eq 	?field:occupied    	no)
               (eq 	?field:water       	no)
            )
            (do-for-fact ( (?foundField field) )
                (eq ?foundField:id  ?field:id)
                (printout t "TS_P_NFI => " ?actor-id " => " ?foundField:id crlf)
                (return ?field:id)
            )
            (return ?poacher:atField)  ; no need to affect default behaviour
	    )
        (return (call-next-method))  ; no need to affect default behaviour
)