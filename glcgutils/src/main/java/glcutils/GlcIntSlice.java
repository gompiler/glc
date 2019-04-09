package glcutils;

public class GlcIntSlice extends GlcIntArray {

    public GlcIntSlice() {
        this(0, null);
    }

    private GlcIntSlice(int length, int[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcIntSlice append(int t) {
        if (length >= capacity() - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity() == 0 ? 2 : capacity() * 2;
            int[] newArray = new int[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            // Note that we don't modify the current length or array, since this slice is unchanged
            return new GlcIntSlice(length + 1, newArray);
        } else {
            // If array were null, it would not have enough capacity; no need to init here
            array[length] = t;
            return new GlcIntSlice(length + 1, array);
        }
    }

}