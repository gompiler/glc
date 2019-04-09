package glcutils;

import java.util.Objects;
import java.util.function.Supplier;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
class Struct {
    // Primitive are non lazy
    int intField = 0;

    // Strings are special in that they are expected to be null by default
    String stringField = null;

    // Golite never expects a null struct, but we load it lazily
    Struct structField = null;

    // Supplier, which generates a new struct
    static Supplier<Struct> supplier = Struct::new;

    /*
     * All fields have getters and setters
     */

    void setIntField(int o) {
        this.intField = o;
    }

    int getIntField() {
        return this.intField;
    }

    void setStringField(String o) {
        this.stringField = o;
    }

    // Still nullable
    String getStringField() {
        return this.stringField;
    }

    // Input can technically be null as well,
    // though it won't ever be in practice
    void setStructField(Struct o) {
        this.structField = o;
    }

    Struct getStructField() {
        if (this.structField == null) {
            this.structField = supplier.get();
        }
        return this.structField;
    }

    /*
     * All fields must supply equality check
     * (This can be nonstatic. Not sure what's better)
     */
    static boolean intFieldEqual(Struct s1, Struct s2) {
        return s1.intField == s2.intField;
    }

    /*
     * Strings are equal if both are null, or if contents are the same
     */
    static boolean stringFieldEqual(Struct s1, Struct s2) {
        return Objects.equals(s1.stringField, s2.stringField);
    }

    /*
     * Load fields only if necessary
     * With recursive types, we eventually get to a depth where both structs aren't initialized
     * Therefore, it will halt
     */
    static boolean structFieldEqual(Struct s1, Struct s2) {
        if (s1.structField == s2.structField) {
            return true;
        }
        if (s1.structField == null) {
            // Note that supplier is based on field type,
            // not struct type
            // It just so happens that the example is recursive
            s1.structField = Struct.supplier.get();
        }
        if (s2.structField == null) {
            s2.structField = Struct.supplier.get();
        }
        return s1.structField.equals(s2.structField);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Struct)) {
            return false;
        }
        Struct other = (Struct) obj;
        // Compare all fields
        return intFieldEqual(this, other) && stringFieldEqual(this, other) && structFieldEqual(this, other);
    }
}
