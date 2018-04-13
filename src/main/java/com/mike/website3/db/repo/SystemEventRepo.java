package com.mike.website3.db.repo;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.SystemEvent;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.sql.Timestamp;
import java.util.List;


public interface SystemEventRepo extends CrudRepository<SystemEvent, Timestamp> {

    List<SystemEvent> findByUsername(String username);
    List<SystemEvent> findByEvent(String event);

    List<SystemEvent> findAll();

    List<SystemEvent> findByEventOrderByTimestampAsc(String event);

    List<SystemEvent> findByEventAndUsernameOrderByTimestampDesc(String event, String username);

    List<SystemEvent> findByUsernameOrderByTimestampDesc(String username);

    List<SystemEvent> findByOrderByTimestampAsc();

    List<SystemEvent> findTop200ByOrderByTimestampDesc();


    // this does work
    @Query("SELECT se FROM SystemEvent se WHERE se.timestamp > :after ORDER BY timestamp DESC")
    public List<SystemEvent> findAfterOrderDesc(@Param("after") Timestamp after);

    List<SystemEvent> findByEventContainingOrderByTimestampDesc(String s);
    List<SystemEvent> findTop200ByEventContainingOrderByTimestampDesc(String s);

    List<SystemEvent> findByEventOrderByTimestampDesc(String event);
}
