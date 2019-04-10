package glcutils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class GlcMutiSliceTest {

    @Test
    public void multiArrayCheck() {
        GlcSlice$Struct1_2 a = new GlcSlice$Struct1_2();
        a = a.append(null);
        assertNotNull(a.get(0));
        a.set(0, a.get(0).append(Utils.supply(Struct1.class)));
        assertNotNull(a.get(0).get(0));
        assertEquals(Utils.supply(Struct1.class), a.get(0).get(0));
    }

    /**
     * Structure is the same for all levels
     * <p>
     * Changing args:
     * - current class
     * - parent class
     * - append signature + body
     * <p>
     * Public constructor with no args is mandatory for instantiation
     */
    private static class GlcSlice$Struct1_2 extends GlcArray<GlcSlice$Struct1_1> {

        public GlcSlice$Struct1_2() {
            this(0, null);
        }

        public GlcSlice$Struct1_2(int length, GlcSlice$Struct1_1[] array) {
            super(GlcSlice$Struct1_1.class, length, array);
        }

        public GlcSlice$Struct1_2 append(GlcSlice$Struct1_1 s) {
            GlcSlice$Struct1_1[] newArray = GlcSliceUtils.append(this.clazz, this.array, this.length, s);
            return new GlcSlice$Struct1_2(length + 1, newArray);
        }

    }

    private static class GlcSlice$Struct1_1 extends GlcArray<Struct1> {

        public GlcSlice$Struct1_1() {
            this(0, null);
        }

        public GlcSlice$Struct1_1(int length, Struct1[] array) {
            super(Struct1.class, length, array);
        }

        public GlcSlice$Struct1_1 append(Struct1 s) {
            Struct1[] newArray = GlcSliceUtils.append(this.clazz, this.array, this.length, s);
            return new GlcSlice$Struct1_1(length + 1, newArray);
        }
    }
}

