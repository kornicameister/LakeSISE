
(deffunction nextFieldIdFromForester (?p-id)
    (do-for-fact ( (?poacher actor) (?actor actor) (?field field) (?fieldActor field) )
        (and
            (eq     ?poacher:id     ?p-id)
            (eq     ?field:id       ?poacher:atField)
            (eq     ?fieldActor:id  ?actor:atField)
        )
        (if (= 1 (isActorInRangeByField ?poacher:atField ?actor:atField ?poacher:visionRange)) then
            (bind ?tmp 0)
            (if (> ?field:id ?fieldActor:id) then
                (bind ?tmp (random 0 ?field:id))
            else then
                (bind ?tmp (random ?field:id (countFacts field)))
            )
            (do-for-fact ( (?foundField field) )
                (and
                  (eq ?foundField:id          ?tmp)
                  (eq ?foundField:occupied    no)
                  (eq ?foundField:water       no)
                )
                (printout t "TT_P_NFI_FROM_FORESTER => " ?p-id " => " ?foundField:id crlf)
                (return ?foundField:id)
            )
        else then
            (return -1)
        )
    )
    (return -1)
)

(deffunction nextFieldIdToWater (?p-id)
     (do-for-fact ( (?poacher actor) (?field field) (?waterField field) )
         (and
             (eq     ?poacher:id        ?p-id)
             (eq     ?poacher:atField   ?field:id)
             (neq    ?poacher:atField   ?waterField:id)
             (eq     ?waterField:water  yes)
         )
         (if (= 1 (isActorInRangeByField ?poacher:atField ?waterField:id ?poacher:visionRange)) then
             (bind ?tmp 0)
             (if (> ?field:id ?waterField:id) then
                 (bind ?tmp (random ?waterField:id ?field:id))
             else then
                 (bind ?tmp (random ?field:id ?waterField:id))
             )
             (do-for-fact ( (?foundField field) )
                 (and
                   (eq ?foundField:id          ?tmp)
                   (eq ?foundField:occupied    no)
                   (eq ?foundField:water       no)
                 )
                 (printout t "TT_P_NFI_TO_WATER => " ?p-id " => " ?foundField:id crlf)
                 (return ?foundField:id)
             )
         else then
             (return -1)
         )
     )
     (return -1)
)

(defmethod nextFieldId (
            (?currentNextField-Id   INTEGER)
            (?actor-type            SYMBOL (eq ?actor-type poacher))
            (?p-id                  STRING ( < 0 (str-compare ?p-id "PoacherActorTT"))))

        ; > turns off

	    (bind ?fromPoacher  (nextFieldIdFromForester ?p-id))
	    (bind ?toWater      (nextFieldIdToWater ?p-id))

	    (if (and (<> ?fromPoacher -1) (<> ?toWater -1)) then
	        (do-for-fact ((?poacher actor) (?forester actor))
	            (and
	                (eq ?poacher:id     ?p-id)
	                (eq ?poacher:type   poacher)
	                (eq ?forester:type  forester)
	            )
                (if (> ?poacher:cash ?forester:corruptionThreshold) then
                    (printout t "TT_P_NFI=> " ?p-id " => " ?fromPoacher crlf)
                    (return ?fromPoacher)
                )
	        )
            (printout t "TT_P_NFI=> " ?p-id " => " ?toWater crlf)
	        (return ?toWater)
	    else then
	        (if (and (= ?fromPoacher -1) (<> ?toWater -1)) then
                (printout t "TT_P_NFI=> " ?p-id " => " ?toWater crlf)
                (return ?toWater)
	        else than
                (printout t "TT_P_NFI=> " ?p-id " => " ?fromPoacher crlf)
	            (return ?fromPoacher)
	        )
	    )

        ;(printout t "TT_P::NFI no next field id=" -1 crlf)
        (return (call-next-method))  ; no need to affect default behaviour
)

(defrule tt_poacher_BribeForester
    "rule applies if the forester is the one who approaches poacher"
	?poacher	<-	(actor  (id ?p-id)
	                        (atField ?p-af)
	                        (moveRange ?p-mr)
	                        (cash ?p-cash)
	                        (type poacher)
	                        (actionDone no)
	                )
	?forester 	<-	(actor  (id ?a-id)
	                        (atField ?f-af)
	                        (cash ?a-cash)
	                        (corruptionThreshold ?a-ct)
	                        (type forester)
	                )
	(test
        (and
            (   <   0 (str-compare ?p-id "PoacherActorTT"))
            (   >   ?p-cash ?a-ct)
            (   >   ?p-cash ?a-cash)
            (   >  ?a-ct   -1)
            (= 1 (isActorInRangeByField ?p-af ?f-af ?p-mr))
        )
	)
	=>
	(bind ?tmp (- ?p-cash (* ?a-ct (random 1 3))))
	(if (> ?tmp 0) then
        (modify ?forester
            (cash                   (+ ?a-cash ?tmp))
            (corruptionThreshold    (- ?a-ct (random 1 5)))
            (tookBribe              ?*true*)
            (actionDone             ?*true*)
        )
        (modify ?poacher
            (cash (- ?p-cash ?tmp))
            (actionDone ?*true*)
        )
	    (printout t ?p-id " has bribed " ?a-id " with " ?tmp " $" crlf)
    )
)

(defrule tt_poacher_CatchFish
	?poacher	<-	(actor  (id ?p-id)
	                        (atField ?p-af)
	                        (cash ?p-cash)
	                        (howManyFishes ?p-hmf)
	                        (attackPower ?p-ap)
	                        (attackRange ?p-ar)
	                        (type poacher)
	                        (actionDone no)
	                )
	?fish 	    <-	(actor  (id ?f-id)
	                        (type ?f-type)
	                        (hp ?f-hp)
	                        (atField ?f-af)
	                )
	(test
	    (and
            (   <   0 (str-compare ?p-id "PoacherActorTT"))
            (= 1 (isActorInRangeByField ?p-af ?f-af ?p-ar))
	    )
	)
	(test
        (or
            (eq ?f-type herbivore_fish)
            (eq ?f-type predator_fish)
        )
	)
	=>
    (if (>= ?p-ap ?f-hp) then
        (modify ?poacher
            (actionDone ?*true*)
            (howManyFishes (+ ?p-hmf 1))
        )
        (modify ?fish
            (hp (- ?f-hp ?p-ap))
        )
    else then
        (modify ?poacher
            (actionDone ?*true*)
        )
        (modify ?fish
            (hp (- ?f-hp ?p-ap))
        )
    )
)
