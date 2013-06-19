package org.kornicameister.sise.lake.types.actors.impl.rg;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

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


}
