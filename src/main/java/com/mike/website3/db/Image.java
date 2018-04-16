package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.MySystemState;
import com.mike.website3.WebController;
import com.mike.website3.Website;
import com.mike.website3.db.repo.ImageRepo;

import javax.persistence.*;
import java.io.File;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="images")
public class Image implements Serializable {

    static public enum Visibility {
        Public,
        Private,
    };
    static public enum Type {
        Unknown,
        JPG,
        M4V,
        MP4,
    };

    @Id
    @Column(name = "id")                        private String id;

    @Column(name = "timestamp")                 private Timestamp timestamp;
    @Column(name = "user_id")                   private String userId;
    @Column(name = "caption")                   private String caption = "";
    @Column(name = "filename")                  private String filename = "";

    @Enumerated(EnumType.STRING)
    private Type type = Type.JPG;

    @Enumerated(EnumType.STRING)
    private Visibility visibility = Visibility.Public;

    public String getId() { return id; }

    public Timestamp getTimestamp() {
        return timestamp;
    }
    public String getUserId() { return userId; }
    private void setUsername(String username) {
        this.userId = username;
    }

    public String getCaption() {
        return caption;
    }
    public void setCaption(String caption) {
        this.caption = caption;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
    public String getFilename() {
        return filename;
    }

    public Type getType() {
        return type;
    }

    public boolean isPublic() {
        return visibility.equals(Visibility.Public);
    }

    public void setPublic(boolean b) {
        if (b)
            visibility = Visibility.Public;
        else
            visibility = Visibility.Private;
    }

    /**
     *
     * @return the actual path to the image
     */
    public String getPath() {
//        File f = new File(new File(new File(Website.getUserDir(), this.userId),"images"), this.filename);
//        return f.getPath();
        return String.format("/users/%s/images/%s", getUserId(), filename);
    }

    protected Image() { }

    public Image(User user, String caption, String filename) {
        id = UUID.randomUUID().toString();
        timestamp = MySystemState.getInstance().nowTimestamp();
        setUsername(user.getUsername());
        setCaption(caption);
        setFilename(filename);

        int i = filename.lastIndexOf(".");
        String t = filename.toLowerCase().substring(i+1, filename.length());
        switch (t) {
            case "jpg":
                type = Type.JPG;
                break;
            case "m4v":
                type = Type.M4V;
                break;
            case "mp4":
                type = Type.MP4;
                break;
            default:
                type = Type.Unknown;
                break;
        }
    }

    @Override
    public String toString() {
        return String.format("%s",
                this.getId().substring(0, 8),
                this.getFilename());
    }

    private static ImageRepo getRepo() {
        return Website.getRepoOwner().getImageRepo();
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public static Image findById(String id) {
        return getRepo().findById(id);
    }

    public static List<Image> findByUserId(String userId) {
        return getRepo().findByUserId(userId);
    }

    public static Image findByUserIdAndFilename(String userId, String name) {
        Image x = getRepo().findByUserIdAndFilename(userId, name);
        return x;
    }

    public static List<Image> findByVisibility(Visibility visibility) {
        List<Image> x = getRepo().findByVisibility(visibility);
        return x;
    }

    public static List<Image> findByUserIdOrderByTimestampDesc(String id) {
        List<Image> x = getRepo().findByUserIdOrderByTimestampDesc(id);
        return x;
    }

    public static List<Image> findByVisibilityOrderByTimestampDesc(Visibility visibility) {
        List<Image> x = getRepo().findByVisibilityOrderByTimestampDesc(visibility);
        return x;
    }

    public static List<Image> findByVisibilityAndTypeOrderByTimestampDesc(Visibility visibility, String type) {
        List<Image> x = findByVisibilityAndTypeOrderByTimestampDesc(visibility, Type.valueOf(type));
        return x;
    }
    public static List<Image> findByVisibilityAndTypeOrderByTimestampDesc(Visibility visibility, Type type) {
        List<Image> x = getRepo().findByVisibilityAndTypeOrderByTimestampDesc(visibility, type);
        return x;
    }

    public static List<Image> findByUserIdAndTypeOrderByTimestampDesc(String userId, String type) {
        List<Image> x = findByUserIdAndTypeOrderByTimestampDesc(userId, Type.valueOf(type));
        return x;
    }
    public static List<Image> findByUserIdAndTypeOrderByTimestampDesc(String userId, Type type) {
        List<Image> x = getRepo().findByUserIdAndTypeOrderByTimestampDesc(userId, type);
        return x;
    }

}
