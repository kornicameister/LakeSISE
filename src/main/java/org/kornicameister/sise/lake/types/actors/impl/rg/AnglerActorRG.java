package org.kornicameister.sise.lake.types.actors.impl.rg;

import java.util.Set;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import CLIPSJNI.PrimitiveValue;

public class AnglerActorRG extends DefaultActor {

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
    	// TODO Auto-generated method stub
    	super.applyEffectiveness(value);
    }
    
    @Override
    public Set<EffectivenessResult> getEffectiveness() {
    	// TODO Auto-generated method stub
    	return super.getEffectiveness();
    }


}
