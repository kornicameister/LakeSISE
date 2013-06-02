package org.kornicameister.sise.lake.types.actors.impl.tt;

import org.kornicameister.sise.lake.types.actors.impl.ForesterActor;

import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ForesterActorTT extends ForesterActor {

    public ForesterActorTT(final Properties properties) {
        super(properties);
    }

    @Override
    protected void resolveProperties(final Properties properties) {

    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), ForesterActorTT.class.getSimpleName());
    }
}
