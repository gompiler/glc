package glcutils;

public class GlcSlice$Int_1 extends GlcArray$Int_1 {

    public GlcSlice$Int_1() {
        this(0, null);
    }

    private GlcSlice$Int_1(int length, int[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice$Int_1 append(int t) {
        int[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcSlice$Int_1(length + 1, newArray);
    }

}