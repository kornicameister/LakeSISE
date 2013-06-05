(defglobal ?*lifeChange* = 5)

(deftemplate field
	(slot x)
	(slot y)
	(slot occupied)
	(slot water)
)

(deftemplate lake
    "Lake describes our environment - in status before iteration"
    (slot width)
    (slot length)
    (slot depth)
    (multislot actors)
    (slot weather))

(deftemplate actor
	(slot id)
	(slot x)            ;location [x]
	(slot y)            ;location [y]
	(slot moveX)        ;move in tour [x] - 0 if none
	(slot moveY)        ;move in tour [y] - 0 if none
	(slot caught)       ;is actor alive, or maybe it was caught, like for example HerbivoreFish by Angler,Poacher, Bird or Predator
	(slot type)         ;actors type, check for Java#LakeActors enum for possible values
	(slot can-attack)   ;can actor do the attack, for most of our actors this is true [0]
	(slot visionRange)  ;how far the actor can see
	(slot attackRange)  ;can he attack from distance
	(slot attackX)      ;target [x]
	(slot attackY)      ;target [y]
	(slot attackSuccess);was attack successful
)

(deftemplate lakeOut
    "Describes out status of the world, after each iteration"
    (multislot actors))

(deftemplate movement
    "Movement is to describe point-to-point move of an actor"
    (slot from)
    (slot to)
    (slot actor))

(deftemplate possibleMovement
    "Possible movement is calculated"
    (slot to))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;rules;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
