package com.mike.exceptions;

/**
 * Created by mike on 7/23/2017.
 */
public class NoEmailAddressForUserException extends Exception {
    public NoEmailAddressForUserException(String s) {
        super(s);
    }
}
