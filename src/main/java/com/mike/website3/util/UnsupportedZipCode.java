package com.mike.website3.util;

public class UnsupportedZipCode extends Throwable {
    public UnsupportedZipCode(String zip) {
        super (zip);
    }
}
