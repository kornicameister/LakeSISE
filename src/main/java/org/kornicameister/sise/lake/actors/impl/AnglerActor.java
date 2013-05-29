package org.kornicameister.sise.lake.actors.impl;

import org.kornicameister.sise.lake.actors.Actor;
import org.kornicameister.sise.lake.actors.ClispActorAbility;
import org.kornicameister.sise.lake.annotations.ClispActor;
import org.kornicameister.sise.lake.annotations.ClispActorRule;
import org.kornicameister.util.Point;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

@ClispActor(
        fact = "Angler",
        slots = {"id", "moveRange", "name", "type", "age"},
        rules = {
                @ClispActorRule(
                        rule = "moveAngler",
                        availibity = ClispActorAbility.MOVEABLE
                )
        }
)
public class AnglerActor extends Actor {

    public AnglerActor(final String name, final Double moveRange) {
        super(name, moveRange);
    }

    public AnglerActor(final String name, final Double moveRange, final Point location) {
        super(name, moveRange, location);
    }
}
