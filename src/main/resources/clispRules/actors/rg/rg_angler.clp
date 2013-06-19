
; Angler tries to catch a fish and it doesn't matter what type is it


(defrule catch; angler catches fish
	?victim	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(weight ?waga)(hp ?hp))
	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	(and
		(test (eq ?alive yes))
		(test (< ?hp ?attackP))
		(test (eq ?*storm* no))

	)
	=>
	(modify ?victim (isAlive no))
	(modify ?angl (weight (+ ?weightS ?waga)))
	(modify ?angl (attackPower (+ ?attackP 10)))
	
)



(defrule weakening; weakens angler when rains
	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	(and
		(test (eq ?*storm* yes))
	)
	=>
	(modify ?angl (attackPower(- ?attackP 8)))
)

(defrule weightLoose; meat rottens and weight is loosen
	?angl <- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	(and
		(test (> ?weightS 60))
	)
	=>
	(modify ?angl (weight(- ?weightS 1)))
)
