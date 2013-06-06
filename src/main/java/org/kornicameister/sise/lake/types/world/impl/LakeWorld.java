package org.kornicameister.sise.lake.types.world.impl;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.WorldHelper;
import org.kornicameister.sise.lake.types.WorldField;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.world.DefaultWorld;

import java.util.Iterator;
import java.util.Properties;
import java.util.Random;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class LakeWorld extends DefaultWorld {
    private static final Logger LOGGER = Logger.getLogger(LakeWorld.class);
    private static final Integer MAX_PRESSURE = 1260;
    private static final Integer MIN_PRESSURE = 900;
    protected Integer lakeX;
    protected Integer lakeY;
    protected Integer lakeSize;
    protected Integer rainTime;
    protected Integer stormTime;
    protected Integer pressureLevel;

    public LakeWorld() {
        super();
    }

    @Override
    public void run() {
        LOGGER.info("Running world");
        final Iterator<DefaultActor> defaultActorIterator = WorldHelper.actorIterator();
        while (defaultActorIterator.hasNext()) {
            defaultActorIterator.next().run();
        }
    }

    protected void resolveProperties(final Properties properties) {

        this.width = Integer.valueOf(properties.getProperty("lake.world.width"));
        this.height = Integer.valueOf(properties.getProperty("lake.world.height"));
        this.lakeX = Integer.valueOf(properties.getProperty("lake.lake.x"));
        this.lakeY = Integer.valueOf(properties.getProperty("lake.lake.y"));
        this.lakeSize = Integer.valueOf(properties.getProperty("lake.lake.size"));
        this.rainTime = Integer.valueOf(properties.getProperty("lake.world.rain"));
        this.stormTime = Integer.valueOf(properties.getProperty("lake.world.storm"));
        this.pressureLevel = Integer.valueOf(properties.getProperty("lake.world.pressure", String.valueOf(new Random()
                .nextInt() * (MAX_PRESSURE - MIN_PRESSURE) + MIN_PRESSURE)));

        this.registerFields();
        this.applyLakeRules();
    }

    private void applyLakeRules() {
        final Iterator<WorldField> fieldsIterator = WorldHelper.fieldIterator();
        WorldField worldField;
        boolean inLake;
        while (fieldsIterator.hasNext()) {
            worldField = fieldsIterator.next();
            inLake = worldField.getX() >= this.lakeX && worldField.getX() <= this.lakeX + lakeSize;
            inLake = inLake && worldField.getY() >= this.lakeY && worldField.getY() <= this.lakeY + lakeSize;
            worldField.setWater(inLake);
            if (LOGGER.isDebugEnabled() && inLake) {
                LOGGER.debug(String.format("WorldField %s in lake", worldField));
            }
        }
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder();
        sb.append(super.toString());
        sb.append(" > ");
        sb.append("LakeWorld{");
        sb.append("lakeX=").append(lakeX);
        sb.append(", lakeY=").append(lakeY);
        sb.append(", lakeSize=").append(lakeSize);
        sb.append(", rainTime=").append(rainTime);
        sb.append(", stormTime=").append(stormTime);
        sb.append(", pressureLevel=").append(pressureLevel);
        sb.append('}');
        return sb.toString();
    }
}
