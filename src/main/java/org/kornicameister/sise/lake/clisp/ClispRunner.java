package org.kornicameister.sise.lake.clisp;

import java.util.Set;

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
 * @version0.0.1
 * @since0.0.1
 */

class ClispRunner implements Runnable {

    private final Set<ClispTypeEnvironmentPair> types;

    public ClispRunner(final Set<ClispTypeEnvironmentPair> types) {
        this.types = types;
    }

    @Override
    public void run() {
        for (ClispTypeEnvironmentPair clispType : this.types) {
            clispType.getClispType().fromClisp(null);
            clispType.getEnvironment().assertString(clispType.getClispType().toClisp());
            clispType.getClispType().doLogic();
            clispType.getClispType().toClisp();
        }
    }
}
