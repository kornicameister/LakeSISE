package org.kornicameister.util;

import com.google.common.base.Objects;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class Point {
    private Double x;
    private Double y;

    public Point() {
        this(0d, 0d);
    }

    public Point(final Double x, final Double y) {
        this.x = x;
        this.y = y;
    }

    public Point(final int x, final int y) {
        this((double) x, (double) y);
    }

    public Double getX() {
        return x;
    }

    public void setX(final Double x) {
        this.x = x;
    }

    public Double getY() {
        return y;
    }

    public void setY(final Double y) {
        this.y = y;
    }

    public void move(Double x, Double y) {
        this.x = x;
        this.y = y;
    }

    public void move(Point point) {
        this.move(point.getX(), point.getY());
    }

    public void translate(Double dx, Double dy) {
        this.x += dx;
        this.y += dy;
    }

    public void translate(final Point point) {
        this.translate(point.getX(), point.getY());
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof Point)) return false;

        Point point = (Point) o;

        return x.equals(point.x) && y.equals(point.y);
    }

    @Override
    public int hashCode() {
        int result = x.hashCode();
        result = 31 * result + y.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("x", x)
                .add("y", y)
                .toString();
    }
}
