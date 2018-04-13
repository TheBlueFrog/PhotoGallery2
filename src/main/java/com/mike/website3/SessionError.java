package com.mike.website3;

/**
 * Created by mike on 9/9/2017.
 */
public class SessionError {

    private final String code;
    private final String error;

    public String getCode() {
        return code;
    }
    public String getError() {
        return error;
    }

    public SessionError(String code, String error) {
        this.code = code;
        this.error = error;
    }
}
