package org.kornicameister.sise.lake.types.effectiveness;

import com.google.common.base.Objects;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public class EffectivenessResult {

    private final String name;
    private final String result;

    public EffectivenessResult(final String name, final String result) {
        this.name = name;
        this.result = result;
    }

    public String getName() {
        return name;
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

        return Objects.equal(this.name, that.name) &&
                Objects.equal(this.result, that.result);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name, result);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                      .addValue(name)
                      .addValue(result)
                      .toString();
    }
}
