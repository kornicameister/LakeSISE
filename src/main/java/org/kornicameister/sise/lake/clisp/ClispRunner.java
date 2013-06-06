package org.kornicameister.sise.lake.clisp;

import org.apache.log4j.Logger;
import org.kornicameister.sise.exception.LakeInitializationException;
import org.kornicameister.sise.lake.types.ClispType;
import org.kornicameister.sise.lake.types.world.DefaultWorld;

import java.util.ArrayList;
import java.util.List;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

class ClispRunner {
    private final static Logger LOGGER = Logger.getLogger(ClispRunner.class);
    private final List<ClispType> types;
    private int iterationCounter = 1;
    private DefaultWorld world;

    public ClispRunner(final List<ClispType> types) {
        this.types = new ArrayList<>(types);
        for (ClispType clispType : types) {
            if (clispType instanceof DefaultWorld) {
                this.world = (DefaultWorld) clispType;
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

    public void run() {

    }

}
