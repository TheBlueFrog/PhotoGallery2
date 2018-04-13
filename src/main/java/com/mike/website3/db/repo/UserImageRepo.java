package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.UserImage;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface UserImageRepo extends CrudRepository<UserImage, String> {

    UserImage findById(String id);

    List<UserImage> findByUserId(String userId);
    List<UserImage> findByUserIdAndUsage(String userId, String usage);
}
