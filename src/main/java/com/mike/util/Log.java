package com.mike.util;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */


import com.mike.website3.db.SystemEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

public class Log
{
    static Map<String, Logger> loggers = new HashMap<>();

	static public void i (String tag, String msg)
	{
	    if ( ! loggers.containsKey(tag))
	        loggers.put(tag, LoggerFactory.getLogger(tag));

		loggers.get(tag).info(msg);
	}
    static public void d (String tag, String msg)
    {
        if ( ! loggers.containsKey(tag))
            loggers.put(tag, LoggerFactory.getLogger(tag));

        loggers.get(tag).info(msg);
    }
	static public void d (Exception e)
	{
	    e("Unknown", e);

        try {
            SystemEvent.save("Unknown Exception caught: " + e.getMessage());
        }
        catch (Exception e1) {
            Log.e("Unknown", e1);
            Log.e("Unknown", "Caught an Exception trying to save Exception to SystemEvent, giving up.");
        }

    }
    static public void d (String tag, Exception e)
    {
        e(tag, e);
    }

    static public void e (String tag, String msg)
    {
        if ( ! loggers.containsKey(tag))
            loggers.put(tag, LoggerFactory.getLogger(tag));

        loggers.get(tag).error(msg);
    }
    static public void e (String tag, Exception e)
    {
        if ( ! loggers.containsKey(tag))
            loggers.put(tag, LoggerFactory.getLogger(tag));

        loggers.get(tag).error(e.toString());
    }
}
