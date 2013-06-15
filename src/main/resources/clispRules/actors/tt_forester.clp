;Forester is an actor who hunts down poacher and checks anglers

(deftemplate tt_forester_doTicket
	(slot who
		(type STRING))
	(slot ticket
		(type INTEGER))
)

(deffunction tt_forester_check_type_valid_id(?actor-type)
	(if (or (eq ?actor-type poacher) (eq ?actor-type angler)) 
		then (return 1)
	)
	(return 0)
)

(defrule tt_forester_do_ticket
	?dt			<-      (tt_forester_doTicket (who ?w-id) (ticket ?ticket))
	?anf 		<-      (actor (id ?w-id) (cash ?anf-cash))
	=>
	(retract ?dt)
	(modify ?anf (cash (- ?anf-cash ?ticket)))
)

(defrule tt_forester_ticket-for-invalid-id
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?anf 		<-	(actor (id ?n-id) (cash ?anf-cash) (type ?anf-type) (validId ?anf-valid-id))
	(test
		(neq ?forester ?anf))
	(test
		(> ?anf-cash 0))
	(test
	    (< ?anf-cash ?a-ct))
	(test
		(neq ?anf-valid-id yes))
	(test
		(eq 1 (tt_forester_check_type_valid_id ?anf-type)))
	=>
	(retract ?nf)

	(if (eq ?anf-type poacher)
		then (bind ?tmp (* ?a-ap 4))
		else (bind ?tmp ?a-ap)
	)

	(assert (tt_forester_doTicket (who ?n-id) (ticket ?tmp)))

	(printout t ?n-id " ticket he got, cash took = " ?tmp "." crlf)
)