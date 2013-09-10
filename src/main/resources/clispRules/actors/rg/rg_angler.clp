;


(defrule catchFish ; if fish hp is lower than angler attack, fish can be caught 
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	?attacker	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS)(howManyFishes ?fishes))
	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))
	(and
		(test (eq ?AF ?curField))
		(test (eq ?VF ?curTField))
		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
		
		(test (eq ?alive yes))
		;(bind ?tmpattk (+ ?attackP ?attackP))
		(test (< ?hp ?attackP))
		;(test (eq ?typ angler))
		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
		(not (caught ?actorId))
		
		(or 
			(test (eq (sub-string 1 9 ?actorTId) "Herbivore"))
			(test (eq (sub-string 1 8 ?actorTId) "Predator"))
		)
	)
	
	=>
	(assert (caught ?actorId))
	;(printout t ?actorTId " had "?hp" hp points, and "?weight" weight points" crlf crlf)
	;(modify ?actor (hp (- ?hp ?attackP)))
	;(modify ?actor (weight (- ?weight 4)))
	(if (< ?fishes 0) then
		(bind ?tmpf (+ ?fishes (abs ?fishes)))
	else then    
		(bind ?tmpf (+ ?fishes 1))
	)
 	(modify ?actor (hp -1)(isAlive no))
	(modify ?attacker (weight (+ ?weight ?weightS))(howManyFishes ?tmpf))
	;(printout t ?actorId" attack dist: "?attackR crlf crlf)
	(printout t ?actorId " caught "?tmpf" fishes, right now caught "?actorTId crlf crlf)
)


(defrule stormaffectAngl ;Angler is affected by storm
	?angler	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS)(howManyFishes ?fishes))
	(and
		(test (eq ?*storm* yes))
		;(test (eq ?alive yes))
		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
		(test (<= ?attackP 15))
		(test (> ?attackP 10))
		(not (strmaffa ?actorId))
	)
	=>
		(assert (strmaffa ?actorId))
		(printout t ?actorId ": looses 1 attack power unit due to storm affection" crlf crlf)
		(modify ?angler (attackPower (- ?attackP 1)))
)

(defrule sunaffectAngl ;Angler is affected by sun
	?angler	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS)(howManyFishes ?fishes))
	(and
		(test (eq ?*sun* yes))
		;(test (eq ?alive yes))
		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
		(test (< ?attackP 15))
		(test (>= ?attackP 10))
		(not (sunaffa ?actorId))
	)
	=>
		(assert (sunaffa ?actorId))
		(printout t ?actorId ": gains 1 attack power unit due to sun affection" crlf crlf)
		(modify ?angler (attackPower (+ ?attackP 1)))
)