package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.exceptions.*;
import com.mike.util.*;
import com.mike.website3.Constants;
import com.mike.website3.*;
import com.mike.website3.db.repo.UserRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.File;
import java.io.Serializable;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

/**
 * class wrapped around the database users table
 */
@Entity
@Table(name="users")
public class User implements Serializable {

    private static final String TAG = User.class.getSimpleName();
    private static final long serialVersionUID = 8100551514802474132L;

    @Id
    @Column(name = "user_id")                   private String userId;      // UUID
    @Column(name = "login_name")                private String loginName;     //

    @Column(name = "pw_salt")                   private String pwSalt = "";     //
    @Column(name = "pw_hash")                   private String pwHash = "";     //

    @Column(name = "enabled", columnDefinition = "boolean default true") private boolean enabled = true;

    @Column(name = "has_logged_in", columnDefinition = "boolean default false")
    private boolean hasLoggedIn = false;

    @Column(name = "join_timestamp")            private Timestamp joinTimestamp;


    protected User() { }

    public static User findByLoginName(String loginName) {
        User x = getRepo().findByLoginName(loginName);
        return x;
    }

    public String getId() {
        return userId;
    }
    public String getUsername() {
        return userId;
    }
    public String getLoginName() {
        return loginName;
    }

    public String getPwSalt() {
        return pwSalt;
    }
    public String getPwHash() {
        return pwHash;
    }

    public boolean getEnabled() { return enabled; }
    public boolean getHasLoggedIn() { return hasLoggedIn; }
    public Timestamp getJoinTimestamp() {
        return joinTimestamp;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }
    public void setPwHash(String pwHash) {
        this.pwHash = pwHash;
    }
    public void setPwSalt(String pwSalt) {
        this.pwSalt = pwSalt;
    }

    public void setJoinTimestamp(Timestamp timestamp) {
        this.joinTimestamp = timestamp;
    }

    /** disabling a user will clear all roles/privs */
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;

        if ( ! this.enabled)
            UserRole.removeAll(getId());
    }
    public void setHasLoggedIn() {
        this.hasLoggedIn = true;
    }

    public static List<String> findAllUserIds() {
        List<String> users = new ArrayList<>();
        findByEnabled(true).forEach(user -> users.add(user.getUsername()));
        return users;
    }

    static private UserRepo getRepo() {
        return Website.getRepoOwner().getUserRepo();
    }

    public static List<User> findByEnabled(boolean enabled) {
        List<User> x = getRepo().findByEnabled(true);
        return x;
    }

    public static List<User> findAll() {
        return getRepo().findAll();
    }

    public static List<User> findAllOrderByNameAsc() {
        List<User> x = findAll();
        Util.sortByLoginName(x);
        return x;
    }


    public void save () {
        getRepo().save(this);
    }

    public static User findById(String userId) {
        return getRepo().findByUserId(userId);
    }

    public static List<User> findByEnabledOrderByLoginName(boolean enabled) {
        return Util.sortByLoginName(getRepo().findByEnabled(true));
    }

    public boolean hasPasswordBeenReset() {
        return getPwHash().length() == Constants.Code.RESET_PW_LENGTH;
    }
    public boolean passwordHasBeenReset() {
        return getPwHash().length() == Constants.Code.RESET_PW_LENGTH;
    }

    public boolean isPasswordResetCode(String loginName, String resetCode) {
        return (getPwHash().length() == Constants.Code.RESET_PW_LENGTH) &&
                getPwHash().equals(resetCode);
    }

    public String getResetCode() {
        String s = getPwHash();
        if (s.length() == Constants.Code.RESET_PW_LENGTH)
            return s;
        else
            return "";
    }

    // called by reset password to put a new PW in
    public void hashPassword(String newPassword) throws NoSuchAlgorithmException {
        String salt = genSalt();
        String hashedPassword = secureHash(newPassword, salt);
        setPwSalt(salt);
        setPwHash(hashedPassword);
        save();
    }

    public void setAuthentication(String salt, String hashedPassword) {
        setPwSalt(salt);
        setPwHash(hashedPassword);
    }

    /**
     * generate a random 5 digit number and put into the pw hash field,
     * we will email this to the user and they have to enter it in
     * the reset pw page
     */
    public void resetPassword() {
        int i = MySystemState.getInstance().getRandom().nextInt(100000);
        setPwHash(String.format("%05d", i));
        save();
    }

    public User(String loginName,
                String password,
                String role)
            throws UserDirectoryExistsException,
            NoSuchAlgorithmException,
            IllegalArgumentException, LoginNameExists {
        User u = getRepo().findByLoginName(loginName);
        if (u != null)
            throw new LoginNameExists(loginName);

        userId = UUID.randomUUID().toString();
        joinTimestamp = MySystemState.getInstance().nowTimestamp();

        this.loginName = loginName;

        // if we fail out after this we have dead directories
        setupUserDirectory();

        String salt = genSalt();
        String hashedPassword = secureHash(password, salt);
        setAuthentication(salt, hashedPassword);

        this.save();

        SystemEvent.save(this, "CreateUser");

        // user now exists do other DB stuff

        setupRoles(getId(), role);
    }

    private void setupRoles(String id, String roleS) {
        UserRole.Role role = UserRole.Role.User;
        if (roleS != null) {
            role = UserRole.Role.valueOf(roleS);
        }

        UserRole.add(id, UserRole.Role.AccountPending); // everyone

        UserRole.add(id, role);

        switch (role) {
            case User:
                // nothing else
                break;
            default:
                String s = String.format("Missing case statement for " + role.toString());
                Log.e(TAG, s);
                SystemEvent.save("system", s);
                break;
        }
    }

    private void setupUserDirectory() throws UserDirectoryExistsException {

        // to avoid case sensitivity issues with the file system
        // that holds the user's directory we lowercase all new file names

        File userdir = Website.getUserDir(getUsername());

        if (userdir.exists()) {
            throw new UserDirectoryExistsException("User directory already exists.  " + userdir.getAbsolutePath());
        }

        userdir.mkdir();

        File imagedir = new File(userdir, "images");
        imagedir.mkdir();
    }

    public void checkForUserDirectory() {

        File userdir = Website.getUserDir(getId());
        if ( ! userdir.exists())
            userdir.mkdir();

        File imagedir = new File(userdir, "images");
        if ( ! imagedir.exists())
            imagedir.mkdir();

        File wwwdir = new File(userdir, "www");
        if ( ! wwwdir.exists())
            wwwdir.mkdir();
    }


    /**
     Authenticate the user by hashing the input password using the stored salt,
     then comparing the generated hashed password to the stored hashed password
     return the User if it validates, otherwise null

     the login name presented is distinct from User.username we map the
     login name into the username
      */
    public static User authenticate(String loginName, String password)
            throws
            PasswordResetException,
            NoSuchAlgorithmException, NoSuchLoginName, NoSuchUserId, AccountIsDisabled, PasswordEmpty {

        if (loginName.isEmpty())
            throw new NoSuchLoginName(loginName);
        if (password.isEmpty())
            throw new PasswordEmpty();

        User user = getRepo().findByLoginName(loginName);
        if (user == null) {
            throw new NoSuchLoginName(loginName);
        }

        if ( ! user.enabled)
            throw new AccountIsDisabled(user);

        if (user.passwordHasBeenReset()) {
            // password has been reset, force it to be changed
            throw new PasswordResetException ("Password has been reset.");
        }

        String hashedPassword = secureHash(password, user.getPwSalt());
        if (hashedPassword.equals(user.getPwHash()))
            return user;
        else
            return null;    // nope
    }

    public void login() {
        checkForUserDirectory();
    }

    static private String genSalt() throws NoSuchAlgorithmException {

        SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");

        byte[] salt = new byte[32];
        sr.nextBytes(salt);

        StringBuilder sb = new StringBuilder();
        Random r = MySystemState.getInstance().getRandom();
        for (int i = 0; i < salt.length; i++) {
            sb.append(Integer.toString((salt[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }

    static private String secureHash(String pw, String salt) throws NoSuchAlgorithmException {
        MessageDigest md = null;
        md = MessageDigest.getInstance("SHA-256");
        md.update((pw + salt).getBytes());

        byte byteData[] = md.digest();

        //convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        return sb.toString();
    }


    // sometime, drop the silly 2, move the FLT to another API or something

    public boolean doesRole2(UserRole.Role role) {
        return UserRole.does(this.getId(), role);
    }

    public boolean doesRole(String role) {
        try {
            boolean x = UserRole.does(this.getId(), UserRole.Role.valueOf(role));
            return x;
        }
        catch (Exception e) {
            Log.e(TAG, String.format("FTL code is asking if a user doesRole %s which does not exist.", role));
            return false;
        }
    }

    /**
     * @param roles  set of user roles
     * @return
     */
    public static List<User> getUsersByRoles(List<UserRole.Role> roles) {
        List<User> users = new ArrayList<>();
        User.findByEnabled(true).forEach(user -> {
            for (UserRole.Role role : roles)
                if (user.doesRole2(role))
                    users.add(user);
        });
        return users;
    }
    public static List<User> getUsersByRole(UserRole.Role role) {
        List<User> users = new ArrayList<>();
        User.findByEnabled(true).forEach(user -> {
            if (user.doesRole2(role))
                users.add(user);
        });
        return users;
    }

    public boolean isRole(List<UserRole.Role> roles) {
        for (UserRole.Role r : roles)
            if (this.doesRole2(r))
                return true;
        return false;
    }


//    public List<String> getStoredImages() {
//        List<String> paths = new ArrayList<>();
//        Website.getStorageService().loadAll(this).forEach(path -> {
//            String s = path.toFile().getName();
//            paths.add(path.toFile().getName());
//        });
//        return paths;
//    }


    public List<PhoneNumber> getPhoneNumbers() {
        return PhoneNumber.findByUserId(getUsername());
    }
    public List<EmailAddress> getEmailAddresses() {
        return EmailAddress.findByUserId(getUsername());
    }

    public void addRole(UserRole.Role role) {
        UserRole.add(this.getUsername(), role);
    }
    public void removeRole(UserRole.Role role) {
        UserRole.remove(this.getUsername(), role);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (! User.class.isAssignableFrom(obj.getClass())) {
            return false;
        }
        final User other = (User) obj;

        return this.getUsername().compareTo(other.getUsername()) == 0;
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = (int) (57 * hash + this.getUsername().hashCode());
        return hash;
    }


    @Override
    public String toString() {
        return String.format("%8.8s", getId());
    }

    public String getPublicHomePageURL() {
        if (StringData.findByUserIdAndKey(getId(), "hasprofile") == null) {
            return "#";
        }
        return String.format("/mini-website?userId=%s", getUsername());
    }

    public void removePhone(String value) {
        for (PhoneNumber p : getPhoneNumbers()) {
            if (p.getPhoneNumber().equals(value)) {
                p.delete();
                return;
            }
        }
    }

    public void removeEmail(String value) {
        for (EmailAddress p : getEmailAddresses()) {
            if (p.getEmail().equals(value)) {
                p.delete();
                return;
            }
        }
    }

    /**
     * we'll assume having a company name defined for the
     * use is an opt-out of location fuzzing...
     * @return
     */
    public boolean locationFuzzRequested() {
        return true;
    }


    public boolean isAnAdmin() {
        return UserRole.isAnAdmin(getId());
    }

    static public List<User> findPending(boolean includeDisabled) {
        List<User> pending = null;
        if (includeDisabled)
            pending = User.findAll();
        else
            pending = User.findByEnabled(true);

        pending = pending.stream()
                .filter(u -> UserRole.does(u.getId(), UserRole.Role.AccountPending))
                .collect(Collectors.toList());
        return pending;
    }

    public interface UserSelector {
        boolean select(User user);
    }
    public interface UserSorter {
        List<User> sort(List<User> users);
    }

    static public List<User> getSortedUsers(UserSelector selector, UserSorter sorter) {

        List<User> users = User.findAll().stream()
                .filter(user1 -> selector.select(user1))
                .collect(Collectors.toList());

        return sorter.sort(users);
    }

    public String getName() {
        return String.format("8.8s", getId());
    }

    static public List<User> findByRole(String role) {
        UserRole.Role role1 = UserRole.Role.valueOf(role);
        return findByRole(role1);
    }
    static public List<User> findByRole(UserRole.Role role) {

        List<User> x = User.getSortedUsers(new UserSelector() {
                                               @Override
                                               public boolean select(User user) {
                                                   return user.getEnabled()
                                                           && UserRole.does(user.getId(), role);
                                               }
                                           },
                                           Util::sortByLoginName);
        return x;
    }

    static public List<User> findByRoles(String roles) {
        String[] x = roles.split(" ");
        List<UserRole.Role> y = Arrays.stream(x).map(s -> UserRole.Role.valueOf(s)).collect(Collectors.toList());
        List<UserRole> z = UserRole.findByRoleIn(y);
        Set<String> userIds = z.stream().map(r -> r.getUserId()).collect(Collectors.toSet());
        List<User> users = userIds.stream().map(userId -> User.findById(userId)).collect(Collectors.toList());
        Util.sortByLoginName(users);
        return users;
    }

    public List<Image> getImages() {
        List<Image> x = Image.findByUserId(getId());
        return x;
    }

}

