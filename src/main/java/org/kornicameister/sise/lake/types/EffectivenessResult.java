package org.kornicameister.sise.lake.types;

import com.google.common.base.Objects;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessResult
        extends Effectiveness {

    private final String result;

    public EffectivenessResult(final Effectiveness effectiveness, final String value) {
        super(effectiveness.getEffectiveness());
        this.result = value;
    }

    public String getResult() {
        return result;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        EffectivenessResult that = (EffectivenessResult) o;

        return Objects.equal(this.result, that.result) &&
                Objects.equal(this.effectiveness, that.effectiveness);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(result, effectiveness);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                      .addValue(result)
                      .addValue(effectiveness)
                      .toString();
    }
}
