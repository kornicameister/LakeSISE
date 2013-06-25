package org.kornicameister.sise.lake.types.world.impl;

import CLIPSJNI.PrimitiveValue;
import com.google.common.base.Objects;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.clisp.InitMode;
import org.kornicameister.sise.lake.types.WorldField;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.world.DefaultWorld;
import org.kornicameister.util.StatField;

import java.util.Iterator;
import java.util.List;
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
    private static final String FIND_FACT_F_FIELD_F_ID_D = "(find-fact ((?f field)) (= ?f:id %d))";
    private static final String FIND_FACT_A_ACTOR_EQ_A_ID_S = "(find-fact ((?a actor)) (eq ?a:id \"%s\"))";
    protected Integer lakeX;
    protected Integer lakeY;
    protected Integer lakeSize;
    protected Boolean rain;
    protected Boolean storm;
    protected Integer pressureLevel;
    private Integer iteration;

    public LakeWorld() {
        super();
        this.iteration = 0;
    }

    @Override
    public void run() {
        LOGGER.info(String.format("[%d] > world loop started", this.iteration));
        this.environment.reset();
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
            try {

                final String findActorFactStr = String.format(FIND_FACT_A_ACTOR_EQ_A_ID_S, actor.getFactId());
                PrimitiveValue value = this.environment.eval(findActorFactStr);
                if (value.size() != 0) {

                    final List<StatField> before = actor.getStats();
                    actor.applyFact(value.get(0));
                    final List<StatField> after = actor.getStats();

                    this.printComparison(before, after);
                } else {
                    defaultActorIterator.remove();
                    System.out.println(String.format("\t%s is no longer alive", actor.getFactId()));
                }


            } catch (Exception exception) {
                LOGGER.fatal(String.format("Failed to update actor %s", actor.getFactId()), exception);
            }
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

    @Override
    protected void resolveProperties(final Properties properties, InitMode initMode) {
        this.width = Integer.valueOf(properties.getProperty("lake.world.width"));
        this.height = Integer.valueOf(properties.getProperty("lake.world.height"));
        this.lakeX = Integer.valueOf(properties.getProperty("lake.lake.x"));
        this.lakeY = Integer.valueOf(properties.getProperty("lake.lake.y"));
        this.lakeSize = Integer.valueOf(properties.getProperty("lake.lake.size"));
        this.rain = Boolean.valueOf(properties.getProperty("lake.world.rain", "false"));
        this.storm = Boolean.valueOf(properties.getProperty("lake.world.storm", "false"));
        this.pressureLevel = Integer.valueOf(properties.getProperty("lake.world.pressure", String.valueOf(new Random()
                .nextInt() * (MAX_PRESSURE - MIN_PRESSURE) + MIN_PRESSURE)));

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
            inLake = worldField.getX() >= this.lakeX && worldField.getX() <= this.lakeX + lakeSize;
            inLake = inLake && worldField.getY() >= this.lakeY && worldField.getY() <= this.lakeY + lakeSize;
            worldField.setWater(inLake);
            if (LOGGER.isDebugEnabled() && inLake) {
                LOGGER.debug(String.format("WorldField %s in lake", worldField));
            }
        }
        this.applyStateToEnvironment();
        LOGGER.info("Applied Lake-World rules");
    }

    public void modifyWorld(Pair<LakeProperty, Object>... propertyObjectPair) {
        for (Pair<LakeProperty, Object> lakeProperty : propertyObjectPair) {
            switch (lakeProperty.getKey()) {
                case PRESSURE:
                    this.pressureLevel = (Integer) lakeProperty.getValue();
                    break;
                case RAIN:
                    this.rain = (Boolean) lakeProperty.getValue();
                    break;
                case STORM:
                    this.storm = (Boolean) lakeProperty.getValue();
                    break;
            }
        }
        this.applyStateToEnvironment();
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("super", super.toString())
                .add("lakeX", lakeX)
                .add("lakeY", lakeY)
                .add("lakeSize", lakeSize)
                .add("rain", rain)
                .add("storm", storm)
                .add("pressureLevel", pressureLevel)
                .add("iteration", iteration)
                .toString();
    }

    @Override
    protected void applyStateToEnvironment() {
        this.environment.eval(String.format("(bind ?*rain* %s)", BooleanToSymbol.toSymbol(this.rain)));
        this.environment.eval(String.format("(bind ?*storm* %s)", BooleanToSymbol.toSymbol(this.storm)));
        this.environment.eval(String.format("(bind ?*pressure* %d)", this.pressureLevel));
        this.environment.eval(String.format("(bind ?*width* %d)", this.width));
        this.environment.eval(String.format("(bind ?*height* %d)", this.height));
        this.environment.eval(String.format("(bind ?*lakeX* %d)", this.lakeX));
        this.environment.eval(String.format("(bind ?*lakeY* %d)", this.lakeY));
        this.environment.eval(String.format("(bind ?*lakeSize* %d)", this.lakeSize));
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
            actor.clearFields();
            this.environment.assertString(actor.getFact());
        }
    }

    public enum LakeProperty {
        RAIN,
        STORM,
        PRESSURE
    }
}
