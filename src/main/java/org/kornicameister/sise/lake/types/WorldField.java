package org.kornicameister.sise.lake.types;

import org.kornicameister.sise.lake.adapters.BooleanToInteger;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class WorldField implements ClispReady {
    private boolean occupied;
    private boolean water;
    private Integer x;
    private Integer y;
    private Object  id;

    public WorldField(Integer x, Integer y) {
        this(x, y, false);
    }

    public WorldField(Integer x, Integer y, boolean occupied) {
        this.occupied = occupied;
        this.x = x;
        this.y = y;
    }

    public boolean isOccupied() {
        return occupied;
    }

    public void setOccupied(boolean occupied) {
        this.occupied = occupied;
    }

    public Integer getX() {
        return x;
    }

    public void setX(Integer x) {
        this.x = x;
    }

    public Integer getY() {
        return y;
    }

    public void setY(Integer y) {
        this.y = y;
    }

    public boolean isWater() {
        return water;
    }

    public void setWater(final boolean water) {
        this.water = water;
    }

    @Override
    public String getFact() {
        return String.format("%s (x %d) (y %d) (occupied %d) (water %d)",
                "field",
                this.x,
                this.y,
                new BooleanToInteger().adaptOut(this.occupied),
                new BooleanToInteger().adaptOut(this.water)
        );
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("WorldField{");
        sb.append("occupied=").append(occupied);
        sb.append(", water=").append(water);
        sb.append(", x=").append(x);
        sb.append(", y=").append(y);
        sb.append('}');
        return sb.toString();
    }

    public Object getId() {
        return id;
    }
}
