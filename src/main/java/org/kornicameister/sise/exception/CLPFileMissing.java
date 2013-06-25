package org.kornicameister.sise.exception;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public class CLPFileMissing extends RuntimeException {
    public CLPFileMissing(String clp) {
        super(String.format("%s is missing and type can not be loaded", clp));
    }
}
