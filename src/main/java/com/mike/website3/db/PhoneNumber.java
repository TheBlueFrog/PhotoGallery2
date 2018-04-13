package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.Website;
import com.mike.website3.db.repo.PhoneNumberRepo;
import org.json.JSONObject;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="user_phone_numbers")
public class PhoneNumber implements Serializable {

    protected static final String table = "user_phone_numbers";

    private static final long serialVersionUID = -6251631027348261111L;

    @Id
    @Column(name = "id")                        private String id;

    @Column(name = "users_id")                  private String userId;
    @Column(name = "phone_number")              private String phoneNumber = "";

    public String getId() { return id; }
    public String getUserId() { return userId; }
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber.replace("'", "");
    }

    protected PhoneNumber () { }

    public PhoneNumber(User user, String phoneNumber) {
        id = UUID.randomUUID().toString();
        userId = user.getUsername();
        setPhoneNumber(phoneNumber);
    }

    public PhoneNumber(User user, JSONObject j) {
        id = j.has("id") ? j.getString("id") : UUID.randomUUID().toString();

        userId = j.has("user_id") ? j.getString("user_id") : user.getUsername();
        assert user.getUsername().equals(userId);

        setPhoneNumber(j.getString("phoneNumber"));
    }

    public JSONObject toJSON() {
        JSONObject j = new JSONObject();
        j.put("id", id);
        j.put("phoneNumber", getPhoneNumber());
        return j;
    }

    @Override
    public String toString() {
        return String.format("%s", this.getPhoneNumber());
    }

    public void save() {
        getRepo().save(this);
    }

    public void delete() {
        getRepo().delete(this);
    }

    private static PhoneNumberRepo getRepo() {
        return Website.getRepoOwner().getPhoneNumberRepo();
    }

    public static List<PhoneNumber> findByUserId(String username) {
        return getRepo().findByUserId(username);

    }
}
