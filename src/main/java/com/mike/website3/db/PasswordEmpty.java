package com.mike.website3.db;

public class PasswordEmpty extends Exception {
    public PasswordEmpty() {
        super("Password is empty");
    }
}
