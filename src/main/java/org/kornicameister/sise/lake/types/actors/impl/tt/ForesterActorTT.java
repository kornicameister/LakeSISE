package org.kornicameister.sise.lake.types.actors.impl.tt;

import CLIPSJNI.PrimitiveValue;
import com.google.common.collect.Sets;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessConstants;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import java.util.Set;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ForesterActorTT
        extends DefaultActor {
    private static final Logger LOGGER = Logger.getLogger(ForesterActorTT.class);
    private Integer tookBribeCounter;

    public ForesterActorTT() {
        super();
        this.tookBribeCounter = 0;
    }

    @Override
    protected LakeActors setType() {
        return LakeActors.FORESTER;
    }

    @Override
    public void run() {
    }

    @Override
    public void applyEffectiveness(final PrimitiveValue value) throws Exception {
        /*
        effectivity_1 - ticket / bribes made
        effectivity_2 - ???
         */
        try {
            this.effectivity_1 += value.getFactSlot(EffectivenessConstants.FieldsNames.EFF_1).doubleValue();
            this.tookBribeCounter += this.tookBribe ? 1 : 0;
            // TODO : one missing effectivity
        } catch (Exception exception) {
            LOGGER.warn(String
                    .format("Error occurred when resolving effectiveness from primitive_value = %s", value), exception);
        }
    }

    @Override public Set<EffectivenessResult> getEffectiveness() {
        final Set<EffectivenessResult> results = Sets.newHashSet();

        // TODO : one missing effectivity
        results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_TICKETS_TO_BRIBES, this.effectivity_1));
        results.add(new EffectivenessResult<>(EffectivenessConstants.Effectiveness.EFF_TOTAL_BRIBES,this.tookBribeCounter));

        return results;
    }

    @Override
    public String getFactName() {
        return ForesterActorTT.class.getSimpleName();
    }
}
