package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.Image;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface ImageRepo extends CrudRepository<Image, String> {

    Image findById(String id);
    List<Image> findByUserId(String userId);

    Image findByFilename(String filename);

    Image findByUserIdAndFilename(String userId, String name);

    List<Image> findByVisibility(Image.Visibility visibility);

    List<Image> findByUserIdOrderByTimestampDesc(String userId);

    List<Image> findByVisibilityOrderByTimestampDesc(Image.Visibility visibility);

    List<Image> findByVisibilityAndTypeOrderByTimestampDesc(Image.Visibility visibility, Image.Type type);
}
