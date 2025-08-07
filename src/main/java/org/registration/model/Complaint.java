package org.registration.model;

import java.util.Date;

public class Complaint {

    // === Status Constants ===
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_PROCESSING = "Processing";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_REJECTED = "Rejected";
    public static final String STATUS_ACCEPTED = "Accepted";

    // === Fields ===
    private Integer id;
    private String title;
    private String description;
    private String status;              // Pending / Processing / Completed / Rejected / Accepted
    private Date createdDate;
    private String userName;
    private String imagePath;
    private String rejectionReason;

    // === Getters & Setters ===
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    // === Helper Methods ===
    public boolean isRejected() {
        return STATUS_REJECTED.equalsIgnoreCase(status);
    }

    public boolean isAccepted() {
        return STATUS_ACCEPTED.equalsIgnoreCase(status);
    }

    @Override
    public String toString() {
        return "Complaint{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", userName='" + userName + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}
