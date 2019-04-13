package glcutils;

import java.util.Objects;

/**
 * The following is an example
 * We need to generate this for each unique class
 */
public class Struct1 implements GlcCopy {
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

    @Override
    public Object copy() {
        Struct1 s = new Struct1();
        s.intField = intField;
        s.stringField = stringField;
        s.structField = Utils.copy(structField);
        return s;
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
        // For primitives, use direct equality
        if (this.intField != other.intField) {
            return false;
        }
        // For strings, directly use objects.equals.
        // Strings equal or if they are both null or equal by content
        if (!Objects.equals(this.stringField, other.stringField)) {
            return false;
        }
        // For objects, check by reference, then check by content.
        // If both are null, we know that they are equal
        // If one is not null, we must compare both by content equality
        // Calling getter will ensure all fields are no longer null,
        // and then we will call equals
        if (this.structField != other.structField && !this.getStructField().equals(other.getStructField())) {
            return false;
        }
        return true;
    }
}
