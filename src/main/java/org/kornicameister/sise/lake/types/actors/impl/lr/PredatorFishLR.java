package org.kornicameister.sise.lake.types.actors.impl.lr;

import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;
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
	private static final Logger LOGGER        = Logger.getLogger(DefaultActor.class);
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
public void applyEffectiveness(PrimitiveValue value) throws Exception {
	  try {
          this.effectivity_1 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_1).doubleValue();
          this.effectivity_2 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_2).doubleValue();
          if(this.getHowManyFishes()<0) this.howManyFishes=0;
      } catch (Exception exception) {
          LOGGER.warn(String
                  .format("Error occurred when resolving effectiveness from primitive_value = %s", value), exception);
      }
}
    @Override
    public Set<EffectivenessResult> getEffectiveness() {
        Set<EffectivenessResult> results = new HashSet<>();
        
        if(this.getEffectivity_1()!=0)
        	results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,
        			this.getHowManyFishes()/this.getEffectivity_1()));
        else
        	results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,0.0));

        	results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_LIVE,Double.toString(this.getEffectivity_2())));
        
        	
       return results;
    }
}
