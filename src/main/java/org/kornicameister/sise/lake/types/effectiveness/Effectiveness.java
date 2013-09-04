package org.kornicameister.sise.lake.types.effectiveness;

import com.google.common.base.Objects;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class Effectiveness {
    protected final String effectiveness;

    public Effectiveness(final String effectiveness) {
        this.effectiveness = effectiveness;
    }

    public String getEffectiveness() {
        return effectiveness;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        Effectiveness that = (Effectiveness) o;

        return Objects.equal(this.effectiveness, that.effectiveness);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(effectiveness);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                      .addValue(effectiveness)
                      .toString();
    }
}
