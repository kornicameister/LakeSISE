
;-------------------------funkcja szukajaca idpola------------------------;
;(deffunction findFieldByXY (?x ?y)
;(do-for-fact ((?field field)) (and (eq ?field:x :x) (eq ?field:y ?y))
; (return ?field:id)
;) 
;)
;----------------------funkcja przesuwajaca----------------------------;
;(defmethod nextFieldId((?currentNextField-Id INTEGER) (?actor-id STRING (eq ?actor-id “HerbivoreFishLR_3”))) 
 ;        (return 2) 

  ;  )
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
(defrule gonRybe
    ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(visionRange ?rangeVision)(moveRange ?rangeMove)(effectivity_1 ?eff_1)
	(attackRange ?rangeAttack)(isAlive ?isAlive))
		;drapieznik
  	?actorSec <-(actor (id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec)) ;roslinozerna
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));pole drapieznika
	(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes));analogia
	(test (eq (sub-string 1 15 ?actor-id-sec) "HerbivoreFishLR"))
	(test (eq (sub-string 1 14 ?actor-id) "PredatorFishLR"))
	(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeVision))) ;czy ofiara jest w polu widzenia
	(test (or(!= ?tX ?x) (!= ?tY ?y)))     ;czy nie jest to samo zwierze
	(test (= ?atField ?ff-id))             ;1 aktor musi byc w poli
	(test (= ?atField-sec ?tf-id))
	(test (!= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeAttack)));jezeli drapieznik moze juz zaatakowac to nie przesuwa

	(test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))  ;czy zwierzaki zyja
	(not (predator_gon ?actor-id))
		)

	=> 
	(assert (predator_gon ?actor-id))
	(printout t ?actor-id "/" ?actor-name " goni rybe!!!!!!!!!!!!!!!  " ?actor-id-sec "/" ?actor-name-sec "  " crlf crlf)
	(bind ?tmp_eff1 (+ ?eff_1 1.0)) ;ilosc prob zlapania
	(bind ?tmp (+ 1 ?rangeVision))
	(modify ?actor (visionRange ?tmp)(effectivity_1 ?tmp_eff1))
)

;-----------------------------rola jedz------------------------------------;
;rola sprawdza okolice drapieznika nastepnie zjada rybe (drapieznik lub zwykla)o mniejszej wadze od siebie. 
;Ryba traci predkosc poniewaz jest  coraz ciezsza

(defrule zjedz_lr ;sprawdza okolice i zjada ryby 
   ?actor 	    <-  (actor(id ?actor-id)(atField ?atField)
                        (type ?actor-name)
                        (visionRange ?rangeVision)
                        (moveRange ?rangeMove)
                        (attackRange ?rangeAttack)
						(hp ?hp)
						(howManyFishes ?fish_count)
                        (isAlive ?isAlive))
	;drapieznik
  	?actorSec   <-  (actor
                        (id ?actor-id-sec)
                        (type ?actor-name-sec)
                        (atField ?atField-sec)
                        (isAlive ?isAlive-sec))
	;drapieznik lub roslinozerna
	
	(and
        ?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes))  ;from
        (field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes))         ;to
       
		(test (eq (sub-string 1 14 ?actor-id) "PredatorFishLR"))
        (test
            (or
                (eq (sub-string 1 15 ?actor-id-sec) "HerbivoreFishLR")             ;spr czy ofiara jest roslino lub mieso zernaa
                (eq (sub-string 1 14 ?actor-id-sec) "PredatorFishLR")
            )
        )
        (test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeAttack)))       ;czy ofiara jest w polu ataku
        (test (or(!= ?tX ?x) (!= ?tX ?x)))
        (test (= ?atField ?ff-id))
        (test (= ?atField-sec ?tf-id))
        (test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))
		
		(not (predator_eat ?actor-id))
		)

	=> 
		(assert (predator_eat ?actor-id))
        (printout t ?actor-id "/" ?actor-name " zjada rybe " ?actor-id-sec "/"?actor-name-sec crlf crlf)
        (bind ?tmp_count (+ ?fish_count 1))
		(bind ?tmp_hp(+ ?hp 16))
		
		   
		(modify ?actor (moveRange 2) (hp ?tmp_hp)(howManyFishes ?tmp_count))
        (modify ?actorSec (isAlive no)(hp -1))
)

;wykonuje sie co runde 1 raz

(defrule survived_turns_predator 
        ?actor 	<-(actor (id ?actor-id)  (hp ?hp)(type ?actor-name)(isAlive ?isAlive)(effectivity_2 ?eff2));roslinozerna
  	
	(and
	
	(test (eq (sub-string 1 14 ?actor-id) "PredatorFishLR"))
	(test (eq yes ?isAlive))									;czy zyje
	(not (predator_survived_flag ?actor-id))							
		)
	=> 
	(assert (predator_survived_flag ?actor-id))
    (printout t ?actor-id "/" ?actor-name " przezyła obecna ture" crlf crlf crlf)

	(bind ?tmp_hp(- ?hp 3))    
	(bind ?tmp_eff2(+ ?eff2 1.0))    
	
	(modify ?actor (effectivity_2 ?tmp_eff2)(hp ?tmp_hp))
)


;(defrule dead 
; ?actorSec <- (actor(id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec)(hp ?hp)) 
; (not (zabij ?actor-id-sec))
; (or
;	(test (eq (sub-string 1 20 ?actor-id-sec) "HerbivoreFishActorLR"))
;	(test (eq (sub-string 1 19 ?actor-id-sec) "PredatorFishActorLR"))
;	)
; (test (= ?hp 0))
;	=> 
;		(assert (zabij ?actor-id-sec))
;		(modify ?actorSec (isAlive ?*false*))
; (printout t crlf  " zabijam!! " ?actor-id-sec crlf)
;)

;(defrule przeglad 
; ?actorSec <- (actor(id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec)(hp ?hp)) 
; (not (przeg ?actor-id-sec))
		

;	=> 
;		(assert (przeg ?actor-id-sec)) 
; (printout t crlf  " aktor" ?actor-id-sec " czy zyje " ?isAlive-sec " hp= " ?hp crlf)
;)


