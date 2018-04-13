package com.mike.website3;

import com.mike.util.Log;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Map;

public class FTLSupport {

    private static final String TAG = FTLSupport.class.getSimpleName();

    public static String expandFile(Map<String, Object> data, String template) {

        try {
//            String fn = new File(Website.getExtFTLDir(), template).
            Template t = Website.getRepoOwner().getConfiguration().getTemplate(template);
            String s = FreeMarkerTemplateUtils.processTemplateIntoString(t, data);

//            Log.d(TAG, s);

            return s;
        }
        catch (TemplateNotFoundException e) {
            Log.d(e);
            return e.toString();
        } catch (IOException e) {
            Log.d(e);
            return e.toString();
        } catch (TemplateException e) {
            Log.d(e);
            return e.toString();
        }
    }

    public static String expandString(Map<String, Object> data, String template) {
        int i = 0;
        String exp = template;
        while(exp.contains("${") && (++i < 5)) {
            exp = doExpandString(data, exp);
        }

        if (i >= 5)
            Log.d(TAG, "Recursive FTL string expansion exceeded limit");

        return exp;
    }

    private static String doExpandString(Map<String, Object> data, String template) {
        String fn = Integer.toString(MySystemState.getInstance().getRandom().nextInt(100000));
        File tmp = new File(Website.tmpTemplateDir, fn);
        try {
            Files.write(tmp.toPath(), template.getBytes());

            Template t = Website.getRepoOwner().getConfiguration().getTemplate(fn);
            String s = FreeMarkerTemplateUtils.processTemplateIntoString(t, data);

//            Log.d(TAG, s);

            return s;
        }
        catch (TemplateNotFoundException e) {
            Log.d(e);
            return e.toString();
        } catch (IOException e) {
            Log.d(e);
            return e.toString();
        } catch (TemplateException e) {
            Log.d(e);
            return e.toString();
        }
        finally {
            if (tmp.exists())
                tmp.delete();
        }
    }
}
