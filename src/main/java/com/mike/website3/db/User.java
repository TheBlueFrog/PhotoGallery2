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
import com.mike.website3.pages.BaseController;
import com.mike.website3.util.UnsupportedZipCode;

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

import static com.mike.website3.pages.BaseController.getBasicData;

/**
 * class wrapped around the database users table
 */
@Entity
@Table(name="users")
public class User implements Serializable {

    private static final String TAG = User.class.getSimpleName();
    private static final long serialVersionUID = 8100551514802474132L;

    @Id
    @Column(name = "username")                  private String username;      // UUID

    @Column(name = "enabled", columnDefinition = "boolean default true") private boolean enabled = true;

    @Column(name = "has_logged_in", columnDefinition = "boolean default false")
    private boolean hasLoggedIn = false;

    @Column(name = "join_timestamp")            private Timestamp joinTimestamp;

    protected User() { }

    public String getUsername() {
        return username;
    }
    public String getId() {
        return username;
    }
    public boolean getEnabled() { return enabled; }
    public boolean getHasLoggedIn() { return hasLoggedIn; }
    public Timestamp getJoinTimestamp() {
        return joinTimestamp;
    }

    private void setUsername(String username) {
        this.username = username;
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

    public static List<String> findAllUsernames() {
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
        Util.sortByUserName(x);
        return x;
    }


    public void save () {
        getRepo().save(this);
    }

    public static User findByUsername(String username) {
        return getRepo().findByUsername(username);
    }
    public static User findByUserId(String username) {
        return getRepo().findByUsername(username);
    }
    public static User findById(String username) {
        return getRepo().findByUsername(username);
    }

    public static List<User> findByEnabledOrderByName(boolean enabled) {
        return Util.sortByUserName(getRepo().findByEnabled(true));
    }

    public static void dropOldColumns() {
    }

    public String getSalt(String loginName) {
        LoginName ln = LoginName.findByLoginName(loginName).get(0);
        return ln.getSalt();
    }
    private void setSalt(String loginName, String salt) {
        LoginName ln = LoginName.findByLoginName(loginName).get(0);
        ln.setSalt(salt);
        ln.save();
    }

    private String getPwHash(String loginName) {
        LoginName ln = LoginName.findByLoginName(loginName).get(0);
        return ln.getPwHash();
    }
    public void setPwHash(String loginName, String hash) {
        LoginName ln = LoginName.findByLoginName(loginName).get(0);
        ln.setPwHash(hash);
        ln.save();
    }

    public boolean passwordHasBeenReset(String loginName) {
        return LoginName.hasPasswordBeenReset(loginName);
    }

    public boolean isPasswordResetCode(String loginName, String resetCode) {
        return (getPwHash(loginName).length() == Constants.Code.RESET_PW_LENGTH) &&
                getPwHash(loginName).equals(resetCode);
    }

    public String getResetCode(String loginName) {
        String s = getPwHash(loginName);
        if (s.length() == Constants.Code.RESET_PW_LENGTH)
            return s;
        else
            return "";
    }

    // called by reset password to put a new PW in
    public void hashPassword(String loginname, String newPassword) throws NoSuchAlgorithmException {
        String salt = genSalt();
        String hashedPassword = secureHash(newPassword, salt);
        setHashedPassword(loginname, salt, hashedPassword);
    }

    public void setHashedPassword(String loginname, String salt, String hashedPassword) {
        setSalt(loginname, salt);
        setPwHash(loginname, hashedPassword);
//        update();
    }

    public void setAuthentication(String loginname, String salt, String hashedPassword) {
        setSalt(loginname, salt);
        setPwHash(loginname, hashedPassword);
    }

    /**
     * generate a random 5 digit number and put into the pw hash field,
     * we will email this to the user and they have to enter it in
     * the reset pw page
     */
    public void resetPassword(String loginname) {

        int i = MySystemState.getInstance().getRandom().nextInt(100000);
        setPwHash(loginname, String.format("%05d", i));
        save();
    }

    public User(String username,
                String password,
                String role,
                String firstName,
                String lastName,
                String street,
                String city,
                String state,
                String zip)
            throws InvalidAddressException,
            UserExistsException,
            UserDirectoryExistsException,
            InvalidLoginNameException,
            NoSuchAlgorithmException,
            IllegalArgumentException
    {
        setUsername(UUID.randomUUID().toString());
        joinTimestamp = MySystemState.getInstance().nowTimestamp();

        String loginName = username;
        boolean validLogin = LoginName.validLoginName(loginName);
        if ( ! validLogin) {
            throw new InvalidLoginNameException("Login name contains invalid characters: " + loginName);
        }

        if (LoginName.findByLoginName(loginName).size() > 0)
            throw new UserExistsException(String.format("Login name %s already exists.", loginName));
        if (EmailAddress.findByEmail(loginName).size() > 0)
            throw new UserExistsException(String.format("Login name %s already exists as an email address.", loginName));

        Address address = setupAddress(getId(), Address.Usage.Default, firstName, lastName, street, city, state, zip);

        // if we fail out after this we have dead directories
        setupUserDirectory();

        /// the pw etc are in another table, do that now
        new LoginName(getId(), loginName)
                .save();

        String salt = genSalt();
        String hashedPassword = secureHash(password, salt);
        setAuthentication(loginName, salt, hashedPassword);

        this.save();

        SystemEvent.save(this, "CreateUser");

        // user now exists do other DB stuff

        setupRoles(getId(), role);

        address.save();

        setupAddress(getId(), Address.Usage.Delivery, firstName, lastName, street, city, state, zip)
                .save();

        new EmailAddress(this, loginName)
                .save();
    }

    private Address setupAddress(String userId,
                                 Address.Usage usage,
                                 String firstName,
                                 String lastName,
                                 String street,
                                 String city,
                                 String state,
                                 String zip)
            throws InvalidAddressException {

        Address address = new Address(userId);
        address.setFirstName(firstName);
        address.setLastName(lastName);
        address.setStreet(street);
        address.setCity(city);
        address.setState(state);
        address.setZip(zip);

        address.setUsage(usage);
        address.geoCodeAddress();

        if ( ! address.hasValidGeoLocation()) {
            throw new InvalidAddressException("Cannot geo-code address");
        }

        address.setUserId(userId);

        return address;
    }

    private void setupRoles(String id, String roleS) {
        UserRole.Role role = UserRole.Role.Eater;
        if (roleS != null) {
            role = UserRole.Role.valueOf(roleS);
        }

        UserRole.add(id, UserRole.Role.AccountPending); // everyone

        UserRole.add(id, role);

        switch (role) {
            case Eater:
                // nothing else
                break;
            case Seeder:
                // all seeders are eaters too
                UserRole.add(id, UserRole.Role.Eater);
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

        String username = LoginName.getUsernameFromLoginName(loginName);
        if (username == null) {
            // no such login name
            throw new NoSuchLoginName(loginName);
        }

        User user = findByUsername(username);

        if (user == null)
            throw new NoSuchUserId(username);

        if ( ! user.enabled)
            throw new AccountIsDisabled(user);

        if (user.passwordHasBeenReset(loginName)) {
            // password has been reset, force it to be changed
            throw new PasswordResetException ("Password has been reset.");
        }

        String hashedPassword = secureHash(password, user.getSalt(loginName));
        if (hashedPassword.equals(user.getPwHash(loginName)))
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


    public UserImage getMainImage() {
        List<UserImage> v = UserImage.findAllByUserIdAndUsage(this.getUsername(), "Main");
        if (v.size() > 0) {
            int i = MySystemState.getInstance().getRandom().nextInt(v.size());
            return v.get(i);
        }
        v = UserImage.findAllByUserId(this.getUsername());
        if (v.size() > 0) {
            int i = MySystemState.getInstance().getRandom().nextInt(v.size());
            return v.get(i);
        }
        return null;
    }
    public int getNumImages() {
        return UserImage.findAllByUserId(this.getUsername()).size();
    }
    public List<UserImage> getImages() {

        List<UserImage> list = UserImage.findAllByUserId(this.getUsername());
        return list;
    }
    public UserImage getImage(String tag) {
        List<UserImage> images = getImages();
        if (images.size() > 0) {
            for(UserImage image : images) {
                if (image.getUsage().equals(tag))
                    return image;
            }

//            return images.get(0);
        }
        return null;
    }

    public List<String> getStoredImages() {
        List<String> paths = new ArrayList<>();
        Website.getStorageService().loadAll(this).forEach(path -> {
            String s = path.toFile().getName();
            paths.add(path.toFile().getName());
        });
        return paths;
    }


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
        return getAddress().toString();
    }
    public String getTitle() {
        return getAddress().getFirstName() + " " + getAddress().getLastName();
    }

    public String getPublicHomePageURL() {
        if (StringData.findByUserIdAndKey(getId(), "hasprofile") == null) {
            return "#";
        }
        return String.format("/mini-website?userId=%s", getUsername());
    }

    public List<Address> getAddresses() {
        return Address.findNewestByUserIdOrderByUsageDesc(this.getUsername());
    }

    /** return the primary address for the use */
    public Address getAddress() {
        List<Address> addresses = Address.findByUserIdAndUsageOrderByUsageDesc(
                this.getUsername(),
                Address.Usage.Default);

        if (addresses.size() == 0) {
            return buildBadAddress();
        }

        return addresses.get(0);
    }

    public boolean validAddress() {
        List<Address> addresses = Address.findByUserIdAndUsageOrderByUsageDesc(
                this.getUsername(),
                Address.Usage.Default);

        if (addresses.size() == 0) {
            return false;
        }

        if ( ! validAddress(Address.Usage.Delivery))
            return false;
        if ( ! validAddress(Address.Usage.Pickup))
            return false;
        if ( ! validAddress(Address.Usage.Stop))
            return false;

        return true;
    }

    private boolean validAddress(Address.Usage usage) {
        List<Address> addresses = Address.findByUserIdAndUsageOrderByUsageDesc(
                this.getUsername(),
                Address.Usage.Delivery);
        return true;
    }

    public Address findRightAddress(Address.Usage type) {

        try {
            return findRightAddress(getAddresses(), type);
        } catch (InvalidAddressException e) {
            return buildBadAddress();
        }
    }

    private Address buildBadAddress() {
        Address address = new Address(getId());
        address.setFirstName("Missing Address Record");
        address.setLastName("Missing Address Record");
        return address;
    }

    private Address findRightAddress(List<Address> addresses, Address.Usage type) throws InvalidAddressException {

        if (addresses.size() < 1) {
            throw new InvalidAddressException(String.format("User %s has no address records.", getId()));
        }

        // look for an exact match on the usage field
        for (Address address : addresses)
            if (address.getUsage().equals(type))
                return address;

        // find the default address
        for (Address address : addresses)
            if (address.getUsage().equals(Address.Usage.Default))
                return address;

        // punt
        return addresses.get(0);
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
     * remove all images whose ID starts with id
     * this does not change the contents of the user image
     * dirctory, only the database record of the image
     *
     * @param id
     */
    public void removeMatchingImages(String id) {
        UserImage.findAllByUserId(getUsername())
                .forEach(userImage -> {
                    if (userImage.getId().startsWith(id))
                        userImage.delete();
                });
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

    // explicit match
    public boolean hasAddress(Address.Usage tag) {
        for(Address address : getAddresses())
            if (address.getUsage().equals(tag))
                return true;
        return false;
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

        Map<User, Address> addressCache = new HashMap<>();

        List<User> users = User.findAll().stream()
                .filter(user1 -> selector.select(user1))
                .collect(Collectors.toList());

        return sorter.sort(users);
    }

    public String getStreetAddress(Address.Usage type) {
        return findRightAddress(type).getStreetAddress();
    }

    public Location getLocation(Address.Usage type) {
        return findRightAddress(type).getLocation();
    }

    public String getName() {
        return getName(Address.Usage.Default);
    }

    public String getName(String usage) {
        return getName(Address.Usage.valueOf(usage));
    }
    public String getName(Address.Usage usage) {

        Address address = null;
        try {
            address = findRightAddress(getAddresses(), usage);
            String name = address.getName();
            if (name.length() < 2)
                name = String.format("%8.8s...", getId());
            return name;
        } catch (InvalidAddressException e) {
            return e.getMessage();
        }
    }

    public Address getAddress(String usage) {
        return getAddress(Address.Usage.valueOf(usage));
    }

    public Address getAddress(Address.Usage tag) {
        return findRightAddress(tag);
    }

    public String getUsernameShort() {
        String s = getId();
        return s.length() > 8 ? s.substring(0, 8) : s;
    }
    public String getIdShort() {
        String s = getId();
        return s.length() > 8 ? s.substring(0, 8) : s;
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
                                           Util::sortByComapanyName);
        return x;
    }

    static public List<User> findByRoles(String roles) {
        String[] x = roles.split(" ");
        List<UserRole.Role> y = Arrays.stream(x).map(s -> UserRole.Role.valueOf(s)).collect(Collectors.toList());
        List<UserRole> z = UserRole.findByRoleIn(y);
        Set<String> userIds = z.stream().map(r -> r.getUserId()).collect(Collectors.toSet());
        List<User> users = userIds.stream().map(userId -> User.findById(userId)).collect(Collectors.toList());
        Util.sortByComapanyName(users);
        return users;
    }
}

