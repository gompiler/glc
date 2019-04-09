package glcutils;

import java.util.function.Supplier;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class GlcStruct2 {
    private float floatField = 0f;

    // Supplier, which generates a new struct
    public static Supplier<GlcStruct2> supplier = GlcStruct2::new;

    /*
     * All fields have getters and setters
     */

    public void setFloatField(int o) {
        this.floatField = o;
    }

    public float getFloatField() {
        return this.floatField;
    }

    /*
     * All fields must supply equality check
     * (This can be nonstatic. Not sure what's better)
     */

    public static boolean floatFieldEqual(GlcStruct2 s1, GlcStruct2 s2) {
        return s1.floatField == s2.floatField;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof GlcStruct2)) {
            return false;
        }
        GlcStruct2 other = (GlcStruct2) obj;
        // Compare all fields
        return floatFieldEqual(this, other);
    }
}
