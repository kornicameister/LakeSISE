package org.kornicameister.sise.lake.types;

import org.kornicameister.sise.lake.io.DataStructure;

import java.util.List;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public interface ClispType {

    /**
     * Method for each actor to implement.
     * This method is used by each actor to modify
     * its internal state without explicit knowledge
     * of type's internal fields at the {@link org.kornicameister.sise.lake.clisp.ClispRunner level}
     *
     * @param input
     *         data to be set
     */
    void setInput(final DataStructure input);

    /**
     * Logic to be done on the Java side, like for example
     * calculating next move and so on. However this method
     * must return its result as list of String-transformed
     * facts ready to be asserted to type's environment. Therefore
     * can be quite large. This method should use {@link DataStructure} that type
     * owns to produce an output
     */
    List<String> getOutput();

    /**
     * This method should return output fact name.
     * In other {@link org.kornicameister.sise.lake.clisp.ClispRunner}
     * expects that by using this name they will be able to extract output data from
     * {@link CLIPSJNI.Environment}
     *
     * @return
     */
    String getOutputFactName();

    /**
     * Returns types name. It just exists for convenience purpose,
     * however can be useful while debugging
     *
     * @return type's name
     */
    String getName();
}
