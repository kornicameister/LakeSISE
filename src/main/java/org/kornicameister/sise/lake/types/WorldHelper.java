package org.kornicameister.sise.lake.types;

import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.FluentIterable;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.actors.DefaultActor;

import javax.annotation.Nullable;
import java.util.*;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public abstract class WorldHelper {
    private static final Logger LOGGER = Logger.getLogger(WorldHelper.class);
    private static final Predicate<WorldField> FREE_FIELD = new Predicate<WorldField>() {
        @Override
        public boolean apply(@Nullable WorldField input) {
            assert input != null;
            return input.isFree();
        }
    };
    private static final Predicate<WorldField> WATER_FIELD_PREDICATE = new Predicate<WorldField>() {
        @Override
        public boolean apply(@Nullable WorldField input) {
            assert input != null;
            return input.isWater();
        }
    };
    private static final Predicate<WorldField> LAND_FIELD_PREDICATE = new Predicate<WorldField>() {
        @Override
        public boolean apply(@Nullable WorldField input) {
            assert input != null;
            return !input.isWater();
        }
    };
    private static Map<Integer, WorldField> fields = new IdentityHashMap<>();
    private static Map<Integer, DefaultActor> actors = new IdentityHashMap<>();

    public static WorldField getField(final int x, final int y) {
        for (WorldField field : fields.values()) {
            if (field.getX().equals(x) && field.getY().equals(y)) {
                return field;
            }
        }
        return null;
    }

    public static WorldField getField(final int id) {
        return fields.get(id);
    }

    public static List<WorldField> getField(FieldPredicate predicate) {
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(String.format("getField(%s)", predicate));
        }
        Collection<WorldField> free = new ArrayList<>(fields.values());
        switch (predicate) {
            case FREE_FIELD:
                free = Collections2.filter(free, FREE_FIELD);
                break;
            case FREE_WATER_FIELD:
                free = FluentIterable
                        .from(free)
                        .filter(WATER_FIELD_PREDICATE)
                        .filter(FREE_FIELD)
                        .toList();
                break;
            case FREE_LAND_FIELD:
                free = FluentIterable
                        .from(free)
                        .filter(LAND_FIELD_PREDICATE)
                        .filter(FREE_FIELD)
                        .toList();
                break;
            case LAND_FIELD:
                free = Collections2.filter(free, LAND_FIELD_PREDICATE);
                break;
            case WATER_FIELD:
                free = Collections2.filter(free, WATER_FIELD_PREDICATE);
                break;
        }
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(String.format("getField(%s) returns %d valid fields", predicate, free.size()));
        }
        return new ArrayList<>(free);
    }

    public static DefaultActor getActor(final WorldField field) {
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(String.format("getActor(%s)", field));
        }
        List<DefaultActor> free = new ArrayList<>(
                FluentIterable
                        .from(actors.values())
                        .filter(new Predicate<DefaultActor>() {
                            @Override
                            public boolean apply(@Nullable DefaultActor input) {
                                assert input != null;
                                assert input.getAtField() != null;
                                return input.getAtField().equals(field);
                            }
                        })
                        .toList()
        );
        return free.size() == 1 ? free.get(0) : null;
    }

    public static List<WorldField> getFieldInActorRange(final DefaultActor actor,
                                                        Collection<WorldField> fields) {
        Collection<WorldField> free = new ArrayList<>(fields);
        if (actor != null) {
            free = Collections2.filter(free, new Predicate<WorldField>() {
                @Override
                public boolean apply(@Nullable WorldField input) {
                    assert input != null;
                    return WorldHelper.isFieldInRange(input, actor);
                }
            });
        }
        return new ArrayList<>(free);
    }

    public static List<WorldField> getFieldInActorRange(final DefaultActor actor) {
        Collection<WorldField> free = new ArrayList<>(WorldHelper.fields.values());
        if (actor != null) {
            free = FluentIterable
                    .from(free)
                    .filter(new Predicate<WorldField>() {
                        @Override
                        public boolean apply(@Nullable WorldField input) {
                            assert input != null;
                            return WorldHelper.isFieldInRange(input, actor);
                        }
                    }).toList();
        }
        return new ArrayList<>(free);
    }

    private static boolean isFieldInRange(WorldField input, DefaultActor actor) {
        final int x = input.getX(),
                y = input.getY(),
                aX = actor.getAtField() != null ? actor.getAtField().getX() : 0,
                aY = actor.getAtField() != null ? actor.getAtField().getY() : 0,
                moveRange = actor.getMoveRange();
        return Math.abs(x - aX) <= moveRange
                && Math.abs(y - aY) <= moveRange;
    }

    public static DefaultActor getActor(final int id) {
        return WorldHelper.actors.get(id);
    }

    public static WorldField registerField(final WorldField field) {
        return WorldHelper.fields.put(field.getId(), field);
    }

    public static DefaultActor registerActor(final DefaultActor actor) {
        return WorldHelper.actors.put(actor.getId(), actor);
    }

    public static Iterator<DefaultActor> actorIterator() {
        return WorldHelper.actors.values().iterator();
    }

    public static void moveActorToField(DefaultActor actor, Integer x, Integer y) {
        final WorldField currentField = actor.getAtField();
        final WorldField nextField = WorldHelper.getField(x, y);
        if (currentField != null) {
            currentField.setOccupied(false);
        }
        nextField.setOccupied(true);
        actor.setAtField(nextField);
    }

    public static Iterator<WorldField> fieldIterator() {
        return fields.values().iterator();
    }

    public static Collection<DefaultActor> getActors() {
        return actors.values();
    }

    public static void removeActor(Integer id) {
        actors.remove(id);
    }

    public enum FieldPredicate {
        LAND_FIELD,
        WATER_FIELD,
        FREE_FIELD,
        FREE_LAND_FIELD,
        FREE_WATER_FIELD,
        IN_RANGE
    }
}
