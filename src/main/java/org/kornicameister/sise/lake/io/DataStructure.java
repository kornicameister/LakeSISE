package org.kornicameister.sise.lake.io;

import com.google.common.base.Objects;

import java.util.HashMap;
import java.util.Map;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class DataStructure {
    private Map<String, String> values;

    public DataStructure() {
        this.values = new HashMap<>();
    }

    public <T> String addValue(final String key, final T value) {
        return this.values.put(key, value.toString());
    }

    public String getValue(final Object key) {
        return this.values.get(key);
    }

    public String toClisp() {
        return null;
    }

    public void fromClisp() {

    }

    public void reset() {
        this.values.clear();
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("values", values)
                .toString();
    }
}
