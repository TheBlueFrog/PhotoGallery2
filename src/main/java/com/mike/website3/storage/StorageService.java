package com.mike.website3.storage;

import com.mike.website3.db.User;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.util.List;

public interface StorageService {

    void init();

    void store(User user, MultipartFile file);

    List<Path> loadAll(User user);

    Path load(User user, String filename);

    Resource loadAsResource(User user, String filename);

    void deleteAll();

}
