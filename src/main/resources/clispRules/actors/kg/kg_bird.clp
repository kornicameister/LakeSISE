(defmethod affectRangeByWeather
    (
        (?range INTEGER)
        (?type SYMBOL)
		 (?id STRING ( < 0 (str-compare ?id "BirdActorKG")) )
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
        (return ?range)
    )
)
(defrule starving
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
(test (< ?hunger 0))
=>
(modify ?actor (hp (- ?hp 6)))
)
(defrule attack
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (hunger ?hunger) (type ?typ))
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive ?alive) (weight ?weight))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
(test (eq yes ?alive))
(test (eq ?type herbivore_fish))
(not (test (eq ?id ?tid)))
(test (eq ?typ bird))
(test (eq yes ?alive))
=>
(modify ?target (hp (- ?hp ?ap)))
(bind ?tmp (/ ?weight 2))
(modify ?actor (hunger (+ ?hunger ?tmp)))
)

(defrule growinghunger
?actor <- (actor (id ?id) (hunger ?hunger) (type ?type))
?startf <- (growing-hunger)
(growing-hunger)
(test (eq ?type bird))
=>
(modify ?actor (hunger (- ?hunger 3)))
(retract ?startf)
)
