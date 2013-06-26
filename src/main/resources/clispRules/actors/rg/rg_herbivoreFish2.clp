;Herbivore fish is an actor, who live only in lake, trying to avoid predator fishes and anglers fishing rodes

(defrule tryToBreakFree ; if fish hp is greater than angler attack, fish can break free but loses it's hp 
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	?attacker	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))
		
	(and
		(test (eq ?AF ?curField))
		(test (eq ?VF ?curTField))
		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
		(test (eq ?alive yes))
		(test (> ?hp ?attackP))
		;(test (eq ?typ angler))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(not (breakfree ?actorTId))
		
		(or 
			(test (eq (sub-string 1 6 ?actorId) "Angler"))
			(test (eq (sub-string 1 7 ?actorId) "Poacher"))
		)
	)
	
	=>
	(assert (breakfree ?actorTId))
	(printout t ?actorTId " looses "?attackP" hp points and 4 weight points due to struggle + dist: "?attackR crlf crlf)
	;(printout t ?actorTId " had "?hp" hp points, and "?weight" weight points" crlf crlf)
	(modify ?actor (hp (- ?hp ?attackP)))
	(modify ?actor (weight (- ?weight 4)))
	(printout t ?actorTId " now has "?hp" hp points, and "?weight" weight points" crlf crlf)
)

;(defrule dyingTime ;Fish dies when weight depleates
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	(and
;		(test (< ?weight 5))
;		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
;		(test (eq ?alive yes))
;	)
;	=>
;	(printout t ?actorTId " is no longer, died of damage" crlf crlf)
;	(modify ?actor (isAlive no))
;	;(modify ?actor (hp 0))
;
;)

;
;(defrule stressStorm ;Fish stressed by storm
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	(and
;		(test (eq ?*storm* yes))
;		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
;		(test (eq ?alive yes))
;	)
;	=>
;	(modify ?actor (weight (- ?weight 6)))
;	(printout t "Stressed " ?actorTId " looses 6 weight points due to storm" crlf crlf)
;
;)
;
;
;
;(defrule stormchck ;Fish storm
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	(and
;		(test (neq ?*storm* no))
;		
;	)
;	=>
;		(printout t ?actorTId ": STORM IS NOW!!!" crlf crlf)
;
;)