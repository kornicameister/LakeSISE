;Herbivore fish is an actor, who live only in lake, trying to avoid predator fishes and anglers fishing rodes



(defrule stormchck ;Fish storm
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (eq ?*storm* yes))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(not (strmchck ?actorTId))
	)
	=>
		(assert (strmchck ?actorTId))
		(printout t ?actorTId ": STORM IS NOW!!!" crlf crlf)

)


;(defrule dyingTime ;Fish dies when weight depleates
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	(and
;		(test (< ?weight 5))
;		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
;		(test (eq ?alive yes))
;	)
;	=>
;	(printout t ?actorTId " is no longer, died of damage" crlf crlf)
;	(modify ?actor (isAlive no))
;	;(modify ?actor (hp 0))
;
;)

;
;(defrule stressStorm ;Fish stressed by storm
;	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
;	(and
;		(test (eq ?*storm* yes))
;		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
;		(test (eq ?alive yes))
;	)
;	=>
;	(modify ?actor (weight (- ?weight 6)))
;	(printout t "Stressed " ?actorTId " looses 6 weight points due to storm" crlf crlf)
;
;)
;
;