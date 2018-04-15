package com.mike.website3.pages.internal;

import com.mike.website3.Constants;
import com.mike.website3.MySessionState;
import com.mike.website3.db.Image;
import com.mike.website3.db.SystemEvent;
import com.mike.website3.db.User;
import com.mike.website3.pages.BaseController;
import com.mike.website3.storage.StorageFileNotFoundException;
import com.mike.website3.storage.StorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Created by mike on 3/6/2017.
 */
@Controller
public class UploadController extends BaseController {

    private final StorageService storageService;

    @Autowired
    public UploadController(StorageService storageService) {
        this.storageService = storageService;
    }

    @GetMapping("/upload")
    public String listUploadedFiles(HttpServletRequest request, Model model) throws IOException {
        String nextPage = "upload";
        User user = getSessionUser(request);
        if (user == null)
            nextPage = Constants.Web.REDIRECT_INDEX_HOME;
        else {
            // this iterates the disk
//            model.addAttribute("files", storageService
//                    .loadAll(user)
////                    .map(path ->
////                            MvcUriComponentsBuilder
////                                    .fromMethodName(UploadController.class, "serveFile", user, path.getFileName().toString())
////                                    .build().toString())
//                    .collect(Collectors.toList()));

            // this lists the db
//            getSessionState(request).setImages(user);
        }

        return super.get(request, model, nextPage);
    }

    @GetMapping("/files/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(User user, @PathVariable String filename) {

        if (user != null) {
            Resource file = storageService.loadAsResource(user, filename);
            return ResponseEntity
                    .ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
                    .body(file);
        }
        return ResponseEntity.badRequest().build();
    }

    @PostMapping("/upload-image")
    public String handleFileUpload(@RequestParam("files") MultipartFile[] files,
                                   RedirectAttributes redirectAttributes,
                                   HttpServletRequest request) {

        MySessionState state = getSessionState(request);
        User user = state.getUser();
        if (user != null) {
            user.checkForUserDirectory();
            for (MultipartFile f : files) {
                storageService.store(user, f);
                redirectAttributes.addFlashAttribute("message",
                        "You successfully uploaded " + f.getOriginalFilename() + "!");

                new Image(user, "", f.getOriginalFilename())
                        .save();

                SystemEvent.save(user, f.getOriginalFilename());
            }
        }
        return "redirect:/upload";
    }

    @PostMapping("/upload-user-image")
    public String handleFileUpload1(@RequestParam("files") MultipartFile[] files,
                                   RedirectAttributes redirectAttributes,
                                   HttpServletRequest request) {

        User user = getSessionUser(request);
        if (user != null) {
            for (MultipartFile f : files) {
                storageService.store(user, f);
                redirectAttributes.addFlashAttribute("message",
                        "You successfully uploaded " + f.getOriginalFilename() + "!");
            }
        }
        return "redirect:/user-image-manager";
    }

    @PostMapping("/update")
    public String update(HttpServletRequest request) {

        User user = getSessionUser(request);
        if (user != null) {
            Image image = Image.findById(request.getParameter("id"));
            image.setCaption(request.getParameter("caption"));
            boolean b = request.getParameter("public") != null;
            image.setPublic(b);
            image.save();
        }
        return "redirect:/upload";
    }

    @ExceptionHandler(StorageFileNotFoundException.class)
    public ResponseEntity handleStorageFileNotFound(StorageFileNotFoundException exc) {
        return ResponseEntity.notFound().build();
    }

}