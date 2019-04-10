package glcutils;

public class Utils {
    public static String boolStr(int b) {
        if (b == 0) {
            return "false";
        } else {
            return "true";
        }
    }

    /**
     * Provides a new instance.
     * Applicable to structs and slices, which must have public default constructors.
     * For strings, we return null by default
     */
    public static <T> T supply(Class<? extends T> clazz) {
        if (clazz == String.class) {
            return null;
        }
        try {
            return clazz.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }

}
