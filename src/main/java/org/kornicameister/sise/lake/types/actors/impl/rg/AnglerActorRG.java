package org.kornicameister.sise.lake.types.actors.impl.rg;

import java.util.Set;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.actors.impl.tt.PoacherActorTT;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import com.google.common.collect.Sets;

import CLIPSJNI.PrimitiveValue;

public class AnglerActorRG extends DefaultActor {

	private static final Logger LOGGER = Logger.getLogger(PoacherActorTT.class);
	
    public AnglerActorRG() {
        super();
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub

    }

    @Override
    public String getFactName() {
        // TODO Auto-generated method stub
        return AnglerActorRG.class.getSimpleName();
    }

    @Override
    protected LakeActors setType() {
        // TODO Auto-generated method stub
        return LakeActors.ANGLER;
    }
    
    @Override
    public void applyEffectiveness(PrimitiveValue value) throws Exception {
    	try {
            this.effectivity_1 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_1).doubleValue();
            this.effectivity_2 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_2).doubleValue();
            if (this.howManyFishes < 0) this.howManyFishes = 0;
        } catch (Exception exception) {
            LOGGER.warn(String
                    .format("Error occurred when resolving effectiveness from primitive_value = %s", value), exception);
        }
    }
    
    @Override
    public Set<EffectivenessResult> getEffectiveness() {
    	   final Set<EffectivenessResult> results = Sets.newHashSet();
    	   
           results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_TOTAL_TICKETS, this.getEffectivity_1()));
           if(this.getEffectivity_2() > 0.0)
        	   results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,  this.getHowManyFishes()/this.getEffectivity_2()));
           else
        	   results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,  this.getHowManyFishes()/1.0));
           return results;
    }


}
