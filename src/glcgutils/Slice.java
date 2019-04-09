package glcgutils;

class Slice<T> {

    private int length;
    private T[] array;
    private final Supplier<T> supplier;
    private Class<?> clazz;

    Slice(Supplier<T> supplier) {
        this.length = 0;
        this.supplier = supplier;
        this.clazz = supplier.get().getClass();
        array = create(length);
    }

    private Slice(Supplier<T> supplier, int length, Class<?> clazz, T[] array) {
        this.supplier = supplier;
        this.length = length;
        this.clazz = clazz;
        this.array = array;
    }

    private T[] create(int length) {
        return (T[]) Array.newInstance(this.clazz, length);
    }

    public T get(int i) {
        if (i > length - 1) {
            throw new IndexOutOfBoundsException();
        }
        if (array[i] == null) {
            array[i] = supplier.get();
        }
        return array[i];
    }


    public void set(int ind, T t) {
        if (ind > length - 1) {
            throw new IndexOutOfBoundsException();
        } else {
            array[ind] = t;
        }
    }

    public Slice<T> append(T t) {
        if (length >= array.length - 1) {
            int newLength = array.length == 0 ? 1 : array.length * 2;
            T[] newArray = create(newLength);
            System.arraycopy(array, 0, newArray, 0, array.length);
            newArray[length] = t;
            // Note that we don't modify the current length or array, since this slice is unchanged
            return new Slice<>(this.supplier, length + 1, this.clazz, newArray);
        } else {
            array[length] = t;
            length++;
            return this;
        }
    }

    public int length() {
        return length;
    }

    public int capacity() {
        return array.length;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Slice)) {
            return false;
        }
        Slice s = (Slice) obj;
        if (this.length != s.length) {
            return false;
        }
        if (!this.clazz.equals(s.clazz)) {
            return false;
        }
        // todo, array compare
        return super.equals(obj);
    }
}