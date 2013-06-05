package org.kornicameister.sise.lake.types.world;

import CLIPSJNI.Environment;
import org.kornicameister.sise.lake.types.DefaultClispType;
import org.kornicameister.sise.lake.types.WorldField;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

abstract public class DefaultWorld extends DefaultClispType {
    //clisp
    protected Integer        width;
    protected Integer        height;
    protected Environment    environment;
    protected WorldField[][] board;
    //clisp

    public DefaultWorld() {
        super();
    }

    @Override
    public String getName() {
        return DefaultWorld.class.getSimpleName();
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("DefaultWorld{");
        sb.append("width=").append(width);
        sb.append(", height=").append(height);
        sb.append(", environment=").append(environment);
        sb.append('}');
        return sb.toString();
    }
}
