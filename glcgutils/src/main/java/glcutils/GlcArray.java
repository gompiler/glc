package glcutils;

import java.util.Arrays;

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

    /**
     * Set new struct value at specified index if it is within bounds
     */
    public void set(int i, Object t) {
        if (debug) {
            if (subSizes.length == 0 && !clazz.isInstance(t)) {
                Utils.fail("Set value in 1D GlcArray, but not of class %s", clazz.getName());
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
        if (!isSlice) {
            throw new RuntimeException("Cannot append to nonslice");
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
        if (!lightEquals(other)) {
            return false;
        }
        init();
        other.init();
        return arrayEquals(other);
    }

    /**
     * Check equality, without checking array data
     */
    boolean lightEquals(GlcArray other) {
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
        return true;
    }

    boolean arrayEquals(GlcArray other) {
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