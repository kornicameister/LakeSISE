(deftemplate przesun (slot id (type STRING)) (slot x(type INTEGER)) (slot y(type INTEGER)))
(deftemplate lake (slot x) (slot y) (slot size))

;----------------------------rola przesuwa danego aktora 1 raz na ture;
(defrule przesunJe
	?au <- (actor (id ?actorid) (atField ?atField) (type ?actor-name) (visionRange ?rangeVision)(moveRange ?rangeMove)(isAlive ?isAlive))
	(przesun (id ?actor-id)(x ?tmpx)(y ?tmpy))
	?fi <- (field (id ?f-id) (x ?x)   (y ?y)  (occupied no))
	(and
	(test (and(= ?x ?tmpx)(= ?y ?tmpy)))
	(test (eq ?actorid ?actor-id))
	)	
	=>
(printout t "Przesuwam rybe" crlf crlf)
	(modify ?fi (occupied yes ))
	(modify ?au (atField ?f-id)(isMoveChanged yes)
))

;-----------------------------------dodanie aktorów do zrealizowania w javie----------------------------;
(deffacts fish "Rybki"
	(actor (id "1PredacorFish") (type predator_fish) (atField 5) (canAttack yes)
				(hp 100)(isAlive yes)(visionRange 3)(attackRange 1)(attackPower 100)(moveRange 20)
				(weight 60)(isMoveChanged no)(isPropertiesChanged no))
;	(actor (id "2PredacorFish") (type predator_fish) (atField 4) (canAttack yes)
;				(hp 100)(isAlive yes)(visionRange 3)(attackRange 1)(attackPower 100)(moveRange 2)
;				(weight 40)(isMoveChanged no)(isPropertiesChanged no))
;(actor (id "3PredacorFish") (type predator_fish) (atField 3) (canAttack yes)
;				(hp 100)(isAlive yes)(visionRange 3)(attackRange 1)(attackPower 100)(moveRange 2)
;				(weight 20))
;(actor (id "4HerbivoreFish") (type herbivore_fish) (atField 9) (canAttack no)
;				(hp 100)(isAlive yes)(visionRange 3)(attackRange 1)(attackPower 100)(moveRange 2)
;				(weight 20)(isMoveChanged no)(isPropertiesChanged no))
	(weather (type none))
	(lake (x 0)(y 0)(size 2))
; swiat 3x3
	(field (id 1) (x 0) (y 0) (occupied no) (water yes))
	(field (id 2) (x 1) (y 0) (occupied no)(water yes))
	(field (id 3) (x 2) (y 0) (occupied no)(water yes))
	(field (id 4) (x 0) (y 1) (occupied no) (water yes))
	(field (id 5) (x 1) (y 1) (occupied yes) (water yes))
	(field (id 6) (x 2) (y 1) (occupied no) (water yes))
	(field (id 7) (x 0) (y 2) (occupied no) (water yes))
	(field (id 8) (x 1) (y 2) (occupied no) (water yes))
	(field (id 9) (x 2) (y 2) (occupied no) (water yes))
	

)
