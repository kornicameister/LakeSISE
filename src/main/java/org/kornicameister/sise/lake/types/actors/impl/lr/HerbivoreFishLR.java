package org.kornicameister.sise.lake.types.actors.impl.lr;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class HerbivoreFishLR extends DefaultActor {

    @Override
    protected LakeActors setType() {
        return LakeActors.HERBIVORE_FISH;
    }

    @Override
    public void run() {

    }

    @Override
    public String getFactName() {
        return HerbivoreFishLR.class.getSimpleName();
    }
}