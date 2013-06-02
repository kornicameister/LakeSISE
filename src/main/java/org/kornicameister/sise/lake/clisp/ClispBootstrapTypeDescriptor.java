package org.kornicameister.sise.lake.clisp;

import com.google.common.base.Objects;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

class ClispBootstrapTypeDescriptor {
    private final String clazz;
    private final String clisp;
    private final String initDataProperties;

    public ClispBootstrapTypeDescriptor(final String clazz, final String clisp, final String initDataProperties) {
        this.clazz = clazz;
        this.clisp = clisp;
        this.initDataProperties = initDataProperties;
    }

    public String getClazz() {
        return clazz;
    }

    public String getClisp() {
        return clisp;
    }

    public String getInitDataProperties() {
        return initDataProperties;
    }

    @Override
    public int hashCode() {
        int result = clazz.hashCode();
        result = 31 * result + clisp.hashCode();
        result = 31 * result + initDataProperties.hashCode();
        return result;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof ClispBootstrapTypeDescriptor)) return false;

        ClispBootstrapTypeDescriptor that = (ClispBootstrapTypeDescriptor) o;

        return clazz.equals(that.clazz) && clisp.equals(that.clisp) && initDataProperties
                .equals(that.initDataProperties);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("clazz", clazz)
                .add("clisp", clisp)
                .add("initDataProperties", initDataProperties)
                .toString();
    }
}
