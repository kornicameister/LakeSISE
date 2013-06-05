package org.kornicameister.sise.lake.types;

import CLIPSJNI.Environment;

import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public abstract class DefaultClispType implements ClispType {
    protected Environment environment;

    @Override
    public void initType(final Properties properties, final Environment environment, final List<String> clpPaths) {
        this.resolveProperties(properties);
        this.resolveEnvironment(environment);
        for (String clp : clpPaths) {
            this.environment.load(clp);
        }
        this.environment.reset();
    }

    protected final void resolveEnvironment(final Environment environment) {
        this.environment = environment;
    }

    protected abstract void resolveProperties(final Properties properties);
}
