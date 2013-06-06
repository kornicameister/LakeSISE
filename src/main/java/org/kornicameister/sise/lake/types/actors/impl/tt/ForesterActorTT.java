package org.kornicameister.sise.lake.types.actors.impl.tt;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ForesterActorTT extends DefaultActor {

    public ForesterActorTT() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.FORESTER;
    }

    @Override
    public void run() {
    }

    @Override
    public String getName() {
        return ForesterActorTT.class.getSimpleName();
    }
}
