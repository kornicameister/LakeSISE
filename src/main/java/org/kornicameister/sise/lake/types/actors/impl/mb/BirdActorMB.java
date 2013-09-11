package org.kornicameister.sise.lake.types.actors.impl.mb;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import java.util.HashSet;
import java.util.Set;

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
    public Set<EffectivenessResult> getEffectiveness() {
        Set<EffectivenessResult> results = new HashSet<>();
        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_LIVE, Double.toString(this.getEffectivity_2())));
        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES, Integer.toString(this.getHowManyFishes())));
        return results;
    }

    @Override
    public String getFactName() {
        return BirdActorMB.class.getSimpleName();
    }
}