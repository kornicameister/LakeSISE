package org.kornicameister.sise.lake;

import org.kornicameister.sise.lake.clisp.ClispEnvironment;
import org.kornicameister.sise.lake.types.world.ui.WorldUI;

import java.awt.*;
import java.util.Scanner;

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
//        if (clispEnvironment.isBootstrapped()) {
//            boolean nextLoop = true;
//            while (nextLoop) {
//                clispEnvironment.mainLoop();
//                System.out.print("Next tour -> \t");
//                String yes_no = scanIn.next();
//                nextLoop = yes_no.equalsIgnoreCase("yes");
//            }
//            scanIn.close();
//            clispEnvironment.destroy();
//        }
    }
}
