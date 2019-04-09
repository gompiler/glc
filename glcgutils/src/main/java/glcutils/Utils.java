package glcutils;

import java.lang.reflect.Array;

public class Utils {
    public static String boolStr(int b) {
        if (b == 0) {
            return "false";
        } else {
            return "true";
        }
    }

    public static <T> T baseSupply(Class<? extends T> clazz) {
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
