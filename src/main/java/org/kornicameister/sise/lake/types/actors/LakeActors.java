package org.kornicameister.sise.lake.types.actors;

import org.apache.log4j.Logger;
import org.kornicameister.sise.lake.types.Effectiveness;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

public enum LakeActors {
    //0
    POACHER,
    //1
    ANGLER,
    //2
    BIRD,
    //3
    HERBIVORE_FISH,
    //4
    PREDATOR_FISH,
    //5
    FORESTER;
    private static final String             EFFECTIVENESS_PATH = "effectiveness.properties";
    private final        Set<Effectiveness> effectiveness      = new HashSet<>();

    LakeActors() {
        this.getEffectiveness();
    }

    public Set<Effectiveness> getEffectiveness() {
        if (this.effectiveness.isEmpty()) {
            this.loadEffectiveness();
        }
        return this.effectiveness;
    }

    private void loadEffectiveness() {
        final Properties properties = new Properties();
        try {
            final InputStream stream = LakeActors.class.getClassLoader()
                                                       .getResourceAsStream(EFFECTIVENESS_PATH);
            properties.load(stream);

            final String key = this.toString().toLowerCase();
            final String[] eff = properties.getProperty(key).split(",");
            for (final String effectiveness : eff) {
                this.effectiveness.add(new Effectiveness(effectiveness));
            }
            Logger.getLogger(LakeActors.class).info(String
                    .format("%s > Loaded effectiveness=%s", this.toString().toLowerCase(), this.effectiveness));
        } catch (IOException e) {
            Logger.getLogger(LakeActors.class).error(e);
        }
    }
}
