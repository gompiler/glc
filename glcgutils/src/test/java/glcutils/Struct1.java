package glcutils;

import java.util.Objects;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class Struct1 {
    // Primitive are non lazy
    private int intField = 0;

    // Strings are special in that they are expected to be null by default
    private String stringField = null;

    // Golite never expects a null struct, but we load it lazily
    private Struct2 structField = null;

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
    public void setStructField(Struct2 o) {
        this.structField = o;
    }

    public Struct2 getStructField() {
        if (this.structField == null) {
            this.structField = Utils.supply(Struct2.class);
        }
        return this.structField;
    }

    /*
     * All fields must supply equality check
     */

    public static boolean intFieldEqual(Struct1 s1, Struct1 s2) {
        return s1.intField == s2.intField;
    }

    /*
     * Strings are equal if both are null, or if contents are the same
     */
    public static boolean stringFieldEqual(Struct1 s1, Struct1 s2) {
        return Objects.equals(s1.stringField, s2.stringField);
    }

    /*
     * Load fields only if necessary
     * With recursive types, we eventually get to a depth where both structs aren't initialized
     * Therefore, it will halt
     */
    public static boolean structFieldEqual(Struct1 s1, Struct1 s2) {
        if (s1.structField == s2.structField) {
            return true;
        }
        return s1.getStructField().equals(s2.getStructField());
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Struct1)) {
            return false;
        }
        Struct1 other = (Struct1) obj;
        // Compare all fields
        return intFieldEqual(this, other) && stringFieldEqual(this, other) && structFieldEqual(this, other);
    }
}