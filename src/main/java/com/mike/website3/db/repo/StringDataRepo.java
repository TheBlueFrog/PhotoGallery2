package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.StringData;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;


public interface StringDataRepo extends CrudRepository<StringData, String> {

    List<StringData> findByUserId(String id);
    Optional<StringData> findByUserIdAndKey(String id, String key);

    StringData findById(String id);

    List<StringData> findByUserIdOrderByKey(String key);
}
