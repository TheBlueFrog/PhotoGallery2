package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface ImageRepo extends CrudRepository<Image, String> {

    Image findById(String id);
    List<Image> findAllByUsername(String username);

    Image findByFilename(String filename);
}
