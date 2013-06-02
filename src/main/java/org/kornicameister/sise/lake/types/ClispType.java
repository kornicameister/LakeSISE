package org.kornicameister.sise.lake.types;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public interface ClispType {
    String toClisp();

    void fromClisp(final String inputData);

    String getName();

    void doLogic();
}
