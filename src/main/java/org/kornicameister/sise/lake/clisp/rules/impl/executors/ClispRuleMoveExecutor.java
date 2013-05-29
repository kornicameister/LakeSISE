package org.kornicameister.sise.lake.clisp.rules.impl.executors;

import com.google.common.base.Preconditions;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.actors.Actor;
import org.kornicameister.sise.lake.clisp.rules.ClispRuleExecuteArgument;
import org.kornicameister.sise.lake.clisp.rules.ClispRuleExecutor;
import org.kornicameister.sise.lake.clisp.rules.impl.arguments.ClispRuleMoveArgument;
import org.kornicameister.util.Point;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ClispRuleMoveExecutor implements ClispRuleExecutor {
    private static final Logger LOGGER = Logger.getLogger(ClispRuleMoveExecutor.class);

    protected void move(final Actor actor, final Point point) {
        if (!this.isMovePossible(actor, point)) {
            LOGGER.warn(String.format("Actor name=%s can't be moved, point exceeds actors range=%f", actor.getName(), actor.getMoveRange()));
        }
        actor.move(point);
    }

    protected boolean isMovePossible(final Actor actor, final Point point) {
        final double x = point.getX(),
                y = point.getY();
        final Double actorRange = actor.getMoveRange();
        return Math.abs(x - actorRange) > 0 &&
                Math.abs(y - actorRange) > 0;
    }

    @Override
    public boolean executeRule(final ClispRuleExecuteArgument argument) {
        Preconditions.checkState(argument instanceof ClispRuleMoveArgument, "Invalid argument");

        final ClispRuleMoveArgument moveArgument = (ClispRuleMoveArgument) argument;
        final Actor actor = moveArgument.getActor();
        final Point point = moveArgument.getMovePoint();

        if (!this.isMovePossible(actor, point)) {
            return false;
        }

        this.move(actor, point);
        return true;
    }
}
