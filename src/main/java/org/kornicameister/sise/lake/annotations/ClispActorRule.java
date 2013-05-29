package org.kornicameister.sise.lake.annotations;

import org.kornicameister.sise.lake.actors.ClispActorAbility;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

@Retention(RetentionPolicy.RUNTIME)
@Target(value = ElementType.TYPE)
public @interface ClispActorRule {
    String rule();

    ClispActorAbility availibity();
}
