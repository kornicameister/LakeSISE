; having fun with chasing

(defglobal ?*tt_f_nf-id* = -1)
(defglobal ?*tt_f_min* = -1)

(deftemplate tt_forester_doTicket
	(slot who
		(type STRING))
	(slot ticket
		(type INTEGER))
)

(defmethod nextFieldId (
            (?currentNextField-Id   INTEGER)
            (?actor-type            SYMBOL (eq ?actor-type forester))
            (?actor-id              STRING ( < 0 (str-compare ?actor-id "ForesterActorTT"))))

	    (do-for-fact ( (?actor actor) (?poacher actor) )
            (and
                (eq     ?actor:id       ?actor-id)
                (eq     ?poacher:type   poacher)
            )
            (do-for-fact ((?field field) (?field2 field))
                (and
                    (eq     ?field:id   ?poacher:atField)
                    (eq     ?field2:id  ?actor:atField)
                    (neq    ?field2:id   ?currentNextField-Id)
                )

                (bind ?nX 0)
                (bind ?nY 0)
                (if (< ?field:x ?field2:x) then
                    (bind ?nX (random ?field:x ?field2:x))
                else then
                    (bind ?nX (random ?field2:x ?field:x))
                )
                (if (< ?field:y ?field2:y) then
                    (bind ?nY (random ?field:y ?field2:y))
                else then
                    (bind ?nY (random ?field2:y ?field:y))
                )

                (do-for-fact ((?field3 field))
                    (and
                        (eq ?field3:x ?nX)
                        (eq ?field3:y ?nY)
                        (eq ?field3:occupied ?*false*)
                        (eq ?field3:water ?*false*)
                    )
                    (printout t "TT_F::NFI next field id=" ?field3:id crlf)
                    (return ?field3:id)
                )
            )

	    )

        (printout t "TT_F::NFI no next field id=" -1 crlf)
        (return (call-next-method))  ; no need to affect default behaviour
)
; having fun with chasing

(defmethod affectRangeByWeather
    (
        (?range INTEGER)
        (?type SYMBOL)
        (?id STRING ( < 0 (str-compare ?id "ForesterActorTT")) )
    )
    (do-for-fact
        ((?ac actor))
        (eq ?ac:id ?id)
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
        (printout t "ForesterActorTT_1 custom affectRangeByWeather, range=" ?range crlf)
        (return ?range)
    )
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
    (declare (salience -20))
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