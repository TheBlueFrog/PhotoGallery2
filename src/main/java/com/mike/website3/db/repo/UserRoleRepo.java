package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.UserRole;
import org.springframework.data.repository.CrudRepository;

import java.sql.Timestamp;
import java.util.List;


public interface UserRoleRepo extends CrudRepository<UserRole, Timestamp> {

    List<UserRole> findByUserId(String userId);

    List<UserRole> findByRole2(UserRole.Role role2);

    List<UserRole> findAllByUserIdOrderByTimestampAsc(String userId);

    UserRole findFirstByUserIdAndRole2OrderByTimestampDesc(String userId, UserRole.Role role2);

    List<UserRole> findByRole2In(List<UserRole.Role> role2s);
}
