package glcutils;

public class GlcSlice$Char_1 extends GlcArray$Char_1 {

    public GlcSlice$Char_1() {
        this(0, null);
    }

    private GlcSlice$Char_1(int length, char[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice$Char_1 append(char t) {
        char[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcSlice$Char_1(length + 1, newArray);
    }

}