package com.mike.website3;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.exceptions.InvalidAddressException;
import com.mike.exceptions.UserDirectoryExistsException;
import com.mike.exceptions.UserExistsException;
import com.mike.util.InvalidLoginNameException;
import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.util.Version;
import com.mike.website3.db.*;
import com.mike.website3.storage.StorageProperties;
import com.mike.website3.storage.StorageService;
import com.mike.website3.tools.TakeDBSnapshot;
import com.mike.website3.util.UnsupportedZipCode;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

import java.io.*;
import java.nio.file.Files;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@SpringBootApplication
@EnableConfigurationProperties(StorageProperties.class)
public class Website {

    private static final String ThisVersion = "0.1.0";
    public static final String minDBVersion = "4.0.0";  // only major version is used, minor/build ignored

    // command line switches

    // --production enforces a 1 minute wait and other stuff
    // delayStartup is implied by --production
    private static boolean isProductionRun = false;
    private static Boolean delayStartup = false;

    public static boolean getProduction() {
        return isProductionRun;
    }
    public static boolean isProduction() {
        return isProductionRun;
    }

    // --dev to enable stuff for a development environment
    private static boolean isDevEnv = false;
    public static boolean getDevEnv() {
        return isDevEnv;
    }

    // --login user pw
    private static String autoUser = "";
    private static String autoPw = "";

    // could move main over to the ApplicationStartup class

    public static void main(String[] args) {

        // we don't have the boot sequence under control, both the Postges
        // DB server and this are started but it appears that we have to
        // stall around for a bit or Postgres not ready to connect

        handleArgs(args);

        SpringApplication.run(Website.class, args);
    }

    @Bean
    CommandLineRunner init(StorageService storageService) {
        return (args) -> {
            storageService.deleteAll();
            storageService.init();

            theStorageService = storageService;
        };
    }

    private static StorageService theStorageService = null;

    public static StorageService getStorageService() {
        return theStorageService;
    }
    private static final String TAG = Website.class.getSimpleName();

    private static Website singleton = null;

    static public Website getInstance() {
        return singleton;
    }

//    private static Configuration cfg = null;
//    public static Configuration getTemplateConfiguration () {
//        return cfg;
//    }

    private static MySystemState systemState = null;

    public static File uploadDir = null;
//    public static File imageDir;

    public static File rootDir;
    // public static File configDir; dead
    public static File tmpDir;
    public static File tmpTemplateDir;
    private static File usersDir;
    private static File staticDataDir;
    private static File generatedDataDir;
    private static File toolsDir;

    public static final Version builtVersion = new Version(ThisVersion);

    protected Website() {

        if (delayStartup) {
            try {
                Log.i(TAG, "Delaying startup");
                Thread.sleep(1 * 60 * 1000);  // two minutes
            } catch (InterruptedException e) {
//            Log.d(e);
            }
        }

        File wd = new File("");
        String path = wd.getAbsolutePath();

        // where uploads will go
//        uploadDir = new File("public/uploads");
//        uploadDir.mkdir(); // create the upload directory if it doesn't exist

        rootDir = new File("..");
        // configDir = new File(rootDir, "milkrunUI/config");

        staticDataDir = new File(rootDir, "static");
        if ( ! staticDataDir.exists())
            staticDataDir.mkdir();

        usersDir = new File(staticDataDir, "users");
        if ( ! usersDir.exists()) {
            Log.e(TAG, "No users dir, exiting");
            System.exit(1);
        }

        tmpTemplateDir = new File(rootDir, "tmp");
        if ( ! tmpTemplateDir.exists())
            tmpTemplateDir.mkdir();

        systemState = new MySystemState();

        Log.i(TAG, String.format("Website version %s", builtVersion.getVersion()));
//        Log.i(TAG, String.format("DB version %s", AbstractDB.getVersion()));

        Log.i(TAG, "Website starting");

//        try {
//            /* Create and adjust the FreeMarker configuration singleton */
//            cfg = new Configuration(Configuration.VERSION_2_3_23);
//
//            FileTemplateLoader ftl1 = new FileTemplateLoader(new File(Constants.Templates.DIR));
//            FileTemplateLoader ftl2 = new FileTemplateLoader(new File("public"));
//
//            MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ftl1, ftl2 });
//            cfg.setTemplateLoader(mtl);
////            cfg.setDirectoryForTemplateLoading(new File(Constants.Templates.DIR));
//
//            cfg.setDefaultEncoding("UTF-8");
//            cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
//            cfg.setLogTemplateExceptions(false);
//        } catch (IOException e) {
//            Log.d(e);
//            System.exit(2);
//        }

        singleton = this;
    }


    public void createPeriodicProcesses() {

        SystemEvent.save("Server", "createPeriodicProcesses");

        // there are a few things we do periodically, like cycle log files or
        // check for news feed updates, e.g. not high speed stuff, just background
        // bookkeeping.  get that machinery setup and running

        Runnable hourlyTasks = () -> {
            MySystemState.getInstance().checkCPULoad();

//            // this is too aggressive until we have branches or something
//            // in the repo
//            DoGitPull.pull("Hourly refresh of milkrunFiles repo");
        };

        Runnable every12Hours = () -> {
        };

        Runnable every24Hours = () -> {
            SystemEvent.save(TakeDBSnapshot.snap("Daily snapshot"));
            SystemEvent.purge(90);
        };

        ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);

        executor.scheduleWithFixedDelay(hourlyTasks, 2, 60, TimeUnit.MINUTES);
        executor.scheduleAtFixedRate(every12Hours, 1, 12, TimeUnit.HOURS);
        executor.scheduleAtFixedRate(every24Hours, 24, 24, TimeUnit.HOURS);
    }

    /** do any stuff that needs doing before the server is handling web pages */
    static public void doHousekeeping() {

        String release = ThisVersion.substring(0, ThisVersion.lastIndexOf("."));

        DatabaseConfig s = DatabaseConfig.findByDefect("CodeBuild");
        if (s == null) {
            // new db
            s = new DatabaseConfig("CodeBuild", "0.1");
            s.save();
        }

        if ( ! s.getNote().equals(release)){
            Log.e(TAG, String.format("Database is tagged %s, must be %s", s.getNote(), release));
            System.exit(-1);
        }
        Log.d(TAG, String.format("Database matches the code, %s", release));

        SystemNotice.cleanShutdownNotices();    // remove any shutdown notices since we're back up

        MySystemState.bootstrap();  // this is ongoing and stays forever

        updateImages();
    }

    /**
     * look through the users/X/images for new images, if found
     * add to database
     */
    private static void updateImages() {
        User.findAll().forEach(user -> {
            File imageDir = new File(new File(Website.getUserDir(), user.getId()), "images");
            try {
                Files.list(imageDir.toPath())
                        .forEach(file -> {
                            String fileName = file.toFile().getName();
                            Image image = Image.findByUserIdAndFilename(user.getId(), fileName);
                            if (image == null) {
                                new Image(user, "", fileName)
                                        .save();
                            }
                        });
            }
            catch (Exception e) {
                Log.e(TAG, e);
            }
        });
    }

    static private String clean (String s) {
        String ss = s.replaceAll("[,]", "");
        return ss;
    }
    static private String clean (int i) {
        return String.format("%d", i);
    }
    static private String clean (double d) {
        return String.format("$ %.2f", d);
    }
    static private String clean (double d, boolean format) {
        return String.format("%.1f", d);
    }

    public static void preStart() {

        if (getDevEnv()) {
        }
    }

    private static void handleArgs(String[] args) {

        delayStartup = false;
        isDevEnv = false;
        for (int i = 0; i < args.length; ++i) {

            String s = args[i];

            if (s.equals("--dev")) {
                isDevEnv = true;
            }

            switch (s) {
                case "--login":
                    autoUser = args[++i];
                    autoPw = args[++i];
                    break;
                case "--production":
                    isProductionRun = true;
                    delayStartup = true;
                    break;

//                case "--delayStartup":
//                    delayStartup = true;
//                    break;
//                case "--sweep-for-users":
//                    sweepForUsers = true;
//                    break;
//                case "-t":

                case "--time":
                    // .e.g --time 3 means move three days into
                    // the future.
                    // negative shift NYI
                    long shift = Integer.parseInt(args[++i]);
                    if (shift < 0) {
                        Log.e(TAG, "Negative --time not supported.  Running with real time.");
                        shift = 0;
                    }

                    Log.i(TAG, String.format("Running %d days in the future.", shift));
                    systemState.setNow(System.currentTimeMillis() + (shift * com.mike.util.Constants.dayInMilli));
                    break;
            }
        }
    }

    public static User autoLogin(MySessionState mySessionState) {
        if (( ! autoUser.equals("")) && ( ! autoPw.equals(""))) {
            try {
                User user = User.authenticate(autoUser, autoPw);
                mySessionState.setUser(autoUser, user);
                SystemEvent.save(user, "AutoLogin");
                Log.d(TAG, "Autologin " + autoUser);
                return user;
            }
            catch (Exception e) {
                Log.e(TAG, e);
            }
        }

        autoUser = "";
        autoPw = "";

        return null;
    }


    static public WebController repoOwner = null;

    public static void registerRepoOwner(WebController controller) {
        repoOwner = controller;
    }

    public static WebController getRepoOwner() {
        return repoOwner;
    }

    // screwed up by not making the user's directory lowercase from
    // the beginning, so it's complicated
    public static File getUserDir(String username) {
        File f = new File(usersDir, username);
        if (f.exists())
            return f;   // early people could have mixed case file names like their username

        f = new File(usersDir, username.toLowerCase());
//        if (f.exists())
            return f;
    }

    public static File getUserDir() {
        return usersDir;
    }
    public static File getGeneratedDataDir() {
        return generatedDataDir;
    }

    static public String[] listFiles(String dir, String pattern) {
        Pattern p = Pattern.compile(pattern);

        File f = new File(rootDir, dir);
        if (f.exists()) {
            String[] files = f.list(new FilenameFilter() {
                @Override
                public boolean accept(File dir, String name) {
                    Matcher m = p.matcher(name);
                    return m.matches();
                }
            });
            return files;
        }
        return new String[0];
    }

    static private boolean emailEnabled = false;
    public static boolean getEmailEnabled() {
        return emailEnabled;
    }
    static public void setEmailEnabled(boolean enabled) {
        emailEnabled = enabled;
    }
}


