;Forester is an actor who hunts down poacher and checks anglers

(deftemplate tt_forester_doTicker
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

(defrule tt_forester_do_ticker
	?dt			<- (tt_forester_doTicker (who ?w-id) (ticket ?ticket))
	?anf 		<-	(actor (id ?w-id) (cash ?anf-cash))
	=>
	(retract ?dt)
	(modify ?anf (cash (- ?anf-cash ?ticket)))
)

(defrule tt_forester_ticker-for-invalid-id
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (attackPower ?fap))
	?anf 		<-	(actor (id ?n-id) (cash ?anf-cash) (type ?anf-type) (validId ?anf-valid-id))
	(test 
		(neq ?forester ?anf))
	(test 
		(<> ?anf-cash 0))
	(test 
		(neq ?anf-valid-id yes))
	(test 
		(eq 1 (tt_forester_check_type_valid_id ?anf-type)))
	=>
	(retract ?nf)
	
	(if (eq ?anf-type poacher)
		then (bind ?tmp (* ?fap 4))
		else (bind ?tmp ?fap)
	)
	
	(assert (tt_forester_doTicker (who ?n-id) (ticket ?tmp)))
	
	(printout t ?n-id " ticket he got, cash took = " ?tmp "." crlf)
)