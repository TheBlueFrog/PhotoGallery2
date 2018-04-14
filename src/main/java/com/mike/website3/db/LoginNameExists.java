package com.mike.website3.db;

public class LoginNameExists extends Exception {
    public LoginNameExists(String loginName) {
        super(loginName);
    }
}
