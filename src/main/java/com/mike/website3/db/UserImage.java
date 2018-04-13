package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.Website;
import com.mike.website3.db.repo.UserImageRepo;

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
@Table(name="user_images")
public class UserImage implements Serializable {

    private static final String table = "user_emails";
    private static final long serialVersionUID = -6522973634492875584L;


    @Id
    @Column(name = "id")                        private String id;      // UUID

    @Column(name = "caption")                   private String caption;
    @Column(name = "filename")                  private String filename;
    @Column(name = "user_id")                   private String userId;

    @Column(name = "usage")                     private String usage;   // Main etc

    public String getId() { return id; }

    public String getUserId() { return userId; }
    public String getCaption() {
        return caption;
    }
    public String getFilename() {
        return filename;
    }
    public String getUsage() {
        if (usage != null)
            return usage;
        return "";
    }

    public void setCaption(String caption) {
        this.caption = caption.replace("'", "");
    }
    private void setUserId(String userId) {
        this.userId = userId;
    }
    public void setFilename(String filename) {
        this.filename = filename.replace("'", "");
    }
    public void setUsage(String usage) {
        this.usage = usage.replace("'", "");
    }

    protected UserImage() { }

    public UserImage(User user, String caption, String filename, String usage) {
        id = UUID.randomUUID().toString();
        setUserId(user.getUsername());
        setCaption(caption);
        setFilename(filename);
        setUsage(usage);
    }

    @Override
    public String toString() {
        return String.format("{%s, %s, %s, %s}",
                this.getId().substring(0, 8),
                this.getFilename(),
                this.getUsage(),
                this.getCaption());
    }

    public String getPath () {
        return String.format("/users/%s/images/%s",
                User.findByUsername(userId).getUsername(),
                getFilename());
    }
    public String getThumbnailPath () {
        return String.format("/users/%s/images/%s-thumbnail",
                User.findByUsername(userId).getUsername(),
                getFilename());
    }


    private static UserImageRepo getRepo() {
        return Website.getRepoOwner().getUserImageRepo();
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public static List<UserImage> findAllByUserId(String userId) {
        return getRepo().findByUserId(userId);
    }

    public static UserImage findById(String imageId) {
        return getRepo().findById(imageId);
    }

    public static List<UserImage> findAllByUserIdAndUsage(String username, String usage) {
        return getRepo().findByUserIdAndUsage(username, usage);
    }

    public static void dropOldColumns() {
//        String table = "user_images";
//
//        DBTable.dropColumn(table, "users_id");
//        DBTable.dropColumn(table, "file_name");
    }
}
