;----------------regula ryba roslinozerna usieka przed drapieznikiem-------------;

(defrule uciekaj
        ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name) (visionRange ?rangeVision)(moveRange ?rangeMove)(isAlive ?isAlive))
  	?actorSec <-(actor (id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec))
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));from
	(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes));to
	(test (= 1 (check_type_herbi ?actor-name)) )  ;spr czy ryba jest roslinozerna
	(test (= 1 (check_type_pred ?actor-name-sec)))  ;spr czy atakujacy to drapieznik
	(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeVision))) ;czy drapieznik jest w polu widzenia
	(test (or(!= ?tX ?x) (!= ?tY ?y)))     ;czy niejest to samo zwierze
	(test (= ?atField ?ff-id))             ;1 aktor musi byc w poli
	(test (= ?atField-sec ?tf-id))
	(test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))  ;czy zwierzaki zyja
<<<<<<< HEAD
	;(or
	;	(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorLR"))
	;	(test (eq (sub-string 1 19 ?actor-id) "PredatorFishActorLR"))
	;)
=======
	(or
		(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorLR"))
		(test (eq (sub-string 1 19 ?actor-id) "PredatorFishActorLR"))
	)
>>>>>>> 968e1229ae0e397741fa94a11ad86e4681caf53f
	;(test (= 3(random 1 20)))
	(not (herbivore_ucieka ?actor-id))
		)

	=> 
	(assert (herbivore_ucieka ?actor-id))
	(printout t ?actor-id "/" ?actor-name " ryba ucieka " ?actor-id-sec "/" ?actor-name-sec ?x " " ?y " " ?tX " " ?tY " "crlf crlf)
	;(bind ?tmpx (getval_rosl ?x ?tX ?rangeMove))
	;(bind ?tmpy (getval_rosl ?y ?tY ?rangeMove))	
	;(bind ?id-pola (findFieldByXY ?tmpx ?tmpy))
	(bind ?tmp (+ ?rangeMove 2))
	(modify ?actor (moveRange ?tmp))
	;---------------------wychacza sie jak modyfikuje pole-------------------------------;
	;(modify ?actor (atField ?id-pola))
)
;-----------------------------rola jedz------------------------------------;
;rola sprawdza okolice roslinozernej nastepnie zjada pokarm; 
;Ryba traci predkosc poniewaz jest  coraz ciezsza
;nie ma pokarmu!!!!!;

(defrule zjedz_herbi_lr ;sprawdza okolice i zjada pokarm
        ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(moveRange ?move) (attackRange ?range)(isAlive ?isAlive)(weight ?waga)
		(hunger  ?hunger)(hp  ?hp))
  	
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));from
	(test (= 1 (check_type_herbi ?actor-name)) )  ;spr czy atakujacy jest roslinozerny
	(test (= ?atField ?ff-id))
	(test (eq yes ?isAlive))
	(test (= 2 (random 1 4)))
<<<<<<< HEAD
	;(or
	;	(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorLR"))
	;	(test (eq (sub-string 1 19 ?actor-id) "PredatorFishActorLR"))
	;)
=======
	(or
		(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorLR"))
		(test (eq (sub-string 1 19 ?actor-id) "PredatorFishActorLR"))
	)
>>>>>>> 968e1229ae0e397741fa94a11ad86e4681caf53f
	(not (herbivore_jedz ?actor-id))
		)

	=> 
	(assert (herbivore_jedz ?actor-id))
    (printout t ?actor-id "/" ?actor-name " zjada pokarm" crlf crlf crlf)
	(bind ?tmp(+ ?waga 10))
	(bind ?tmpSpeed(- ?move 2))
	(bind ?tmp_hun(+ ?hunger 60))
	(bind ?tmp_hp(+ ?hp ?tmp))    
	(modify ?actor (weight ?tmp)(moveRange ?tmpSpeed)(hunger ?tmp_hun)(hp ?tmp_hp))
)

;-------------------funkcja zwraca wartosc gdzi ma byc roslinozerca---------;
(deffunction getval_rosl(?x ?tx ?rangeMove)
       		(if(< ?x ?tx) then
			(bind ?tmp (- ?x ?rangeMove))
       			(return ?tmp)
			else
			(bind ?tmp (+ ?x ?rangeMove))
       			(return ?tmp)
				)
       		
       	)


;---------------------------------- wspolna f-cja dla ryb-------------------------;
(defmethod affectRangeByWeather
 (
 (?range INTEGER)
 (?type SYMBOL)
 (?id STRING (and( < 0 (str-compare ?id "PredatorFishActorLR")) ( < 0 (str-compare ?id "HerbivoreFishLR"))))
 )
 (do-for-fact
 ((?ac actor))
 (eq ?ac:id ?id)
 (bind ?range ?ac:moveRange)

 (if (eq ?*storm* yes) then
 (bind ?range 1)
 else then
 (if (eq ?*rain* yes) then
 (bind ?range 3)
 else then
 (bind ?range 4)
 )
 )
 (return ?range)
 )
)
