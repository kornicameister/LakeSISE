(deftemplate field
    (slot id)
	(slot x)
	(slot y)
	(slot occupied)
	(slot water)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Note for generic-abilities
; 1 means that actor is able to do so, 0 otherwise
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate actor
    ;-----------------description--------------------;
	(slot id)           ;ID actora + getName()
	(slot type)         ;actors type, check for Java#LakeActors enum for possible values
    ;-----------------description--------------------;

    ;-----------------location----------------------;
	(slot atField)            ;location field-id
	(slot toField)            ;location field-id
    ;-----------------location----------------------;

    ;-----------------generic-abilities--------------;
    (slot canAttack)
    (slot canFly)
    (slot canSwim)
    ;-----------------generic-abilities--------------;

    ;-----------------generic-properties--------------;
    (slot hp)           ;behavior different for each actor
    (slot visionRange)  ;how far can we look in to the void
    (slot attackRange)  ;can we attack from distance
    (slot attackPower)  ;how good we are in killing
    (slot moveRange)    ;how far can we go
    ;-----------------generic-properties--------------;

    ;-----------------attack-properties---------------;
    (slot targetId)     ;id of the actor we want to attack
    (slot targetHit)    ;was actor hit
    ;-----------------attack-properties---------------;

    ;-----------------corruption-properties-----------;
    (slot cash)                 ;can we pay over threshold
    (slot corruptionThreshold)  ;threshold over which poacher can be payed off
    (slot validId)              ;if angler/poacher has no ID - fee, decrement cash
    ;-----------------corruption-properties-----------;
)
