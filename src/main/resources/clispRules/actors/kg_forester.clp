;Forester is an actor who hunts down poacher and checks anglers

(deftemplate kg_forester_writeTicket
	(slot who
		(type STRING))
	(slot ticket
		(type INTEGER))
)

(defrule kg_forester_ticketForInvalidId
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?fieldId))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (type forester))
	?equivocal 		<-	(actor (id ?neiId) (cash ?equivocal-cash) (type ?equivocalType) (validId ?equivocalValidId))
	(test
		(neq ?forester ?equivocal))
	(test
		(neq ?equivocalValidId yes))
	=>
	(retract ?nf)

	(bind ?tmp (?a-ap))

	(assert (kg_forester_writeTicket (who ?neiId) (ticket ?tmp)))

	(printout t ?n-id " ticket he got, cash took = " ?tmp "." crlf)
)