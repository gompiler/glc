package glcutils;

import org.junit.Test;

import static org.junit.Assert.*;

public class GlcMutiSliceTest {

    @Test
    public void multiArrayCheck() {
        GlcSlice$String$2 a = new GlcSlice$String$2();
        a = a.append(null);
        assertNotNull(a.get(0));
    }

    private static class GlcSlice$String$2 extends GlcSlice<GlcSlice$String$1> {

        public GlcSlice$String$2() {
            super(GlcSlice$String$1.class);
        }

        @Override
        public GlcSlice$String$2 append(GlcSlice$String$1 s) {
            return (GlcSlice$String$2) super.append(s);
        }

    }

    private static class GlcSlice$String$1 extends GlcSlice<String> {
        public GlcSlice$String$1() {
            super(() -> null, String.class);
        }

        @Override
        public GlcSlice$String$1 append(String s) {
            return (GlcSlice$String$1) super.append(s);
        }
    }
}

