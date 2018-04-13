package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.Address;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface AddressRepo extends CrudRepository<Address, String> {

    List<Address> findAll();

    Address findById(String id);

    List<Address> findByUserIdOrderByUsageDesc(String username);
    List<Address> findByUserIdAndUsageOrderByUsageDesc(String userId, Address.Usage usage);

    List<Address> findByUserIdOrderById(String userId);

    List<Address> findByUserIdAndUsageOrderByTimestampDesc(String userId, Address.Usage usage);

    Address findFirstByUserIdAndUsageOrderByTimestampDesc(String userId, Address.Usage usage);
}
