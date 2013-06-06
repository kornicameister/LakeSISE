package org.kornicameister.sise.lake.types.actors;

import org.kornicameister.sise.lake.WorldFieldsStore;
import org.kornicameister.sise.lake.adapters.BooleanToInteger;
import org.kornicameister.sise.lake.types.ClispReady;
import org.kornicameister.sise.lake.types.ClispType;
import org.kornicameister.sise.lake.types.DefaultClispType;
import org.kornicameister.sise.lake.types.WorldField;

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
    private static final String   CLISP_PREFIX = "actor";
    private static final String[] TEMPLATE     = {
            //description
            "(id %d)",
            "(type %d)",
            //description
            //location
            "(atField %d)",
            "(toField %d)",
            //location
            //generic-abilities
            "(canAttack %d)",
            "(canFly %d)",
            "(canSwim %d)",
            //generic-abilities
            //generic-properties
            "(hp %d)",
            "(visionRange %d)",
            "(attackRange %d)",
            "(attackPower %d)",
            "(moveRange %d)",
            //generic-properties
            //attack-properties
            "(targetId %d)",
            "(targetHit %d)",
            //attack-properties
            //corruption-properties
            "(cash %d)",
            "(corruptionThreshold %d)",
            "(validId %d)"
            //corruption-properties
    };
    private static       Integer  ID           = 0;
    private final Integer      id;
    protected     LakeActors   type;
    protected     WorldField   atField;
    protected     WorldField   toField;
    protected     Boolean      canAttack;
    protected     Boolean      canFly;
    protected     Boolean      canSwim;
    protected     Integer      hp;
    protected     Integer      visionRange;
    protected     Integer      attackRange;
    protected     Integer      moveRange;
    protected     DefaultActor target;
    protected     Boolean      targetHit;
    protected     Integer      cash;
    protected     Integer      corruptionThreshold;
    protected     Boolean      validId;
    private       Integer      attackPower;

    public DefaultActor() {
        this.id = DefaultActor.ID++;
    }

    @Override
    protected final void resolveProperties(final Properties properties) {
        int x = Integer.valueOf(properties.getProperty("actor.x"));
        int y = Integer.valueOf(properties.getProperty("actor.y"));

        this.hp = Integer.valueOf(properties.getProperty("actor.hp"), -1);
        this.moveRange = Integer.valueOf(properties.getProperty("actor.move.range"), -1);
        this.visionRange = Integer.valueOf(properties.getProperty("actor.vision.range"), -1);
        this.attackRange = Integer.valueOf(properties.getProperty("actor.weapon.range"), -1);
        this.attackPower = Integer.valueOf(properties.getProperty("actor.weapon.power"), -1);
        this.canAttack = Boolean.valueOf(properties.getProperty("actor.weapon.canAttack", "false"));
        this.canFly = Boolean.valueOf(properties.getProperty("actor.weapon.canFly", "false"));
        this.canSwim = Boolean.valueOf(properties.getProperty("actor.weapon.canSwim", "false"));
        this.cash = Integer.valueOf(properties.getProperty("actor.cash"), -1);
        this.corruptionThreshold = Integer.valueOf(properties.getProperty("actor.corruptionThreshold"), -1);
        this.targetHit = false;
        this.type = this.setType();
        this.atField = WorldFieldsStore.getField(x, y);
        this.toField = this.atField;
    }

    protected abstract LakeActors setType();

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
                .append(CLISP_PREFIX)
                .append(String.format(TEMPLATE[Mapping.ID], this.id))
                .append(String.format(TEMPLATE[Mapping.TYPE], this.type.ordinal()))
                .append(String.format(TEMPLATE[Mapping.AT_FIELD], this.atField.getId()))
                .append(String.format(TEMPLATE[Mapping.TO_FIELD], this.toField.getId()))
                .append(String.format(TEMPLATE[Mapping.CAN_ATTACK], BooleanToInteger.toInteger(this.canAttack)))
                .append(String.format(TEMPLATE[Mapping.CAN_FLY], BooleanToInteger.toInteger(this.canFly)))
                .append(String.format(TEMPLATE[Mapping.CAN_SWIM], BooleanToInteger.toInteger(this.canSwim)))
                .append(String.format(TEMPLATE[Mapping.HP], this.hp))
                .append(String.format(TEMPLATE[Mapping.VISION_RANGE], this.visionRange))
                .append(String.format(TEMPLATE[Mapping.ATTACK_RANGE], this.attackRange))
                .append(String.format(TEMPLATE[Mapping.ATTACK_POWER], this.attackPower))
                .append(String.format(TEMPLATE[Mapping.MOVE_RANGE], this.moveRange))
                .append(String.format(TEMPLATE[Mapping.TARGET_ID], this.target.id))
                .append(String.format(TEMPLATE[Mapping.TARGET_HIT], BooleanToInteger.toInteger(this.targetHit)))
                .append(String.format(TEMPLATE[Mapping.CASH], this.cash))
                .append(String.format(TEMPLATE[Mapping.CORR_THRESHOLD], this.corruptionThreshold))
                .append(String.format(TEMPLATE[Mapping.VALID_ID], this.validId))
                .append(" )");

        return builder.toString();
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

    public WorldField getToField() {
        return toField;
    }

    public void setToField(final WorldField toField) {
        this.toField = toField;
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

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("DefaultActor{");
        sb.append("id=").append(id);
        sb.append(", type=").append(type);
        sb.append(", atField=").append(atField);
        sb.append(", toField=").append(toField);
        sb.append(", canAttack=").append(canAttack);
        sb.append(", canFly=").append(canFly);
        sb.append(", canSwim=").append(canSwim);
        sb.append(", hp=").append(hp);
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

    private static class Mapping {
        private static final int ID             = 0;
        private static final int TYPE           = 1;
        private static final int AT_FIELD       = 2;
        private static final int TO_FIELD       = 3;
        private static final int CAN_ATTACK     = 4;
        private static final int CAN_FLY        = 5;
        private static final int CAN_SWIM       = 6;
        private static final int HP             = 7;
        private static final int VISION_RANGE   = 8;
        private static final int ATTACK_RANGE   = 9;
        private static final int ATTACK_POWER   = 10;
        private static final int MOVE_RANGE     = 11;
        private static final int TARGET_ID      = 12;
        private static final int TARGET_HIT     = 13;
        private static final int CASH           = 14;
        private static final int CORR_THRESHOLD = 15;
        private static final int VALID_ID       = 16;
    }
}
