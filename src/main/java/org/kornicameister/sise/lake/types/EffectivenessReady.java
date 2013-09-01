package org.kornicameister.sise.lake.types;

import CLIPSJNI.PrimitiveValue;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */
public interface EffectivenessReady {
    void applyEffectiveness(final PrimitiveValue value) throws Exception;
}
