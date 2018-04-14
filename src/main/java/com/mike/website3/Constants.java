package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

/**
 * Created by mike on 11/3/2016.
 */
public class Constants {

    public static final String appName = "MilkRun";

    // name of the session object we store to manage our session data
    public static final String appSession = appName + "-Session";

    public static enum Errors {
        Code_1,         // Known login name didn't map to a user
        Code_2,         // No reset email address for login name
        Code_3,         // User prefs has invalid email address ID for login name
        Code_4,

    };

    /**
     * various flavors of an Item's text fields (columns)
     */
    public enum ItemText {
        Identification,
        Short1,
        Short2,
        Description,
        Note
    }

    public class Web {
        // sometime when things are quiet remove the EATER_ALPHA altogether

        public static final String INDEX_HTML = "index";

        public static final String REDIRECT_EATER_ALPHA_HOME = "redirect:/" + INDEX_HTML;
        public static final String REDIRECT_INDEX_HOME = "redirect:/" + INDEX_HTML;
        public static final String REDIRECT_PENDING_ACCOUNT = "redirect:/pending-account";

        public static final String DNS_NAME = "mikesfunstuff.com";
    }

    public class Templates {
        public static final String DIR = "templates";
    }

    public class Code {

        public static final String NoDateAvailable = "No date";

        /**
         * MilkRuns are made at some frequency, that implies that when
         * we are looking into future cart offers for items to include in
         * a given run some are "close enough" to make in this run and
         * some are not and will wait for another run.  This determines
         * that threshold.
         *
         * dead dead
         */
        public static final long DaysInFutureThreshold = 5L; // within the next 5 days

        /**
         * the system is 'local' so we pick a timezone that matches the local
         * time.  The user calendar depends on getting to the right timezone
         * to be able to display the correct set of days.
         *
         * WRONG WRONG WRONG
         */
        public static final String SYSTEM_TIME_ZONE = "America/Los_Angeles";

        public static final int MILKRUN_ISSUE_TYPE_SUPPLIER = 1;
        public static final int MILKRUN_ISSUE_TYPE_DELIVERY = 2;

        // when a password is reset instead of a hash (big long string) it will
        // contain exactly this many random digits.  When attempting to set a new
        // password the user must provide these digits, which he got via email or other ways
        public static final int RESET_PW_LENGTH = 5;
    }

}
