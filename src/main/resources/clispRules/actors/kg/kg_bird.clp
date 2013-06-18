;----------------glodny - > wolniejszy---------------;
(defrule hungrybird
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap) (hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (> 30 ?hunger))
(test (< 11 ?hunger))
(test (eq no ?aggressive))
(test (eq ?type bird))
=>
(modify ?actor (aggressive yes) (moveRange (- ?mr 2)) (visionRange (+ ?vr 1))))


;--------------najedzony = szybki i sprawny--------------;
(defrule chillingbird
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap)(hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (< 30 ?hunger))
(test (eq yes ?aggressive))
(test (eq ?type bird))

=>
(modify ?actor (aggressive no) (moveRange (+ ?mr 2)) (visionRange (- ?vr 1))))


;----------------glodowka=smierc-----------------------;

(defrule starvingb3
(declare (salience -4)) 
?removing <- (removing done)
?starving <- (starving ?c ?d)
?remove <- (remove_hp ?a)
?startf <- (check-hungerb)
(removing done)
=>
(retract ?removing)
(retract ?starving)
(retract ?remove)
(retract ?startf)
)

(defrule starving-check
(declare (salience 1)) 
(test (= 1 1))
=>
(assert (check-hungerb)))

(defrule clear-starve
(declare (salience -999))
?retf <- (check-hungerb)
(test (= 1 1))
=>
(retract ?retf))

;------------------agresywny+cel w zasiegu = omnomnom---------;
(defrule attackb
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (aggressive ?ag) (hunger ?hunger) (type ?typ))
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

=>
(modify ?target (hp (- ?hp 100)))
(modify ?actor (hunger (+ ?hunger 20)))
)



;---------------czas = glod -----------------------;
(defrule growinghungerb
?actor <- (actor (id ?id) (hunger ?hunger) (type ?type))
?startf <- (growing-hunger)
(growing-hunger)
(test (eq ?type bird))
=>
(modify ?actor (hunger (- ?hunger 1)))
(retract ?startf)
)

(defrule hungerdec
(declare (salience 1)) 
(test (= 1 1))
=>
(assert (growing-hunger))
)