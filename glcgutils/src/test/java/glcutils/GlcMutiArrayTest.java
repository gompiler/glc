package glcutils;

import org.junit.Test;

import static org.junit.Assert.assertNull;

public class GlcMutiArrayTest {

    @Test
    public void multiArrayCheck() {
        GlcArray$String$2 a1 = new GlcArray$String$2(3, 5);
        GlcArray$String$2 a2 = new GlcArray$String$2(3, 5);
        GlcArray$String$2 a3 = new GlcArray$String$2(3, 6);
        GlcDataTest.assertEquality(a1, a2, a3);
        assertNull(a1.get(1).get(1));
    }

    /**
     * For upper levels, pass suppliers which take the first n - 1 lengths
     *
     * Changing args:
     * - currentClass
     * - parentClass
     * - constructorHeader
     * - constructorBody
     */
    private static class GlcArray$String$2 extends GlcArray<GlcArray$String$1> {

        public GlcArray$String$2(int length1, int length2) {
            super(() -> new GlcArray$String$1(length1), GlcArray$String$1.class, length2);
        }

    }

    /**
     * For first level, do not provide supplier
     *
     * Changing args:
     * - currentClass
     * - parentClass
     */
    private static class GlcArray$String$1 extends GlcArray<String> {
        public GlcArray$String$1(int length) {
            super(String.class, length);
        }
    }
}

