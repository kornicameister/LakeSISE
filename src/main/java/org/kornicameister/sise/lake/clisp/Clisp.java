package org.kornicameister.sise.lake.clisp;

import CLIPSJNI.Environment;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.actors.Actor;
import org.kornicameister.sise.lake.actors.ClispActorAbility;
import org.kornicameister.sise.lake.annotations.ClispActor;
import org.kornicameister.sise.lake.annotations.ClispActorRule;
import org.kornicameister.sise.lake.clisp.rules.ClispRuleExecutor;
import org.kornicameister.sise.lake.clisp.rules.impl.arguments.ClispRuleMoveArgument;
import org.kornicameister.sise.lake.clisp.rules.impl.executors.ClispRuleMoveExecutor;
import org.kornicameister.util.Point;

import javax.annotation.Nullable;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class Clisp {
    private static final Logger LOGGER = Logger.getLogger(Clisp.class);
    private static Clisp ourInstance = new Clisp(new Environment());
    private static Map<ClispActorAbility, ClispRuleExecutor> abilityRuleExecutorMap;
    private Environment environment;

    static {
        Clisp.abilityRuleExecutorMap = new HashMap<>();
        Clisp.abilityRuleExecutorMap.put(ClispActorAbility.MOVEABLE, new ClispRuleMoveExecutor());
    }

    private Clisp(final Environment environment) {
        this.environment = environment;
    }

    public static Clisp getInstance() {
        Clisp.ourInstance = new Clisp(new Environment());
        return Clisp.ourInstance;
    }

    public boolean moveActor(final Actor actor, final Point point) {
        Preconditions.checkArgument(actor != null, "Actor instance can not be null");
        Preconditions.checkArgument(point != null, "Point translation instance can not be null");
        assert actor != null;

        if (ClispAbilityChecker.isActorAbleTo(actor, ClispActorAbility.MOVEABLE)) {
            LOGGER.info(String.format("moveActor(%s)", actor.getName()));
            return Clisp.abilityRuleExecutorMap.get(ClispActorAbility.MOVEABLE).executeRule(
                    new ClispRuleMoveArgument(actor, point)
            );
        }
        return false;
    }

    private static class ClispAbilityChecker {
        private static final Logger LOGGER = Logger.getLogger(ClispAbilityChecker.class);

        private static boolean isActorAbleTo(final Actor actor, final ClispActorAbility ability) {
            ClispActor clispActor = actor.getClass().getAnnotation(ClispActor.class);
            boolean able = clispActor != null;
            if (able) {
                List<ClispActorRule> actorAbilities = Arrays.asList(clispActor.rules());
                able = Collections2.filter(actorAbilities, new Predicate<ClispActorRule>() {
                    @Override
                    public boolean apply(@Nullable final ClispActorRule clispActorRule) {
                        assert clispActorRule != null;
                        return clispActorRule.availibity().equals(ability);
                    }
                }).iterator().next() != null;
            }
            if (LOGGER.isTraceEnabled()) {
                LOGGER.trace(String.format("Actor name=[%s] %s able to move at all", actor.getName(), able ? "is" : "is not"));
            }
            return able;
        }
    }
}
