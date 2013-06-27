;Herbivore fish is an actor, who live only in lake, trying to avoid predator fishes and anglers fishing rodes


(defrule stormaffect ;Fish is affected by storm	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))	(and		(test (eq ?*storm* yes))		(test (eq ?alive yes))		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))		(not (strmaff ?actorTId))	)	=>		(assert (strmaff ?actorTId))		(printout t ?actorTId ": looses 1 weight due to fear" crlf crlf)		(modify ?actor (weight (- ?weight 1))))

(defrule dyingTime ;Fish dies when weight depleates
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (< ?weight 3))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(test (eq ?alive yes))
		;(not (deadd ?actorTId))
	)
	=>
	;(assert (deadd ?actorTId))
	(bind ?tmpd no)
	(printout t ?actorTId " is no longer, alive - "?alive " " ?weight crlf crlf)
	(modify ?actor (isAlive ?tmpd)(hp -1))
	;(printout t ?actorTId " is no longer, alive - "?alive crlf crlf)
	;(modify ?actor (hp 0))

)

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