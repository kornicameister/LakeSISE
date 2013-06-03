package org.kornicameister.sise.lake.types.actors.impl.tt;

import org.kornicameister.sise.lake.io.DataStructure;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class PoacherActorTT extends DefaultActor {

    public PoacherActorTT(final Properties properties) {
        super(properties);
    }

    @Override
    protected String resolveProperties(final Properties properties) {
        return null;
    }

    @Override
    public String getOutputFactName() {
        return null;
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
        return String.format("%s->%s", super.getName(), PoacherActorTT.class.getSimpleName());
    }
}
