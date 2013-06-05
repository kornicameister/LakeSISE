package org.kornicameister.sise.lake.adapters;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public interface Adapter<F, T> {
    T adaptOut(F value);

    F adaptIn(T value);
}
