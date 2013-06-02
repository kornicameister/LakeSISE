package org.kornicameister.sise.lake.types;

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
    private Integer id;

    public DefaultType(final Properties properties) {
        this.id = DefaultType.ID++;
        this.resolveProperties(properties);
    }

    protected abstract void resolveProperties(final Properties properties);

    public Integer getId() {
        return id;
    }

    @Override
    public String toClisp() {
        return null;
    }

    @Override
    public void fromClisp(final String inputData) {

    }

    @Override
    public String getName() {
        return DefaultType.class.getSimpleName();
    }

    @Override
    public void doLogic() {
        // no impl
    }
}
