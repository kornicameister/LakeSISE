package org.kornicameister.sise.lake.types.world;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.DefaultClispType;
import org.kornicameister.sise.lake.types.WorldField;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

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
                final Iterator<DefaultActor> defaultActorIterator = WorldHelper.actorIterator();
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
        List<WorldField> freeFields = null;
        switch (actor.getType()) {
            case HERBIVORE_FISH:
            case PREDATOR_FISH:
                freeFields = WorldHelper.getField(WorldHelper.FieldPredicate.FREE_WATER_FIELD);
                break;
            case FORESTER:
            case POACHER:
            case ANGLER:
            case BIRD:
                freeFields = WorldHelper.getField(WorldHelper.FieldPredicate.FREE_LAND_FIELD);
                break;
        }
        freeFields = WorldHelper.getFieldInActorRange(actor, freeFields);
        return freeFields.get(new Random().nextInt(freeFields.size() - 1));
    }

    @Override
    public String getFactName() {
        return DefaultWorld.class.getSimpleName();
    }

    @Override
    public String getFactId() {
        return String.format("%s_%d", this.getFactName(), 0);
    }

    protected void registerFields() {
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                WorldHelper.registerField(new WorldField(i, j));
            }
        }
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

    protected abstract void applyStateToEnvironment();
}
