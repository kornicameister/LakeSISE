;----------------glodny - > agresja + MOC---------------;
(defrule hungry
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap) (hunger ?hunger) (aggressive ?aggressive))
(test (> 50 ?hunger))
(test (< 21 ?hunger))
=>
(modify ?actor (aggressive yes) (moveRange (+ ?mr 1)) (visionRange (+ ?vr 1)) (attackPower (+ ?ap 40))))


;--------------najedzony = spokojny i wolniutki--------------;
(defrule chilling
?actor <- (actor (id ?id) (moveRange ?mr) (visionRange ?vr) (attackPower ?ap)(hunger ?hunger) (aggressive ?aggressive))
(test (< 50 ?hunger))
(test (eq yes ?aggressive))
=>
(modify ?actor (aggressive no) (moveRange (- ?mr 1)) (visionRange (- ?vr 1)) (attackPower (- ?ap 40))))


;----------------glodowka=smierc-----------------------;
(defrule starving
?actor <- (actor (id ?id) (hp ?hp) (hunger ?hunger))
(test (> 21 ?hunger))
=>
(modify ?actor (hp (- ?hp 5)))))



;------------------agresywny+cel w zasiegu = omnomnom---------;
(defrule attack
?actor <- (actor (id ?id) (attackRange ?ar)(atField ?paf) (attackPower ?ap) (aggressive ?ag) (hunger ?hunger))
?fieldp <- (field (id ?fid) (x ?x) (y ?y))
?target <- (actor (id ?tid) (atField ?taf) (hp ?hp) (type ?type))
?fieldt <- (field (id ?tfid) (x ?tX) (y ?tY))
(test (eq ?fid ?paf))
(test (eq ?tfid ?taf))
(test (= 1 (is-actor-in-range ?x ?y ?tX ?tY ?ar)))
(test (eq yes ?ag))
(or (test (eq ?type herbivore_fish))
	(test (eq ?type predator_fish))
)
=>
(modify ?target (hp (- ?hp ?ap)))
(modify ?actor (hunger (+ ?hunger 60)))
)



;---------------czas = glod -----------------------;
(defrule growinghunger
?actor <- (actor (id ?id) (hunger ?hunger))
(test (= 1 1))
=>
(modify ?actor (hunger (- ?hunger 2)))
)