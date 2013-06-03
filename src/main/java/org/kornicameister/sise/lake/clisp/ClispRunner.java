package org.kornicameister.sise.lake.clisp;

import CLIPSJNI.PrimitiveValue;
import org.apache.log4j.Logger;
import org.kornicameister.sise.exception.LakeInitializationException;
import org.kornicameister.sise.lake.io.DataStructure;
import org.kornicameister.sise.lake.types.ClispType;
import org.kornicameister.sise.lake.types.world.DefaultWorld;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

/**
 * Class that executes mainLoop of the program
 * MainLoop works in following algorithm
 * <ol>
 * <li>
 * Gather inputs from all actors and world
 * </li>
 * <li>
 * Load input to environments
 * </li>
 * <li>
 * Run environments
 * </li>
 * <li>
 * Gather outputs from environments
 * </li>
 * <li>
 * Push output after transformation to actors
 * </li>
 * <li>
 * Do actors logic
 * </li>
 * <li>
 * Reset all and go to the next loop if necessary
 * </li>
 * </ol>
 *
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

class ClispRunner implements Runnable {
    private final static Logger LOGGER = Logger.getLogger(ClispRunner.class);
    private final List<ClispTypeEnvironmentPair> types;
    private       ClispTypeEnvironmentPair       world;

    public ClispRunner(final List<ClispTypeEnvironmentPair> types) {
        this.types = new ArrayList<>(types);
        for (ClispTypeEnvironmentPair pair : types) {
            if (pair.getClispType() instanceof DefaultWorld) {
                this.world = pair;
            }
        }
        if (this.world == null) {
            throw new LakeInitializationException("World is missing, exiting...");
        }
        // ensure that world is processed as the last
        {
            this.types.remove(this.world);
            this.types.add(this.types.size(), this.world);
        }
        // ensure that world is processed as the last
    }

    /**
     * InOwnThreadRunner implements round processing functionality.
     * It goes as follow:
     * <ol>
     * <li>Gather data from data -> output from actors = input for their environments</li>
     * <li></li>
     * <li></li>
     * <li></li>
     * </ol>
     */
    @Override
    public void run() {
        this.prepare();
        boolean again = false;
        int iterationCounter = 1;
        do {
            LOGGER.info(String.format("Entering iteration -> %d", iterationCounter));
            {
                this.reset();
                this.doTypesLogic();
                this.runEnv();
                this.gatherOutputs();
            }
            LOGGER.info(String.format("Exiting iteration -> %d", iterationCounter++));
        } while (again);
    }

    private void runEnv() {
        for (ClispTypeEnvironmentPair clispType : this.types) {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("runEnv(type -> %s)", clispType.getClispType().getName()));
            }
            final long output = clispType.getEnvironment().run();
            LOGGER.info(String
                    .format("runEvn#result(type -> %s,result -> %d", clispType.getClispType().getName(), output));
        }
    }

    private void doTypesLogic() {
        for (ClispTypeEnvironmentPair pair : this.types) {
            final ClispType clispTypeInstance = pair.getClispType();
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("doTypesLogic(type -> %s)", clispTypeInstance.getName()));
            }
            final List<String> outputs = clispTypeInstance.getOutput();
            if (outputs != null) {
                LOGGER.info(String
                        .format("doTypesLogic(type -> %s provided %d facts", clispTypeInstance.getName(), outputs
                                .size()));
                for (String fact : outputs) {
                    pair.getEnvironment().assertString(fact);
                }
            } else {
                LOGGER.warn(String
                        .format("doTypesLogic(type -> %s provided null output", clispTypeInstance.getName()));
            }
        }
    }

    private void reset() {
        for (ClispTypeEnvironmentPair clispType : this.types) {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("reset(type -> %s)", clispType.getClispType().getName()));
            }
            clispType.getEnvironment().reset();
        }
    }

    private void gatherOutputs() {
        ListIterator<ClispTypeEnvironmentPair> it = this.types.listIterator(this.types.size() - 1);
        while (it.hasPrevious()) {
            ClispTypeEnvironmentPair pair = it.previous();
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("reset(type -> %s)", pair.getClispType().getName()));
            }
            final PrimitiveValue output = pair.getEnvironment()
                    .eval(ClispRunner.findAllFactsString(pair.getClispType().getOutputFactName()));
            final DataStructure dataStructure = new DataStructure();
            dataStructure.addValue("output", output);
            pair.getClispType().setInput(dataStructure);
        }
    }

    private static String findAllFactsString(final String outputFactName) {
        return String.format("(find-all-facts ((?f %s)) TRUE)", outputFactName);
    }

    /**
     * This method is called before main loop and it loads
     * initial data to all environments. Initial data is read
     * from the {@link org.kornicameister.sise.lake.types.ClispType} by using
     * {@link org.kornicameister.sise.lake.types.ClispType#getOutput()} method.
     * Initial data is loaded from properties file, that should be delivered along
     * with type's configuration to complete it.
     */
    public void prepare() {

    }
}
