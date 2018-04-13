package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.util.Util;
import com.mike.website3.MySystemState;
import com.mike.website3.Website;
import com.mike.website3.db.repo.UserRepo;
import com.mike.website3.db.repo.UserRoleRepo;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.*;

import static com.mike.website3.db.UserRole.Role.*;

/**
 * Created by mike on 11/6/2016.
 *
 * database CRUD class to hold user roles (permissions)
 *
 * https://github.com/TheBlueFrog/milkrunDocs/blob/master/User%20Roles.md

 */

@Entity
@Table(name="user_roles")
public class UserRole implements Serializable {

    private static final long serialVersionUID = -4835340789636598054L;
    private static final String TAG = UserRepo.class.getSimpleName();

    public static List<UserRole> findAllByUserIdOrderByTimestampAsc(String userId) {
        List<UserRole> x = getRepo().findAllByUserIdOrderByTimestampAsc(userId);
        return x;
    }

    public static List<UserRole> findByRoleIn(List<Role> y) {
        List<UserRole> x = getRepo().findByRole2In(y);
        return x;
    }

    public static void removeAll(String userId) {
        getRepo().findByUserId(userId).forEach(role -> role.delete());
    }

    public static enum Role  {
        Admin,                  // a lesser god, can make users *Admins
        // these are used to control which public UI is presented

        AccountPending,         // new accounts are created in this state, they may have
                                // this removed automatically or manually by an Admin
        User,

        InDevelopment,          // enable code still in-dev
    };

    private static List<Role> allAdminsRoles = Arrays.asList(
            new UserRole.Role[] {
                    Admin,
            });

    static public List<Role>  getAllAdminsRoles() { return allAdminsRoles; }

    static private List<Role> singletonRoles = new ArrayList<>();
    static {
    }

    @Id
    @Column(name = "timestamp")                 private Timestamp timestamp;
    @Column(name = "users_id")                  private String userId;
    @Column(name = "role")                      private String role;  // dead

    @Column(name = "role2", columnDefinition = "text default 'AccountPending'")
    @Enumerated(EnumType.STRING)
    private Role role2 = Role.AccountPending;

    // should convert the role column to an enum
    // backcompat is tricky

//    @Column(name = "rating", columnDefinition = "text default 'UNRATED'")
//    @Enumerated(EnumType.STRING)                private Rating rating = Rating.UNRATED;
//
//    public Rating getRating () { return rating; }
//    public void setRating(Rating rating) {
//        this.rating = rating;
//    }

    public Timestamp getTimestamp() { return timestamp; }
    public String getUserId() { return userId; }
    public Role getRole() {
        return role2;
    }

    public String getTimestampAsString() { return Util.timestamp2String(timestamp); }

    // no setters, jsut delete the record create a new one

    protected UserRole() { }

    public UserRole(String userId, Role role) {

        timestamp = new Timestamp(MySystemState.getInstance().now());
        this.userId = userId;
        this.role2 = role;
    }

    private void removeAllOthers(Role role) {

        if (isSingleton(role))
            findByRole(role).forEach(r -> {
                r.delete();
            });
    }

    public boolean isSingleton(Role role) {
        return  singletonRoles.contains(role);
    }

    @Override
    public String toString() {
        return String.format("%s, %s",
                this.getUserId(),
                this.getRole());
    }

    static private UserRoleRepo getRepo() {
        return Website.getRepoOwner().getUserRoleRepo();
    }

    public void save() {
        // some roles can only be assigned to one person,
        // this makes it hard for two people to close a run at the
        // same time due to mis-communication etc.

        if (isSingleton(role2)) {
            removeAllOthers(role2);
        }

        getRepo().save(this);

        SystemEvent.save(String.format(
                "%s given to %s",
                role2.toString(),
                userId
        ));
    }
    public void delete() {
        getRepo().delete(this);

        SystemEvent.save(String.format(
                "%s removed from %s",
                this.role2.toString(),
                this.getUserId()
        ));
    }

    public static List<UserRole> findAllByUserId(String userId) {
        return getRepo().findByUserId(userId);
    }

    public static List<UserRole> findByRole(Role role) {
        return getRepo().findByRole2(role);
    }
    public static List<UserRole> findByRole(String role) {
        return findByRole(Role.valueOf(role));
    }

    public static UserRole findFirstByUserIdAndRoleOrderByTimestampDesc(String userId, Role role) {
        UserRole x = getRepo().findFirstByUserIdAndRole2OrderByTimestampDesc(userId, role);
        return x;
    }
    public static UserRole findFirstByUserIdAndRoleOrderByTimestampDesc(String userId, String role) {
        UserRole x = getRepo().findFirstByUserIdAndRole2OrderByTimestampDesc(userId, Role.valueOf(role));
        return x;
    }

    static public boolean does(String userId, String role) {
        return does(userId, Role.valueOf(role));
    }
    private static boolean does(String userId, List<Role> roles) {
        for(Role r : roles)
            if (does(userId, r))
                return true;
        return false;
    }

    /**
     * @param userId
     * @param role role we're asking about
     * @return true if the user does the role, this allows inheritance
     * of Admins
     */
    public static boolean does(String userId, Role role) {
        List<UserRole> list = getRepo().findByUserId(userId);
        for(UserRole r : list)
            if (r.role2.equals(role))
                return true;

        // if they are asking about a non-singleton subAdmin priv that doesn't
        // match but they have full Admin that's cool
        if (role.toString().endsWith("Admin")
                && (role.toString().length() > "Admin".length())
                && ( ! singletonRoles.contains(role))) {
            for(UserRole r : list)
                if (r.role2.equals(Role.Admin))
                    return true;
        }
        return false;
    }

    static public boolean is(String userId, String role) {
        return is(userId, Role.valueOf(role));
    }
    /**
     *
     * @param username
     * @param role
     * @return true is the user explicitly has the role, no
     * inheritance, useful for exclusion
     */
    public static boolean is(String username, Role role) {
        List<UserRole> list = getRepo().findByUserId(username);
        for(UserRole r : list)
            if (r.role2.equals(role))
                return true;

        return false;
    }

    static public boolean isAnAdmin(String userId) {
        return does(userId, allAdminsRoles);
    }

    public static void add(String username, Role role) {
        for (UserRole r : UserRole.findAllByUserId(username)) {
            if (r.role2.equals(role))
                return; // already does
        }

        new UserRole(username, role).save();
    }

    public static void remove(String username, Role role) {
        for (UserRole r : UserRole.findAllByUserId(username)) {
            if (r.role2.equals(role)) {
                r.delete();
            }
        }
    }

    // the UI is attempting to change a permission, make sure 'the rules'
    // allow that.  Because in HTML a checkbox is not sent if it's off
    // that's coming in as an off, so we need to make sure the UI isn't
    // showing more than it should
    public static void changeRole(User sessionUser, User targetUser, boolean on, UserRole.Role role) {
        switch(role) {
            case Admin:
                if (UserRole.is(sessionUser.getId(), Admin))    // only by Admin
                    change(targetUser, role, on);
                return;

            default:
                if (UserRole.isAnAdmin(sessionUser.getId()))        // the rest by any Admin
                    change(targetUser, role, on);
                return;
        }
    }

    private static void change(User targetUser, Role role, boolean on) {
        if (on) {
            UserRole.add(targetUser.getId(), role);
        } else {
            UserRole.remove(targetUser.getId(), role);
        }
    }

}
