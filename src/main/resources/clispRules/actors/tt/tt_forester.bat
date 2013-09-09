; having fun with chasing

(defmethod nextFieldId
        (
            (?currentNextField-Id   INTEGER)
            (?actor-type            SYMBOL (eq ?actor-type forester))
            (?actor-id              STRING ( eq (sub-string 1 15 ?actor-id) "ForesterActorTT"))
        )

	    (do-for-fact ( (?poacher actor) (?actor actor) (?field field) (?fieldActor field) )
            (and
                (eq     ?poacher:type   poacher)
                (eq     ?field:id       ?poacher:atField)
                (eq     ?actor:id       ?actor-id)
                (eq     ?fieldActor:id  ?actor:atField)
            )

            (bind ?tmp 0)
            (if (> ?field:id ?fieldActor:id) then
                (bind ?tmp (random ?fieldActor:id ?field:id))
            else then
                (bind ?tmp (random ?field:id ?fieldActor:id))
            )
            (do-for-fact ( (?foundField field) )
                (and
                    (eq ?foundField:id          ?tmp)
                    (eq ?foundField:occupied    no)
                    (eq ?foundField:water       no)
                )
                (printout t "TT_F_NFI => " ?actor-id " => " ?foundField:id crlf)
                (return ?foundField:id)
            )
            (return (call-next-method))  ; no need to affect default behaviour
	    )

        ;(printout t "TT_F::NFI no next field id=" -1 crlf)
        (return (call-next-method))  ; no need to affect default behaviour
)
; having fun with chasing

(defmethod affectRangeByWeather
    (
        (?range     INTEGER)
        (?type      SYMBOL ( eq ?type forester))
        (?actor-id  STRING ( eq (sub-string 1 15 ?actor-id) "ForesterActorTT"))
    )
    (do-for-fact
        ((?ac actor))
        (eq ?ac:id ?actor-id)
        (bind ?range ?ac:moveRange)

        (if (and (eq ?*rain* yes) (eq ?*storm* yes)) then
            (bind ?range 4)
        else then
            (if (and (eq ?*storm* yes) (eq ?*rain* no)) then
                (bind ?range 2)
            else then
                (if (and (eq ?*storm* no) (eq ?*rain* yes)) then
                    (bind ?range 3)
                else then
                    (bind ?range 1)
                )
            )
        )
        (printout t ?actor-id " custom affectRangeByWeather, range=" ?range crlf)
        (return ?range)
    )
)

(defrule tt_forester_TicketForInvalidId
	?forester 	<-	(actor  (id ?f-id)
	                        (atField ?f-af)
	                        (moveRange ?f-mr)
	                        (attackPower ?f-ap)
	                        (cash ?f-cash)
	                        (corruptionThreshold ?f-ct)
	                        (type forester)
	                        (actionDone no)
	                        (effectivity_1 ?eff_f)
	                )
	?suspect 	<-	(actor  (id ?s-id)
	                        (atField ?s-af)
	                        (cash ?s-cash)
	                        (type angler)
	                        (validId no)
	                )
	(test
	    (and
            ( eq (sub-string 1 15 ?f-id) "ForesterActorTT")
            (= 1 (isActorInRangeByField ?f-af ?s-af ?f-mr))
        )
	)
	=>
	(modify ?suspect
	    (cash (- ?s-cash ?f-ap))
	)
	(modify ?forester
	    (actionDone ?*true*)
	    (effectivity_1 (+ ?eff_s 1.0)
	)
	(printout t ?f-id " has made the ticket for " ?s-id crlf)
)

(defrule tt_forester_CatchPoacher
	?forester 	<-	(actor  (id ?f-id)
	                        (cash ?f-cash)
	                        (atField ?f-af)
	                        (moveRange ?f-mr)
	                        (attackPower ?f-ap)
	                        (corruptionThreshold ?f-ct)
	                        (type forester)
	                        (actionDone no)
	                        (effectivity_1 ?eff_f)
	                )
	?suspect 	<-	(actor  (id ?s-id)
	                        (cash ?s-cash)
	                        (atField ?s-af)
	                        (type poacher)
	                        (effectivity_1 ?eff_s)
	                )
	(test
        (and
            ( eq (sub-string 1 15 ?f-id) "ForesterActorTT")
            ( <=    ?s-cash ?f-ct)
            (= 1 (isActorInRangeByField ?f-af ?s-af ?f-mr))
        )
    )
	=>
	(bind ?tmp                  (* ?f-ap (random 3 6)))
	(modify ?suspect
	    (cash (- ?s-cash ?tmp))
	    (actionDone ?*true*)
	    (effectivity_1 (+ ?eff_s 1.0))
	)
	(modify ?forester
	    (actionDone ?*true*)
	    (effectivity_1 (+ ?eff_s 1.0))
	)
	(printout t ?f-id " has made the large ticket " ?tmp " for " ?s-id crlf)
)

