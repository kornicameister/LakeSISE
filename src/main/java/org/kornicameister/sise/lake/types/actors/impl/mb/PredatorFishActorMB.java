package org.kornicameister.sise.lake.types.actors.impl.mb;

import java.util.HashSet;
import java.util.Set;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

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
 public Set<EffectivenessResult> getEffectiveness() 
	 { Set<EffectivenessResult> results = new HashSet<>();
	 results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_LIVE,Double.toString(this.getEffectivity_2())));
	 results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,Integer.toString(this.getHowManyFishes()))); 
	 return results; 
	 }
	
	
    @Override
    public String getFactName() {
        return PredatorFishActorMB.class.getSimpleName();
    }
}
