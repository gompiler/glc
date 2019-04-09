package glcutils;

import java.lang.reflect.Array;

public class GlcArray<T> {
    int length;
    T[] array;
    final Supplier<T> supplier;
    final Class<? extends T> clazz;

    public GlcArray(Class<? extends T> clazz, int length) {
        this(() -> Utils.baseSupply(clazz), clazz, length, null);
    }

    public GlcArray(Supplier<T> supplier, Class<? extends T> clazz, int length) {
        this(supplier, clazz, length, null);
    }

    public GlcArray(Class<? extends T> clazz, int length, T[] array) {
        this(() -> Utils.baseSupply(clazz), clazz, length, array);
    }

    GlcArray(Supplier<T> supplier, Class<? extends T> clazz, int length, T[] array) {
        this.length = length;
        this.supplier = supplier;
        this.clazz = clazz;
        this.array = array;
    }

    /**
     * Ensures that array is nonnull
     */
    final void init() {
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
    public T supply() {
        return supplier.get();
    }

    /**
     * Return nonnull struct if index is within bounds
     */
    public final T get(int i) {
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
        if (array == other.array) {
            return true;
        }
        init();
        other.init();
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