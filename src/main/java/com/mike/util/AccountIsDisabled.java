package com.mike.util;

import com.mike.website3.db.User;

public class AccountIsDisabled extends Exception {
    public AccountIsDisabled(User user) {
        super(user.getId());
    }
}
