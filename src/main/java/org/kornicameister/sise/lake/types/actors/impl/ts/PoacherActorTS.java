package org.kornicameister.sise.lake.types.actors.impl.ts;

import java.util.Set;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.actors.impl.ts.PoacherActorTS;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import com.google.common.collect.Sets;

import CLIPSJNI.PrimitiveValue;

public class PoacherActorTS extends DefaultActor {
	private static final Logger LOGGER = Logger.getLogger(PoacherActorTS.class);
	public PoacherActorTS () {
		super();
		}
		
	@Override
	protected LakeActors setType() {
		return LakeActors.POACHER;
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

	@Override
	public void run() {
		}
	
	@Override
	public String getFactName() {
		return PoacherActorTS.class.getSimpleName();
		}
	
	public void applyFact(PrimitiveValue value) throws Exception {
        this.setAtField(WorldHelper.getField(value.getFactSlot("atField").intValue()));
        this.setAttackPower(value.getFactSlot("attackPower").intValue());
        this.setAttackRange(value.getFactSlot("attackRange").intValue());
        this.setMoveRange(value.getFactSlot("moveRange").intValue());
        this.setCash(value.getFactSlot("cash").intValue());
        this.setHp(value.getFactSlot("hp").intValue());
        this.setTargetHit(BooleanToSymbol.fromSymbol(value.getFactSlot("targetHit").symbolValue()));
        this.setHunger(value.getFactSlot("hunger").intValue());
        this.setWeight(value.getFactSlot("weight").intValue());
        this.setHowManyFishes(value.getFactSlot("howManyFishes").intValue());
        this.setTookBribe(BooleanToSymbol.fromSymbol(value.getFactSlot("tookBribe").symbolValue()));
        this.setCorruptionThreshold(value.getFactSlot("corruptionThreshold").intValue());
    }
}
