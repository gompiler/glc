package glcutils;

import org.junit.Test;

import static org.junit.Assert.*;

public class GlcMutiSliceTest {

    @Test
    public void multiArrayCheck() {
        GlcSlice$String$2 a = new GlcSlice$String$2();
        a = a.append(null);
        assertNotNull(a.get(0));
        a.set(0, a.get(0).append("Hello"));
        assertEquals("Hello", a.get(0).get(0));
    }

    /*
     * Structure is the same for all levels
     */

    private static class GlcSlice$String$2 extends GlcArray<GlcSlice$String$1> {

        public GlcSlice$String$2() {
            this(0, null);
        }

        public GlcSlice$String$2(int length, GlcSlice$String$1[] array) {
            super(GlcSlice$String$1.class, length, array);
        }

        public GlcSlice$String$2 append(GlcSlice$String$1 s) {
            GlcSlice$String$1[] newArray = GlcSliceUtils.append(this.clazz, this.array, this.length, s);
            return new GlcSlice$String$2(length + 1, newArray);
        }

    }

    private static class GlcSlice$String$1 extends GlcArray<String> {

        public GlcSlice$String$1() {
            this(0, null);
        }

        public GlcSlice$String$1(int length, String[] array) {
            super(String.class, length, array);
        }

        public GlcSlice$String$1 append(String s) {
            String[] newArray = GlcSliceUtils.append(this.clazz, this.array, this.length, s);
            return new GlcSlice$String$1(length + 1, newArray);
        }
    }
}

