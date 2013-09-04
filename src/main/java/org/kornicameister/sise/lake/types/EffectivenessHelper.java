package org.kornicameister.sise.lake.types;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.io.*;
import java.util.Collection;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessHelper {
    private static final String                                PATH           = "effectiveness";
    private static final Multimap<String, EffectivenessResult> TYPE_TO_RESULT = HashMultimap.create();
    private static final Logger                                LOGGER         = Logger
            .getLogger(EffectivenessHelper.class);

    public static void storeEffectiveness(final Class<? extends DefaultActor> from, final EffectivenessResult result) {
        TYPE_TO_RESULT.put(from.getSimpleName(), result);
    }

    public static void saveToFile() {

        final File dir = new File(String.format("%s_%s", PATH, System.currentTimeMillis()));
        if (!dir.exists()) {
            final boolean dirCreated = dir.mkdir();
            LOGGER.debug(String.format("Created=%s dir for path=%s", dirCreated, dir));
        }

        for (final String entry : TYPE_TO_RESULT.keySet()) {

            final File actorDir = new File(String.format("%s/%s", dir.getPath(), entry));
            if (!actorDir.exists()) {
                boolean actorDirCreated = actorDir.mkdir();
                LOGGER.debug(String.format("Created=%s dir for path=%s", actorDirCreated, actorDir));
            }

            final Collection<EffectivenessResult> effectivenessResults = TYPE_TO_RESULT.get(entry);
            final Multimap<String, EffectivenessResult> byName = EffectivenessHelper.getByName(effectivenessResults);

            for (final String key : byName.keySet()) {
                try {

                    final File targetFile = new File(String
                            .format("%s/%s.eff", actorDir.getPath(), key));
                    int counter = 1;

                    // read last logged effectiveness counter
                    if (targetFile.exists()) {
                        final String tail = EffectivenessHelper.tail(targetFile);
                        try {
                            counter = Integer.parseInt(tail.split(" ")[0]);
                        } catch (NumberFormatException nfe) {
                            LOGGER.warn("Could not read last counter", nfe);
                        }
                    }

                    final PrintWriter writer = new PrintWriter(targetFile);
                    for (final EffectivenessResult result : byName.get(key)) {
                        writer.print(counter--);
                        writer.print(" ");
                        writer.print(result.getEffectiveness());
                        writer.print(" ");
                        writer.print(result.getResult());
                        writer.println();
                    }
                    writer.flush();
                    writer.close();

                } catch (FileNotFoundException e) {
                    LOGGER.error("Could not write to the file", e);
                }

            }
        }
    }

    private static Multimap<String, EffectivenessResult> getByName(final Collection<EffectivenessResult> entry) {
        final Multimap<String, EffectivenessResult> resultMultiMap = HashMultimap.create();
        for (final EffectivenessResult result : entry) {
            resultMultiMap.put(result.getEffectiveness(), result);
        }
        return resultMultiMap;
    }

    private static String tail(final File file) {
        RandomAccessFile fileHandler = null;
        try {
            fileHandler = new RandomAccessFile(file, "r");
            long fileLength = file.length() - 1;
            StringBuilder sb = new StringBuilder();

            for (long filePointer = fileLength ; filePointer != -1 ; filePointer--) {
                fileHandler.seek(filePointer);
                int readByte = fileHandler.readByte();

                if (readByte == 0xA) {
                    if (filePointer == fileLength) {
                        continue;
                    } else {
                        break;
                    }
                } else if (readByte == 0xD) {
                    if (filePointer == fileLength - 1) {
                        continue;
                    } else {
                        break;
                    }
                }

                sb.append((char) readByte);
            }

            return sb.reverse().toString();
        } catch (java.io.FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (java.io.IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (fileHandler != null) {
                try {
                    fileHandler.close();
                } catch (IOException e) {
                /* ignore */
                }
            }
        }
    }

}
