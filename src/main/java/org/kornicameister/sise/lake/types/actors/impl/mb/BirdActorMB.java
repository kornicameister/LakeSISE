package org.kornicameister.sise.lake.types.actors.impl.mb;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

/**
 * Created with IntelliJ IDEA.
 * User: GodDamnItNappa!
 * Date: 17.06.13
 * Time: 17:56
 * To change this template use File | Settings | File Templates.
 */
public class BirdActorMB extends DefaultActor {

    public BirdActorMB() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.BIRD;
    }

    @Override
    public void run() {
    }

    @Override
    public String getFactName() {
        return BirdActorMB.class.getSimpleName();
    }
}