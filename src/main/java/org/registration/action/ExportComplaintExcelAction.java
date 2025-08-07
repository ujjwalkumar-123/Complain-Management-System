package org.registration.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.registration.model.Complaint;
import org.registration.service.ComplaintService;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class ExportComplaintExcelAction extends ActionSupport {
    private InputStream excelStream;

    private ComplaintService complaintService = new ComplaintService(); // Update if you're using DI

    public InputStream getExcelStream() {
        return excelStream;
    }

    @Override
    public String execute() {
        try {
            List<Complaint> complaints = complaintService.getAllComplaints();

            // Avoid duplicate complaints using LinkedHashSet
            Set<String> uniqueDescriptions = new LinkedHashSet<>();
            Set<Complaint> uniqueComplaints = new LinkedHashSet<>();

            for (Complaint c : complaints) {
                if (uniqueDescriptions.add(c.getDescription().trim())) {
                    uniqueComplaints.add(c);
                }
            }

            // Excel creation
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Complaints");

            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("ID");
            headerRow.createCell(1).setCellValue("User");
            headerRow.createCell(2).setCellValue("Description");
            headerRow.createCell(3).setCellValue("Status");
            headerRow.createCell(4).setCellValue("Rejection Reason");

            int rowNum = 1;
            for (Complaint c : uniqueComplaints) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(c.getId());
                row.createCell(1).setCellValue(c.getUser().getName());
                row.createCell(2).setCellValue(c.getDescription());
                row.createCell(3).setCellValue(c.getStatus());
                row.createCell(4).setCellValue(c.getRejectionReason() != null ? c.getRejectionReason() : "");
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            workbook.close();

            excelStream = new ByteArrayInputStream(out.toByteArray());
            out.close();

            return SUCCESS;

        } catch (Exception e) {
            e.printStackTrace();
            return ERROR;
        }
    }
}
