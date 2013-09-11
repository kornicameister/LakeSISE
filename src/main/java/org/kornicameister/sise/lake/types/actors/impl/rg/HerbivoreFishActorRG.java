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

public class HerbivoreFishActorRG extends DefaultActor {

	private static final Logger LOGGER = Logger.getLogger(PoacherActorTT.class);
	
    public HerbivoreFishActorRG() {
        super();
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub

    }

    @Override
    public String getFactName() {
        // TODO Auto-generated method stub
        return HerbivoreFishActorRG.class.getSimpleName();
    }

    @Override
    protected LakeActors setType() {
        // TODO Auto-generated method stub
        return LakeActors.HERBIVORE_FISH;
    }
    
    @Override
    public void applyEffectiveness(PrimitiveValue value) throws Exception {
    	try {
            this.effectivity_1 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_1).doubleValue();
            this.effectivity_2 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_2).doubleValue();
        } catch (Exception exception) {
            LOGGER.warn(String
                    .format("Error occurred when resolving effectiveness from primitive_value = %s", value), exception);
        }
    }
    
    @Override
    public Set<EffectivenessResult> getEffectiveness() {
    	// TODO Auto-generated method stub
    	final Set<EffectivenessResult> results = Sets.newHashSet();
    	
    	 results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_TOTAL_ESCAPES, this.effectivity_1));
         results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_LIVE, this.getRoundsAlive()));

         return results;
    }

}
