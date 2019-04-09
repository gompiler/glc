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
        int[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcIntSlice(length + 1, newArray);
    }

}