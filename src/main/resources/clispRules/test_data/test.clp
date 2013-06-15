; to remove fact -> retract + fact_id
; to modify fact -> modify fact_id (slot_name value)

(assert (actor
  	(id "ForesterActorTT_1")
  	(type forester)
  	(atField 0)
  	(canAttack yes)
  	(canFly no)
  	(canSwim no)
  	(hp 100)
  	(visionRange 10)
  	(attackRange 1)
  	(attackPower 2)
  	(moveRange 1)
  	(targetId -1)
  	(targetHit no)
  	(cash 0)
  	(corruptionThreshold 10)
  	(validId yes)
))

(assert (actor
	(id "PoacherActorTT_2")
	(type poacher)
	(atField 1)
	(canAttack yes)
	(canFly no)
	(canSwim no)
	(hp 100)
	(visionRange 10)
	(attackRange 1)
	(attackPower 2)
	(moveRange 1)
	(targetId -1)
	(targetHit no)
	(cash 100)
	(corruptionThreshold 0)
	(validId yes)
))

(assert (actorNeighbour (actor "ForesterActorTT_1") (neighbour "PoacherActorTT_2") (field 1)))
(assert (actorNeighbour (actor "PoacherActorTT_2") (neighbour "ForesterActorTT_1") (field 0)))
