package glcgutils;

class GlcSlice<T> extends GlcArray<T> {

    GlcSlice(Supplier<T> supplier) {
        this(supplier, 0, supplier.get().getClass(), null);
    }

    private GlcSlice(Supplier<T> supplier, int length, Class<?> clazz, T[] array) {
        super(supplier, length, clazz, array);
    }

    public GlcSlice<T> append(T t) {
        if (length >= capacity() - 1) {
            int newLength = capacity() == 0 ? 1 : capacity() * 2;
            T[] newArray = create(newLength);
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            // Note that we don't modify the current length or array, since this slice is unchanged
            return new GlcSlice<>(this.supplier, length + 1, this.clazz, newArray);
        } else {
            array[length] = t;
            length++;
            return this;
        }
    }
}