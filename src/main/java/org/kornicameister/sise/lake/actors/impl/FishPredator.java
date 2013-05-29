package org.kornicameister.sise.lake.actors.impl;

import org.kornicameister.sise.lake.actors.Actor;
import org.kornicameister.util.Point;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class FishPredator extends Actor {
    public FishPredator(final String name, final Double moveRange) {
        super(name, moveRange);
    }

    public FishPredator(final String name, final Double moveRange, final Point location) {
        super(name, moveRange, location);
    }
}
