package org.kornicameister.sise.lake.types.world.ui;

import org.kornicameister.sise.lake.types.actors.DefaultActor;

import javax.swing.*;

/**
 * Created with IntelliJ IDEA.
 * User: GodDamnItNappa!
 * Date: 16.06.13
 * Time: 00:54
 * To change this template use File | Settings | File Templates.
 */
public class Field {
    static String ANGLER_IMAGE = "";
    static String BIRD_IMAGE = "";
    static String FORESTER_IMAGE = "";
    static String HERBIVORE_FISH_IMAGE = "";
    static String POACHER_IMAGE = "";
    static String PREDATOR_FISH_IMAGE = "";
    static String LAND_IMAGE = "";
    static String WATER_IMAGE = "";
    private JLabel label;
    private DefaultActor actor;
    private boolean water;

    public Field(JLabel label, DefaultActor actor) {
        this.label = label;
        this.actor = actor;
        this.setWater(false);
        this.label.setToolTipText("");
        this.label.setIcon(new ImageIcon(LAND_IMAGE));
        label.setVisible(true);
    }

    public JLabel getLabel() {
        return label;
    }

    public void setLabel(JLabel label) {
        this.label = label;
    }

    public void setIcon(DefaultActor actor) {
        switch (actor.getType()) {
            case ANGLER:
                this.label.setIcon(new ImageIcon(ANGLER_IMAGE));
                break;
            case BIRD:
                this.label.setIcon(new ImageIcon(BIRD_IMAGE));
                break;
            case FORESTER:
                this.label.setIcon(new ImageIcon(FORESTER_IMAGE));
                break;
            case HERBIVORE_FISH:
                this.label.setIcon(new ImageIcon(HERBIVORE_FISH_IMAGE));
                break;
            case POACHER:
                this.label.setIcon(new ImageIcon(POACHER_IMAGE));
                break;
            case PREDATOR_FISH:
                this.label.setIcon(new ImageIcon(PREDATOR_FISH_IMAGE));
                break;
            default:
                if (!isWater()) this.label.setIcon(new ImageIcon(LAND_IMAGE));
                else this.label.setIcon(new ImageIcon(WATER_IMAGE));
                break;
        }
    }

    public DefaultActor getActor() {
        return actor;
    }

    public void setActor(DefaultActor actor) {
        this.actor = actor;
        if (this.actor != null) {
            //System.out.println(actor.toString());
            this.label.setToolTipText(this.actor.toString());
            this.setIcon(this.actor);
        } else {
            this.label.setToolTipText("");
            if (!isWater()) this.label.setIcon(new ImageIcon(LAND_IMAGE));
            else this.label.setIcon(new ImageIcon(WATER_IMAGE));
        }
    }

    public boolean isWater() {
        return water;
    }

    public void setWater(boolean water) {
        this.water = water;
        if (!isWater()) this.label.setIcon(new ImageIcon(LAND_IMAGE));
        else this.label.setIcon(new ImageIcon(WATER_IMAGE));
    }
}
