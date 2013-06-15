package org.kornicameister.sise.lake.types.actors.impl.mb;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

/**
 * Created with IntelliJ IDEA.
 * User: GodDamnItNappa!
 * Date: 15.06.13
 * Time: 23:44
 * To change this template use File | Settings | File Templates.
 */
public class PredatorFishActorMB extends DefaultActor {

    public PredatorFishActorMB() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.PREDATOR_FISH;
    }

    @Override
    public void run() {
    }

    @Override
    public String getFactName() {
        return PredatorFishActorMB.class.getSimpleName();
    }
}
