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
	(moveRange 3)
	(targetId -1)
	(targetHit no)
	(cash 100)
	(corruptionThreshold 10)
	(validId yes)
))

(assert (field 
	(id 0)
	(x 0)
	(y 0)
	(occupied yes)
	(water no)
))

(assert (field 
	(id 1)
	(x 1)
	(y 1)
	(occupied no)
	(water no)
))

(assert (field 
	(id 2)
	(x 2)
	(y 2)
	(occupied no)
	(water no)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 0)
	(to 1)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 1)
	(to 2)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 0)
	(to 1)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 2)
	(to 1)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 2)
	(to 2)
))

(assert (moveActor
	(actor "ForesterActorTT_1")
	(from 2)
	(to 3)
))