package com.mike.website3.storage;

import com.mike.website3.Constants;
import com.mike.website3.Website;
import com.mike.website3.db.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class FileSystemStorageService implements StorageService {

    private final Path rootLocation;

    @Autowired
    public FileSystemStorageService(StorageProperties properties) {
        this.rootLocation = Website.uploadDir.toPath(); // Paths.get(properties.getLocation());
    }

    @Override
    public void store(User user, MultipartFile file) {
        try {
            if (file.isEmpty()) {
                throw new StorageException("Did not store empty file " + file.getOriginalFilename());
            }

            File f = new File(Website.getUserDir(user.getUsername()),"images");
            Path p = f.toPath();
            Files.copy(file.getInputStream(),
                    p.resolve(file.getOriginalFilename()));

//            // update db to record this image
//            UserImage image = new UserImage(user, "", file.getOriginalFilename(), "Main");
//            image.save();

        } catch (Exception e) {
            throw new StorageException("Failed to store file " + file.getOriginalFilename(), e);
        }
    }

    @Override
    public List<Path> loadAll(User user) {
        try {
            List<Path> files = new ArrayList<>();

            File f = new File(Website.getUserDir(user.getUsername()),"images");
            Path p = f.toPath();
            if (f.exists()) {
                Files.walk(p, 1)
                        .filter(path -> !path.equals(p))
                        .map(path -> p.relativize(path))
                        .forEach(path -> files.add(path));

                Collections.sort(files, new Comparator<Path>() {
                    @Override
                    public int compare(Path o1, Path o2) {
                        return o1.toFile().getName().compareTo(o2.toFile().getName());
                    }
                });
            }

            return files;

        } catch (IOException e) {
            throw new StorageException("Failed to read stored files", e);
        }
    }

    @Override
    public Path load(User user, String filename) {
        File f = new File(Website.getUserDir(user.getUsername()),"images");
        Path p = f.toPath();
        return p.resolve(filename);
    }

    @Override
    public Resource loadAsResource(User user, String filename) {
        try {
            Path file = load(user, filename);
            Resource resource = new UrlResource(file.toUri());
            if(resource.exists() || resource.isReadable()) {
                return resource;
            }
            else {
                throw new StorageFileNotFoundException("Could not read file: " + filename);

            }
        } catch (MalformedURLException e) {
            throw new StorageFileNotFoundException("Could not read file: " + filename, e);
        }
    }

    @Override
    public void deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile());
    }

    @Override
    public void init() {
        try {
            Files.createDirectory(rootLocation);
        } catch (IOException e) {
            throw new StorageException("Could not initialize storage", e);
        }
    }
}
