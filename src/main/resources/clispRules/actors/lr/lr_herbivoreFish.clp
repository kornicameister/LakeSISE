;-------------------funkcja zwraca wartosc gdzi ma byc roslinozerca---------;
(deffunction getval_rosl(?x ?tx ?rangeMove)
			;x roslinozerna tx drapieznik
			;(bind ?tmp ?rangeMove)
			;(while (eq 1 1)
			
			;(if(< ?x ?tx) then
			;(bind ?v (- ?x ?tmp))
			;else
			;(bind ?v (+ ?x ?tmp))
			;	)
			;( bind ?tmp (- ?tmp 1))
			;(printout t "Wartosc " ?v crlf crlf)
			;(if(>= ?v 0) then
			;(return ?v))
			;)
			(bind ?v (- ?x ?tx))
			;(printout t "Tu!!!!!!!!!!!" ?v " x1 " ?x " x2 " ?tx crlf crlf crlf)
			(if (and (< ?v 0)(> ?x 1)) then
				(bind ?v (- ?x 1))
			
			(return ?v)
			)
			;!!!! brak logiki konca jeziora
			;!!!!(bind ?v (+ ?x 1))
			(bind ?v ?x )
			(return ?v)
			
			
    )

;----------------regula ryba roslinozerna usieka przed drapieznikiem-------------;

(defrule uciekaj
    ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name) (visionRange ?rangeVision)(moveRange ?rangeMove)(isAlive ?isAlive)(effectivity_1 ?eff_1));roslinozerca
  	?actorSec <-(actor (id ?actor-id-sec)(type ?actor-name-sec) (atField ?atField-sec)(isAlive ?isAlive-sec));drapieznik
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));pole ryby roslinozernej
	(field (id ?tf-id) (x ?tX)  (y ?tY) (occupied yes));pole ryby drapieznej
	;(test (= 1 (check_type_herbi ?actor-name)) )  ;spr czy ryba jest roslinozerna
	;(test (= 1 (check_type_pred ?actor-name-sec)))  ;spr czy atakujacy to drapieznik
	(test (eq (sub-string 1 15 ?actor-id) "HerbivoreFishLR"))
	(test (eq (sub-string 1 14 ?actor-id-sec) "PredatorFishLR"))

	(test (= 1 (isActorInRange ?x ?y ?tX ?tY ?rangeVision))) ;czy drapieznik jest w polu widzenia
	(test (or(!= ?tX ?x) (!= ?tY ?y)))     ;czy niejest to samo zwierze
	(test (= ?atField ?ff-id))             ;roslinozerna aktor musi byc w poli
	(test (= ?atField-sec ?tf-id))			;analogicznie dla drapieznika
	(test (and(eq yes ?isAlive)(eq yes ?isAlive-sec)))  ;czy zwierzaki zyja

	(not (herbivore_ucieka ?actor-id))  ;czy nie bylo juz wywołania dla tej ryby
		)

	=> 
	(assert (herbivore_ucieka ?actor-id))  			;dodanie faktu
	;effective
	
	;modify range move 
	(bind ?tmp (+ ?rangeMove 1))
	(bind ?tmp_eff1 (+ ?eff_1 1.0))
	(modify ?actor (moveRange ?tmp) (effectivity_1 ?tmp_eff1))
	
	(printout t ?actor-id "/" ?actor-name " " ?x " " ?y  " ryba ucieka " ?actor-id-sec "/" ?actor-name-sec " " ?tX " " ?tY  crlf crlf)
)
;-----------------------------rola jedz------------------------------------;
;rola sprawdza okolice roslinozernej nastepnie zjada pokarm ; 
;Ryba traci predkosc poniewaz jest  coraz ciezsza
;nie ma pokarmu!!!!!;

(defrule zjedz_herbi_lr ;sprawdza okolice i zjada pokarm
        ?actor 	<-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(moveRange ?move) (attackRange ?range)(isAlive ?isAlive)(weight ?waga);roslinozerna
		(hunger  ?hunger)(hp  ?hp)) ;rybka
  	
	(and
	?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes))	;pole rybki
	;(test (= 1 (check_type_herbi ?actor-name)) )  				;czy rybka jest roslinozerna
	(test (eq (sub-string 1 15 ?actor-id) "HerbivoreFishLR"))
	(test (= ?atField ?ff-id))									;czy rybka 
	(test (eq yes ?isAlive))									;czy zyje
	(test (= 2 (random 1 4)))									;rybka nie je zawsze	
	;(or
	;	
	;	(test (eq (sub-string 1 19 ?actor-id) "PredatorFishActorLR"))
	;)
	(not (herbivore_jedz ?actor-id))							;rybka je raz na ture
		)

	=> 
	(assert (herbivore_jedz ?actor-id))
    (printout t ?actor-id "/" ?actor-name " zjada pokarm" crlf crlf crlf)
	(bind ?tmpSpeed(- ?move 2))
	(bind ?tmp_hp(+ ?hp 10))    
	(modify ?actor (moveRange ?tmpSpeed)(hp ?tmp_hp))
)

;wykonuje sie co runde 1 raz

(defrule survived_turns_herbivore 
        ?actor 	<-(actor (id ?actor-id)  (hp ?hp)(type ?actor-name)(isAlive ?isAlive)(effectivity_2 ?eff2));roslinozerna
  	
	(and
	;(test (= 1 (check_type_herbi ?actor-name)) )
	(test (eq (sub-string 1 15 ?actor-id) "HerbivoreFishLR"))
	(test (eq yes ?isAlive))									;czy zyje
	(not (herbivore_survived_flag ?actor-id))							
		)
	=> 
	(assert (herbivore_survived_flag ?actor-id))
    (printout t ?actor-id "/" ?actor-name " przezyła obecna ture" crlf crlf crlf)

	(bind ?tmp_hp(- ?hp 2))    
	(bind ?tmp_eff2(+ ?eff2 1.0))    
	
	(modify ?actor (effectivity_2 ?tmp_eff2)(hp ?tmp_hp))
)



;-------------------------------------wspolna f-cja dla ryb-------------------------;
(defmethod affectRangeByWeather
 (
 (?range INTEGER)
 (?type SYMBOL)
 (?id STRING (and( < 0 (str-compare ?id "PredatorFishLR")) ( < 0 (str-compare ?id "HerbivoreFishLR"))))
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