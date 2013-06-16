package org.kornicameister.sise.lake.clisp;

import org.junit.Assert;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

/**
 * @author kornicameister
 * @version 0.0.1
 * @since 0.0.1
 */

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ClispEnvironmentTest {
    private static final String PROPERTIES = "D:\\Dropbox\\STUDIA\\INFORMATYKA\\SEMESTR6\\SISE\\Lake\\src\\main\\resources\\lake.properties";
    private static ClispEnvironment clispEnvironment;

    @Test
    public void test_1_GetInstance() throws Exception {
        ClispEnvironmentTest.clispEnvironment = ClispEnvironment.getInstance(PROPERTIES);
        Assert.assertNotNull("ClispEnvironment environment is null", ClispEnvironmentTest.clispEnvironment);
    }
}
