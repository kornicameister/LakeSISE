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
        (printout t ?id " new move range=" ?range crlf)
        (return ?range)
    )
)
(defrule starvingKG
    ?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (effectiveness_1  ?ef))
    (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
    (test (< ?hunger 0))
    =>
    (modify ?actor (hp (- ?hp 6))  (effectiveness_1 (+ ?ef 1)) (actionDone ?*true*))
)


(defrule attackKG
    ?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (hunger ?hunger) (howManyFishes ?hmf) (effectiveness_1  ?ef) (type bird)  (actionDone no))
    ?fieldp <- (field (id ?fid) (x ?x) (y ?y))
    ?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive yes) (weight ?weight))
    ?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
    (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
    (test (eq ?fid ?paf))
    (test (eq ?tfid ?taf))
    (test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
    (test (or (eq ?type herbivore_fish) (eq ?type predator_fish)) )
    (test (neq ?id ?tid))
    =>
    (modify ?target (hp (- ?hp ?ap)))
    (if(< ?hp 0) then
        (modify ?actor (howManyFishes (+ ?hmf 1)))
    )
    (modify ?actor (hunger (+ ?hunger ?weight)) (actionDone ?*true*))
)

(defrule growinghungerKG
     ?actor <- (actor (id ?id) (hunger ?hunger) (type bird) (effectiveness_1  ?ef) (actionDone no))
     (test (eq (sub-string 1 11 ?id) "BirdActorKG"))
     =>
     ( if (> ?hunger 0) then
     (modify ?actor (effectiveness_1 (+ ?ef 1)))
     )
     (modify ?actor (hunger (- ?hunger 3)) (actionDone ?*true*))
     (printout t "amem" crlf)
 )
