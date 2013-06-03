package org.kornicameister.sise.lake.types.world.impl;

import org.kornicameister.sise.lake.io.DataStructure;
import org.kornicameister.sise.lake.types.world.DefaultWorld;

import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class LakeWorld extends DefaultWorld {
    private static final String LAKE_OUTPUT_FACT_NAME_DV = "lake-output";
    private static final String LAKE_OUTPUT_FACT_NAME    = "lake.output.fact.name";

    public LakeWorld(final Properties properties) {
        super(properties);
    }

    @Override
    protected String resolveProperties(final Properties properties) {
        return properties.getProperty(LAKE_OUTPUT_FACT_NAME, LAKE_OUTPUT_FACT_NAME_DV);
    }

    @Override
    public void setInput(final DataStructure input) {

    }

    @Override
    public List<String> getOutput() {
        return null;
    }

    @Override
    public String getName() {
        return String.format("%s->%s", super.getName(), LakeWorld.class.getSimpleName());
    }
}
