package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.PhoneNumber;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface PhoneNumberRepo extends CrudRepository<PhoneNumber, Integer> {

    List<PhoneNumber> findByUserId(String userN);
}
