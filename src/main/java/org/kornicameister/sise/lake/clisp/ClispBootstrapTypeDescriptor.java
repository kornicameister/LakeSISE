package org.kornicameister.sise.lake.clisp;

import com.google.common.base.Objects;
import org.apache.log4j.Logger;

import java.util.List;
import java.util.Random;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

class ClispBootstrapTypeDescriptor {
    private static final Logger LOGGER = Logger.getLogger(ClispBootstrapTypeDescriptor.class);
    private static final Random SEED = new Random(System.nanoTime());
    private static final int MAX = 10;
    private final String clazz;
    private final List<String> clisp;
    private final String initDataProperties;
    private Integer number;

    public ClispBootstrapTypeDescriptor(final String clazz,
                                        final List<String> clisp,
                                        final String initDataProperties,
                                        final String number) {
        this.clazz = clazz;
        this.clisp = clisp;
        this.initDataProperties = initDataProperties;
        this.setNumber(number);
    }

    public String getClazz() {
        return clazz;
    }

    public List<String> getClisp() {
        return clisp;
    }

    public String getInitDataProperties() {
        return initDataProperties;
    }

    public Integer getNumber() {
        return number;
    }

    private void setNumber(String number) {
        if (number.equals("random")) {
            this.number = SEED.nextInt(MAX);
        } else {
            try {
                this.number = Integer.parseInt(number);
            } catch (NumberFormatException nfe) {
                LOGGER.warn(nfe);
                this.number = 1;
            }
        }
    }

    @Override
    public int hashCode() {
        int result = clazz.hashCode();
        result = 31 * result + clisp.hashCode();
        result = 31 * result + initDataProperties.hashCode();
        result = 31 * result + number.hashCode();
        return result;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof ClispBootstrapTypeDescriptor)) {
            return false;
        }

        ClispBootstrapTypeDescriptor that = (ClispBootstrapTypeDescriptor) o;

        return clazz.equals(that.clazz) && clisp.equals(that.clisp) && initDataProperties
                .equals(that.initDataProperties) && number.equals(that.number);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("clazz", clazz)
                .add("clisp", clisp)
                .add("initDataProperties", initDataProperties)
                .add("number", number)
                .toString();
    }
}
