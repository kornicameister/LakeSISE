package org.kornicameister.sise.lake.actors;

import com.google.common.base.Objects;
import org.kornicameister.sise.lake.actors.functionality.Movable;
import org.kornicameister.sise.lake.annotations.ClispActor;
import org.kornicameister.util.Point;

/**
 * Basic fact, ready to be used to server
 * as the foundamental element for the rest
 * of actors.
 *
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

@ClispActor(fact = "Actor")
public abstract class Actor implements Movable {
    private static Integer ID = 0;
    private final Integer id;
    private final String name;
    private final String type;
    private final Double moveRange;
    private Integer age;
    private Point location;

    public Actor(final String name, final Double moveRange) {
        this.id = Actor.ID++;
        this.name = name;
        this.moveRange = moveRange;
        this.type = this.getClass().getName();
        this.age = 0;
    }

    public Actor(final String name, final Double moveRange, final Point location) {
        this(name, moveRange);
        this.location = location;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public Double getMoveRange() {
        return moveRange;
    }

    public Point getLocation() {
        return location;
    }

    @Override
    public void move(final Point point) {
        this.location.translate(point);
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof Actor)) return false;

        Actor that = (Actor) o;

        return moveRange.equals(that.moveRange) &&
                name.equals(that.name);
    }

    @Override
    public int hashCode() {
        int result = name.hashCode();
        result = 31 * result + moveRange.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("id", id)
                .add("name", name)
                .add("type", type)
                .add("moveRange", moveRange)
                .toString();
    }
}
