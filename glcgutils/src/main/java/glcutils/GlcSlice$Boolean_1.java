package glcutils;

public class GlcSlice$Boolean_1 extends GlcArray$Boolean_1 {

    public GlcSlice$Boolean_1() {
        this(0, null);
    }

    private GlcSlice$Boolean_1(int length, boolean[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice$Boolean_1 append(boolean t) {
        boolean[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcSlice$Boolean_1(length + 1, newArray);
    }

}