package org.kornicameister.sise.lake.clisp;

import CLIPSJNI.Environment;
import com.google.common.base.Objects;
import org.kornicameister.sise.lake.types.ClispType;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

class ClispTypeEnvironmentPair {
    private final Environment environment;
    private final ClispType clispType;

    public ClispTypeEnvironmentPair(final Environment environment, final ClispType clispType) {
        this.environment = environment;
        this.clispType = clispType;
    }

    public Environment getEnvironment() {
        return environment;
    }

    public ClispType getClispType() {
        return clispType;
    }

    public void destroy() {
        this.environment.destroy();
    }

    @Override
    public int hashCode() {
        int result = environment.hashCode();
        result = 31 * result + clispType.hashCode();
        return result;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof ClispTypeEnvironmentPair)) return false;

        ClispTypeEnvironmentPair that = (ClispTypeEnvironmentPair) o;

        return clispType.equals(that.clispType) && environment.equals(that.environment);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("environment", environment)
                .add("clispType", clispType.getName())
                .toString();
    }
}
