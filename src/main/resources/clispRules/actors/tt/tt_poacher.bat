(defrule tt_poacher_bribe_forester
    "rule applies if the forester is the one who approaches poacher"
	?nf			<-	(actorNeighbour (actor ?p-id) (neighbour ?a-id) (field ?f-id))
	?poacher	<-	(actor (id ?p-id) (cash ?p-cash) (type ?p-type) (validId ?valid-id))
	?forester 	<-	(actor (id ?a-id) (cash ?a-cash) (type ?a-type) (corruptionThreshold ?a-ct))
	(test
	    (and
	        (   <   0 (str-compare ?p-id "PoacherActorTT"))
	        (   >=  ?p-cash ?a-ct)
            (   >   ?p-cash 0)
            (   eq  ?p-type poacher)
            (   eq  ?a-type forester)
        )
    )
	=>
	(retract ?nf)
	(bind ?tmp (- ?p-cash ?a-ct))

    (modify ?forester (cash (+ ?a-cash ?tmp)) (corruptionThreshold (- ?a-ct 1)))
    (modify ?poacher (cash (- ?p-cash ?tmp)))

	(printout t ?p-id " has bribed " ?a-id " with " ?tmp " $" crlf)
)