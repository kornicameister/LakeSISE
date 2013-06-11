package org.kornicameister.sise.lake.types.actors;

import CLIPSJNI.PrimitiveValue;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.adapters.BooleanToSymbol;
import org.kornicameister.sise.lake.types.*;

import java.util.Iterator;
import java.util.List;
import java.util.Properties;

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
    protected DefaultActor target;
    protected Boolean targetHit;
    protected Integer cash;
    protected Integer corruptionThreshold;
    protected Boolean validId;
    protected Integer attackPower;
    private List<WorldField> neighbourhood;

    public DefaultActor() {
        this.id = DefaultActor.ID++;
    }

    @Override
    protected final void resolveProperties(final Properties properties) {
        this.hp = Integer.valueOf(properties.getProperty("actor.hp", DEFAULT_VALUE));
        this.moveRange = Integer.valueOf(properties.getProperty("actor.move.range", DEFAULT_VALUE));
        this.visionRange = Integer.valueOf(properties.getProperty("actor.vision.range", DEFAULT_VALUE));
        this.attackRange = Integer.valueOf(properties.getProperty("actor.weapon.range", DEFAULT_VALUE));
        this.attackPower = Integer.valueOf(properties.getProperty("actor.weapon.power", DEFAULT_VALUE));
        this.canAttack = Boolean.valueOf(properties.getProperty("actor.weapon.canAttack", DEFAULT_VALUE_FALSE));
        this.canFly = Boolean.valueOf(properties.getProperty("actor.weapon.canFly", DEFAULT_VALUE_FALSE));
        this.canSwim = Boolean.valueOf(properties.getProperty("actor.weapon.canSwim", DEFAULT_VALUE_FALSE));
        this.cash = Integer.valueOf(properties.getProperty("actor.cash", DEFAULT_VALUE));
        this.validId = Boolean.valueOf(properties.getProperty("actor.cash", DEFAULT_VALUE_FALSE));
        this.corruptionThreshold = Integer.valueOf(properties.getProperty("actor.corruptionThreshold", DEFAULT_VALUE));
        this.targetHit = false;
        this.type = this.setType();
        this.target = null;
        this.isAlive = this.hp > 0;

        WorldHelper.registerActor(this);
    }

    protected abstract LakeActors setType();

    public final DefaultActor prepare(List<WorldField> neighbourhood) {
        this.neighbourhood = neighbourhood;

        //asserting neighbours
        Iterator<WorldField> it = neighbourhood.iterator();
        while (it.hasNext()) {
            final WorldField field = it.next();
            final DefaultActor actor = WorldHelper.getActor(field);
            if (actor != null) {
                if (!actor.equals(this)) {
                    this.environment.assertString(String.format(
                            ACTOR_NEIGHBOUR_ACTOR_D_NEIGHBOUR_D_FIELD_D,
                            this.getFactId(),
                            actor.getFactId(),
                            field.getId()
                    ));
                }
            } else {
                it.remove();
            }
        }

        if (LOGGER.isInfoEnabled()) {
            LOGGER.info(String.format("%d/%s has %d in his area", this.id, this.type, neighbourhood.size()));
        }
        return this;
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
                .append(String.format("(isAlive %s)\n", BooleanToSymbol.toSymbol(this.isAlive)))
                .append(String.format("(canAttack %s)\n", BooleanToSymbol.toSymbol(this.canAttack)))
                .append(String.format("(canFly %s)\n", BooleanToSymbol.toSymbol(this.canFly)))
                .append(String.format("(canSwim %s)\n", BooleanToSymbol.toSymbol(this.canSwim)))
                .append(String.format("(hp %d)\n", this.hp))
                .append(String.format("(visionRange %d)\n", this.visionRange))
                .append(String.format("(attackRange %d)\n", this.attackRange))
                .append(String.format("(attackPower %d)\n", this.attackPower))
                .append(String.format("(moveRange %d)\n", this.moveRange))
                .append(String.format("(targetId %d)\n", this.target == null ? -1 : this.target.id))
                .append(String.format("(targetHit %s)\n", BooleanToSymbol.toSymbol(this.targetHit)))
                .append(String.format("(cash %d)\n", this.cash))
                .append(String.format("(corruptionThreshold %d)\n", this.corruptionThreshold))
                .append(String.format("(validId %s)\n", BooleanToSymbol.toSymbol(this.validId)))
                .append(" )");

        return builder.toString();
    }

    @Override
    public void applyFact(PrimitiveValue value) throws Exception {
        this.setAtField(WorldHelper.getField(value.getFactSlot("atField").intValue()));
        this.setAttackPower(value.getFactSlot("attackPower").intValue());
        this.setAttackRange(value.getFactSlot("attackRange").intValue());
        this.setCash(value.getFactSlot("cash").intValue());
        this.setHp(value.getFactSlot("hp").intValue());
        this.setTargetHit(BooleanToSymbol.fromSymbol(value.getFactSlot("targetHit").symbolValue()));
    }

    @Override
    public String getFactId() {
        return String.format("%s_%d", this.getFactName(), this.getId());
    }

    public Integer getId() {
        return id;
    }

    public LakeActors getType() {
        return type;
    }

    public void setType(final LakeActors type) {
        this.type = type;
    }

    public WorldField getAtField() {
        return atField;
    }

    public void setAtField(final WorldField atField) {
        this.atField = atField;
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

    public Integer getAttackRange() {
        return attackRange;
    }

    public void setAttackRange(final Integer attackRange) {
        this.attackRange = attackRange;
    }

    public Integer getMoveRange() {
        return moveRange;
    }

    public void setMoveRange(final Integer moveRange) {
        this.moveRange = moveRange;
    }

    public DefaultActor getTarget() {
        return target;
    }

    public void setTarget(final DefaultActor target) {
        this.target = target;
    }

    public Boolean getTargetHit() {
        return targetHit;
    }

    public void setTargetHit(final Boolean targetHit) {
        this.targetHit = targetHit;
    }

    public Integer getCash() {
        return cash;
    }

    public void setCash(final Integer cash) {
        this.cash = cash;
    }

    public Integer getCorruptionThreshold() {
        return corruptionThreshold;
    }

    public void setCorruptionThreshold(final Integer corruptionThreshold) {
        this.corruptionThreshold = corruptionThreshold;
    }

    public Boolean getValidId() {
        return validId;
    }

    public void setValidId(final Boolean validId) {
        this.validId = validId;
    }

    public Integer getAttackPower() {
        return attackPower;
    }

    public void setAttackPower(final Integer attackPower) {
        this.attackPower = attackPower;
    }

    public Boolean getAlive() {
        return isAlive;
    }

    public void setAlive(Boolean alive) {
        isAlive = alive;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("DefaultActor{");
        sb.append("id=").append(id);
        sb.append(", type=").append(type);
        sb.append(", atField=").append(atField);
        sb.append(", canAttack=").append(canAttack);
        sb.append(", canFly=").append(canFly);
        sb.append(", canSwim=").append(canSwim);
        sb.append(", hp=").append(hp);
        sb.append(", isAlive=").append(isAlive);
        sb.append(", visionRange=").append(visionRange);
        sb.append(", attackRange=").append(attackRange);
        sb.append(", moveRange=").append(moveRange);
        sb.append(", target=").append(target);
        sb.append(", targetHit=").append(targetHit);
        sb.append(", cash=").append(cash);
        sb.append(", corruptionThreshold=").append(corruptionThreshold);
        sb.append(", validId=").append(validId);
        sb.append(", attackPower=").append(attackPower);
        sb.append('}');
        return sb.toString();
    }
}
