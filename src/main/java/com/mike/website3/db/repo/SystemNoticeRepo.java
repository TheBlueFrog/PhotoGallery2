package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.SystemNotice;
import org.springframework.data.repository.CrudRepository;

import java.sql.Timestamp;
import java.util.List;


public interface SystemNoticeRepo extends CrudRepository<SystemNotice, Timestamp> {

    List<SystemNotice> findAll();

    List<SystemNotice> findByBody(String body);
}
