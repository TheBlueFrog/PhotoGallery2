package com.mike.website3;

import com.mike.util.Log;
import com.mike.website3.db.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestUserPrefs {

    private static final String TAG = TestUserPrefs.class.getSimpleName();

    @Test
    public void test_checkRolesOfUserMike () {
        User.findAll().forEach(user -> {
            UserPrefs p = UserPrefs.findByUserId(user.getUsername());
            if (p == null)
                Log.d(TAG, String.format("user %s has no Pref record", user.getUsername()));
            else
                Log.d(TAG, String.format("user %s has a single Pref record", user.getUsername()));
        });

    }

}

