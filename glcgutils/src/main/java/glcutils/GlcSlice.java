package glcutils;

class GlcSlice<T> extends GlcArray<T> {

    public GlcSlice(Class<? extends T> clazz) {
        this(clazz, 0, null);
    }

    private GlcSlice(Class<? extends T> clazz, int length, T[] array) {
        super(clazz, length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice<T> append(T t) {
        if (length >= capacity() - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity() == 0 ? 2 : capacity() * 2;
            T[] newArray = create(newLength);
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            // Note that we don't modify the current length or array, since this slice is unchanged
            return new GlcSlice<>(this.clazz, length + 1, newArray);
        } else {
            // If array were null, it would not have enough capacity; no need to init here
            array[length] = t;
            return new GlcSlice<>(this.clazz, length + 1, array);
        }
    }

}