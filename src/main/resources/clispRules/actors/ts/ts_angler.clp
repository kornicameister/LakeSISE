;Angler is an actor, who tries to catch fish

(defrule tryToCatchFishA
	?anglerActor <- (actor (id ?AnglerActorID)(atField ?anglerFID)(weight ?currentAnglerWeight)(attackRange ?anglerAR)(attackPower ?anglerAP)(howManyFishes ?howMany)(targetId ?tarID))
	?targetActor <- (actor (id ?TargetActorID)(type ?tarTyp)(atField ?targetFID)(weight ?targetWeight)(hp ?healthPts)(isAlive ?alive))
	?anglerField <- (field (id ?AID)(x ?ax)(y ?ay))
	?targetField <- (field (id ?TID)(x ?tx)(y ?ty))
	(test (eq ?AID ?anglerFID))
	(test (eq ?TID ?targetFID))
	(test ( < 0 (str-compare ?AnglerActorID "AnglerActorTS")))
	(test (>= ?anglerAR (sqrt (+ (abs (- ?ax ?tx)) (abs (- ?ay ?ty))))))
	(test (>= ?anglerAP ?healthPts))
	(or (test (eq ?tarTyp predator_fish))
		(test (eq ?tarTyp herbivore_fish))
		)
	(not (test (eq ?AnglerActorID ?TargetActorID)))
	(test (eq ?alive yes))
	(not (angler tried to catch))
	=>
	(assert (angler tried to catch))
	(modify ?targetActor (isAlive no))
	(modify ?anglerActor (weight (+ ?currentAnglerWeight ?targetWeight))(howManyFishes (+ ?howMany 1)))
)

(defrule tooWeakToCatchA
	?anglerActor <- (actor (id ?AnglerActorID)(atField ?anglerFID)(weight ?currentAnglerWeight)(attackRange ?anglerAR)(attackPower ?anglerAP)(howManyFishes ?howMany)(targetId ?tarID))
	?targetActor <- (actor (id ?TargetActorID)(type ?tarTyp)(atField ?targetFID)(weight ?targetWeight)(hp ?healthPts)(isAlive ?alive))
	?anglerField <- (field (id ?AID)(x ?ax)(y ?ay))
	?targetField <- (field (id ?TID)(x ?tx)(y ?ty))
	(test (eq ?AID ?anglerFID))
	(test (eq ?TID ?targetFID))
	(test ( < 0 (str-compare ?AnglerActorID "AnglerActorTS")))
	(test (>= ?anglerAR (sqrt (+ (abs (- ?ax ?tx)) (abs (- ?ay ?ty))))))
	(test (< ?anglerAP ?healthPts))
	(or (test (eq ?tarTyp predator_fish))
		(test (eq ?tarTyp herbivore_fish))
		)
	(not (test (eq ?AnglerActorID ?TargetActorID)))
	(test (eq ?alive yes))
	(not (angler tried to catch))
	=>
	(assert (angler tried to catch))
	(modify ?targetActor (hp (- ?healthPts ?anglerAP)))
)