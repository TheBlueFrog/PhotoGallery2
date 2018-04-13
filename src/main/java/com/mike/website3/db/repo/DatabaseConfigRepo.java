package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.DatabaseConfig;
import org.springframework.data.repository.CrudRepository;

import java.sql.Timestamp;


public interface DatabaseConfigRepo extends CrudRepository<DatabaseConfig, Timestamp> {

    DatabaseConfig findByDefect(String defect);
}
