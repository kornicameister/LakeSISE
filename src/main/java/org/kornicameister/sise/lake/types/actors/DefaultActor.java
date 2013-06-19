package org.kornicameister.sise.lake.types.actors;

import CLIPSJNI.PrimitiveValue;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.clisp.InitMode;
import org.kornicameister.sise.lake.types.*;
import org.kornicameister.util.StatField;

import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.Random;

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
        extends DefaultClispType
        implements ClispType, ClispReady {
    private static final Logger LOGGER = Logger.getLogger(DefaultActor.class);
    private static final String DEFAULT_VALUE = String.valueOf(-1);
    private static final String DEFAULT_VALUE_FALSE = "false";
    private static final String CLISP_PREFIX = "actor";
    private static final String ACTOR_NEIGHBOUR_ACTOR_D_NEIGHBOUR_D_FIELD_D =
            "(actorNeighbour (actor \"%s\") (neighbour \"%s\") (field %d))";
    private static final String EMPTY_STRING = "";
    private static Integer ID = 0;
    protected final Integer id;
    protected LakeActors type;
    protected WorldField atField;
    protected Boolean canAttack;
    protected Boolean canFly;
    protected Boolean canSwim;
    protected Boolean isAlive;
    protected Integer hp;
    protected Integer visionRange;
    protected Integer attackRange;
    protected Integer moveRange;
    protected Integer hunger;
    protected DefaultActor target;
    protected Boolean targetHit;
    protected Boolean aggressive;
    protected Integer cash;
    protected Integer corruptionThreshold;
    protected Boolean validId;
    protected Integer attackPower;
    protected Integer weight;
    protected Boolean isMoveChanged;
    protected Integer howManyFishes;
    private List<WorldField> neighbourhood;

    public DefaultActor() {
        this.id = DefaultActor.ID++;
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

    protected void doRandomInit(final Properties properties) {
        final Random seed = new Random(properties.hashCode());
        // by type
        switch (this.getType()) {
            case HERBIVORE_FISH:
            case PREDATOR_FISH:
                this.canSwim = true;
                this.canFly = false;
                this.cash = 1;
                break;
            case BIRD:
                this.canSwim = false;
                this.canFly = true;
                this.cash = 1;
                break;
            case ANGLER:
            case POACHER:
            case FORESTER:
                this.canFly = false;
                this.canSwim = false;
                this.cash = DefaultActor.getRandomInt(1, 10000, seed);
        }
        // from properties
        this.aggressive = Boolean.valueOf(properties.getProperty("actor.aggressive", DEFAULT_VALUE_FALSE));
        this.howManyFishes = Integer.valueOf(properties.getProperty("actor.howManyFishes", DEFAULT_VALUE));

        // by random
        this.hp = DefaultActor.getRandomInt(50, 150, seed);
        this.moveRange = DefaultActor.getRandomInt(5, 10, seed);
        this.visionRange = DefaultActor.getRandomInt(5, 10, seed);
        this.attackRange = DefaultActor.getRandomInt(5, 10, seed);
        this.attackPower = DefaultActor.getRandomInt(10, 15, seed);
        this.hunger = DefaultActor.getRandomInt(5, 20, seed);
        this.canAttack = DefaultActor.getRandomInt(1, 100, seed) % 3 == 0;
        this.validId = DefaultActor.getRandomInt(1, 100, seed) % 3 == 0;
        this.weight = DefaultActor.getRandomInt(1, 100, seed);
        this.corruptionThreshold = DefaultActor.getRandomInt(1, this.cash, seed);
    }

    private static Integer getRandomInt(int lower, int higher, final Random seed) {
        return seed.nextInt(higher) - lower;
    }

    public LakeActors getType() {
        return type;
    }

    public void setType(final LakeActors type) {
        this.type = type;
    }

    protected abstract LakeActors setType();

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
                .append(String.format("(howManyFises %d)\n", this.howManyFishes))
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
                .append(String.format("(validId %s)\n", BooleanToSymbol.toSymbol(this.validId)))
                .append(this.appendExtraDataToFact())
                .append(" )");

        return builder.toString();
    }

    @Override
    public String getFactId() {
        return String.format("%s_%d", this.getFactName(), this.getId());
    }

    public Integer getId() {
        return id;
    }

    @Override
    public void applyFact(PrimitiveValue value) throws Exception {
        this.setAtField(WorldHelper.getField(value.getFactSlot("atField").intValue()));
        this.setAttackPower(value.getFactSlot("attackPower").intValue());
        this.setAttackRange(value.getFactSlot("attackRange").intValue());
        this.setCash(value.getFactSlot("cash").intValue());
        this.setHp(value.getFactSlot("hp").intValue());
        this.setTargetHit(BooleanToSymbol.fromSymbol(value.getFactSlot("targetHit").symbolValue()));
        this.setHunger(value.getFactSlot("hunger").intValue());
        this.setWeight(value.getFactSlot("weight").intValue());
        this.setHowManyFishes(value.getFactSlot("howManyFises").intValue());
    }

    protected String appendExtraDataToFact() {
        return EMPTY_STRING;
    }

    public Boolean getCanAttack() {
        return canAttack;
    }

    public void setCanAttack(final Boolean canAttack) {
        this.canAttack = canAttack;
    }

    public Boolean getCanFly() {
        return canFly;
    }

    public void setCanFly(final Boolean canFly) {
        this.canFly = canFly;
    }

    public Boolean getCanSwim() {
        return canSwim;
    }

    public void setCanSwim(final Boolean canSwim) {
        this.canSwim = canSwim;
    }

    public Integer getHp() {
        return hp;
    }

    public void setHp(final Integer hp) {
        this.hp = hp;
    }

    public Integer getVisionRange() {
        return visionRange;
    }

    public void setVisionRange(final Integer visionRange) {
        this.visionRange = visionRange;
    }

    public Integer getMoveRange() {
        return moveRange;
    }

    public void setMoveRange(final Integer moveRange) {
        this.moveRange = moveRange;
    }

    public Boolean getValidId() {
        return validId;
    }

    public void setValidId(final Boolean validId) {
        this.validId = validId;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("DefaultActor{");
        sb.append("id=").append(id);
        sb.append("\n, type=").append(type);
        sb.append("\n, atField=").append(atField);
        sb.append("\n, canAttack=").append(canAttack);
        sb.append("\n, canFly=").append(canFly);
        sb.append("\n, canSwim=").append(canSwim);
        sb.append("\n, hp=").append(hp);
        sb.append("\n, isAlive=").append(isAlive);
        sb.append("\n, visionRange=").append(visionRange);
        sb.append("\n, attackRange=").append(attackRange);
        sb.append("\n, moveRange=").append(moveRange);
        sb.append("\n, hunger=").append(hunger);
        sb.append("\n, target=").append(target);
        sb.append("\n, targetHit=").append(targetHit);
        sb.append("\n, aggressive=").append(aggressive);
        sb.append("\n, cash=").append(cash);
        sb.append("\n, corruptionThreshold=").append(corruptionThreshold);
        sb.append("\n, validId=").append(validId);
        sb.append("\n, attackPower=").append(attackPower);
        sb.append('}');
        return sb.toString();
    }

    public List<StatField> getStats() {
        List<StatField> stats = new LinkedList<>();

        stats.add(new StatField("ID", this.getFactId()));
        stats.add(new StatField("Field", this.getAtField().getId()));
        stats.add(new StatField("Alive", this.getAlive()));
        stats.add(new StatField("Hunger", this.getHunger()));
        stats.add(new StatField("Fished", this.getHowManyFishes()));
        stats.add(new StatField("Target", this.getTarget() != null ? this.getTarget().getFactId() : "none"));
        stats.add(new StatField("TargetHit", this.getTargetHit()));
        stats.add(new StatField("Cash", this.getCash()));
        stats.add(new StatField("CorruptionT", this.getCorruptionThreshold()));
        stats.add(new StatField("-------", ""));
        stats.add(new StatField("AttackPwr", this.getAttackPower()));
        stats.add(new StatField("AttackRg", this.getAttackRange()));
        stats.add(new StatField("-------", ""));

        return stats;
    }

    public Integer getHunger() {
        return hunger;
    }

    public void setHunger(Integer hunger) {
        this.hunger = hunger;
    }

    public Integer getCorruptionThreshold() {
        return corruptionThreshold;
    }

    public void setCorruptionThreshold(final Integer corruptionThreshold) {
        this.corruptionThreshold = corruptionThreshold;
    }

    public Integer getCash() {
        return cash;
    }

    public void setCash(final Integer cash) {
        this.cash = cash;
    }

    public Boolean getTargetHit() {
        return targetHit;
    }

    public void setTargetHit(final Boolean targetHit) {
        this.targetHit = targetHit;
    }

    public DefaultActor getTarget() {
        return target;
    }

    public void setTarget(final DefaultActor target) {
        this.target = target;
    }

    public WorldField getAtField() {
        return atField;
    }

    public void setAtField(final WorldField atField) {
        this.atField = atField;
    }

    public Integer getHowManyFishes() {
        return this.howManyFishes;
    }

    public void setHowManyFishes(Integer howManyFishes) {
        this.howManyFishes = howManyFishes;
    }

    public Boolean getAlive() {
        return isAlive;
    }

    public void setAlive(Boolean alive) {
        isAlive = alive;
    }

    public Integer getAttackPower() {
        return attackPower;
    }

    public void setAttackPower(final Integer attackPower) {
        this.attackPower = attackPower;
    }

    public Integer getAttackRange() {
        return attackRange;
    }

    public void setAttackRange(final Integer attackRange) {
        this.attackRange = attackRange;
    }

    public int getWeight() {
        return this.weight;
    }

    public void setWeight(final int weight) {
        this.weight = weight;
    }

    public Boolean getAggressive() {
        return aggressive;
    }

    public void setAggressive(Boolean aggressive) {
        this.aggressive = aggressive;
    }
}
