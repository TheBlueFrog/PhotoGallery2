package com.mike.website3.tools;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mike on 4/2/2017.
 */
public class GetCPULoad extends RunProcess {

    private static final String TAG = GetCPULoad.class.getSimpleName();

    public static List<String> snap(String tag) {

        List<String> args = new ArrayList<>();
        if (RunProcess.isWindows) {
            args.add(tag);
            args.add("Not Supported on Windows");
            return args;
        }

        args.add("ps -uax | grep website");

        return runProcess(args, tag);
    }

}
