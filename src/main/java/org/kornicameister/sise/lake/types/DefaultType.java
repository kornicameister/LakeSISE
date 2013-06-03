package org.kornicameister.sise.lake.types;

import com.google.common.base.Objects;
import org.kornicameister.sise.lake.io.DataStructure;

import java.util.Properties;

/**
 * Basic fact, ready to be used to serve
 * as the foundamental element for the rest
 * of actors.
 *
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */


public abstract class DefaultType implements ClispType {
    private static Integer ID = 0;
    protected DataStructure dataStructure;
    private   Integer       id;
    private   String        outputFactName;

    protected DefaultType(final Properties properties) {
        this.id = DefaultType.ID++;
        this.outputFactName = this.resolveProperties(properties);
    }

    /**
     * This method resolves properties for actor particular implementation.
     * It must return one variable which is output fact name by which {@link org.kornicameister.sise.lake.clisp.ClispRunner}
     * is able to extract output fact for particular type
     *
     * @param properties
     *
     * @return outputFactName
     */
    protected abstract String resolveProperties(final Properties properties);

    public Integer getId() {
        return this.id;
    }

    @Override
    public String getOutputFactName() {
        return this.outputFactName;
    }

    @Override
    public String getName() {
        return DefaultType.class.getSimpleName();
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + outputFactName.hashCode();
        return result;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof DefaultType)) {
            return false;
        }

        DefaultType that = (DefaultType) o;

        return id.equals(that.id) && outputFactName.equals(that.outputFactName);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("dataStructure", dataStructure)
                .add("id", id)
                .add("outputFactName", outputFactName)
                .toString();
    }
}
