package org.registration.action;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.struts2.ServletActionContext;
import org.registration.model.Complaint;
import org.registration.service.ComplaintService;

import com.opensymphony.xwork2.ActionSupport;

public class AdminAction extends ActionSupport {

    private ComplaintService complaintService;
    private List<Complaint> complaintList;

    private int id;
    private String actionType;        // accept / reject
    private String rejectionReason;
    private String status;            // pending / processing / completed

    private InputStream excelStream;
    private String excelFileName;

    // Setters & Getters
    public void setComplaintService(ComplaintService complaintService) {
        this.complaintService = complaintService;
    }

    public List<Complaint> getComplaintList() {
        return complaintList;
    }

    public void setComplaintList(List<Complaint> complaintList) {
        this.complaintList = complaintList;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public InputStream getExcelStream() {
        return excelStream;
    }

    public String getExcelFileName() {
        return excelFileName;
    }

    // ✅ Show list of all complaints
    public String listComplaints() {
        complaintList = complaintService.listComplaints();
        return SUCCESS;
    }

 // ✅ Accept, Reject, or Manual Status update without overwriting
    public String updateStatus() {
        Complaint complaint = complaintService.getComplaintById(id);
        if (complaint == null) return ERROR;

        boolean statusChanged = false;

        // Manual status update (Pending, Processing, Completed) — Only if admin changed
        if (status != null && !status.trim().isEmpty() && 
            !"accept".equalsIgnoreCase(actionType) && 
            !"reject".equalsIgnoreCase(actionType)) {
            complaint.setStatus(status);
            statusChanged = true;
        }

        // Accept / Reject update (only if explicitly selected)
        if ("accept".equalsIgnoreCase(actionType)) {
            complaint.setStatus("Accepted");
            complaint.setRejectionReason(null);
            statusChanged = true;
        } 
        else if ("reject".equalsIgnoreCase(actionType)) {
            complaint.setStatus("Rejected");
            complaint.setRejectionReason(rejectionReason);
            statusChanged = true;
        }

        if (statusChanged) {
            complaintService.saveOrUpdateComplaint(complaint);
        }

        return SUCCESS;
    }

    // ✅ Update status (Pending, Processing, Completed)
    public String changeComplaintStatus() {
        Complaint complaint = complaintService.getComplaintById(id);
        if (complaint != null && status != null && !status.isEmpty()) {
            complaint.setStatus(status);
            complaintService.saveOrUpdateComplaint(complaint);
        }
        return SUCCESS;
    }

    // ✅ Show complaint details
    public String showComplaintDetails() {
        HttpServletRequest request = ServletActionContext.getRequest();
        Complaint complaint = complaintService.getComplaintById(id);
        if (complaint != null) {
            request.setAttribute("complaint", complaint);
        }
        return SUCCESS;
    }

    // ✅ Export complaints to Excel
    public String exportToExcel() {
        try {
            List<Complaint> complaints = complaintService.getDistinctComplaintsForExcel();

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Complaints");

            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("ID");
            header.createCell(1).setCellValue("User Name");
            header.createCell(2).setCellValue("Title");
            header.createCell(3).setCellValue("Description");
            header.createCell(4).setCellValue("Status");
            header.createCell(5).setCellValue("Rejection Reason");

            int rowNum = 1;
            for (Complaint c : complaints) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(c.getId());
                row.createCell(1).setCellValue(c.getUserName());
                row.createCell(2).setCellValue(c.getTitle());
                row.createCell(3).setCellValue(c.getDescription());
                row.createCell(4).setCellValue(c.getStatus());
                row.createCell(5).setCellValue(c.getRejectionReason() != null ? c.getRejectionReason() : "");
            }

            for (int i = 0; i < 6; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            workbook.write(bos);
            workbook.close();

            excelStream = new ByteArrayInputStream(bos.toByteArray());
            excelFileName = "complaints.xlsx";

            return "excel";
        } catch (Exception e) {
            e.printStackTrace();
            return ERROR;
        }
    }
}
