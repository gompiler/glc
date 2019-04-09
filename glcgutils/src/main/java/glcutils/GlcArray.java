package glcutils;

import java.lang.reflect.Array;

public class GlcArray<T> {
    int length;
    T[] array;
    final Class<? extends T> clazz;

    public GlcArray(Class<? extends T> clazz, int length) {
        this(clazz, length, null);
    }

    public GlcArray(Class<? extends T> clazz, int length, T[] array) {
        this.length = length;
        this.clazz = clazz;
        this.array = array;
    }

    /**
     * Ensures that array is nonnull
     */
    void init() {
        if (array == null) {
            array = create(length);
        }
    }

    /**
     * Generates a new array of the provided length
     * Note that each value is null
     */
    final T[] create(int length) {
        //noinspection unchecked
        return (T[]) Array.newInstance(this.clazz, length);
    }

    /**
     * Generate a new element entry,
     * based on the struct supplier definition
     */
    final T supply() {
        return Utils.newInstance(clazz);
    }

    /**
     * Return nonnull struct if index is within bounds
     */
    public final T get(int i) {
        if (i > length - 1) {
            throw new IndexOutOfBoundsException();
        }
        init();
        if (array[i] == null) {
            array[i] = supply();
        }
        return array[i];
    }

    /**
     * Set new struct value at specified index if it is within bounds
     */
    public final void set(int i, T t) {
        if (i > length - 1) {
            throw new IndexOutOfBoundsException();
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
    public final int capacity() {
        return array == null ? 0 : array.length;
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
        if (this.length != other.length) {
            return false;
        }
        if (!this.clazz.equals(other.clazz)) {
            return false;
        }
        for (int i = 0; i < length(); i++) {
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