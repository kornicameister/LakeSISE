package org.kornicameister.sise.lake.types.actors.impl.kg;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import java.util.HashSet;
import java.util.Set;

/**
 * @author <a href="165405@edu.p.lodz.pl">Karol Górecki</a>
 * @version 0.0.1
 * @since 0.0.1
 */
public class BirdActorKG extends DefaultActor {

    public BirdActorKG() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.BIRD;
    }

    @Override
    public void run() {
    }

    @Override
    public String getFactName() {
        return BirdActorKG.class.getSimpleName();
    }

    @Override
    public Set<EffectivenessResult> getEffectiveness() {
        Set<EffectivenessResult> results = new HashSet<>();

        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_LIVE,Double.toString(this.getRoundsAlive())));
        results.add(new EffectivenessResult(EffectivenessConstants.Effectiveness.EFF_CAUGHT_FISHES,Integer.toString(this.getHowManyFishes())));

        return results;
    }
}
