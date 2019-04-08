public class Slice {
    public int length;
    private Object[] array;
    public Slice() {
        length = 0;
        array = new Object[0];
    }
    public Slice getSlice() {
        Slice ret = new Slice();
        ret.length = length;
        ret.array = array;
        return ret;
    }
    public Object get(int ind) {
        if (ind > length - 1) {
            throw new IndexOutOfBoundsException();
        } else {
            return array[ind];
        }
    }
    public void set(int ind, Object o) {
        if (ind > length - 1) {
            throw new IndexOutOfBoundsException();
        } else {
            array[ind] = o;
        }
    }
    public Slice append(Object o) {
        if (length >= array.length - 1) {
            int newLength = 0;
            if (array.length == 0) {
                newLength = 2;
            }
            else {
                newLength = 2 * array.length;
            }
            Object[] tarray = new Object[newLength];
            System.arraycopy(array, 0, tarray, 0, array.length);
            array = tarray;
        }
        length++;
        array[length] = o;
        return this;
    }
    public int capacity() {
        return array.length;
    }
};
