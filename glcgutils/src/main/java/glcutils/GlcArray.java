package glcutils;

import java.util.Arrays;

/**
 * Lazy multi dimensional array implementation, supporting slice operations.
 * The public constructor allows you to specify the multi dimensional sizes.
 * For instance, passing new int[]{1, 2, 3} with class Test.class will create Test[1][2][3]
 * To create a slice, simply provide a size that is less than 0.
 * <p>
 * No generics are used, so there are no guarantees towards get and set.
 * It is expected that you set arrays of the appropriate subsizes for a multi dimensional array,
 * or a value of the appropriate type in a one dimensional array.
 * You may optionally set the debug flag to true to get some verifications.
 */
public class GlcArray {
    /**
     * Current length of the array
     */
    private final int length;
    /**
     * True if structure is a slice and supports append
     */
    private final boolean isSlice;
    /**
     * List of nested sizes
     * Empty if one dimensional array
     */
    private final int[] subSizes;
    /**
     * True to enable some runtime verifications
     */
    private final boolean debug;
    /**
     * Underlying array; may be null
     */
    private Object[] array;
    /**
     * Class for base type.
     * See {@link Utils#supplyObj(Class)}
     */
    private final Class clazz;

    public GlcArray(Class clazz, int[] sizes) {
        this(clazz, sizes, false);
    }

    GlcArray(Class clazz, int[] sizes, boolean debug) {
        this(clazz, sizes[0] < 0, Utils.tail(sizes), Math.max(0, sizes[0]), null, debug);
    }

    private GlcArray(Class clazz, boolean isSlice, int[] subSizes, int length, Object[] array, boolean debug) {
        this.length = length;
        this.isSlice = isSlice;
        this.subSizes = subSizes;
        this.clazz = clazz;
        this.array = array;
        this.debug = debug;
    }

    /**
     * Ensures that array is nonnull
     */
    private void init() {
        if (array == null) {
            array = new Object[length];
        }
    }

    /**
     * Generate a new element entry,
     * based on the struct supplier definition
     */
    private Object supply() {
        if (subSizes.length == 0) {
            return Utils.supplyObj(clazz);
        }
        return new GlcArray(clazz, subSizes, debug);
    }

    public GlcArray copy() {
        Object[] newArray = null;
        if (this.array != null) {
            newArray = new Object[this.length];
            System.arraycopy(this.array, 0, newArray, 0, this.length);
        }
        return new GlcArray(this.clazz, this.isSlice, this.subSizes, this.length, newArray, this.debug);
    }

    /**
     * Return nonnull struct if index is within bounds
     */
    public final <T> T get(int i) {
        init();
        if (array[i] == null) {
            array[i] = supply();
        }
        if (i > length - 1) {
            Utils.fail("Slice index %d out of range (length %d)", i, length);
        }
        // noinspection unchecked
        return (T) array[i];
    }

    /**
     * Mainly for testing; shortcut to get the next array depth
     */
    final GlcArray getArray(int i) {
        return get(i);
    }

    public final boolean getBoolean(int i) {
        return get(i);
    }

    public final char getChar(int i) {
        return get(i);
    }

    public final int getInt(int i) {
        return get(i);
    }

    public final float getFloat(int i) {
        return get(i);
    }

    public final double getDouble(int i) {
        return get(i);
    }

    private void verify(Object t) {
        if (!debug) {
            return;
        }
        if (t == null) {
            return;
        }
        if (subSizes.length == 0 && !clazz.isInstance(t)) {
            Utils.fail("Set value of class %s in 1D GlcArray, expected class %s", t.getClass().getName(), clazz.getName());
        } else if (subSizes.length > 0) {
            if (!(t instanceof GlcArray)) {
                Utils.fail("Set value in multi GlcArray, but not of class GlcArray");
            }
            GlcArray v = (GlcArray) t;
            if (!Arrays.equals(v.subSizes, Utils.tail(subSizes))) {
                Utils.fail("Set GlcArray of sizes %s in GlcArray of sizes %s", Arrays.toString(v.subSizes), Arrays.toString(subSizes));
            }
        }
    }

    /**
     * Set new struct value at specified index if it is within bounds
     */
    public void set(int i, Object t) {
        verify(t);
        init();
        array[i] = t;
    }

    public void set(int i, boolean t) {
        set(i, (Object) t);
    }

    public void set(int i, char t) {
        set(i, (Object) t);
    }

    public void set(int i, int t) {
        set(i, (Object) t);
    }

    public void set(int i, float t) {
        set(i, (Object) t);
    }

    public void set(int i, double t) {
        set(i, (Object) t);
    }

    /**
     * Gets the length of the array, representative of the number of elements
     * stored
     */
    public final int length() {
        return length;
    }

    /**
     * Gets the capacity of the array, representative of the number of elements
     * that can be stored
     */
    public int capacity() {
        return array == null ? 0 : array.length;
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcArray append(Object t) {
        verify(t);
        if (!isSlice) {
            Utils.fail("Cannot append to nonslice");
        }
        Object[] newArray = append(array, length, t);
        return new GlcArray(clazz, true, subSizes, length + 1, newArray, debug);
    }

    public GlcArray append(boolean t) {
        return append((Object) t);
    }

    public GlcArray append(char t) {
        return append((Object) t);
    }

    public GlcArray append(int t) {
        return append((Object) t);
    }

    public GlcArray append(float t) {
        return append((Object) t);
    }

    public GlcArray append(double t) {
        return append((Object) t);
    }

    /**
     * Underlying append logic, returning the resulting array data
     * Static for legacy, in case we want to support custom primitive types
     */
    private static Object[] append(Object[] array, int length, Object t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length > capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = newCapacity(capacity);
            Object[] newArray = new Object[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }

    /**
     * We have an initial capacity of 2 due to legacy golang
     * This is a requirement for golite
     */
    private static int newCapacity(int capacity) {
        return capacity <= 0 ? 2 : 2 * capacity;
    }

    /**
     * Single level lazy equality check, where null values
     * are presumed to be equal.
     * Note that structs should implement deep equals,
     * so this should result in a deep equal too.
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        GlcArray other = (GlcArray) obj;
        if (this.isSlice != other.isSlice) {
            return false;
        }
        if (this.length != other.length) {
            return false;
        }
        if (!Arrays.equals(this.subSizes, other.subSizes)) {
            return false;
        }
        if (!this.clazz.equals(other.clazz)) {
            return false;
        }
        init();
        other.init();
        for (int i = 0; i < length; i++) {
            if (array[i] == other.array[i]) {
                continue;
            }
            if (array[i] == null) {
                array[i] = supply();
            }
            if (other.array[i] == null) {
                other.array[i] = supply();
            }
            if (!array[i].equals(other.array[i])) {
                return false;
            }
        }
        return true;
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(array);
    }

    @Override
    public String toString() {
        if (debug) {
            return contentString();
        }
        return Arrays.toString(array);
    }

    String contentString() {
        StringBuilder s = new StringBuilder();
        s.append('[');
        if (!isSlice) {
            s.append(length);
        }
        s.append(']');
        for (int i : subSizes) {
            s.append('[');
            if (i > 0) {
                s.append(i);
            }
            s.append(']');
        }
        s.append(clazz.getName());
        if (array == null) {
            s.append(" - null");
            return s.toString();
        }
        for (int i = 0; i < array.length; i++) {
            Object o = array[i];
            s.append("\n\t").append(i).append(": ");
            if (o instanceof GlcArray) {
                String so = ((GlcArray) o).contentString();
                so = so.replace("\n", "\n\t");
                s.append(so);
            } else {
                s.append(o);
            }
        }
        return s.toString();
    }
}
