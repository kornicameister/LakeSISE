package org.kornicameister.sise.lake.types.actors.impl.lr;

import java.util.HashSet;
import java.util.Set;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import CLIPSJNI.PrimitiveValue;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class PredatorFishLR extends DefaultActor {

    @Override
    protected LakeActors setType() {
        return LakeActors.PREDATOR_FISH;
    }

    @Override
    public void run() {

    }

    @Override
    public String getFactName() {
        return PredatorFishLR.class.getSimpleName();
    }
 
    @Override
    public Set<EffectivenessResult> getEffectiveness() {
        Set<EffectivenessResult> results = new HashSet<>();

        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,
        		Double.toString(((double)this.getHowManyFishes())/this.getEffectivity_1())));
        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_LIVE,Double.toString(this.getEffectivity_2())));
        
       return results;
    }
}
