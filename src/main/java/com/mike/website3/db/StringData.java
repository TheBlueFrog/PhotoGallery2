package com.mike.website3.db;

import com.mike.util.DuplicateKeyException;
import com.mike.util.Log;
import com.mike.website3.Website;
import com.mike.website3.db.repo.StringDataRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.UUID;


/*
    this class wraps a table that holds named string data, there
    two types of names, system names which have an empty user_id
    and named strings which are specific to a user.

    the system names are for system stuff, like the company name

    the per-user names are primarily used for populating the
    per-use mini-website FTL template slots

     update string_data set value2 = value;
 */
@Entity
@Table(name="string_data")
public class StringData implements Serializable {
    private static final long serialVersionUID = 961453838595302235L;
    private static final String TAG = StringData.class.getSimpleName();

    @Id
    @Column(name = "id")            private String id;

    @Column(name = "user_id")       private String userId;
    @Column(name = "key")           private String key;
    @Column(name = "value")         private String value;       // dead
    @Column(name = "value2", columnDefinition="text default ''")   private String value2 = "";

    public String getId() {
        return id;
    }
    public String getKey() {
        return key;
    }
    public String getValue() {
        return value2;
    }
    public void setValue(String value) {
        this.value2 = value;
    }

    protected StringData() {
    }

    public StringData(String userId, String key, String value) throws DuplicateKeyException {
        if (findByUserIdAndKey(userId, key) != null)
            throw new DuplicateKeyException("The key " + key + " already exists.");

        this.id = UUID.randomUUID().toString();
        this.userId = userId;
        this.key = key;
        this.value2 = value != null ? value : "";
    }

    // we allow userId to be "", which is taken to mean that
    // it applies to all users, e.g. the system
    public StringData(String key, String value) throws DuplicateKeyException {
        if (findByUserIdAndKey("", key) != null)
            throw new DuplicateKeyException("The key " + key + " already exists.");

        this.id = UUID.randomUUID().toString();
        this.userId = "";
        this.key = key;
        this.value2 = value != null ? value : "";
    }

    static private StringDataRepo getRepo() {
        return Website.getRepoOwner().getMiniWebsiteDataRepo();
    }

    public void save() {
        getRepo().save(this);
    }

    public void delete() {
        getRepo().delete(this);
    }

    public static List<StringData> findByUserId(String id) {
        List<StringData> x = getRepo().findByUserId(id);
        return x;
    }

    public static StringData findByUserIdAndKey(String id, String key) {
        Optional<StringData> x = getRepo().findByUserIdAndKey(id, key);
        if (x.isPresent())
            return x.get();
        else
            return null;
    }

    public static Optional<StringData> findByUserIdAndKey2(String id, String key) {
        Optional<StringData> x = getRepo().findByUserIdAndKey(id, key);
        return x;
//        if (x == null)
//            return Optional.empty();
//        else
//            return Optional.of(x);
    }

    public static StringData findById(String id) {
        StringData x = getRepo().findById(id);
        return x;
    }

    public static List<StringData> findByUserIdOrderByKey(String userId) {
        List<StringData> x = getRepo().findByUserIdOrderByKey(userId);

        if (x.size() == 0)
            try {
                prePopulateKeys(userId);
                x = getRepo().findByUserIdOrderByKey(userId);
            } catch (DuplicateKeyException e) {
                Log.e(TAG, e);
            }

        return x;
    }

    private static String[] miniWebsiteKeys = new String[] {
        "Title",
        "Link",
        "Paragraph1",
        "Paragraph2",
        "Address",
        "Contact",
        "Practices",
        "Bio",
        "Facebook",
        "Instagram",
        "Twitter",
        "hasprofile",
        "Name",
        "Services"
    };

    private static void prePopulateKeys(String userId) throws DuplicateKeyException {
        for(String s : miniWebsiteKeys) {
            StringData sd = new StringData(userId, s, "");
            sd.save();
        }
    }

    // setup various random system parameters that are required

}


