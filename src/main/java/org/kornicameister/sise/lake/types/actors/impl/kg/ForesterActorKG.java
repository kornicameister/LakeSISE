package org.kornicameister.sise.lake.types.actors.impl.kg;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import java.util.HashSet;
import java.util.Set;

/**
 * @author <a href="165405@edu.p.lodz.pl">Karol Górecki</a>
 * @version 0.0.1
 * @since 0.0.1
 */
public class ForesterActorKG extends DefaultActor {

    public ForesterActorKG() {
        super();
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.FORESTER;
    }

    @Override
    public void run() {
    }

    @Override
    public String getFactName() {
        return ForesterActorKG.class.getSimpleName();
    }

    @Override
    public Set<EffectivenessResult> getEffectiveness() {
        Set<EffectivenessResult> results = new HashSet<>();

        results.add(new EffectivenessResult("a",Double.toString(this.effectiveness1)));
        results.add(new EffectivenessResult("b",Integer.toString(0)));

        return results;
    }
}