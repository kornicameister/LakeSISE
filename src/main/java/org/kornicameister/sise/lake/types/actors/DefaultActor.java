package org.kornicameister.sise.lake.types.actors;

import org.kornicameister.sise.lake.types.DefaultType;
import org.kornicameister.util.Point;

import java.util.Properties;

/**
 * Basic fact, ready to be used to serve
 * as the foundamental element for the rest
 * of actors.
 *
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public abstract class DefaultActor extends DefaultType {
    private Double moveRange;
    private Integer age;
    private Point  location;

    public DefaultActor(final Properties properties) {
        super(properties);
    }

    public Double getMoveRange() {
        return moveRange;
    }

    public Point getLocation() {
        return location;
    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), DefaultActor.class.getSimpleName());
    }
}
