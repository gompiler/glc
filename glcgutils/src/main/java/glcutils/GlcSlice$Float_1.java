package glcutils;

public class GlcSlice$Float_1 extends GlcArray$Float_1 {

    public GlcSlice$Float_1() {
        this(0, null);
    }

    private GlcSlice$Float_1(int length, float[] array) {
        super(length, array);
    }

    /**
     * Returns a new slice, with the value appended.
     * Note that the underlying array will be reused if the capacity allows another element.
     * Otherwise, a new array is returned
     */
    public GlcSlice$Float_1 append(float t) {
        float[] newArray = GlcSliceUtils.append(array, length, t);
        return new GlcSlice$Float_1(length + 1, newArray);
    }

}