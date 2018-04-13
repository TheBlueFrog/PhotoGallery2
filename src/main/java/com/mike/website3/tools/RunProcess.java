package com.mike.website3.tools;

import com.mike.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.function.Consumer;

/**
 * Created by mike on 7/23/2017.
 */
public class RunProcess {
    private static final String TAG = RunProcess.class.getSimpleName();

    static public boolean isWindows = System.getProperty("os.name")
            .toLowerCase().startsWith("windows");

    public static List<String> runProcess(List<String> args, String tag) {

        List<String> theOutput = new ArrayList<>();

        try {
            ProcessBuilder builder = new ProcessBuilder();

            if (isWindows) {
                args.add(0, "cmd.exe");
                args.add(1, "/c");
                builder.command(args);
            } else {
                args.add(0, "sh");
                args.add(1, "-c");
                builder.command(args);
            }

            theOutput.add(tag);
            theOutput.add("\n");

            Process process = builder.start();
            StreamGobbler streamGobbler =
                    new StreamGobbler(process.getInputStream(), new Consumer<String>() {
                        @Override
                        public void accept(String s) {
                            theOutput.add(s);
                        }
                    });

            Executors.newSingleThreadExecutor().submit(streamGobbler);
            int exitCode = process.waitFor();
            theOutput.add(String.format("exitCode %d", exitCode));
        }
        catch (Exception e) {
            Log.e(TAG, e);
            theOutput.add("Error");
        }

        return theOutput;
    }

    protected static class StreamGobbler implements Runnable {
        private InputStream inputStream;
        private Consumer<String> consumer;

        public StreamGobbler(InputStream inputStream, Consumer<String> consumer) {
            this.inputStream = inputStream;
            this.consumer = consumer;
        }

        @Override
        public void run() {
            new BufferedReader(new InputStreamReader(inputStream)).lines()
                    .forEach(consumer);
        }
    }
}
