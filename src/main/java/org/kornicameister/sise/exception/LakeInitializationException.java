package org.kornicameister.sise.exception;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class LakeInitializationException extends RuntimeException {
    public LakeInitializationException(final Exception multipleE) {
        super(String.format("Exception of type -> %s interrupted in program loading", multipleE.getClass()
                .getSimpleName()), multipleE);
    }
}
