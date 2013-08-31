package org.kornicameister.sise.lake.types;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessHelper {
    private static final int                                       THRESHOLD       = 2;
    private static final String                                    PATH            = "effectiveness";
    private static final Map<String, HashSet<EffectivenessResult>> TYPE_TO_RESULT  = new HashMap<>();
    private static final Map<String, Integer>                      TYPE_TO_COUNTER = new HashMap<>();
    private static final Logger                                    LOGGER          = Logger
            .getLogger(EffectivenessHelper.class);

    public static void storeEffectiveness(final Class<? extends DefaultActor> from, final EffectivenessResult result) {
        final String key = from.getSimpleName();
        HashSet<EffectivenessResult> results = TYPE_TO_RESULT.get(key);

        if (results == null) {
            results = new HashSet<>();
            results.add(result);
            TYPE_TO_RESULT.put(key, results);
        } else {
            results.add(result);
        }

        TYPE_TO_COUNTER.put(key, TYPE_TO_COUNTER.get(key) != null ? TYPE_TO_COUNTER.get(key) + 1 : 1);

        if (results.size() == THRESHOLD) {
            //store to file
            final File dir = new File(PATH);
            if (!dir.exists()) {
                final boolean mkdir = dir.mkdir();
                LOGGER.debug(String.format("Created dir for path=%s", PATH));
            }

            try {
                final PrintWriter writer = new PrintWriter(new File(String
                        .format("%s/%s", PATH, from.getSimpleName())));
                Integer counter = TYPE_TO_COUNTER.get(key);

                for (final EffectivenessResult effectivenessResult : results) {
                    writer.print(counter--);
                    writer.print(" ");
                    writer.print(effectivenessResult.getEffectiveness());
                    writer.print(" ");
                    writer.print(effectivenessResult.getResult());
                    writer.println();
                }

            } catch (FileNotFoundException e) {
                LOGGER.error("Oups,", e);
            }

        }
    }

}
