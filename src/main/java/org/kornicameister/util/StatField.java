package org.kornicameister.util;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class StatField {
    private final String field;
    private final String value;

    public StatField(String field, Object value) {
        this.field = field;
        this.value = value.toString();
    }

    public String getField() {
        return field;
    }

    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("StatField{");
        sb.append("field='").append(field).append('\'');
        sb.append(", value='").append(value).append('\'');
        sb.append('}');
        return sb.toString();
    }
}
