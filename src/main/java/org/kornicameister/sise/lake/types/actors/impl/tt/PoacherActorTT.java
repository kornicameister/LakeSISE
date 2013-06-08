package org.kornicameister.sise.lake.types.actors.impl.tt;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class PoacherActorTT extends DefaultActor {

    public PoacherActorTT() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.POACHER;
    }

    @Override
    public String getFactName() {
        return PoacherActorTT.class.getSimpleName();
    }

    @Override
    public void run() {

    }
}
