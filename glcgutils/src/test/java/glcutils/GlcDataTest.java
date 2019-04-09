package glcutils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;

public class GlcDataTest {

    @Test
    public void structEquality() {
        GlcStruct1 s1_1 = new GlcStruct1();
        GlcStruct1 s1_2 = new GlcStruct1();
        GlcStruct2 s2 = new GlcStruct2();
        assertEquals("Reference equality failed", s1_1, s1_1);
        assertEquals("Structural equality failed", s1_1, s1_2);
        s1_1.setStringField("Hello");
        assertNotEquals("Reference inequality failed", s1_1, s1_2);
        s1_1.setStringField(null);
        s1_2.setStructField(s2);
        assertEquals("Nested struct generation failed", s1_1, s1_2);
    }


    @Test
    public void primitiveArrayEquality() {
        GlcIntArray a1 = new GlcIntArray(8);
        GlcIntArray a2 = new GlcIntArray(8);
        GlcIntArray a3 = new GlcIntArray(5);
        assertEquals("Reference equality failed", a1, a1);
        assertEquals("Structural equality failed", a1, a2);
        assertNotEquals("Length inequality failed", a1, a3);
        a1.set(3, 3);
        assertNotEquals("Structural inequality failed", a1, a2);
    }
}
