package org.kornicameister.sise.exception;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class BadActorDescriptor extends RuntimeException {
    public BadActorDescriptor(final String message) {
        super(message);
    }
}
