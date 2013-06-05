package org.kornicameister.sise.lake.adapters;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class BooleanToInteger implements Adapter<Boolean, Integer> {
    private static final BooleanToInteger BOOLEAN_TO_INTEGER = new BooleanToInteger();

    public static boolean toBoolean(Integer value) {
        return BOOLEAN_TO_INTEGER.adaptIn(value);
    }

    public static Integer toInteger(Boolean value) {
        return BOOLEAN_TO_INTEGER.adaptOut(value);
    }

    @Override
    public Integer adaptOut(Boolean value) {
        return value ? 1 : 0;
    }

    @Override
    public Boolean adaptIn(Integer value) {
        return value.equals(1);
    }
}
