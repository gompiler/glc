package glcutils;

public class GlcException extends RuntimeException {
    public GlcException() {
        super();
    }

    public GlcException(String message) {
        super(message);
    }

    public GlcException(String message, Throwable cause) {
        super(message, cause);
    }

    public GlcException(Throwable cause) {
        super(cause);
    }

    protected GlcException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
