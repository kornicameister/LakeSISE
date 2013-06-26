(defmethod affectRangeByWeather
    (
        (?range     INTEGER)
        (?type      SYMBOL ( eq ?type forester))
        (?actor-id  STRING ( < 0 (str-compare ?actor-id "ForesterActorKG")))
    )
    (do-for-fact
        ((?ac actor))
        (eq ?ac:id ?actor-id)
        (bind ?range ?ac:moveRange)

        (if (eq ?*storm* yes) then
            (bind ?range 4)
        else then
            (bind ?range 2)
        )
        (printout t ?actor-id " custom affectRangeByWeather, range=" ?range crlf)
        (return ?range)
    )
)

(defrule kg_forester_ticketForInvalidId
	?forester 	<-	(actor  (id ?f-id)
    	                        (atField ?foresterField)
    	                        (moveRange ?foresterMoveRange)
    	                        (attackPower ?foresterPower)
    	                        (cash ?f-cash)
    	                        (corruptionThreshold ?f-ct)
    	                        (type forester)
    	                        (actionDone no)
    	                )
    ?equivocal 	<-	(actor  (id ?equivocalId)
                            (atField ?equivocalField)
                            (cash ?equivocalCash)
                            (type angler)
                            (validId no)
                    )
    (test
        (and
            ( > 0 (str-compare ?f-id "ForesterActorKG"))
            (= 1 (isActorInRangeByField ?foresterField ?equivocalField ?foresterMoveRange))
        )
    )
    =>
	(modify ?equivocal (cash (- ?equivocalCash ?foresterPower)))
		(modify ?forester
    	    (actionDone ?*true*)
    	)
)