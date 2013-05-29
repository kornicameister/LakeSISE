package org.kornicameister.sise.lake.clisp;

import org.junit.Assert;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;
import org.kornicameister.sise.lake.actors.impl.AnglerActor;
import org.kornicameister.util.Point;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ClispTest {
    private static Clisp clisp;

    @Test
    public void test_1_GetInstance() throws Exception {
        ClispTest.clisp = Clisp.getInstance();
        Assert.assertNotNull("Clisp environment is null", ClispTest.clisp);
    }

    @Test
    public void test_2_MoveActor() throws Exception {
        AnglerActor anglerActor = new AnglerActor("angler", 10d, new Point(10, 10));
        Assert.assertTrue("Actor could not be moved", ClispTest.clisp.moveActor(anglerActor, new Point(2, 0)));
        Assert.assertFalse("Actor could be moved", ClispTest.clisp.moveActor(anglerActor, new Point(200, 200)));
    }
}
