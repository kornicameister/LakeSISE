package org.kornicameister.sise.lake.types;

import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessHelper {
    private static final int                                       THRESHOLD = 2;
    private static final Map<String, HashSet<EffectivenessResult>> SET_MAP   = new HashMap<>();

    public static void storeEffectiveness(final Class<? extends DefaultActor> from, final EffectivenessResult result) {
        HashSet<EffectivenessResult> results = SET_MAP.get(from.getName());
        if (results == null) {
            results = new HashSet<>();
            results.add(result);
            SET_MAP.put(from.getName(), results);
        } else {
            results.add(result);
        }

        if (results.size() == THRESHOLD) {
            //store to file
        }
    }

}
