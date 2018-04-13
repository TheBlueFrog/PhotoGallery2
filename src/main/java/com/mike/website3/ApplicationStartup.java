package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.db.SystemEvent;
import com.mike.website3.tools.TakeDBSnapshot;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

/**
 * Created by mike on 2/7/2017.
 */

@Component
public class ApplicationStartup
        implements
        ApplicationListener<ApplicationReadyEvent>
//        ApplicationListener<ApplicationPreparedEvent>
{

    @EventListener(ContextRefreshedEvent.class)
    void contextRefreshedEvent() {
        SystemEvent.save("Server", "ContextRefreshedEvent");

        SystemEvent.save(TakeDBSnapshot.snap("Startup snapshot, pre-housekeeping"));

        Website.doHousekeeping();
    }

    /**
     * This event is executed as late as conceivably possible to indicate that
     * the application is ready to service requests.
     */
    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        SystemEvent.save("Server", "ApplicationReadyEvent");

        Website.getInstance().createPeriodicProcesses();

        Website.getInstance().preStart();
    }
}