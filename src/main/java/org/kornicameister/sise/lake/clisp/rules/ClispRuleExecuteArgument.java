package org.kornicameister.sise.lake.clisp.rules;

import com.google.common.base.Objects;
import org.kornicameister.sise.lake.actors.Actor;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public abstract class ClispRuleExecuteArgument {
    protected final Actor actor;

    public ClispRuleExecuteArgument(final Actor actor) {
        this.actor = actor;
    }

    public Actor getActor() {
        return actor;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("actor", actor)
                .toString();
    }
}
