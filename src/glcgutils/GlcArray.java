package glcgutils;

class GlcArray<T> {
    int length;
    T[] array;
    final Supplier<T> supplier;
    final Class<?> clazz;

    GlcArray(Supplier<T> supplier, int length, Class<?> clazz, T[] array) {
        this.supplier = supplier;
        this.length = length;
        this.clazz = clazz;
        this.array = array;
    }

    final void init() {
        if (array == null) {
            array = create(length);
        }
    }

    final T[] create(int length) {
        return (T[]) Array.newInstance(this.clazz, length);
    }

    final T supply() {
        return supplier.get();
    }

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

    public final void set(int i, T t) {
        if (i > length - 1) {
            throw new IndexOutOfBoundsException();
        }
        init();
        array[i] = t;
    }

    public final int length() {
        return length;
    }

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