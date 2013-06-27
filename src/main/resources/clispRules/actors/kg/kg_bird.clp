(defmethod affectRangeByWeather
    (
        (?range INTEGER)
        (?type SYMBOL)
		 (?id STRING ( eq (sub-string 1 11 ?id) "BirdActorKG"))
    )
    (do-for-fact
        ((?ac actor))
        (eq ?ac:id ?id)
        (bind ?range ?ac:moveRange)

        (if (eq ?*storm* yes) then
            (bind ?range 0)
        else then
            (if (eq ?*rain* yes) then
                (bind ?range 2)
            else then
                (bind ?range 5)
            )
        )
        (printout t ?actor-id " new move range=" ?range crlf)
        (return ?range)
    )
)
(defrule starving
    ?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
    (test (< ?hunger 0))
    (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
    =>
    (modify ?actor (hp (- ?hp 6)))
)
(defrule attack
    ?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (hunger ?hunger) (howManyFishes ?hmf) (type bird) (actionDone no))
    ?fieldp <- (field (id ?fid) (x ?x) (y ?y))
    ?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive yes) (weight ?weight))
    ?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
    (test (eq ?fid ?paf))
    (test (eq ?tfid ?taf))
    (test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
    (test (or (eq ?type herbivore_fish) (eq ?type predator_fish)) )
    (test (neq ?id ?tid))
    (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
    =>
    (modify ?target (hp (- ?hp ?ap)))
    (if(< ?hp 0) then
        (modify ?actor (howManyFishes (+ ?hmf 1)))
    )
    (modify ?actor (hunger (+ ?hunger ?weight)))
    (modify ?actor (actionDone ?*true*))
)

(defrule growinghunger
    ?actor <- (actor (id ?id) (hunger ?hunger) (type bird) (actionDone no))
    (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
    =>
    (modify ?actor (hunger (- ?hunger 3)))
    (modify ?actor (actionDone ?*true*))
)
