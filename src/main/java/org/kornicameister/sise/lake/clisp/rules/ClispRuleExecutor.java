package org.kornicameister.sise.lake.clisp.rules;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public interface ClispRuleExecutor {
    boolean executeRule(final ClispRuleExecuteArgument argument);
}
