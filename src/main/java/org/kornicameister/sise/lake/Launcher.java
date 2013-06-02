package org.kornicameister.sise.lake;

import org.kornicameister.sise.lake.clisp.ClispEnvironment;

public class Launcher {

    public static void main(String[] args) {
        ClispEnvironment clispEnvironment = ClispEnvironment.newInstance(args[0]);
        if (clispEnvironment.isBootstrapped()) {
            clispEnvironment.mainLoop();
        }
    }
}
