package org.kornicameister.sise.lake.types;

import CLIPSJNI.Environment;
import org.apache.log4j.Logger;

import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public abstract class DefaultClispType implements ClispType {
    private static final Logger LOGGER = Logger.getLogger(DefaultClispType.class);
    protected Environment environment;

    @Override
    public void initType(final Properties properties, final Environment environment, final List<String> clpPaths) {

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(String.format("Initializing clisp type\nproperties=%s,environment=%s,facts=%s",
                    properties, environment, clpPaths));
        }

        this.resolveEnvironment(environment);

        for (String clp : clpPaths) {
            this.environment.load(clp);
        }
        this.environment.reset();

        this.resolveProperties(properties);
    }

    protected final void resolveEnvironment(final Environment environment) {
        this.environment = environment;
    }

    protected abstract void resolveProperties(final Properties properties);
}
