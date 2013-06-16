package org.kornicameister.sise.lake.types.world.ui;

import javax.swing.*;

/**
 * Created with IntelliJ IDEA.
 * User: GodDamnItNappa!
 * Date: 16.06.13
 * Time: 00:22
 * To change this template use File | Settings | File Templates.
 */
public class WorldUI extends JFrame {
    private int maxFieldsHorizontally;
    private int maxFieldsVertically;

    public WorldUI(){
        this.setTitle("LakeSISE");
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setLocationRelativeTo(null);
    }
}
