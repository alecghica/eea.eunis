package ro.finsiel.eunis.admin;

import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;

import ro.finsiel.eunis.Settings;
import ro.finsiel.eunis.factsheet.PicturesHelper;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPictureDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPicturePersist;
import ro.finsiel.eunis.jrfTables.EunisRelatedReportsDomain;
import ro.finsiel.eunis.jrfTables.EunisRelatedReportsPersist;
import ro.finsiel.eunis.session.SessionManager;
import eionet.eunis.util.Constants;

/**
 * This is the servlet used for uploading files / documents on the server.<br />
 * Implemented as a servlet which performs POST FORM processing.
 *
 * @author finsiel
 */
public class EUNISUploadServlet extends HttpServlet {

    /** Type of upload FILE - documents etc. used in RELATED REPORTS part of the web site */
    private static final int UPLOAD_TYPE_FILE = 0;

    /** Type of upload FILE - documents etc. used in SPECIES/SITES FACTSHEETS part of the web site */
    private static final int UPLOAD_TYPE_PICTURE = 1;

    private static String BASE_DIR = "";

    /** The temporary dir where parts of the upload are stored temporary (if file size is bigger than memory buffer). */
    private static String TEMP_DIR = "temp";

    /** Maximum file size allowed to be uploaded to the server. */
    private static int MAX_FILE_SIZE = 104857600; // Default value

    /** Files with size smaller than this are written directly to disk, others through TEMP_DIR first. */
    private static int MAX_MEM_TRESHOLD = 4096; // Files smaller than 4k are directly written to disk

    /** Session manager. */
    private SessionManager sessionManager;

    /** Used for picture uploading. */
    NatureObjectInfo natureObjectInfo = new NatureObjectInfo();

    private static final int MAX_WIDTH = 300;

    private static final int MAX_HEIGHT = 400;

    public void init() {
        Settings.loadSettings(this);
        // System.out.println("EUNISUploadServlet::init();");
    }

    /**
     * Overrides public method doPost of javax.servlet.http.HttpServlet.
     *
     * @param request
     *            Request object
     * @param response
     *            Response object.
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);

        sessionManager = (SessionManager) session.getAttribute("SessionManager");

        // Initialise the default settings
        try {
            BASE_DIR = getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM);
            TEMP_DIR = BASE_DIR + getServletContext().getInitParameter("TEMP_DIR");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        List items = new ArrayList();
        boolean isMultipart = FileUpload.isMultipartContent(request);
        DiskFileUpload upload = new DiskFileUpload();

        upload.setSizeThreshold(MAX_MEM_TRESHOLD);
        upload.setSizeMax(MAX_FILE_SIZE);
        upload.setRepositoryPath(TEMP_DIR);
        try {
            items = upload.parseRequest(request);
        } catch (FileUploadException ex) {
            ex.printStackTrace();
            try {
                response.sendRedirect("related-reports-error.jsp?status=Error while interpreting request");
            } catch (IOException _ex) {
                _ex.printStackTrace();
            }
        }
        // If it's a multi-part content then it's an upload. So we process it.
        if (isMultipart) {
            int uploadType = -1;
            String description = ""; // Description of the uploaded document (used only for UPLOAD_TYPE_FILE)

            // Process the uploaded items
            for (int i = 0; i < items.size(); i++) {
                FileItem item = (FileItem) items.get(i);

                if (item.isFormField()) {
                    // FORM FIELD
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();

                    if (null != fieldName && fieldName.equals("uploadType")) {
                        if (null != fieldValue && fieldValue.equalsIgnoreCase("file")) {
                            uploadType = UPLOAD_TYPE_FILE;
                        }
                        if (null != fieldValue && fieldValue.equalsIgnoreCase("picture")) {
                            uploadType = UPLOAD_TYPE_PICTURE;
                        }
                    }
                    // Id object
                    if (null != fieldName && fieldName.equalsIgnoreCase("idobject")) {
                        natureObjectInfo.idObject = fieldValue;
                    }
                    // Description
                    if (null != fieldName && fieldName.equalsIgnoreCase("description")) {
                        natureObjectInfo.description = fieldValue;
                        description = fieldValue;
                    }
                    // Nature object type
                    if (null != fieldName && fieldName.equalsIgnoreCase("natureobjecttype")) {
                        natureObjectInfo.natureObjectType = fieldValue;
                    }
                }
            }
            if (uploadType == UPLOAD_TYPE_FILE) {
                String message = "";

                if (sessionManager.isAuthenticated() && sessionManager.isUpload_reports_RIGHT()) {
                    try {
                        uploadDocument(items, message, sessionManager.getUsername(), description);
                        response.sendRedirect("related-reports-upload.jsp?message=" + message);
                    } catch (IOException ex) { // Thrown by sendRedirect
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        try {
                            String errorURL = "related-reports-error.jsp?status=" + ex.getMessage();

                            response.sendRedirect(errorURL); // location is a dummy param
                        } catch (IOException ioex) {
                            ioex.printStackTrace();
                        }
                    }
                } else {
                    message = "You must be logged in and have the 'upload files' ";
                    message += "right in order to use this feature. Upload is not possible.";
                    try {
                        response.sendRedirect("related-reports-error.jsp?status=" + message);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
            if (uploadType == UPLOAD_TYPE_PICTURE) {
                if (sessionManager.isAuthenticated() && sessionManager.isUpload_pictures_RIGHT()) {
                    try {
                        uploadPicture(items);
                        String redirectStr = "pictures-upload.jsp?operation=upload";

                        redirectStr += "&idobject=" + natureObjectInfo.idObject;
                        redirectStr += "&natureobjecttype=" + natureObjectInfo.natureObjectType;
                        redirectStr += "&filename=" + natureObjectInfo.filename;
                        redirectStr += "&message=Picture successfully loaded.";
                        response.sendRedirect(redirectStr);
                    } catch (IOException ex) { // Thrown by sendRedirect
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        try {
                            response.sendRedirect("related-reports-error.jsp?status=An error ocurred during picture upload. "
                                    + ex.getMessage());
                        } catch (IOException ioex) {
                            ioex.printStackTrace();
                        }
                    }
                } else {
                    try {
                        response.sendRedirect("related-reports-error.jsp?status=You do not have the proper rights. Upload is not possible.");
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }
    }

    /**
     * This method is used to upload pictures for species/sites within database.
     *
     * @param fileItems
     *            FileItems which came form request parsed by the upload method (DiskFileUpload).<br />
     *            Contains information about upload (HTTP FORM headers, parsed as elements).
     * @throws Exception
     *             Is throwed for various reasons: IOException, database down etc.
     */
    private void uploadPicture(List fileItems) throws Exception {
        natureObjectInfo = new NatureObjectInfo();
        String filename = "";
        String idObject = "";
        String description = "";
        String natureObjectType = "";
        String source = "";
        String sourceUrl = "";
        String license = "";
        boolean mainPicture = false;
        FileItem uploadedFileItem = null;

        for (int i = 0; i < fileItems.size(); i++) {
            FileItem item = (FileItem) fileItems.get(i);

            if (item.isFormField()) {
                // FORM FIELD
                String fieldName = item.getFieldName();
                String fieldValue = item.getString();

                // Filename
                if (null != fieldName && fieldName.equalsIgnoreCase("filename")) {
                    filename = fieldValue;
                }
                // Id object
                if (null != fieldName && fieldName.equalsIgnoreCase("idobject")) {
                    idObject = fieldValue;
                }
                // Description
                if (null != fieldName && fieldName.equalsIgnoreCase("description")) {
                    description = new String(fieldValue.getBytes("iso-8859-1"), "UTF-8");
                }
                // Nature object type
                if (null != fieldName && fieldName.equalsIgnoreCase("natureobjecttype")) {
                    natureObjectType = fieldValue;
                }

                // Main picture
                if (null != fieldName && fieldName.equalsIgnoreCase("main_picture")) {
                    mainPicture = true;
                }

                // Source
                if (null != fieldName && fieldName.equalsIgnoreCase("source")) {
                    source = new String(fieldValue.getBytes("iso-8859-1"), "UTF-8");
                }

                // Source URL
                if (null != fieldName && fieldName.equalsIgnoreCase("sourceUrl")) {
                    sourceUrl = new String(fieldValue.getBytes("iso-8859-1"), "UTF-8");
                }

                // License
                if (null != fieldName && fieldName.equalsIgnoreCase("license")) {
                    license = new String(fieldValue.getBytes("iso-8859-1"), "UTF-8");
                }

            } else {
                // / UPLOAD FIELD
                filename = item.getName();
                uploadedFileItem = item;
            }
        }
        String uploadDir = "";

        if (natureObjectType.equalsIgnoreCase("Species")) {
            uploadDir = getServletConfig().getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");
        } else if (natureObjectType.equalsIgnoreCase("Sites")) {
            uploadDir = getServletConfig().getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_SITES");
        } else if (natureObjectType.equalsIgnoreCase("Habitats")) {
            uploadDir = getServletConfig().getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_HABITATS");
        }
        // Save the file in the right dir...
        filename = FileUtils.getRealName(filename);
        String imgName = filename;

        String suffix = imgName.substring(imgName.lastIndexOf("."));

        if (suffix == null
                || suffix.equals("")
                || (!suffix.equalsIgnoreCase(".jpg") && !suffix.equalsIgnoreCase(".jpeg") && !suffix.equalsIgnoreCase(".gif")
                        && !suffix.equalsIgnoreCase(".png") && !suffix.equalsIgnoreCase(".tif") && !suffix
                        .equalsIgnoreCase(".tiff"))) {
            throw new Exception(
                    "File has to be in one of the following formats: jpg, jpeg, gif, png, tif, tiff (case-insensitive)");
        }

        String fname = UniqueID.getUniqueID() + suffix.toLowerCase();

        filename = BASE_DIR + uploadDir + fname;
        // System.out.println("filename = " + filename);
        File file = new File(filename);

        // System.out.println("file = " + file);
        uploadedFileItem.write(file);
        natureObjectInfo.filename = fname;
        natureObjectInfo.description = description;
        natureObjectInfo.idObject = idObject;
        natureObjectInfo.natureObjectType = natureObjectType;
        // Sync the database with the pictures
        String scientificName = null;

        if (natureObjectType.equalsIgnoreCase("Species")) {
            scientificName = PicturesHelper.findSpeciesByIDObject(idObject);
        } else if (natureObjectType.equalsIgnoreCase("Sites")) {
            scientificName = PicturesHelper.findSitesByIDObject(idObject);
        } else if (natureObjectType.equalsIgnoreCase("Habitats")) {
            scientificName = PicturesHelper.findHabitatsByIDObject(idObject);
        }

        Chm62edtNatureObjectPicturePersist pictureObject = new Chm62edtNatureObjectPicturePersist();

        pictureObject.setDescription(description);
        pictureObject.setMainPicture(false);
        pictureObject.setFileName(fname);
        pictureObject.setIdObject(idObject);
        pictureObject.setName(scientificName);
        pictureObject.setNatureObjectType(natureObjectType);
        pictureObject.setSource(source);
        pictureObject.setSourceUrl(sourceUrl);
        pictureObject.setLicense(license);
        new Chm62edtNatureObjectPictureDomain().save(pictureObject);

        String mainPictureFilename = idObject + "_main_picture" + suffix;
        Chm62edtNatureObjectPictureDomain domain = new Chm62edtNatureObjectPictureDomain();
        List<Chm62edtNatureObjectPicturePersist> mainPictures =
                domain.findWhere(" FILE_NAME = '" + mainPictureFilename + "' and MAIN_PIC = 1 and NAME = '" + scientificName + "'");

        if (mainPictures == null || mainPictures.size() == 0) {
            mainPicture = true;
        }

        // processing main picture
        if (mainPicture) {
            BufferedImage image = ImageIO.read(file);
            double ratio = (double) image.getWidth() / (double) image.getHeight();
            double idealRatio = (double) MAX_WIDTH / (double) MAX_HEIGHT;
            int newHeight = 0, newWidth = 0;

            if (ratio > idealRatio) {
                newWidth = Math.min(image.getWidth(), MAX_WIDTH);
                newHeight = (int) (newWidth / ratio);
            } else {
                newHeight = Math.min(image.getHeight(), MAX_HEIGHT);
                newWidth = (int) (newHeight * ratio);
            }

            AffineTransform at =
                    AffineTransform.getScaleInstance((double) newWidth / (double) image.getWidth(), (double) newHeight
                            / (double) image.getHeight());
            BufferedImage output = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);

            ((Graphics2D) output.getGraphics()).drawRenderedImage(image, at);

            File outputFile = new File(BASE_DIR + uploadDir + mainPictureFilename);

            ImageIO.write(output, "JPG", outputFile);

            Chm62edtNatureObjectPicturePersist mainPicturePersist = new Chm62edtNatureObjectPicturePersist();

            // delete old mainPictures
            for (Chm62edtNatureObjectPicturePersist mainPic : mainPictures) {
                domain.save(mainPic);
                domain.delete(mainPic);
            }
            // create new one
            mainPicturePersist.setDescription(description);
            mainPicturePersist.setMainPicture(true);
            mainPicturePersist.setFileName(mainPictureFilename);
            mainPicturePersist.setIdObject(idObject);
            mainPicturePersist.setName(scientificName);
            mainPicturePersist.setNatureObjectType(natureObjectType);
            mainPicturePersist.setMaxWidth(new Integer(newWidth));
            mainPicturePersist.setMaxHeight(new Integer(newHeight));
            mainPicturePersist.setSource(source);
            mainPicturePersist.setSourceUrl(sourceUrl);
            mainPicturePersist.setLicense(license);
            domain.save(mainPicturePersist);

        }

    }

    /**
     * This method is used to upload a generic file (*.doc, *.pdf etc) on the server.
     *
     * @param fileItems
     *            FileItems which came form request parsed by the upload method (DiskFileUpload).<br />
     *            Contains information about upload (HTTP FORM headers, parsed as elements).
     * @param message
     *            OUTPUT field which is filled with a human-friendly status message of upload.
     * @param username
     *            User who does the upload
     * @param description
     *            Description of this file used for storing whithin database as REPORT_NAME.
     * @throws Exception
     *             Throws exceptions from various reasons: IOException, file already exists etc.
     */
    private void uploadDocument(List fileItems, String message, String username, String description) throws Exception {
        String filename = "";
        FileItem uploadedFileItem = null;

        for (int i = 0; i < fileItems.size(); i++) {
            FileItem item = (FileItem) fileItems.get(i);

            if (item.isFormField()) {
                String fieldName = item.getFieldName();
                String fieldValue = item.getString();

                // FORM FIELD
                if (null != fieldName && fieldName.equalsIgnoreCase("filename")) {
                    filename = fieldValue;
                }
            } else {
                // / UPLOAD FIELD
                filename = item.getName();
                uploadedFileItem = item;
            }
        }
        String uploadDir = getServletConfig().getServletContext().getInitParameter("UPLOAD_DIR_FILES");

        filename = FileUtils.getRealName(filename);
        filename = BASE_DIR + uploadDir + filename;
        File file = new File(filename);

        if (file.exists()) {
            message = "A document with same file name already exists on the server. Please rename the file and try again.";
            throw new Exception(message);
        } else {
            try { // Do a 'safe upload' - catch all exception to be sure file is there.
                  // System.out.println( "file=" + file );
                uploadedFileItem.write(file);
                // The upload completed correctly. Now synchronize the database with new file...
                EunisRelatedReportsPersist rowObject = new EunisRelatedReportsPersist();

                rowObject.setFileName(file.getName());
                rowObject.setApproved(new Integer(0));
                rowObject.setRecordAuthor(username);
                rowObject.setReportName(description);
                new EunisRelatedReportsDomain().save(rowObject); // Save within database
                message = "Document successfully uploaded.";
            } catch (Exception ex) {
                ex.printStackTrace();
                if (file.exists()) { // If file was successfully uploaded, but insert into database was not succeeded, delete the
                                     // file.
                    file.delete();
                }
                throw new Exception("An exception ocurred while trying to save the file on disk or database. Offending file was:"
                        + file.getName());
            }
        }
    }

    /**
     * Wrapping class used to store information about a picture (used only when uploading pictures).
     */
    private class NatureObjectInfo {
        public String idObject = "";
        public String description = "";
        public String natureObjectType = "";
        public String filename = "";
    }
}
