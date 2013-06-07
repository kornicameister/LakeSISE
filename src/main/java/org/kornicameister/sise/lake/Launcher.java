package org.kornicameister.sise.lake;

import org.kornicameister.sise.lake.clisp.ClispEnvironment;

import java.util.Scanner;

public class Launcher {

    public static void main(String[] args) {
        ClispEnvironment clispEnvironment = ClispEnvironment.newInstance(args[0]);
        Scanner scanIn = new Scanner(System.in);
        if (clispEnvironment.isBootstrapped()) {
            boolean nextLoop = true;
            while (nextLoop) {
                clispEnvironment.mainLoop();
                System.out.print("Next tour -> \t");
                String yes_no = scanIn.next();
                nextLoop = yes_no.equalsIgnoreCase("yes");
            }
            scanIn.close();
            clispEnvironment.destroy();
        }
    }
}
