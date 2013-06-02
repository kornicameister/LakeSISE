package org.kornicameister.sise.lake.types.actors.impl;

import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class PoacherActor extends DefaultActor {
    public PoacherActor(final Properties properties) {
        super(properties);
    }

    @Override
    protected void resolveProperties(final Properties properties) {

    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), "PoacherActor");
    }
}
