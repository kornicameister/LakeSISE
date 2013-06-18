;Angler is an actor, who tries to catch fish

(defrule catchAFish
	?actor 	<- (actor (id ?actorId)(attackRange ?attackR)(atField ?curField)(attackPower ?attackP)(type ?typ)(weight ?wagaS))
	?target <- (actor (id ?actorTId)(atField ?curTField)(type ?typT)(isAlive ?alive)(weight ?waga)(hp ?hp))
	?targField <- (field (id ?tfid) (x ?targx) (y ?targy))
	?actorField <- (field (id ?afid) (x ?actorx) (y ?actory))
	(test (eq ?afid ?curField))
	(test (eq ?tfid ?curTField))
	(test (= 1 (isActorInRange ?actorx ?actory ?targx ?targy ?attackR)))
	(test (eq yes ?alive))
	(test (eq ?typT herbivore_fish))
	(or (test (eq ?typT predator_fish))) 
	(not (test (eq ?actorId ?actorTId)))
	(test (eq ?typ angler))
	
	=>
	(modify ?target (hp (- ?hp 100)))
)