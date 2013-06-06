package org.kornicameister.sise.lake;

import org.kornicameister.sise.lake.types.WorldField;

import java.util.IdentityHashMap;
import java.util.Map;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class WorldFieldsStore {
    private static Map<Object, WorldField> fields = new IdentityHashMap<>();

    public static WorldField getField(final int x, final int y) {
        for (WorldField field : fields.values()) {
            if (field.getX().equals(x) && field.getY().equals(y)) {
                return field;
            }
        }
        return null;
    }

    public static void registerField(final WorldField field) {
        WorldFieldsStore.fields.put(field.getId(), field);
    }
}
