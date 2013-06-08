package org.kornicameister.sise.lake.adapters;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class BooleanToSymbol implements Adapter<Boolean, String> {
    private static final BooleanToSymbol BOOLEAN_TO_INTEGER = new BooleanToSymbol();

    public static boolean fromSymbol(String value) {
        return BOOLEAN_TO_INTEGER.adaptIn(value);
    }

    public static String toSymbol(Boolean value) {
        return BOOLEAN_TO_INTEGER.adaptOut(value);
    }

    @Override
    public String adaptOut(Boolean value) {
        return value ? "yes" : "no";
    }

    @Override
    public Boolean adaptIn(String value) {
        return value.equals("yes");
    }
}
