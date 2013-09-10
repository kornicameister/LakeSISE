package org.kornicameister.sise.lake.types.actors.impl.ts;

import java.util.Set;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.actors.impl.ts.AnglerActorTS;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import CLIPSJNI.PrimitiveValue;

import com.google.common.collect.Sets;

public class AnglerActorTS extends DefaultActor {
	private static final Logger LOGGER = Logger.getLogger(PoacherActorTS.class);
	public AnglerActorTS () {
		super();
		}
		
	@Override
	protected LakeActors setType() {
		return LakeActors.ANGLER;
		}
		
	@Override
	public void run() {
		}
	
	@Override
	public String getFactName() {
		return AnglerActorTS.class.getSimpleName();
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
		final Set<EffectivenessResult> results = Sets.newHashSet();

        results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_TOTAL_TICKETS, this.effectivity_1));
        results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES, this.effectivity_2 / this
                .getRoundsAlive()));

        return results;
	}
}