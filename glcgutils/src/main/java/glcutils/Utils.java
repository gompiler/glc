package glcutils;

public class Utils {
    public static String boolStr(int b) {
        if (b == 0) {
            return "false";
        } else {
            return "true";
        }
    }

    public static <T> T newInstance(Class<? extends T> clazz) {
        try {
            return clazz.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
}
