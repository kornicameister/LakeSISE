package org.kornicameister.sise.lake.types.actors.impl.ts;

import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

import CLIPSJNI.PrimitiveValue;

public class PoacherActorTS extends DefaultActor {
	
	public PoacherActorTS () {
		super();
		}
		
	@Override
	protected LakeActors setType() {
		return LakeActors.POACHER;
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
