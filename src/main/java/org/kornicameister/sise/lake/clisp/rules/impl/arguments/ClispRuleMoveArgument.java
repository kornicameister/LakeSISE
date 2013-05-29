package org.kornicameister.sise.lake.clisp.rules.impl.arguments;

import com.google.common.base.Objects;
import org.kornicameister.sise.lake.actors.Actor;
import org.kornicameister.sise.lake.clisp.rules.ClispRuleExecuteArgument;
import org.kornicameister.util.Point;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class ClispRuleMoveArgument extends ClispRuleExecuteArgument {
    private final Point movePoint;

    public ClispRuleMoveArgument(final Actor actor, final Point movePoint) {
        super(actor);
        this.movePoint = movePoint;
    }

    public Point getMovePoint() {
        return movePoint;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("movePoint", movePoint)
                .toString();
    }
}
