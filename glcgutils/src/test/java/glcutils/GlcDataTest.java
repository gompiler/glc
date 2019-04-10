package glcutils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;

public class GlcDataTest {

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
    public void primitiveArrayEquality() {
        GlcArray$Int_1 a1 = new GlcArray$Int_1(8);
        GlcArray$Int_1 a2 = new GlcArray$Int_1(8);
        GlcArray$Int_1 a3 = new GlcArray$Int_1(5);
        assertEquality(a1, a2, a3);
        a1.set(3, 3);
        assertNotEquals("Structural inequality failed", a1, a2);
    }

    @Test
    public void arrayEquality() {
        Struct2 s = new Struct2();
        GlcArray<Struct2> a1 = new GlcArray<>(Struct2.class, 8);
        GlcArray<Struct2> a2 = new GlcArray<>(Struct2.class, 8);
        GlcArray<Struct2> a3 = new GlcArray<>(Struct2.class, 5);
        assertEquality(a1, a2, a3);
        a1.set(3, s);
        assertEquals("Nested struct generation failed", a1, a2);
        s.setFloatField(8f);
        assertNotEquals("Structural inequality failed", a1, a2);
    }

    @Test
    public void primitiveSliceEquality() {
        GlcSlice$Int_1 a1 = new GlcSlice$Int_1();
        GlcSlice$Int_1 a2 = new GlcSlice$Int_1();
        GlcSlice$Int_1 a3 = a2.append(0);
        assertEquality(a1, a2, a3);
        assertNotEquals("Structural inequality failed", a1.append(1), a3);
        assertEquals("Structural equality failed", a1.append(0), a3);
    }
}
