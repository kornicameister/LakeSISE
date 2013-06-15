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
    (printout t "TicketDo :: " ?ticket crlf)
)

(defrule tt_forester_ticket-for-invalid-id
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?suspect 	<-	(actor (id ?n-id) (cash ?suspect-cash) (type ?suspect-type) (validId ?suspect-valid-id))
	(and
        (test
            (neq ?forester ?suspect))
        (test
            (> ?suspect-cash 0))
        (test
            (<= ?suspect-cash ?a-ct))
        (test
            (eq ?suspect-valid-id no))
        (test
            (eq 1 (tt_forester_check_type_valid_id ?suspect-type)))
	)
	=>
	(retract ?nf)

	(if (eq ?suspect-type poacher)
		then (bind ?tmp (* ?a-ap 4))
		else (bind ?tmp ?a-ap)
	)

	(assert (tt_forester_doTicket (who ?n-id) (ticket ?tmp)))
)