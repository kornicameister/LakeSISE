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