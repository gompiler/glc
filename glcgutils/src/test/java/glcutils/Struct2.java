package glcutils;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class Struct2 {
    private float floatField = 0f;

    /*
     * All fields have getters and setters
     */

    public void setFloatField(float o) {
        this.floatField = o;
    }

    public float getFloatField() {
        return this.floatField;
    }

    /*
     * All fields must supply equality check
     * (This can be nonstatic. Not sure what's better)
     */

    public static boolean floatFieldEqual(Struct2 s1, Struct2 s2) {
        return s1.floatField == s2.floatField;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Struct2)) {
            return false;
        }
        Struct2 other = (Struct2) obj;
        // Compare all fields
        return floatFieldEqual(this, other);
    }
}
