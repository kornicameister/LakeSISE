

(defrule kg_forester_ticketForInvalidId
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?fieldId))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (type forester))
	?equivocal 		<-	(actor (id ?neiId) (cash ?equivocalCash) (type ?equivocalType) (validId ?equivocalValidId))
	(and
	(test
		(neq ?forester ?equivocal))
	(test
		(neq ?equivocalValidId yes))
	(test
		(or (eq ?equivocalType poacher) (eq ?equivocalType angler)))
	)
	=>
	(retract ?nf)

	(modify ?equivocal (cash (- ?equivocalCash ?a-ap)))
)