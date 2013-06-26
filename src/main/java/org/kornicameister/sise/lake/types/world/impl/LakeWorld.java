package org.kornicameister.sise.lake.types.world.impl;

import CLIPSJNI.PrimitiveValue;
import com.google.common.base.Objects;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.clisp.InitMode;
import org.kornicameister.sise.lake.types.WorldField;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.world.DefaultWorld;
import org.kornicameister.util.StatField;

import java.util.*;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class LakeWorld extends DefaultWorld {
    private static final Logger LOGGER = Logger.getLogger(LakeWorld.class);
    private static final String FIND_FACT_F_FIELD_F_ID_D = "(find-fact ((?f field)) (= ?f:id %d))";
    private static final String FIND_FACT_A_ACTOR_EQ_A_ID_S = "(find-fact ((?a actor)) (eq ?a:id \"%s\"))";
    private static final String DO_WEATHER_RANDOM_S = "(doWeather (random %s) )";
    protected Integer lakeX;
    protected Integer lakeY;
    protected Integer lakeSize;
    private Integer iteration;
    private Set<Weather> weatherList;

    public LakeWorld() {
        super();
        this.iteration = 0;
        this.weatherList = new HashSet<>();
    }

    @Override
    public void run() {
        LOGGER.info(String.format("[%d] > world loop started", this.iteration));
        this.environment.reset();
        this.assertWeather();
        this.assertFields();
        this.assertActors();
        this.environment.run();
        this.collectResults();
        LOGGER.info(String.format("[%d] > world loop finished", this.iteration++));
    }

    private void collectResults() {
        final Iterator<DefaultActor> defaultActorIterator = WorldHelper.actorIterator();
        final Iterator<WorldField> worldFieldIterator = WorldHelper.fieldIterator();
        while (defaultActorIterator.hasNext()) {
            final DefaultActor actor = defaultActorIterator.next();
            //collect results and update fields status and actors status
            if (actor.isAlive()) {
                this.collectResultFromActor(actor);
            } else {
                this.printDeath(actor);
            }
            //collect results and update fields status and actors status
        }
        while (worldFieldIterator.hasNext()) {
            final WorldField field = worldFieldIterator.next();
            try {
                final String findPrevFieldStr = String.format(FIND_FACT_F_FIELD_F_ID_D, field.getId());
                field.applyFact(this.environment.eval(findPrevFieldStr).get(0));
            } catch (Exception exception) {
                LOGGER.fatal(String.format("Failed to update field %s", field.getId()), exception);
            }
        }
    }

    private void collectResultFromActor(final DefaultActor actor) {
        try {
            final String findActorFactStr = String.format(FIND_FACT_A_ACTOR_EQ_A_ID_S, actor.getFactId());
            PrimitiveValue value = this.environment.eval(findActorFactStr);
            if (value.size() != 0) {

                final List<StatField> before = actor.getStats();
                actor.newRound();
                actor.applyFact(value.get(0));
                final List<StatField> after = actor.getStats();

                this.printComparison(before, after);
            } else {
                actor.setAlive(false);
                System.out.println(String.format("\t%s is no longer alive", actor.getFactId()));
            }
        } catch (Exception exception) {
            LOGGER.fatal(String.format("Failed to update actor %s", actor.getFactId()), exception);
        }
    }

    @Override
    protected void resolveProperties(final Properties properties, InitMode initMode) {
        this.width = Integer.valueOf(properties.getProperty("lake.world.width"));
        this.height = Integer.valueOf(properties.getProperty("lake.world.height"));
        this.lakeX = Integer.valueOf(properties.getProperty("lake.lake.x"));
        this.lakeY = Integer.valueOf(properties.getProperty("lake.lake.y"));
        this.lakeSize = Integer.valueOf(properties.getProperty("lake.lake.size"));

        final String[] conditions = properties.getProperty("lake.world.conditions").split(",");
        for (String str : conditions) {
            this.weatherList.add(Weather.valueOf(str.toUpperCase()));
        }

        this.registerFields();
        this.applyLakeRules();

        WorldHelper.registerWorld(this);
    }

    private void applyLakeRules() {
        LOGGER.info("Applying Lake-World rules");
        final Iterator<WorldField> fieldsIterator = WorldHelper.fieldIterator();
        WorldField worldField;
        boolean inLake;
        while (fieldsIterator.hasNext()) {
            worldField = fieldsIterator.next();
            inLake = this.isInLakeArea(worldField);
            worldField.setWater(inLake);
            if (LOGGER.isDebugEnabled() && inLake) {
                LOGGER.debug(String.format("WorldField %s in lake", worldField));
            }
        }
        LOGGER.info("Applied Lake-World rules");
    }

    private boolean isInLakeArea(WorldField worldField) {
        boolean inLake;
        inLake = worldField.getX() >= this.lakeX && worldField.getX() <= this.lakeX + lakeSize;
        inLake = inLake && worldField.getY() >= this.lakeY && worldField.getY() <= this.lakeY + lakeSize;
        return inLake;
    }

    public void applyWeather(Weather... conditions) {
        this.weatherList.clear();
        Collections.addAll(this.weatherList, conditions);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("super", super.toString())
                .add("lakeX", lakeX)
                .add("lakeY", lakeY)
                .add("lakeSize", lakeSize)
                .add("iteration", iteration)
                .add("weatherList", weatherList)
                .toString();
    }

    @Override
    protected void assertWeather() {
        final StringBuilder weatherSB = new StringBuilder();
        for (Weather weather : this.weatherList) {
            weatherSB.append(weather.toString().toLowerCase()).append(" ");
        }
        weatherSB.deleteCharAt(weatherSB.length() - 1);
        this.environment.assertString(String.format(DO_WEATHER_RANDOM_S, weatherSB.toString().trim()));
    }

    @Override
    protected void assertFields() {
        final Iterator<WorldField> worldFieldIterator = WorldHelper.fieldIterator();
        while (worldFieldIterator.hasNext()) {
            this.environment.assertString(worldFieldIterator.next().getFact());
        }
    }

    @Override
    protected void assertActors() {
        final Iterator<DefaultActor> defaultActorIterator = WorldHelper.actorIterator();
        while (defaultActorIterator.hasNext()) {
            final DefaultActor actor = defaultActorIterator.next();
            if (actor.isAlive()) {
                actor.clearFields();
                this.environment.assertString(actor.getFact());
            } else {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug(String.format("Actor %s is no longer alive and wont participat in the round", actor.getFactId()));
                }
            }
        }
    }

    public enum Weather {
        RAIN, STORM, SUN
    }
}
