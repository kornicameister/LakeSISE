;Herbivore fish is an actor, who live only in lake, trying to avoid predator fishes and anglers fishing rodes

(defrule tryToBreakFree ; if fish hp is greater than angler attack, fish can break free but loses it's hp 
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	?attacker	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?weightS))
	?anglerField <- (field (id ?AF)(x ?ax)(y ?ay))
	?actorField <- (field (id ?VF)(x ?vx)(y ?vy))

		(test (eq ?AF ?curField))
		(test (eq ?VF ?curTField))
		(test (>= ?attackR (sqrt (+ (abs (- ?ax ?vx)) (abs (- ?ay ?vy))))))
		(test (eq ?alive yes))
		(test (> ?hp ?attackP))
		(test (eq ?typ angler))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))

	=>
	(assert (angler tried to catch))
	(modify ?actor (hp (- ?hp ?attackP)))
	(modify ?actor (hp (- ?weight 25)))
)



(defrule dyingTime ;Fish dies when weight depleates
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (< ?weight 5))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(test (eq ?alive yes))
	)
	=>
	(modify ?actor (isAlive no))

)


(defrule rotten; dead fish looses weight and rottens
	?actor	<- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(moveRange ?move)(weight ?weight)(hp ?hp))
	(and
		(test (eq ?alive no))
		(test (eq (sub-string 1 20 ?actorTId) "HerbivoreFishActorRG"))
		(test (> ?weight 0))
	)
	=>
	(bind ?tmp (- ?weight 2))
	(modify ?actor(weight ?tmp))

)

(defrule check
	?actor  <-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(moveRange ?move) (attackRange ?range)(isAlive ?isAlive)(weight 	?weight)(hp ?fhp))	

	(and

		(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorRG"))
	
	)
	=>
	(printout t ?actor-id "/" ?actor-name " TRUE" crlf crlf)
	(if (eq ?isAlive no) then
	(printout t ?actor-id "/" ?actor-name " is DEAD" crlf crlf)
)



(defrule eat;fish eat when hungry or hp is decreased
       ?actor  <-(actor (id ?actor-id) (atField ?atField) (type ?actor-name)(moveRange ?move) (attackRange ?range)(isAlive ?isAlive)(weight ?weight)(hp ?fhp))
  	?fish	<-(actor (id ?fishId)(atField ?fishField)(type ?fishType)(isAlive ?fishAlive)(moveRange ?fmove)(weight ?fweight)(hp ?fshp))
(and
?fi <- (field (id ?ff-id) (x ?x)   (y ?y)  (occupied yes));from

;(test (= 1 (check_type_herbi ?actor-name)) )  ;check for attackers
(test (= ?atField ?ff-id))
(test (eq yes ?isAlive))
(test (< ?weight 20))
;(test ( < 0 (str-compare ?actor-id "HerbivoreFishRG")))
(test (eq (sub-string 1 20 ?actor-id) "HerbivoreFishActorRG"))
)
=> 
(printout t ?actor-id "/" ?actor-name " eats now" crlf crlf crlf)

(if (< ?fhp 90) then
(modify ?actor (hp(+ ?fhp 30)))
(printout t ?actor-id "/" ?actor-name " just restored 20 hp" crlf crlf crlf)
)

(modify ?fi (occupied no))
(bind ?tmp(+ ?weight 15))
(bind ?tmpSpeed(- ?move 2))
(modify ?actor (weight ?tmp)(moveRange ?tmpSpeed))
)


























