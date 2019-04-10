package glcutils;

public class GlcSlice$String_1 extends GlcArray$String_1 {

    public GlcSlice$String_1() {
        this(0, null);
    }

    private GlcSlice$String_1(int length, String[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice$String_1 append(String t) {
        String[] newArray = GlcSliceUtils.append(String.class, array, length, t);
        return new GlcSlice$String_1(length + 1, newArray);
    }

}