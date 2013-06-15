;-------------------funkcja zwraca wartosc gdzi ma byc drapieznik---------;
(deffunction getval(?x ?y ?Tx ?Ty ?rangeMove)
	(if (is-actor-in-range ?x ?y ?Tx ?Ty ?rangeMove) then
        (bind ?tmp (- ?Tx 1))
    else
        (bind ?tmp (+ ?x(- ?Tx ?x)))
    )
   (return ?tmp)
)
;----------------regula ryba drapiezna goni rybe roslinozerna-------------;
(defrule gonRybe
    ?actor 	    <-(actor
                        (id ?actor-id)
                        (atField ?atField)
                        (type ?actor-name)
                        (isMoveChanged ?zmiana)
                        (visionRange ?rangeVision)
                        (moveRange ?rangeMove)
                        (attackRange ?rangeAttack)
                        (isAlive ?isAlive))
  	?actorSec   <-(actor
                        (id ?actor-id-sec)
                        (type ?actor-name-sec)
                        (atField ?atField-sec)
                        (isAlive ?isAlive-sec))
	(and
        ?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes))      ;from
        (field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes))             ;to
        (test (= 1 (check_type_pred ?actor-name)) )                     ;spr czy atakujacy jest drapiezny
        (test (= 1 (check_type_herbi ?actor-name-sec)))                 ;spr czy ofiara jest roslinozerna
        (test (= 1 (is-actor-in-range ?x ?y ?tX ?tY ?rangeVision)))     ;czy ofiara jest w polu widzenia
        (test (or(!= ?tX ?x) (!= ?tX ?x)))                              ;czy niejest to samo zwierze
        (test (= ?atField ?ff-id))                                      ;1 aktor musi byc w poli
        (test (= ?atField-sec ?tf-id))
        (test (!= 1 (is-actor-in-range ?x ?y ?tX ?tY ?rangeAttack)))    ;jezeli drapieznik moze juz zaatakowac to nie przesuwa
        (test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))              ;czy zwierzaki zyja
        (test (eq no ?zmiana))
	)
	=> 
	(modify ?fi (occupied no))
	(printout t ?actor-id "/" ?actor-name " goni rybe" ?actor-id-sec "/" ?actor-name-sec ?x " " ?y " " ?tX " " ?tY " "crlf crlf)
	(bind ?tmpx (getval ?x ?y ?tX ?tY ?rangeMove))
	(bind ?tmpy (getval ?y ?x ?tY ?tX ?rangeMove))	
	(assert(przesun (id ?actor-id)(x ?tmpx)(y ?tmpy)))	
)

;-----------------------------rola jedz------------------------------------;
;rola sprawdza okolice drapieznika nastepnie zjada rybe (drapieznik lub zwykla)o mniejszej wadze od siebie. 
;Ryba traci predkosc poniewaz jest  coraz ciezsza

(defrule zjedz ;sprawdza okolice i zjada ryby 
   ?actor 	    <-  (actor
                        (id ?actor-id)
                        (atField ?atField)
                        (type ?actor-name)
                        (isMoveChanged ?zmiana)
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
        (test (= 1 (is-actor-in-range ?x ?y ?tX ?tY ?range)))       ;czy ofiara jest w polu ataku
        (test (or(!= ?tX ?x) (!= ?tX ?x)))
        (test (= ?atField ?ff-id))
        (test (= ?atField-sec ?tf-id))
        (test (>= ?waga ?waga-sec))
        (test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))
        (test (eq no ?zmiana))
	)
	=> 
        (printout t ?actor-id "/" ?actor-name " zjada rybe x="?x " y="?y  "zjada rybe x2="?tX " y2="?tY crlf crlf crlf)
        (modify ?fi (occupied no))
        (bind ?tmp(+ ?waga ?waga-sec))
        (bind ?tmpSpeed(- ?move(div ?move (div ?waga ?waga-sec))))
        (modify ?actor (atField ?tf-id)(weight ?tmp)(moveRange ?tmpSpeed)(isMoveChanged yes))
        (modify ?actorSec (isAlive ?*false*)(hp 0))
)
