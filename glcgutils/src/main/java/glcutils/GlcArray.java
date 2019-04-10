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
    private final int length;
    private final boolean isSlice;
    private final int[] subSizes;
    private final boolean debug;
    private Object[] array;
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

    /**
     * Return nonnull struct if index is within bounds
     */
    public final <T> T get(int i) {
        init();
        if (array[i] == null) {
            array[i] = supply();
        }
        return (T) array[i];
    }

    final GlcArray getArray(int i) {
        return get(i);
    }

    public void verify(Object t) {
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
        Object[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcArray(clazz, true, subSizes, length + 1, newArray, debug);
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
}