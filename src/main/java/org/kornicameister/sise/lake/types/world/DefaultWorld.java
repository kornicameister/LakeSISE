package org.kornicameister.sise.lake.types.world;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.WorldHelper;
import org.kornicameister.sise.lake.types.DefaultClispType;
import org.kornicameister.sise.lake.types.WorldField;
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
                    final DefaultActor next = defaultActorIterator.next();
                    this.randomizeField(next);
                    this.environment.assertString(next.getFact());
                }
                this.worldReady = true;
            }
        } catch (Exception ex) {
            LOGGER.error("Failure in world initializing process", ex);
        }
        return this.worldReady;
    }

    private void randomizeField(DefaultActor actor) {
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
        final WorldField freeField = freeFields.get(new Random().nextInt(freeFields.size() - 1));
        WorldHelper.moveActorToField(actor, freeField.getX(), freeField.getY());
    }

    @Override
    public String getName() {
        return DefaultWorld.class.getSimpleName();
    }

    protected void registerFields() {
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                final WorldField worldField = new WorldField(i, j);
                WorldHelper.registerField(worldField);
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
}
