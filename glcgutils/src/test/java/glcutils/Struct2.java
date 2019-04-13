package glcutils;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class Struct2 implements GlcCopy {
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

    @Override
    public Object copy() {
        Struct2 s = new Struct2();
        s.floatField = floatField;
        return s;
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
        if (this.floatField != other.floatField) {
            return false;
        }
        return true;
    }
}
