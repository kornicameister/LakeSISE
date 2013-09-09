package org.kornicameister.sise.lake.types.effectiveness;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.io.*;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessHelper {
    private static final String PATH   = "effectiveness";
    private static final Logger LOGGER = Logger
            .getLogger(EffectivenessHelper.class);

    public static void storeToFile() {

        final Multimap<String, EffectivenessResult> typeToResult = EffectivenessHelper.collectEffectivenessFromActors();
        final File rootFolder = EffectivenessHelper.getEffectivenessRootFolder();

        for (final String entry : typeToResult.keySet()) {

            final File actorDir = EffectivenessHelper.getActorFolder(rootFolder.getPath(), entry);
            final Collection<EffectivenessResult> effectivenessResults = typeToResult.get(entry);
            final Multimap<String, EffectivenessResult> byName = EffectivenessHelper.getByName(effectivenessResults);

            for (final String key : byName.keySet()) {
                try {

                    final File targetFile = new File(String
                            .format("%s/%s.eff", actorDir.getPath(), key));
                    int counter = EffectivenessHelper.getLastCounter(targetFile);

                    EffectivenessHelper.saveToFile(byName.get(key), targetFile, counter);

                } catch (FileNotFoundException e) {
                    LOGGER.error("Could not write to the file", e);
                }

            }
        }
    }

    private static void saveToFile(final Collection<EffectivenessResult> byName, final File targetFile, int counter) throws
            FileNotFoundException {
        final PrintWriter writer = new PrintWriter(targetFile);
        for (final EffectivenessResult result : byName) {
            writer.print(counter++);
            writer.print(" ");
            writer.print(result.getName());
            writer.print(" ");
            writer.print(result.getResult());
            writer.println();
        }
        writer.flush();
        writer.close();
    }

    private static int getLastCounter(final File targetFile) {
        int counter = 1;
        if (targetFile.exists()) {
            final String tail = EffectivenessHelper.tail(targetFile);
            try {
                counter = Integer.parseInt(tail.split(" ")[0]);
            } catch (NumberFormatException nfe) {
                LOGGER.warn("Could not read last counter", nfe);
                counter = 1;
            }
        }
        return counter;
    }

    private static File getActorFolder(final String rootFolder, final String entry) {
        final File actorDir = new File(String.format("%s/%s", rootFolder, entry));
        if (!actorDir.exists()) {
            boolean actorDirCreated = actorDir.mkdir();
            LOGGER.debug(String.format("Created=%s dir for path=%s", actorDirCreated, actorDir));
        }
        return actorDir;
    }

    private static File getEffectivenessRootFolder() {
        final File dir = new File(String.format("%s_%s", PATH, System.currentTimeMillis()));
        if (!dir.exists()) {
            final boolean dirCreated = dir.mkdir();
            LOGGER.debug(String.format("Created=%s dir for path=%s", dirCreated, dir));
        }
        return dir;
    }

    private static Multimap<String, EffectivenessResult> collectEffectivenessFromActors() {
        final Iterator<DefaultActor> actorIterator = WorldHelper.getActorIterator(false);
        final Multimap<String, EffectivenessResult> typeToResult = HashMultimap.create();

        while (actorIterator.hasNext()) {
            final DefaultActor actor = actorIterator.next();
            final Set<EffectivenessResult> effectiveness = actor.getEffectiveness();
            if (effectiveness != null) {
                for (final EffectivenessResult result : effectiveness) {
                    typeToResult.put(actor.getClass().getSimpleName(), result);
                }
            } else {
                LOGGER.error(String.format("Failed to read effectiveness from actor=%s", actor.getFactId()));
            }
        }

        return typeToResult;
    }

    private static Multimap<String, EffectivenessResult> getByName(final Collection<EffectivenessResult> entry) {
        final Multimap<String, EffectivenessResult> resultMultiMap = HashMultimap.create();
        for (final EffectivenessResult result : entry) {
            resultMultiMap.put(result.getName(), result);
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
