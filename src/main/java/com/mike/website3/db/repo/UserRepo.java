package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface UserRepo extends CrudRepository<User, String> {

    List<User> findAll();

    User findByUserId(String userId);

    List<User> findByEnabled(boolean enabled);

    User findByLoginName(String loginName);
}
