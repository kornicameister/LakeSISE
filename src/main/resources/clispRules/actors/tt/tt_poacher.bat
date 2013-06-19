(defrule tt_poacher_bribe_forester
    "rule applies if the forester is the one who approaches poacher"
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?p-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?poacher	<-	(actor (id ?p-id) (cash ?p-cash) (type poacher) (validId ?valid-id))
	(test
	    (and
	        ( < 0 (str-compare ?a-id "PoacherActorTT"))
	        (>= ?p-cash ?a-ct)
            (> ?p-cash 0)
        )
    )
	=>
	(retract ?nf)
	(bind ?tmp (- ?p-cash ?a-ct))
	(if (> ?tmp 0) then
            (modify ?forester (cash (+ ?a-cash ?tmp)))
            (modify ?poacher (cash (- ?p-cash ?tmp)))
            (modify ?forester (corruptionThreshold (- ?a-ct 10)))
	)
	(printout t "DUPA" crlf)
)