package org.kornicameister.sise.lake.clisp;

import CLIPSJNI.Environment;
import org.apache.log4j.Logger;
import org.kornicameister.sise.exception.LakeInitializationException;
import org.kornicameister.sise.lake.types.ClispType;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
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
    private static ClispEnvironment               ourInstance;
    private final  String                         propertiesPath;
    private        List<ClispTypeEnvironmentPair> typeEnvironmentPairMap;
    private        boolean                        bootstrapped;

    private ClispEnvironment(final String propertiesPath) {
        this.propertiesPath = propertiesPath;
        this.typeEnvironmentPairMap = new ArrayList<>();
        this.bootstrapped = this.bootstrap();
    }

    private boolean bootstrap() {
        final Properties properties = new Properties();
        try {
            properties.load(new BufferedReader(new FileReader(new File(this.propertiesPath))));
            for (ClispBootstrapTypeDescriptor entry : ClispPropertiesSplitter.load(LAKE_TYPES, properties)) {
                final ClispTypeEnvironmentPair value = this.bootstrapInternal(entry);
                LOGGER.info(String.format("Bootstrap -> %s to %s", entry.getClazz(), value));
                this.typeEnvironmentPairMap.add(value);
            }

            return this.typeEnvironmentPairMap.size() != 0;

        } catch (IOException ioe) {
            LOGGER.error("Failed to load app", ioe);
        }
        return false;
    }

    private ClispTypeEnvironmentPair bootstrapInternal(final ClispBootstrapTypeDescriptor entry) {
        try {

            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug(String.format("Loading type -> %s", entry.getClazz()));
            }

            Properties loadData = new Properties();
            loadData.load(new BufferedReader(new FileReader(new File(entry.getInitDataProperties()))));

            Class<?> clazz = Class.forName(entry.getClazz());
            Constructor constructor = clazz.getConstructor(Properties.class);
            ClispType clispType = (ClispType) constructor.newInstance(loadData);

            Environment environment = new Environment();
            environment.load(entry.getClisp());

            return new ClispTypeEnvironmentPair(environment, clispType);

        } catch (InstantiationException | IllegalAccessException | ClassNotFoundException | IOException | NoSuchMethodException | InvocationTargetException multipleE) {
            LOGGER.error(String.format("Failure in creating actor for entry -> %s", entry.getClazz()), multipleE);
            throw new LakeInitializationException(multipleE);
        }
    }

    public static ClispEnvironment newInstance(final String propertiesPath) {
        ClispEnvironment.ourInstance = new ClispEnvironment(propertiesPath);
        return ClispEnvironment.ourInstance;
    }

    public static ClispEnvironment getInstance() {
        return ClispEnvironment.ourInstance;
    }

    public void mainLoop() {
        // run in thread
        new Thread(new ClispRunner(this.typeEnvironmentPairMap)).start();
    }

    public boolean isBootstrapped() {
        return bootstrapped;
    }
}
