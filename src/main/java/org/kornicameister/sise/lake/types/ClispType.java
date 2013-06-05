package org.kornicameister.sise.lake.types;

import CLIPSJNI.Environment;

import java.util.List;
import java.util.Properties;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public interface ClispType {

    /**
     * Use this method to initialize ClispType
     *
     * @param properties
     * @param environment
     */
    void initType(final Properties properties,
                  final Environment environment,
                  List<String> clpPaths);

    void run();

    /**
     * Returns types name. It just exists for convenience purpose,
     * however can be useful while debugging
     *
     * @return type's name
     */
    String getName();
}
