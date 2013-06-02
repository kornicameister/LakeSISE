(reset)
(clear)

(deftemplate player
    (slot name)
    (slot moveRange (default none))
    (multislot position (default none))
    (slot type))

(deftemplate angler
    (slot player)
    (slot cash)
    (slot validId)
    (slot fees))

(deftemplate bird
    (slot player)
    (slot hunger)
    (slot altitude)
    (slot speed))

(deftemplate fishHerbivore
    (slot player)
    (slot hunger))

(deftemplate fishPredator
    (slot hunger)
    (slot speed))

(deftemplate poacherWeapon
    (slot range)
    (slot name)
    (slot power))

(deftemplate poacher
    (slot player)
    (slot weapon))

(deftemplate forester
    (slot bribeThreshold)
    (slot player))

(deffacts players_facts_basic "Basic actors facts"
    (player (name AnglerActor)   (type org.kornicameister.sise.lake.actors.AnglerActor))
    (player (name BirdActor)     (type org.kornicameister.sise.lake.actors.BirdActor))
    (player (name FishHerbivore) (type org.kornicameister.sise.lake.actors.FishHerbivore))
    (player (name FishPredator)  (type org.kornicameister.sise.lake.actors.FishPredator))
    (player (name PoacherActor)  (type org.kornicameister.sise.lake.actors.PoacherActor))
    (player (name ForesterActor)  (type org.kornicameister.sise.lake.actors.ForesterActor)))

(deffunction isAngler
    (?actor)
    (answer ?ID=()
=>
    (printout t "Is Angler")))

(reset) ; to load facts from deffacts
