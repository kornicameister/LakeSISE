(deftemplate actor
    (slot name)
    (slot type))

(deftemplate angler
    (slot actor)
    (slot range)
    (slot cash)
    (slot validId)
    (slot fees))

(deftemplate bird
    (slot actor)
    (slot hunger)
    (slot altitude)
    (slot range)
    (slot speed))

(deftemplate fishHerbivore
    (slot actor)
    (slot hunger))

(deftemplate fishPredator
    (slot hunger)
    (slot range)
    (slot speed))

(deftemplate poacherWeapon
    (slot actor)
    (slot name)
    (slot range)
    (slot power))

(deftemplate poacher
    (slot actor)
    (slot weapon))

(deftemplate forester
    (slot actor))