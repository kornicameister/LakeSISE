;-------------------------funkcja szukajaca idpola------------------------;
(deffunction findFieldByXY (?x ?y)
(do-for-fact ((?field field)) (and (eq ?field:x :x) (eq ?field:y ?y))
 (return ?field:id)
) 
)
;----------------------funkcja przesuwajaca----------------------------;
;(defmethod nextFieldId((?currentNextField-Id INTEGER) (?actor-id STRING (eq ?actor-id “MyActorId”))) 
;         (return 2) 

 ;   )
;-------------------funkcja zwraca wartosc gdzi ma byc drapieznik---------;
(deffunction getval(?x ?y ?Tx ?Ty ?rangeMove)
 
	(if (isActorInRange ?x ?y ?Tx ?Ty ?rangeMove) then
       		(bind ?tmp (- ?Tx 1))
		(return ?tmp)
       	else
       		(bind ?tmp (+ ?x(- ?Tx ?x)))
       			(return ?tmp)
       		
       	))
	
		;(printout t "tuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu " crlf crlf)
;----------------regula ryba drapiezna goni rybe roslinozerna-------------;
;(defrule cos
;	?actorSec <-(actor (id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec))
;	=>
;	(printout t "tutaj " ?actor-id-sec crlf crlf)
;	)
(defrule gonRybe
        ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(visionRange ?rangeVision)(moveRange ?rangeMove)(attackRange ?rangeAttack)(isAlive ?isAlive))
  	?actorSec <-(actor (id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec))
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));from
	(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes));to
	(test (= 1 (check_type_pred ?actor-name)) )  ;spr czy atakujacy jest drapiezny
	(test (= 1 (check_type_herbi ?actor-name-sec)))  ;spr czy ofiara jest roslinozerna
	;(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeVision))) ;czy ofiara jest w polu widzenia
	(test (or(!= ?tX ?x) (!= ?tY ?y)))     ;czy niejest to samo zwierze
	(test (= ?atField ?ff-id))             ;1 aktor musi byc w poli
	(test (= ?atField-sec ?tf-id))
	;(test (!= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeAttack)));jezeli drapieznik moze juz zaatakowac to nie przesuwa
	(test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))  ;czy zwierzaki zyja
	)
	=> 
	;(modify ?fi (occupied no))
	(printout t ?actor-id "/" ?actor-name " goni rybe!!!!!!!!!!!!!!!  " ?actor-id-sec "/" ?actor-name-sec ?x " " ?y " " ?tX " " ?tY " "crlf crlf)
	(bind ?tmpx (getval ?x ?y ?tX ?tY ?rangeMove))
	(bind ?tmpy (getval ?y ?x ?tY ?tX ?rangeMove))	
	(bind ?id-pola (findFieldByXY ?tmpx ?tmpy))
	;---------------------wychacza sie jak modyfikuje pole-------------------------------;
	;(modify ?actor (atField ?id-pola))
;---------------------------do zrobienia trzeba przesunac aktora----------------------;
	;(assert(przesun (id ?actor-id)(x ?tmpx)(y ?tmpy)))	
)



;-----------------------------rola jedz------------------------------------;
;rola sprawdza okolice drapieznika nastepnie zjada rybe (drapieznik lub zwykla)o mniejszej wadze od siebie. 
;Ryba traci predkosc poniewaz jest  coraz ciezsza

(defrule zjedz ;sprawdza okolice i zjada ryby 
   ?actor 	    <-  (actor
                        (id ?actor-id)
                        (atField ?atField)
                        (type ?actor-name)
                        (visionRange ?rangeVision)
                        (moveRange ?rangeMove)
                        (attackRange ?rangeAttack)
                        (weight ?waga)
                        (isAlive ?isAlive))
  	?actorSec   <-  (actor
                        (id ?actor-id-sec)
                        (type ?actor-name-sec)
                        (atField ?atField-sec)
                        (weight ?waga-sec)
                        (isAlive ?isAlive-sec))

	(and
        ?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes))  ;from
        (field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes))         ;to
        (test (= 1 (check_type_pred ?actor-name)) )                 ;spr czy atakujacy jest drapierzny
        (test
            (or
                (= 1 (check_type_pred ?actor-name-sec))             ;spr czy ofiara jest roslino lub mieso zernaa
                (= 1 (check_type_herbi ?actor-name-sec))
            )
        )
        (test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeAttack)))       ;czy ofiara jest w polu ataku
        (test (or(!= ?tX ?x) (!= ?tX ?x)))
        (test (= ?atField ?ff-id))
        (test (= ?atField-sec ?tf-id))
        (test (>= ?waga ?waga-sec))
        (test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))
	)
	=> 
        (printout t ?actor-id "/" ?actor-name " zjada rybe x="?x " y="?y  "zjada rybe x2="?tX " y2="?tY crlf crlf crlf)
        (modify ?fi (occupied no))
        (bind ?tmp(+ ?waga ?waga-sec))
        (bind ?tmpSpeed(- ?rangeMove(div ?rangeMove (div ?waga ?waga-sec))))
        ;(modify ?actor (atField ?tf-id)(weight ?tmp)(moveRange ?tmpSpeed))
        (modify ?actorSec (isAlive ?*false*)(hp 0))
)
