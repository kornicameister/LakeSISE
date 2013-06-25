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
	        (or
                (eq ?f-type herbivore_fish)
                (eq ?f-type predator_fish)
            )
            (   <   0 (str-compare ?p-id "PoacherActorTT"))
            (= 1 (isActorInRangeByField ?p-af ?f-af ?p-ar))
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
