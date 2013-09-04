package org.kornicameister.sise.lake.types.world;

import com.google.common.base.Preconditions;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.DefaultClispType;
import org.kornicameister.sise.lake.types.WorldField;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.util.StatField;

import java.util.Iterator;
import java.util.List;
import java.util.Random;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

abstract public class DefaultWorld
        extends DefaultClispType
        implements World {
    private final static Logger LOGGER = Logger.getLogger(DefaultActor.class);
    private static final String STAT_STRING = "\t%1$-15s ::\t %2$-20s >>> \t%3$s";
    protected Integer width;
    protected Integer height;
    protected Boolean worldReady;

    public DefaultWorld() {
        super();
        this.worldReady = false;
    }

    @Override
    public boolean initializeWorld() {
        try {
            if (!this.worldReady) {
                final Iterator<DefaultActor> defaultActorIterator = WorldHelper.actorIterator(false);
                while (defaultActorIterator.hasNext()) {
                    this.randomizeField(defaultActorIterator.next());
                }
                this.worldReady = true;
            }
        } catch (Exception ex) {
            LOGGER.error("Failure in world initializing process", ex);
        }
        return this.worldReady;
    }

    private void randomizeField(DefaultActor actor) {
        final WorldField freeField = this.getWorldFieldToActor(actor);
        WorldHelper.moveActorToField(actor, freeField.getX(), freeField.getY());
    }

    protected WorldField getWorldFieldToActor(DefaultActor actor) {
        final List<WorldField> freeFields = this.getWorldFieldsByActorType(actor);
        return this.getRandomWorldField(freeFields);
    }

    private List<WorldField> getWorldFieldsByActorType(DefaultActor actor) {
        List<WorldField> freeFields = null;
        switch (actor.getType()) {
            case HERBIVORE_FISH:
            case PREDATOR_FISH:
                freeFields = WorldHelper.getField(WorldHelper.FieldPredicate.FREE_WATER_FIELD);
                break;
            case ANGLER:
                freeFields = WorldHelper.getField(WorldHelper.FieldPredicate.LAND_FIELD_NEXT_TO_WATER_FIELD);
                break;
            case FORESTER:
            case POACHER:
            case BIRD:
                freeFields = WorldHelper.getField(WorldHelper.FieldPredicate.FREE_LAND_FIELD);
                break;
        }
        return freeFields;
    }

    private WorldField getRandomWorldField(List<WorldField> freeFields) {
        if (freeFields.size() == 1) {
            return freeFields.get(0);
        }
        return freeFields.get(new Random().nextInt(freeFields.size() - 1));
    }

    protected void registerFields() {
        for (int i = 0; i < getWidth(); i++) {
            for (int j = 0; j < getHeight(); j++) {
                WorldHelper.registerField(new WorldField(i, j));
            }
        }
    }

    public Integer getWidth() {
        return width;
    }

    public void setWidth(Integer width) {
        this.width = width;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    @Override
    public String toString() {
        return String.format("width=%d, height=%d, environment=%s}", getWidth(), getHeight(), environment);
    }

    protected abstract void assertWeather();

    protected abstract void assertFields();

    protected abstract void assertActors();

    protected void printComparison(final List<StatField> before, final List<StatField> after) {
        Preconditions.checkArgument(before.size() == after.size());
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append("\tStatistic\t\n");

        for (int i = 0; i < before.size(); i++) {
            final StatField beforeStat = before.get(i);
            final StatField afterStat = after.get(i);
            if (beforeStat.getField().equals(afterStat.getField())) {
                stringBuilder
                        .append(
                                String.format(STAT_STRING,
                                        beforeStat.getField(),
                                        beforeStat.getValue(),
                                        afterStat.getValue()))
                        .append("\n");
            }
        }
        System.out.println(stringBuilder.toString());
    }

    protected void printDeath(final DefaultActor actor) {
        System.out.println(String.format("Actor %s is death, been alive for %d rounds", actor.getFactId(), actor.getRoundsAlive()));
    }

    @Override
    public String getFactName() {
        return DefaultWorld.class.getSimpleName();
    }

    @Override
    public String getFactId() {
        return String.format("%s_%d", this.getFactName(), 0);
    }

}
