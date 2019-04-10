package glcutils;

import java.util.Arrays;

public class GlcArray$Int_1 {
    int length;
    int[] array;

    public GlcArray$Int_1(int length) {
        this(length, null);
    }

    GlcArray$Int_1(int length, int[] array) {
        this.length = length;
        this.array = array;
    }

    /**
     * Ensures that array is nonnull
     */
    final void init() {
        if (array == null) {
            array = new int[length];
        }
    }

    /**
     * Return nonnull struct if index is within bounds
     */
    public final int get(int i) {
        init();
        return array[i];
    }

    /**
     * Set new struct value at specified index if it is within bounds
     */
    public final void set(int i, int t) {
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
    public final int capacity() {
        return array == null ? 0 : array.length;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        GlcArray$Int_1 other = (GlcArray$Int_1) obj;
        if (length != other.length) {
            return false;
        }
        if (array == other.array) {
            return true;
        }
        init();
        other.init();
        return Arrays.equals(array, other.array);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(array);
    }

    @Override
    public String toString() {
        return Arrays.toString(array);
    }
}