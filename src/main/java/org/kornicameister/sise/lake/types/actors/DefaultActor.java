package org.kornicameister.sise.lake.types.actors;

import CLIPSJNI.Environment;
import org.kornicameister.sise.lake.adapters.BooleanToInteger;
import org.kornicameister.sise.lake.types.ClispReady;
import org.kornicameister.sise.lake.types.ClispType;
import org.kornicameister.sise.lake.types.DefaultClispType;

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
    private static Integer ID = 0;
    private final Integer     id;
    //TODO fix class fields, so fields' types match their purpose
    //Provide inline converting of fields to valid clisp values
    protected     LakeActors  type;
    protected     Integer     x;
    protected     Integer     y;
    protected     Integer     moveX;
    protected     Integer     moveY;
    protected     Integer     moveRange;
    protected     Integer     visionRange;
    protected     Integer     attackRange;
    protected     Integer     caught;
    protected     Integer     canAttack;
    protected     Integer     attackX;
    protected     Integer     attackY;
    protected     Integer     attackSuccess;
    protected     Environment environment;

    public DefaultActor() {
        this.id = DefaultActor.ID++;
    }

    @Override
    protected final void resolveProperties(final Properties properties) {
        this.x = Integer.valueOf(properties.getProperty("actor.x"));
        this.y = Integer.valueOf(properties.getProperty("actor.y"));
        this.moveRange = Integer.valueOf(properties.getProperty("actor.move.range"));
        this.visionRange = Integer.valueOf(properties.getProperty("actor.vision.range"));
        this.attackRange = Integer.valueOf(properties.getProperty("actor.weapon.range"));
        this.canAttack = BooleanToInteger.toInteger(Boolean.valueOf(properties.getProperty("actor.weapon.canAttack")));

        // init-default
        this.moveX = 0;
        this.moveY = 0;
        this.caught = BooleanToInteger.toInteger(false);
        this.attackX = 0;
        this.attackY = 0;
        this.attackSuccess = BooleanToInteger.toInteger(false);
        this.type = this.setType();
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
        final String template =
                "(actor (id %d) (name %s) (x %d) (y %d) (moveX %d) (moveY %d) " +
                        "(caught %d) (type %d) (can-attack %d) (visionRange %d) (moveRange %d)" +
                        "(attackX %d) (attackY %d) (attackSuccess %d))";

        return String.format(template,
                this.id,
                this.getName(),
                this.x,
                this.y,
                this.moveX,
                this.moveY,
                this.caught,
                this.type.ordinal(),
                this.canAttack,
                this.visionRange,
                this.moveRange,
                this.attackX,
                this.attackY,
                this.attackSuccess);
    }
}
