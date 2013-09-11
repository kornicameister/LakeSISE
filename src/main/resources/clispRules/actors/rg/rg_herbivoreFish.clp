;Herbivore fish is an actor, who live only in lake, trying to avoid predator fishes and anglers fishing rodes


(defrule tryToBreakFree ; if fish hp is greater than angler attack, fish can break free but loses it's hp 
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp)		(effectivity_1 ?eff1))
	?attacker	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))
	(and
		(test (eq ?AF ?curField))
		(test (eq ?VF ?curTField))
		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
		
		(test (eq ?alive yes))
		;(bind ?tmpattk (+ ?attackP ?attackP))
		(test (> ?hp ?attackP))
		;(test (eq ?typ angler))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
		(not (breakfree ?actorId))
		
		;(or 
		;	(test (eq (sub-string 1 9 ?actorTId) "Herbivore"))
		;	(test (eq (sub-string 1 8 ?actorTId) "Predator"))
		;)
	)
	
	=>
	(assert (breakfree ?actorId))
	;(printout t ?actorTId " had "?hp" hp points, and "?weight" weight points" crlf crlf)
	;(modify ?actor (hp (- ?hp ?attackP)))
	;(modify ?actor (weight (- ?weight 4)))
	(if (> ?weight 20) then
		(bind ?tmpw (- ?weight 4))
	else then    
		(bind ?tmpw (- ?weight 0))
	)
	(bind ?tmp_eff_1 (+ ?eff1 1))
 	(modify ?actor (hp (- ?hp ?attackP))(weight ?tmpw)(effectivity_1 ?tmp_eff_1))
	;(printout t ?actorId" attack dist: "?attackR crlf crlf)
	;(printout t ?actorTId " now has "?hp" hp (lost "?attackP") points, and "?weight" weight points, attacked by: "?actorId " escaped times: " ?tmp_eff_1 crlf crlf)
)

(defrule stormaffect ;Fish is affected by storm
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (eq ?*storm* yes))
		(test (eq ?alive yes))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(not (strmaff ?actorTId))
	)
	=>
		(assert (strmaff ?actorTId))
		(printout t ?actorTId ": looses 1 weight due to fear" crlf crlf)
		(modify ?actor (weight (- ?weight 1)))
)

(defrule dyingTime ;Fish dies when weight depleates
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (< ?weight 3))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(test (eq ?alive yes))
		;(not (deadd ?actorTId))
	)
	=>
	;(assert (deadd ?actorTId))
	(bind ?tmpd no)
	(printout t ?actorTId " is no longer, alive - "?alive " " ?weight crlf crlf)
	(modify ?actor (isAlive ?tmpd)(hp -1))
	;(printout t ?actorTId " is no longer, alive - "?alive crlf crlf)
	;(modify ?actor (hp 0))

)

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