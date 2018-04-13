package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.LoginName;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface LoginNameRepo extends CrudRepository<LoginName, String> {

    @Override
    List<LoginName> findAll();

    List<LoginName> findByUserId(String userId);
    LoginName findByLoginName(String loginName);

    LoginName findByUserIdAndLoginName(String userId, String loginName);

    List<LoginName> findAllByOrderByLoginName();

}
