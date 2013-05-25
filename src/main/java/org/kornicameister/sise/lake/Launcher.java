package org.kornicameister.sise.lake;

import CLIPSJNI.Environment;

public class Launcher {

    public static void main(String[] args) {
        Environment clisp = new Environment();
        clisp.run();
    }
}
