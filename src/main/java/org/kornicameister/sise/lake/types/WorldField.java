package org.kornicameister.sise.lake.types;

import CLIPSJNI.PrimitiveValue;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class WorldField implements ClispReady {
    private static int ID = 1;
    private final Integer id;
    private Boolean occupied;
    private Boolean water;
    private Integer x;
    private Integer y;

    public WorldField(Integer x, Integer y) {
        this(x, y, false, false);
    }

    public WorldField(Integer x, Integer y, boolean occupied, boolean water) {
        this.id = WorldField.ID++;
        this.occupied = occupied;
        this.x = x;
        this.y = y;
        this.water = water;
    }

    public Integer getId() {
        return id;
    }

    public boolean isFree() {
        return !occupied;
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
        return String.format("(field (id %d) (x %d) (y %d) (occupied %s) (water %s))",
                this.id,
                this.x,
                this.y,
                BooleanToSymbol.toSymbol(this.occupied),
                BooleanToSymbol.toSymbol(this.water)
        );
    }

    @Override
    public void applyFact(PrimitiveValue value) throws Exception {
        this.setOccupied(BooleanToSymbol.fromSymbol(value.getFactSlot("occupied").symbolValue()));
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
}
