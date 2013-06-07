package org.kornicameister.sise.lake.clisp;

import CLIPSJNI.Environment;
import org.apache.log4j.Logger;
import org.kornicameister.sise.exception.LakeInitializationException;
import org.kornicameister.sise.lake.types.ClispType;
import org.kornicameister.sise.lake.types.world.DefaultWorld;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ClispEnvironment {
    private static final Logger LOGGER = Logger.getLogger(ClispEnvironment.class);
    private static final String LAKE_TYPES = "lake.types";
    private static final Environment ENVIRONMENT = new Environment();
    private static ClispEnvironment ourInstance;
    private final String propertiesPath;
    private List<ClispType> clispTypes;
    private boolean bootstrapped;

    private ClispEnvironment(final String propertiesPath) {
        this.propertiesPath = propertiesPath;
        this.clispTypes = new ArrayList<>();
        this.bootstrapped = this.bootstrap();
    }

    public static ClispEnvironment newInstance(final String propertiesPath) {
        ClispEnvironment.ourInstance = new ClispEnvironment(propertiesPath);
        return ClispEnvironment.ourInstance;
    }

    private boolean bootstrap() {
        final Properties properties = new Properties();
        try {
            properties.load(new BufferedReader(new FileReader(new File(this.propertiesPath))));
            for (ClispBootstrapTypeDescriptor entry : ClispPropertiesSplitter.load(LAKE_TYPES, properties)) {
                final ClispType value = this.bootstrapInternal(entry);
                LOGGER.info(String.format("Bootstrap -> %s to %s", entry.getClazz(), value));
                this.clispTypes.add(value);
            }

            return this.clispTypes.size() != 0;

        } catch (IOException ioe) {
            LOGGER.error("Failed to load app", ioe);
        }
        return false;
    }

    private ClispType bootstrapInternal(final ClispBootstrapTypeDescriptor entry) {
        try {

            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("Loading type -> %s", entry.getClazz()));
            }

            Properties loadData = new Properties();
            loadData.load(new BufferedReader(new FileReader(new File(entry.getInitDataProperties()))));

            Class<?> clazz = Class.forName(entry.getClazz());
            ClispType clispType = (ClispType) clazz.newInstance();

            clispType.initType(loadData, ClispEnvironment.ENVIRONMENT, entry.getClisp());

            return clispType;

        } catch (InstantiationException | IllegalAccessException | ClassNotFoundException | IOException multipleE) {
            LOGGER.error(String.format("Failure in creating actor for entry -> %s", entry.getClazz()), multipleE);
            throw new LakeInitializationException(multipleE);
        }
    }

    public void mainLoop() {
        // find world
        final DefaultWorld defaultWorld = this.findWorld();
        if (defaultWorld == null) {
            LOGGER.error("No world found...will exit");
            throw new LakeInitializationException("There is no world defined...");
        }
        // find world
        if (defaultWorld.initializeWorld()) {
            defaultWorld.run();
        } else {
            throw new LakeInitializationException("World failed to be initialized...");
        }
    }

    private DefaultWorld findWorld() {
        for (ClispType clispType : this.clispTypes) {
            if (clispType instanceof DefaultWorld) {
                return (DefaultWorld) clispType;
            }
        }
        return null;
    }

    public boolean isBootstrapped() {
        return bootstrapped;
    }
}
