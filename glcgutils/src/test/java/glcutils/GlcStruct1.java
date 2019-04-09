package glcutils;

import java.util.Objects;
import java.util.function.Supplier;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class GlcStruct1 {
    // Primitive are non lazy
    private int intField = 0;

    // Strings are special in that they are expected to be null by default
    private String stringField = null;

    // Golite never expects a null struct, but we load it lazily
    private GlcStruct2 structField = null;

    // Supplier, which generates a new struct
    public static Supplier<GlcStruct1> supplier = GlcStruct1::new;

    /*
     * All fields have getters and setters
     */

    public void setIntField(int o) {
        this.intField = o;
    }

    public int getIntField() {
        return this.intField;
    }

    public void setStringField(String o) {
        this.stringField = o;
    }

    // Still nullable
    public String getStringField() {
        return this.stringField;
    }

    // Input can technically be null as well,
    // though it won't ever be in practice
    public void setStructField(GlcStruct2 o) {
        this.structField = o;
    }

    public GlcStruct2 getStructField() {
        if (this.structField == null) {
            this.structField = GlcStruct2.supplier.get();
        }
        return this.structField;
    }

    /*
     * All fields must supply equality check
     */

    public static boolean intFieldEqual(GlcStruct1 s1, GlcStruct1 s2) {
        return s1.intField == s2.intField;
    }

    /*
     * Strings are equal if both are null, or if contents are the same
     */
    public static boolean stringFieldEqual(GlcStruct1 s1, GlcStruct1 s2) {
        return Objects.equals(s1.stringField, s2.stringField);
    }

    /*
     * Load fields only if necessary
     * With recursive types, we eventually get to a depth where both structs aren't initialized
     * Therefore, it will halt
     */
    public static boolean structFieldEqual(GlcStruct1 s1, GlcStruct1 s2) {
        if (s1.structField == s2.structField) {
            return true;
        }
        if (s1.structField == null) {
            // Note that supplier is based on field type
            s1.structField = GlcStruct2.supplier.get();
        }
        if (s2.structField == null) {
            s2.structField = GlcStruct2.supplier.get();
        }
        return s1.structField.equals(s2.structField);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof GlcStruct1)) {
            return false;
        }
        GlcStruct1 other = (GlcStruct1) obj;
        // Compare all fields
        return intFieldEqual(this, other) && stringFieldEqual(this, other) && structFieldEqual(this, other);
    }
}
