(defrule tt_poacher_bribe_forester
    "rule applies if the forester is the one who approaches poacher"
	?nf			<-	(actorNeighbour (actor ?p-id) (neighbour ?a-id) (field ?f-id))
	?poacher	<-	(actor (id ?p-id) (cash ?p-cash) (type poacher) (validId ?valid-id))
	?forester 	<-	(actor (id ?a-id) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	(test
	    (and
	        ( < 0 (str-compare ?p-id "PoacherActorTT"))
	        (>= ?p-cash ?a-ct)
            (> ?p-cash 0)
        )
    )
	=>
	(retract ?nf)
	(bind ?tmp (- ?p-cash ?a-ct))

    (modify ?forester (cash (+ ?a-cash ?tmp)) (corruptionThreshold (- ?a-ct 10)))
    (modify ?poacher (cash (- ?p-cash ?tmp)))

	(printout t ?p-id " has bribed " ?a-id " with " ?tmp " $" crlf)
)