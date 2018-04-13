package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.EmailAddress;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface EmailAddressRepo extends CrudRepository<EmailAddress, Integer> {

    List<EmailAddress> findByUserId(String username);

    EmailAddress findById(String id);

    List<EmailAddress> findByEmail(String email);
}
