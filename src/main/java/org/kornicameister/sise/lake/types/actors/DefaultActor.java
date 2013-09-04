package org.kornicameister.sise.lake.types.actors;

import CLIPSJNI.PrimitiveValue;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.clisp.InitMode;
import org.kornicameister.sise.lake.types.WorldHelper;
import org.kornicameister.sise.lake.types.effectiveness.Effectiveness;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessHelper;
import org.kornicameister.sise.lake.types.effectiveness.EffectivenessResult;

import java.util.Properties;
import java.util.Random;
import java.util.Set;

/**
 * Basic fact, ready to be used to serve
 * as the foundamental element for the rest
 * of actors.
 *
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public abstract class DefaultActor
        extends _DefaultActor {
    private static final Logger LOGGER        = Logger.getLogger(DefaultActor.class);
    private static final String DEFAULT_VALUE = String.valueOf(-1);
    private static final String DEFAULT_VALUE_FALSE = "false";
    private static final String CLISP_PREFIX  = "actor";

    public DefaultActor() {
        super();
    }

    @Override
    protected final void resolveProperties(final Properties properties, final InitMode initMode) {
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(String.format("Initializing %s by mode %s", this.getClass().getSimpleName(), initMode));
        }

        this.targetHit = false;
        this.type = this.setType();
        this.target = null;
        this.isMoveChanged = false;
        this.tookBribe = false;
        this.corruptionThreshold = -1;
        this.cash = 1;
        this.canSwim = false;
        this.canFly = false;
        this.canAttack = false;

        switch (initMode) {
            case NORMAL:
                this.doNormalInit(properties);
                break;
            case RANDOM:
                this.doRandomInit(properties);
                break;
        }

        this.isAlive = this.hp > 0;

        WorldHelper.registerActor(this);
    }

    @Override
    protected void doNormalInit(final Properties properties) {
        this.hp = Integer.valueOf(properties.getProperty("actor.hp", DEFAULT_VALUE));
        this.moveRange = Integer.valueOf(properties.getProperty("actor.move.range", DEFAULT_VALUE));
        this.visionRange = Integer.valueOf(properties.getProperty("actor.vision.range", DEFAULT_VALUE));
        this.attackRange = Integer.valueOf(properties.getProperty("actor.weapon.range", DEFAULT_VALUE));
        this.attackPower = Integer.valueOf(properties.getProperty("actor.weapon.power", DEFAULT_VALUE));
        this.hunger = Integer.valueOf(properties.getProperty("actor.hunger", DEFAULT_VALUE));
        this.canAttack = Boolean.valueOf(properties.getProperty("actor.weapon.canAttack", DEFAULT_VALUE_FALSE));
        this.canFly = Boolean.valueOf(properties.getProperty("actor.weapon.canFly", DEFAULT_VALUE_FALSE));
        this.canSwim = Boolean.valueOf(properties.getProperty("actor.weapon.canSwim", DEFAULT_VALUE_FALSE));
        this.aggressive = Boolean.valueOf(properties.getProperty("actor.aggressive", DEFAULT_VALUE_FALSE));
        this.cash = Integer.valueOf(properties.getProperty("actor.cash", DEFAULT_VALUE));
        this.validId = Boolean.valueOf(properties.getProperty("actor.validId", DEFAULT_VALUE_FALSE));
        this.weight = Integer.valueOf(properties.getProperty("actor.weight", DEFAULT_VALUE));
        this.corruptionThreshold = Integer.valueOf(properties.getProperty("actor.corruptionThreshold", DEFAULT_VALUE));
        this.howManyFishes = Integer.valueOf(properties.getProperty("actor.howManyFishes", DEFAULT_VALUE));
    }

    @Override
    protected void doRandomInit(final Properties properties) {
        final Random seed = new Random(System.nanoTime());

        // by random
        this.hp = DefaultActor.getRandomInt(30, 80, seed);
        this.moveRange = DefaultActor.getRandomInt(4, 6, seed);
        this.visionRange = DefaultActor.getRandomInt(5, 10, seed);
        this.attackRange = DefaultActor.getRandomInt(5, 10, seed);
        this.attackPower = DefaultActor.getRandomInt(10, 15, seed);
        this.hunger = DefaultActor.getRandomInt(5, 20, seed);
        this.canAttack = DefaultActor.getRandomInt(1, 100, seed) % 3 == 0;
        this.validId = DefaultActor.getRandomInt(1, 100, seed) % 3 == 0;
        this.weight = DefaultActor.getRandomInt(1, 100, seed);

        // by type  - global
        switch (this.getType()) {
            case HERBIVORE_FISH:
                this.canSwim = true;
                this.moveRange = DefaultActor.getRandomInt(3, 4, seed);
                this.visionRange = this.moveRange;
                this.attackRange = 0;
                break;
            case PREDATOR_FISH:
                this.canSwim = true;
                this.moveRange = DefaultActor.getRandomInt(2, 3, seed);
                this.visionRange = 3;
                this.attackRange = 1;
                break;
            case BIRD:
                this.canFly = true;
                break;
            case ANGLER:
                this.moveRange = 0;
                this.visionRange = DefaultActor.getRandomInt(2, 3, seed);
                this.attackRange = DefaultActor.getRandomInt(2, 3, seed);
                this.cash = DefaultActor.getRandomInt(1, 50, seed);
                break;
            case POACHER:
                this.cash = DefaultActor.getRandomInt(1, 50, seed);
                break;
            case FORESTER:
                this.cash = DefaultActor.getRandomInt(1, 50, seed);
                this.corruptionThreshold = DefaultActor.getRandomInt(5, 50, seed);
                break;
        }

        // from properties
        this.aggressive = Boolean.valueOf(properties.getProperty("actor.aggressive", DEFAULT_VALUE_FALSE));
        this.howManyFishes = Integer.valueOf(properties.getProperty("actor.howManyFishes", DEFAULT_VALUE));
    }

    /**
     * This method must not be overridden.
     * It returns clisp string describing particular actor.
     *
     * @return clisp fact
     */
    @Override
    public final String getFact() {
        final StringBuilder builder = new StringBuilder();

        builder.append("( ")
               .append(String.format("%s \n", CLISP_PREFIX))
               .append(String.format("(id \"%s\")\n", this.getFactId()))
               .append(String.format("(type %s)\n", this.type.name().toLowerCase()))
               .append(String.format("(atField %d)\n", this.atField != null ? this.atField.getId() : -1))
               .append(String.format("(isMoveChanged %s)\n", BooleanToSymbol.toSymbol(this.isMoveChanged)))
               .append(String.format("(isAlive %s)\n", BooleanToSymbol.toSymbol(this.isAlive)))
               .append(String.format("(canAttack %s)\n", BooleanToSymbol.toSymbol(this.canAttack)))
               .append(String.format("(canFly %s)\n", BooleanToSymbol.toSymbol(this.canFly)))
               .append(String.format("(canSwim %s)\n", BooleanToSymbol.toSymbol(this.canSwim)))
               .append(String.format("(weight %d)\n", this.weight))
               .append(String.format("(howManyFishes %d)\n", this.howManyFishes))
               .append(String.format("(hp %d)\n", this.hp))
               .append(String.format("(visionRange %d)\n", this.visionRange))
               .append(String.format("(attackRange %d)\n", this.attackRange))
               .append(String.format("(attackPower %d)\n", this.attackPower))
               .append(String.format("(hunger %d)\n", this.hunger))
               .append(String.format("(moveRange %d)\n", this.moveRange))
               .append(String.format("(targetId %d)\n", this.target == null ? -1 : this.target.id))
               .append(String.format("(targetHit %s)\n", BooleanToSymbol.toSymbol(this.targetHit)))
               .append(String.format("(aggressive %s)\n", BooleanToSymbol.toSymbol(this.aggressive)))
               .append(String.format("(cash %d)\n", this.cash))
               .append(String.format("(corruptionThreshold %d)\n", this.corruptionThreshold))
               .append(String.format("(tookBribe %s)\n", BooleanToSymbol.toSymbol(this.tookBribe)))
               .append(String.format("(validId %s)\n", BooleanToSymbol.toSymbol(this.validId)))
               .append(this.appendExtraDataToFact())
               .append(" )");

        return builder.toString();
    }

    @Override
    public void applyFact(final PrimitiveValue value) throws Exception {
        this.setAtField(WorldHelper.getField(value.getFactSlot("atField").intValue()));
        this.setAttackPower(value.getFactSlot("attackPower").intValue());
        this.setAttackRange(value.getFactSlot("attackRange").intValue());
        this.setCash(value.getFactSlot("cash").intValue());
        this.setHp(value.getFactSlot("hp").intValue());
        this.setTargetHit(BooleanToSymbol.fromSymbol(value.getFactSlot("targetHit").symbolValue()));
        this.setHunger(value.getFactSlot("hunger").intValue());
        this.setWeight(value.getFactSlot("weight").intValue());
        this.setHowManyFishes(value.getFactSlot("howManyFishes").intValue());
        this.setTookBribe(BooleanToSymbol.fromSymbol(value.getFactSlot("tookBribe").symbolValue()));
        this.setCorruptionThreshold(value.getFactSlot("corruptionThreshold").intValue());
    }

    @Override
    public void applyEffectiveness(final PrimitiveValue value) throws Exception {
        final Set<Effectiveness> effectivenessSet = this.getType().getEffectiveness();
        for (final Effectiveness effectiveness : effectivenessSet) {
            try {
                PrimitiveValue primitiveValue;
                if ((primitiveValue = value.getFactSlot(effectiveness.getEffectiveness())) != null) {
                    EffectivenessHelper
                            .storeEffectiveness(this.getClass(),
                                    new EffectivenessResult(effectiveness, primitiveValue
                                            .getValue()
                                            .toString())
                            );
                }
            } catch (Exception exception) {
                LOGGER.warn(String.format("Error occurred when resolving effectiveness=%s", effectiveness), exception);
            }
        }
    }

    @Override
    public String getFactId() {
        return String.format("%s_%d", this.getFactName(), this.getId());
    }

}
