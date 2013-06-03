package org.kornicameister.sise.lake.types.world;

import org.kornicameister.sise.lake.types.DefaultType;

import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

abstract public class DefaultWorld extends DefaultType {

    public DefaultWorld(final Properties properties) {
        super(properties);
    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), DefaultWorld.class.getSimpleName());
    }
}
