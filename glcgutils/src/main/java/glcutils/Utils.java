package glcutils;

import java.util.Arrays;

@SuppressWarnings({"WeakerAccess", "unchecked"})
public class Utils {
    public static String boolStr(int b) {
        if (b == 0) {
            return "false";
        } else {
            return "true";
        }
    }

    public static <T> T copy(Object o) {
        return (T) copyObj(o);
    }

    /**
     * Makes a copy of the object
     * If it implements copy (structs or arrays), it will use a custom copy function
     * Otherwise (primitive, string, null), return original object
     *
     * @param o
     * @return
     */
    public static Object copyObj(Object o) {
        if (o instanceof GlcCopy) {
            return ((GlcCopy) o).copy();
        }
        return o;
    }

    public static int[] tail(int[] array) {
        return Arrays.copyOfRange(array, 1, array.length);
    }

    public static void fail(String s, Object... args) {
        throw new GlcException(String.format(s, args));
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

    public static Object supplyObj(Class clazz) {
        if (clazz == String.class) {
            return null;
        }
        if (clazz == Integer.class) {
            return 0;
        }
        if (clazz == Boolean.class) {
            return false;
        }
        if (clazz == Float.class) {
            return 0f;
        }
        if (clazz == Character.class) {
            return '\0';
        }
        try {
            return clazz.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new GlcException(e);
        }
    }

}
