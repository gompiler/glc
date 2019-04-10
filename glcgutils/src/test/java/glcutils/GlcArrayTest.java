package glcutils;

import org.junit.Test;

import static org.junit.Assert.*;

public class GlcArrayTest {

    /**
     * Checks reference and structural equality
     */
    static <T> void assertEquality(T s1, T s2) {
        assertEquals("Reference equality failed", s1, s1);
        assertEquals("Structural equality failed", s1, s2);
    }

    /**
     * Provided that s3 has a different length,
     * also checks for length inequality
     */
    static <T> void assertEquality(T s1, T s2, T s3) {
        assertEquality(s1, s2);
        assertNotEquals("Length inequality failed", s1, s3);
    }

    @Test
    public void structEquality() {
        Struct1 s1_1 = new Struct1();
        Struct1 s1_2 = new Struct1();
        Struct2 s2 = new Struct2();
        assertEquals("Reference equality failed", s1_1, s1_1);
        assertEquals("Structural equality failed", s1_1, s1_2);
        s1_1.setStringField("Hello");
        assertNotEquals("Reference inequality failed", s1_1, s1_2);
        s1_1.setStringField(null);
        s1_2.setStructField(s2);
        assertEquals("Nested struct generation failed", s1_1, s1_2);
    }

    @Test
    public void arrayEquality() {
        Struct2 s = new Struct2();
        GlcArray a1 = new GlcArray(Struct2.class, new int[]{8}, true);
        GlcArray a2 = new GlcArray(Struct2.class, new int[]{8}, true);
        GlcArray a3 = new GlcArray(Struct2.class, new int[]{5}, true);
        assertEquality(a1, a2, a3);
        a1.set(3, s);
        assertEquals("Nested struct generation failed", a1, a2);
        s.setFloatField(8f);
        assertNotEquals("Structural inequality failed", a1, a2);
    }

    @Test(expected = GlcException.class)
    public void appendForbiddenInSlice() {
        GlcArray a1 = new GlcArray(Struct2.class, new int[]{8}, true);
        a1.append(null);
    }

    @Test
    public void intArrayEquality() {
        GlcArray a1 = new GlcArray(Integer.class, new int[]{8}, true);
        GlcArray a2 = new GlcArray(Integer.class, new int[]{8}, true);
        GlcArray a3 = new GlcArray(Integer.class, new int[]{5}, true);
        assertEquality(a1, a2, a3);
        a1.set(3, 5);
        assertNotEquals("Structural inequality failed", a1, a2);
        assertEquals("Bad default int", 0, a1.getInt(2));
        assertEquals("Bad setter", 5, a1.getInt(3));
    }

    @Test
    public void intSliceEquality() {
        GlcArray a1 = new GlcArray(Integer.class, new int[]{-1}, true);
        GlcArray a2 = new GlcArray(Integer.class, new int[]{-1}, true);
        GlcArray a3 = a2.append(1);
        assertEquality(a1, a2, a3);
        assertNotEquals("Structural inequality failed", a1.append(0), a3);
        assertEquals("Structural equality failed", a1.append(1), a3);
    }

    @Test
    public void multiArrayCheck() {
        GlcArray a1 = new GlcArray(Struct1.class, new int[]{3, 5}, true);
        GlcArray a2 = new GlcArray(Struct1.class, new int[]{3, 5}, true);
        GlcArray a3 = new GlcArray(Struct1.class, new int[]{3, 6}, true);
        GlcArrayTest.assertEquality(a1, a2, a3);
        assertNotNull(a1.getArray(1).get(1));
        assertEquals(Utils.supply(Struct1.class), a1.getArray(1).get(1));
    }

    @Test
    public void multiSliceCheck() {
        GlcArray a = new GlcArray(Struct1.class, new int[]{-1, -1}, true);
        a = a.append(null);
        a.set(0, a.getArray(0).append(Utils.supply(Struct1.class)));
        assertNotNull(a.getArray(0).get(0));
        assertEquals(Utils.supply(Struct1.class), a.getArray(0).get(0));
    }

    /**
     * Resulting structure:
     * - [5][][3]glcutils.Struct1
     * - 	0: [][3]glcutils.Struct1 - null
     * - 	1: null
     * - 	2: null
     * - 	3: null
     * - 	4: [][3]glcutils.Struct1
     * - 		0: [3]glcutils.Struct1
     * - 			0: null
     * - 			1: null
     * - 			2: glcutils.Struct1@28ba21f3
     * - 		1: null
     */
    @Test
    public void multiSliceArrayCheck() {
        GlcArray a = new GlcArray(Struct1.class, new int[]{5, -1, 3}, true);
        assertEquals(5, a.length());
        assertEquals("Bad slice capacity", 0, a.getArray(0).capacity());
        GlcArray b = new GlcArray(Struct1.class, new int[]{-1, 3}, true);
        b = b.append(null);
        a.set(4, b);
        assertEquals(Utils.supply(Struct1.class), a.getArray(4).getArray(0).get(2));
    }

}

