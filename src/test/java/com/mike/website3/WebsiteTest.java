package com.mike.website3;

import com.mike.util.Log;
import org.junit.Test;

import static org.junit.Assert.*;

public class WebsiteTest {
    private static final String TAG = WebsiteTest.class.getSimpleName();

    @Test
    public void isProduction() throws Exception {
        if (Website.isProduction())
            Log.d(TAG, "OK");
    }

}