package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.WebController;
import com.mike.website3.Website;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.File;
import java.io.Serializable;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="images")
public class Image implements Serializable {

    @Id
    @Column(name = "id")                        private String id;

    @Column(name = "username")                  private String username;
    @Column(name = "caption")                   private String caption = "";
    @Column(name = "filename")                  private String filename = "";
    @Column(name = "visibility")                private String visibility = "Public";

    public String getId() { return id; }

    public String getUsername() { return username; }
    private void setUsername(String username) {
        this.username = username;
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

    public boolean isPublic() {
        return visibility.contains("Public");
    }

    public void setPublic(boolean b) {
        if (b) {
            if (!visibility.contains("Public"))
                visibility += " Public";
        }
        else {
            if (visibility.contains("Public"))
                visibility = visibility.replace("Public", "");
        }

        visibility = visibility.replace("  ", " ");
    }

    /**
     *
     * @return the actual path to the image
     */
    public String getPath() {
        File f = new File(new File(new File(Website.getUserDir(), this.username),"images"), this.filename);
        return f.getPath();
    }

    protected Image() { }

    public Image(User user, String caption, String filename) {
        id = UUID.randomUUID().toString();
        setUsername(user.getUsername());
        setCaption(caption);
        setFilename(filename);
    }

    @Override
    public String toString() {
        return String.format("%s",
                this.getId().substring(0, 8),
                this.getFilename());
    }

    private static com.mike.website3.db.ImageRepo getRepo() {
        return Website.getRepoOwner().getImageRepo();
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public static List<Image> findAllByUsername(String username) {
        return getRepo().findAllByUsername(username);
    }

    public static Image findById(String id) {
        return getRepo().findById(id);
    }

}
