;----------------glodny - > agresja + MOC---------------;
(defrule hungry
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap) (hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (> 50 ?hunger))
(test (< 21 ?hunger))
(test (eq no ?aggressive))
(test (eq ?type predator_fish))
(test (eq (sub-string 1 19 ?id) "PredatorFishActorMB"))
=>
(modify ?actor (aggressive yes) (moveRange (+ ?mr 1)) (visionRange (+ ?vr 1))))


;--------------najedzony = spokojny i wolniutki--------------;
(defrule chilling
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap)(hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (< 50 ?hunger))
(test (eq yes ?aggressive))
(test (eq ?type predator_fish))
(test (eq (sub-string 1 19 ?id) "PredatorFishActorMB"))
=>
(modify ?actor (aggressive no) (moveRange (- ?mr 1)) (visionRange (- ?vr 1))))


;----------------glodowka=smierc-----------------------;
;-------------inne podejscie---------------;
(defrule starving
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
(test (> 21 ?hunger))
(test (eq ?type predator_fish))
(not (hunger-checked ?id))
(test (eq (sub-string 1 19 ?id) "PredatorFishActorMB"))
=>
(assert (hunger-checked ?id))
(modify ?actor (hp (- ?hp 5)))
)




;------------------agresywny+cel w zasiegu = omnomnom---------;
(defrule attack
(declare (salience 100)) 
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (aggressive ?ag) (hunger ?hunger) (type ?typ) (howManyFishes ?num)) 
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive ?alive))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?ar)))
(test (eq yes ?ag))
(test (eq ?typ predator_fish))
(test (eq yes ?alive))
(or (test (eq ?type herbivore_fish))
	(test (eq ?type predator_fish))
)
(not (test (eq ?id ?tid)))
(test (eq ?typ predator_fish))
(test (eq yes ?alive))
(not (attacked ?id ?tid))
(test (eq (sub-string 1 19 ?id) "PredatorFishActorMB"))
=>
(modify ?target (hp (- ?hp 80)))
(modify ?actor (hunger (+ ?hunger 60)) (howManyFishes (+ ?num 1)))
(assert (attacked ?id ?tid))
)



;---------------czas = glod -----------------------;
(defrule growinghunger
?actor <- (actor (id ?id) (hunger ?hunger) (type ?type))
(test (eq ?type predator_fish))
(not (hunger-increased ?id))
(test (eq (sub-string 1 19 ?id) "PredatorFishActorMB"))
=>
(modify ?actor (hunger (- ?hunger 2)))
(assert (hunger-increased ?id))
)

