package org.kornicameister.sise.lake.types.actors.impl;

import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ForesterActor extends DefaultActor {

    public ForesterActor(final Properties properties) {
        super(properties);
    }

    @Override
    protected void resolveProperties(final Properties properties) {

    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), ForesterActor.class.getSimpleName());
    }
}
