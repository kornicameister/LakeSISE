;----------------glodny - > agresja + MOC---------------;
(defrule hungry
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap) (hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (> 50 ?hunger))
(test (< 21 ?hunger))
(test (eq no ?aggressive))
(test (eq ?type predator_fish))
=>
(modify ?actor (aggressive yes) (moveRange (+ ?mr 1)) (visionRange (+ ?vr 1))))


;--------------najedzony = spokojny i wolniutki--------------;
(defrule chilling
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap)(hunger ?hunger) (aggressive ?aggressive) (type ?type))
(test (< 50 ?hunger))
(test (eq yes ?aggressive))
(test (eq ?type predator_fish))

=>
(modify ?actor (aggressive no) (moveRange (- ?mr 1)) (visionRange (- ?vr 1))))


;----------------glodowka=smierc-----------------------;
;-------------part1 bo inaczej petli sie---------------;
(defrule starving
(declare (salience -1)) 
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
(test (> 21 ?hunger))
(test (eq ?type predator_fish))
(check-hunger)
=>
(assert (starving yes ?id)))

;-------------part 2 -----------------;
(defrule starving1
(declare (salience -2)) 
?actor <- (actor (id ?id) (hp ?hp))
?starve <- (starving ?a ?b)
(test (eq ?b ?id))
(test (eq ?a yes))
=>
(assert (remove_hp ?id))
)

;------------part3 bo logical nie chce dzialac-------------;
(defrule starving2
(declare (salience -3)) 
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger) (type ?type))
?remove <- (remove_hp ?a)
(test (eq ?a ?id))
(not (removing done))
=>
(modify ?actor (hp (- ?hp 5)))
(assert (removing done))
)

(defrule starving3
(declare (salience -4)) 
?removing <- (removing done)
?starving <- (starving ?c ?d)
?remove <- (remove_hp ?a)
?startf <- (check-hunger)
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
(assert (check-hunger)))

(defrule clear-starve
(declare (salience -999))
?retf <- (check-hunger)
(test (= 1 1))
=>
(retract ?retf))

;------------------agresywny+cel w zasiegu = omnomnom---------;
(defrule attack
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (aggressive ?ag) (hunger ?hunger) (type ?typ))
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type) (isAlive ?alive))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (is-actor-in-range ?x ?y ?tX ?tY ?ar)))
(test (eq yes ?ag))
(test (eq ?typ predator_fish))
(test (eq yes ?alive))
(or (test (eq ?type herbivore_fish))
	(test (eq ?type predator_fish))
)
(not (test (eq ?id ?tid)))
(test (eq ?typ predator_fish))
(test (eq yes ?alive))

=>
(modify ?target (hp (- ?hp 80)))
(modify ?actor (hunger (+ ?hunger 60)))
)



;---------------czas = glod -----------------------;
(defrule growinghunger
?actor <- (actor (id ?id) (hunger ?hunger) (type ?type))
?startf <- (growing-hunger)
(growing-hunger)
(test (eq ?type predator_fish))
=>
(modify ?actor (hunger (- ?hunger 2)))
(retract ?startf)
)

(defrule hungerdec
(declare (salience 1)) 
(test (= 1 1))
=>
(assert (growing-hunger))
)