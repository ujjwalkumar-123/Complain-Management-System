package org.registration.action;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.registration.model.Complaint;
import org.registration.service.ComplaintService;

import com.opensymphony.xwork2.ActionSupport;

public class ComplaintAction extends ActionSupport {

    private ComplaintService complaintService;
    private List<Complaint> complaintList;
    private Complaint complaint;
    private int id;

    // File upload fields
    private File image;
    private String imageFileName;
    private String imageContentType;

    public void setComplaintService(ComplaintService complaintService) {
        this.complaintService = complaintService;
    }

    public List<Complaint> getComplaintList() {
        return complaintList;
    }

    public Complaint getComplaint() {
        return complaint;
    }

    public void setComplaint(Complaint complaint) {
        this.complaint = complaint;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public File getImage() {
        return image;
    }

    public void setImage(File image) {
        this.image = image;
    }

    public String getImageFileName() {
        return imageFileName;
    }

    public void setImageFileName(String imageFileName) {
        this.imageFileName = imageFileName;
    }

    public String getImageContentType() {
        return imageContentType;
    }

    public void setImageContentType(String imageContentType) {
        this.imageContentType = imageContentType;
    }

    // Show list based on role
    public String list() {
        HttpSession session = ServletActionContext.getRequest().getSession();
        String role = (String) session.getAttribute("role");
        String loggedInUser = (String) session.getAttribute("userName");

        if ("admin".equalsIgnoreCase(role)) {
            complaintList = complaintService.listComplaints();
        } else {
            complaintList = complaintService.listComplaintsByUser(loggedInUser);
        }
        return SUCCESS;
    }

    // Show form for add/edit
    public String form() {
        if (id != 0) {
            complaint = complaintService.getComplaintById(id);
        }
        return SUCCESS;
    }

    // Save complaint (user-side)
    public String save() {
        if (complaint != null) {
            if (complaint.getId() == null) {
                complaint.setCreatedDate(new Date());

                HttpSession session = ServletActionContext.getRequest().getSession();
                String loggedInUser = (String) session.getAttribute("userName");
                complaint.setUserName(loggedInUser);
                complaint.setStatus("Pending"); // Default status
            }

            // Image saving logic (fixed)
            if (image != null) {
                try {
                    // ✅ Save inside webapp/uploadedImages for browser access
                    String uploadPath = ServletActionContext.getServletContext().getRealPath("/uploadedImages");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    File savedFile = new File(uploadDir, imageFileName);
                    int counter = 1;
                    String baseName = imageFileName;
                    String extension = "";

                    int dotIndex = imageFileName.lastIndexOf('.');
                    if (dotIndex > 0) {
                        baseName = imageFileName.substring(0, dotIndex);
                        extension = imageFileName.substring(dotIndex);
                    }

                    while (savedFile.exists()) {
                        savedFile = new File(uploadDir, baseName + "_" + counter + extension);
                        counter++;
                    }

                    Files.copy(image.toPath(), savedFile.toPath());

                    // ✅ Store relative path so JSP can display it
                    complaint.setImagePath("uploadedImages/" + savedFile.getName());

                } catch (IOException e) {
                    e.printStackTrace();
                    addActionError("Image upload failed: " + e.getMessage());
                    return ERROR;
                }
            }

            complaintService.saveOrUpdateComplaint(complaint);
        }
        return "success";
    }

    // Delete complaint
    public String delete() {
        if (id != 0) {
            complaintService.deleteComplaint(id);
            complaintService.resetAutoIncrementIfEmpty();
        }
        return SUCCESS;
    }

    // Update status from admin side
    public String updateStatus() {
        if (id != 0 && complaint != null) {
            Complaint existingComplaint = complaintService.getComplaintById(id);
            if (existingComplaint != null) {
                existingComplaint.setStatus(complaint.getStatus());

                if ("Rejected".equalsIgnoreCase(complaint.getStatus())) {
                    existingComplaint.setRejectionReason(complaint.getRejectionReason());
                } else {
                    existingComplaint.setRejectionReason(null);
                }

                complaintService.saveOrUpdateComplaint(existingComplaint);
            }
        }
        return SUCCESS;
    }
}
