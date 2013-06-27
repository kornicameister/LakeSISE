;


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
		;(bind ?tmpattk (+ ?attackP ?attackP))
		(test (> ?hp ?attackP))
		;(test (eq ?typ angler))
		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
		(not (breakfree ?actorId))
		
		(or 
			(test (eq (sub-string 1 9 ?actorTId) "Herbivore"))
			(test (eq (sub-string 1 8 ?actorTId) "Predator"))
		)
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
 	(modify ?actor (hp (- ?hp ?attackP))(weight ?tmpw))
	;(printout t ?actorId" attack dist: "?attackR crlf crlf)
	(printout t ?actorTId " now has "?hp" hp (lost "?attackP") points, and "?weight" weight points, attacked by: "?actorId crlf crlf)
)


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
 	(modify ?actor (hp 0)(isAlive no))
	(modify ?attacker (weight (+ ?weight ?weightS))(howManyFishes ?tmpf))
	;(printout t ?actorId" attack dist: "?attackR crlf crlf)
	(printout t ?actorId " caught "?tmpf" fishes, right now caught "?actorTId crlf crlf)
)

;(defrule locateFish;
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	?attacker	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
;	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
;	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))
;	?dist <- (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy)))))
;	
;	(and
;		(test (eq ?AF ?curField))
;		(test (eq ?VF ?curTField))
;		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
;		(test (eq ?alive yes))
;		;(test (eq ?typ angler))
;		(test (eq (sub-string 1 13 ?actorId) "AnglerActorRG"))
;		(or
;			(test (eq (sub-string 1 13 ?actorTId) "HerbivoreFish"))
;			(test (eq (sub-string 1 12 ?actorTId) "PredatorFish"))
;		)
;		(not (locate ?actorId))
;		
;	)
;	
;	=>
;	(assert (locate ?actorId))
;	(printout t ?actorId " has range of "" sees "?actorTIf" in distance of " ?dist crlf crlf)
;	
;)
;

;; Angler tries to catch a fish and it doesn't matter what type is it
;
;
;(defrule catch; angler catches fish
;	?victim	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(weight ?waga)(hp ?hp))
;	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS)		;		 (howManyFishes ?fishes))
;	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
;	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))
;	(and
;		(test (eq ?AF ?curField))
;		(test (eq ?VF ?curTField))
;		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
;
;		(test (eq ?alive yes))
;		(test (< ?hp ?attackP))
;		(test (eq ?*storm* no))
;		(or 
;			(test (eq (sub-string 1 13 ?actorTId) "HerbivoreFish"))
;			(test (eq (sub-string 1 12 ?actorTId) "PredatorFish"))
;		)
;
;	)
;	=>
;	(printout t ?actorId " catches " ?actorTId " and caught in total " ?fishes " fishes"crlf crlf)
;	(modify ?victim (isAlive no))
;	(modify ?angl (weight (+ ?weightS ?waga)))
;	(modify ?angl (attackPower (+ ?attackP 2)))
;	(modify ?angl (howManyFishes (+ ?fishes 1)))
;	
;)


;
;(defrule weakening; weakens angler when rains
;	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
;	(and
;		(test (eq ?*storm* yes))
;	)
;	=>
;	(modify ?angl (attackPower(- ?attackP 8)))
;)
;
;(defrule weightLoose; meat rottens and weight is loosen
;	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
;	(and
;		(test (> ?weightS 60))
;	)
;	=>
;	(modify ?angl (weight(- ?weightS 1)))
;)
;