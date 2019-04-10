package glcutils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class GlcMutiArrayTest {

    @Test
    public void multiArrayCheck() {
        GlcArray$Struct1_2 a1 = new GlcArray$Struct1_2(3, 5);
        GlcArray$Struct1_2 a2 = new GlcArray$Struct1_2(3, 5);
        GlcArray$Struct1_2 a3 = new GlcArray$Struct1_2(3, 6);
        GlcDataTest.assertEquality(a1, a2, a3);
        assertNotNull(a1.get(1).get(1));
        assertEquals(Utils.supply(Struct1.class), a1.get(1).get(1));
    }

    /**
     * For upper levels, pass suppliers which take the first n - 1 lengths
     * <p>
     * Changing args:
     * - currentClass
     * - parentClass
     * - constructorHeader
     * - constructorBody
     */
    private static class GlcArray$Struct1_2 extends GlcArray<GlcArray$Struct1_1> {

        public GlcArray$Struct1_2(int length1, int length2) {
            super(() -> new GlcArray$Struct1_1(length1), GlcArray$Struct1_1.class, length2);
        }

    }

    /**
     * For first level, do not provide supplier
     * <p>
     * Changing args:
     * - currentClass
     * - parentClass
     */
    private static class GlcArray$Struct1_1 extends GlcArray<Struct1> {
        public GlcArray$Struct1_1(int length) {
            super(Struct1.class, length);
        }
    }
}

