(defrule initializeBIRD
?actor <- (actor (id ?id) (moveRange ?mr) (type ?type) (effectivity_1 ?eff1) (effectivity_2 ?eff2) (isAlive ?alive))
(test (eq ?type bird))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
(not (test (eq ?eff1 ?eff2)))
(not (test (eq ?eff1 0.0)))
(test (eq yes ?alive))
=>
(modify ?actor (effectivity_2 (+ ?eff2 1)))
)




;----------------glodny - > wolniejszy---------------;
(defrule hungrybird
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap) (hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (> 30 ?hunger))
(test (< 11 ?hunger))
(test (eq no ?aggressive))
(test (eq ?type bird))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(modify ?actor (aggressive yes) (moveRange (- ?mr 2)) (visionRange (+ ?vr 1))))


;--------------najedzony = szybki i sprawny--------------;
(defrule chillingbird
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap)(hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (< 30 ?hunger))
(test (eq yes ?aggressive))
(test (eq ?type bird))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(modify ?actor (aggressive no) (moveRange (+ ?mr 2)) (visionRange (- ?vr 1))))


;----------------glodowka=smierc-----------------------;
;-------------part1 bo inaczej petli sie---------------;
(defrule starvingb
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
(test (> 11 ?hunger))
(test (eq ?type bird))
(not (checked-hungerb ?id))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(assert (checked-hungerb ?id))
(modify ?actor (hp (- ?hp 4)))
)




;------------------agresywny+cel w zasiegu = omnomnom---------;
(defrule attackb
(declare (salience 101)) 
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (aggressive ?ag) (hunger ?hunger) (type ?typ) (howManyFishes ?num) )
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive ?alive))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
(test (eq yes ?alive))
(test (eq ?type herbivore_fish))
(not (test (eq ?id ?tid)))
(test (eq ?typ bird))
(test (eq yes ?alive))
(not (attacked ?id ?tid))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(modify ?target (hp (- ?hp 100)))
(modify ?actor (hunger (+ ?hunger 20)) (howManyFishes (+ ?num 1)))
(assert (attacked ?id ?tid))
)



;---------------czas = glod -----------------------;
(defrule growinghungerb
?actor <- (actor (id ?id) (hunger ?hunger) (type ?type) (effectivity_1 ?eff1))
(not (hunger-increasedb ?id))
(test (eq ?type bird))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(assert (hunger-increasedb ?id))
(modify ?actor (hunger (- ?hunger 1)) (effectivity_1 (+ ?eff1 1)))
)


;-------------kuku dla ludzi-------------------;
(defrule troll
(declare (salience 100)) 
?actor <- (actor (id ?id) (attackRange ?ar) (atField ?paf) (type ?typ) (howManyFishes ?num))
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (moveRange ?mr) (visionRange ?vr))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
(or (test (eq ?type angler))
	(test (eq ?type poacher))
	(test (eq ?type forester))
)
(not (pooped ?id ?tid))
(test (eq ?typ bird))
(test (eq (sub-string 1 11 ?id) "BirdActorMB"))
=>
(modify ?target (moveRange (- ?mr 1)) (howManyFishes (+ ?num 1)) (visionRange (- ?vr 1)))
(assert (pooped ?id ?tid))
)


