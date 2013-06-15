(defrule tt_poacher_bribe_forester
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?poacher	<-	(actor (id ?n-id) (cash ?p-cash) (type poacher))
	(test
	    (>= ?p-cash ?a-ct))
	=>
	(retract ?nf)
	(bind ?tmp (- ?p-cash ?a-ct))
	(bind ?fac (+ ?a-cash ?tmp))
	(bind ?pac (- ?p-cash ?tmp))
	(modify ?forester (cash  ?fac))
	(modify ?poacher  (cash  ?pac))
	(printout t ?n-id " > MOD=" ?tmp " FAC=" ?fac " PAC=" ?pac crlf)
)