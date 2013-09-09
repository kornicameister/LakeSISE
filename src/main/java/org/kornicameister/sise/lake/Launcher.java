package org.kornicameister.sise.lake;

import org.kornicameister.sise.lake.ui.WorldUI;

import java.awt.*;

public class Launcher {

    public static void main(String[] args) {
        final String clispEnvironment = args[0];
        final String uiPropFile = args[1];
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                new WorldUI(clispEnvironment, uiPropFile);
            }
        });

    }
}
