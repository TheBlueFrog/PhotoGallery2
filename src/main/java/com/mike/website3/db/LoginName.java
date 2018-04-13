package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Log;
import com.mike.website3.Constants;
import com.mike.website3.MySystemState;
import com.mike.website3.Website;
import com.mike.website3.db.repo.LoginNameRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Created by mike on 11/6/2016.
 *
 * database CRUD class to hold user roles (permissions)
 */
@Entity
@Table(name="login_names")
public class LoginName implements Serializable {

    private static final long serialVersionUID = -4745423361379674335L;
    private static final String TAG = LoginName.class.getSimpleName();

    @Id
    @Column(name = "login_name")                private String loginName;
    @Column(name = "users_id")                  private String userId;
    @Column(name = "salt")                      private String salt = "";
    @Column(name = "pw_hash")                   private String pwHash = "";

    public String getUserId() { return userId; }
    public String getLoginName() {
        return loginName.toLowerCase();
    }
    public String getLoginNameRaw() {
        return loginName;
    }
    public String getSalt() { return salt; }
    public String getPwHash() { return pwHash; }

    public void setSalt(String salt) {
        this.salt = salt;
    }
    public void setPwHash(String hash) {
        this.pwHash = hash;
    }


    protected LoginName() { }

    public LoginName(String userId, String loginName) {
        this.userId = userId;
        this.loginName = loginName.replace("'", "").replace("/", "");
    }

    public void save() {
        Website.getRepoOwner().getLoginNameRepo().save(this);
    }
    public void delete() {
        Website.getRepoOwner().getLoginNameRepo().delete(this);
    }

    private static final Pattern VALID_EMAIL_ADDRESS_REGEX =
            Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);

    static public boolean validLoginName(String loginName) {
        Matcher matcher = VALID_EMAIL_ADDRESS_REGEX .matcher(loginName);
        return matcher.find();
    }

    static private LoginNameRepo getRepo() {
        return Website.getRepoOwner().getLoginNameRepo();
    }

    public static List<LoginName> findAllByUserId(String userId) {
        return getRepo().findByUserId(userId);
    }

    public static String getUsernameFromLoginName(String loginName) {
        List<LoginName> loginNames = findByLoginName(loginName);
        if (loginNames.size() > 0) {
            String username = loginNames.get(0).getUserId();
            return username;
        }

        return null;
    }

    static public List<LoginName> findByLoginName(String loginName) {
        String lc = loginName.toLowerCase();
        List<LoginName> db = getRepo().findAllByOrderByLoginName();
        List<LoginName> output = new ArrayList<>();
        for (LoginName y : db) {
            if (y.getLoginName().equals(lc)) {
                output.add(y);
            }
        }

        if (output.size() > 1) {
            SystemEvent.save("System", String.format("Non-unique login name %s", loginName));
        }

        return output;
    }

    static public LoginName findByUserIdAndLoginName(String userId, String loginName) {
        String lc = loginName.toLowerCase();
        List<LoginName> x = getRepo().findAll();
        for (LoginName y : x) {
            if ((y.getLoginName().equals(lc)) && (y.getUserId().equals(userId))) {
                return y;
            }
        }
        return null;
    }


    // one-time to grandfather in users prior to LoginName, triggered
    // iff the LoginName table is empty
    public static void grandfatherExistingUsers() {
        if (getRepo().findAll().size() == 0) {
            Log.e(TAG, new NullPointerException("Can't grandfather in existing users, code removed."));
            assert false; // oops
//            User.getMiniUsers().forEach(user -> {
//                LoginName loginName = new LoginName(user.username, user.username);
//                loginName.setSalt(user.salt);
//                loginName.setPwHash(user.pwHash);
//                loginName.save();
//            });
//            Log.d(TAG, "Grandfathered existing users into the LoginName table");
        }
    }


    public static boolean hasPasswordBeenReset(String loginName) {
        List<LoginName> loginName1 = findByLoginName(loginName);
        if (loginName1.size() > 0)
            return loginName1.get(0).hasPasswordBeenReset();
        return false;
    }

    public boolean hasPasswordBeenReset() {
        return getPwHash().length() == Constants.Code.RESET_PW_LENGTH;
    }

    public static void resetPassword(String loginname) {
        List<LoginName> loginName = findByLoginName(loginname);
        if (loginName.size() > 0)
            loginName.get(0).resetPassword();
    }

    public void resetPassword() {
        int i = MySystemState.getInstance().getRandom().nextInt(100000);
        setPwHash(String.format("%05d", i));
        save();
    }


    static public List<LoginName> findReset() {
        List<LoginName> reset = getRepo().findAll().stream()
                .filter(loginName ->
                        (loginName.getPwHash().length() == 5)
                                // 11111 is a mass pw reset before Beta
                                // login names that start with mr-282 are accounts
                                // of old users that we had make new acounts, the
                                // mr-282 lets us match up the old and new accounts
                                // if that ever becomes important
                            && ( ! loginName.getPwHash().equals("11111"))
                            && ( ! loginName.getLoginName().startsWith("mr-282"))
                )
                .collect(Collectors.toList());

        Collections.sort(reset, (o1, o2) -> o1.getLoginName().compareTo(o2.getLoginName()));
        return reset;
    }

    public static void findDuplicates() {
        List<LoginName> x = getRepo().findAll().stream()
                .collect(Collectors.toList());
        Set<String> unique = new HashSet<>();
        x.forEach(s -> {
            if (User.findById(s.getUserId()).getEnabled()) {
                if (!unique.add(s.getLoginName())) {
                    List<LoginName> y = LoginName.findByLoginName(s.getLoginName());
                    y.forEach(loginName1 ->
                            Log.e(TAG, String.format("Duplicate login name %s and %s account %s",
                                    loginName1.getLoginName(),
                                    loginName1.getLoginNameRaw(),
                                    loginName1.getUserId()))
                    );
                }
            }
        });
    }

    public static boolean hasDuplicate(String userId) {
        List<LoginName> x = getRepo().findByUserId(userId).stream()
                .collect(Collectors.toList());
        Set<String> unique = new HashSet<>();
        for(LoginName s : x) {
            if (User.findById(s.getUserId()).getEnabled()) {
                if (!unique.add(s.getLoginName())) {
                    List<LoginName> y = LoginName.findByLoginName(s.getLoginName());
                    y.forEach(loginName1 ->
                            Log.e(TAG, String.format("Duplicate login name %s and %s account %s",
                                    loginName1.getLoginName(),
                                    loginName1.getLoginNameRaw(),
                                    loginName1.getUserId()))
                    );
                    return true;
                }
            }
        }
        return false;
    }

    private static List<LoginName> findByUserId(String userId) {
        List<LoginName> x = getRepo().findByUserId(userId);
        return x;
    }
}
