; having fun with chasing

(defglobal ?*tt_f_nf-id* = -1)
(defglobal ?*tt_f_min* = -1)

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
                    ;(printout t "TT_F::NFI next field id=" ?field3:id crlf)
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

(defrule tt_forester_TicketForInvalidId
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (cash ?a-cash) (corruptionThreshold ?a-ct) (type ?a-type))
	?suspect 	<-	(actor (id ?n-id) (cash ?suspect-cash) (type ?s-type) (validId ?suspect-valid-id))
	(test
        (and
            ( <     0 (str-compare ?a-id "ForesterActorTT"))
            ( eq    ?suspect-valid-id no )
            ( eq    ?a-type forester)
            ( eq    ?s-type angler)
        )
	)
	=>
	(retract ?nf)
	(bind ?tmp ?a-ap)
	(modify ?suspect (cash (- ?suspect-cash ?tmp)))
	(printout t ?a-id " put ticket for invalid id for " ?n-id " at " ?tmp " $" crlf)
)

(defrule tt_forester_CatchPoacher
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (attackPower ?a-ap) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?suspect 	<-	(actor (id ?n-id) (cash ?suspect-cash) (type poacher) (validId ?suspect-valid-id))
	(test
        (and
            ( < 0 (str-compare ?a-id "ForesterActorTT"))
            ( <= ?suspect-cash ?a-ct)
        )
	)
	=>
	(retract ?nf)
	(modify ?suspect (isAlive ?*false*) (cash -1))
	(printout t ?a-id " caught poacher " ?n-id crlf)
)
