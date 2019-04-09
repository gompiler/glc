package glcutils;

import java.lang.reflect.Array;

public class GlcSliceUtils {
    
    /**
     * Appends value at provided length using provided array.
     * If capacity is too small, a new array will be generated
     */
    public static <T> T[] append(Class<? extends T> clazz, T[] array, int length, T t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length >= capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity == 0 ? 2 : capacity * 2;
            T[] newArray = (T[]) Array.newInstance(clazz, newLength);
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }

    /**
     * Appends value at provided length using provided array.
     * If capacity is too small, a new array will be generated
     */
    public static boolean[] append(boolean[] array, int length, boolean t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length >= capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity == 0 ? 2 : capacity * 2;
            boolean[] newArray = new boolean[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }

    /**
     * Appends value at provided length using provided array.
     * If capacity is too small, a new array will be generated
     */
    public static char[] append(char[] array, int length, char t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length >= capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity == 0 ? 2 : capacity * 2;
            char[] newArray = new char[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }

    /**
     * Appends value at provided length using provided array.
     * If capacity is too small, a new array will be generated
     */
    public static int[] append(int[] array, int length, int t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length >= capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity == 0 ? 2 : capacity * 2;
            int[] newArray = new int[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }

    /**
     * Appends value at provided length using provided array.
     * If capacity is too small, a new array will be generated
     */
    public static float[] append(float[] array, int length, float t) {
        int capacity = array == null ? 0 : array.length;
        if (array == null || length >= capacity - 1) {
            // We have an initial capacity of 2 due to legacy golang
            // This is a requirement for golite
            int newLength = capacity == 0 ? 2 : capacity * 2;
            float[] newArray = new float[newLength];
            if (array != null) {
                System.arraycopy(array, 0, newArray, 0, length);
            }
            newArray[length] = t;
            return newArray;
        } else {
            array[length] = t;
            return array;
        }
    }
}
