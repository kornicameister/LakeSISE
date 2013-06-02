package org.kornicameister.sise.lake.types.world;

import org.kornicameister.sise.lake.io.InputData;
import org.kornicameister.sise.lake.types.DefaultType;

import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class LakeWorld extends DefaultType {
    public LakeWorld(final Properties properties) {
        super(properties);
    }

    @Override
    public String toClisp() {
        return null;
    }

    @Override
    public void fromClisp(final InputData inputData) {

    }

    @Override
    protected void resolveProperties(final Properties properties) {

    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), LakeWorld.class.getSimpleName());
    }
}
