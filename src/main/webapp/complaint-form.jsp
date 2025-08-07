<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.registration.model.Complaint" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");

    if (userName == null) {
        response.sendRedirect("loginPage");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
%>
<html>
<head>
    <title><%= (complaint != null && complaint.getId() != null) ? "Edit Complaint" : "Add Complaint" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background:  linear-gradient(to right, #4facfe, #00f2fe);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        .top-bar {
            background: rgba(0, 0, 0, 0.6);
            color: white;
            padding: 12px 20px;
        }
        .form-container {
            max-width: 650px;
            margin: 50px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 6px 18px rgba(0,0,0,0.2);
            animation: fadeIn 0.5s ease-in-out;
        }
        .btn-custom {
            padding: 10px 20px;
            font-weight: bold;
        }
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>

<!-- Top bar -->
<div class="top-bar d-flex justify-content-between align-items-center">
    <h5 class="mb-0">Welcome, <%= userName %> 👋</h5>
    <a href="logout" class="btn btn-danger btn-sm">Logout</a>
</div>

<!-- Complaint Form -->
<div class="container">
    <div class="form-container">
        <h3 class="mb-3 text-center">
            <%= (complaint != null && complaint.getId() != null) ? "✏️ Edit Complaint" : "➕ Add Complaint" %>
        </h3>
        <hr>

        <form action="saveComplaint" method="post" class="row g-3" enctype="multipart/form-data">
            <input type="hidden" name="complaint.id" value="<%= (complaint != null) ? complaint.getId() : "" %>">

            <div class="col-12">
                <label class="form-label">Title</label>
                <input type="text" name="complaint.title" class="form-control"
                       value="<%= (complaint != null) ? complaint.getTitle() : "" %>" required>
            </div>

            <div class="col-12">
                <label class="form-label">Description</label>
                <textarea name="complaint.description" class="form-control" rows="4" required><%= (complaint != null) ? complaint.getDescription() : "" %></textarea>
            </div>

            <%-- Admin only status and rejection reason --%>
            <% if ("admin".equalsIgnoreCase(role)) { %>
                <div class="col-md-6">
                    <label class="form-label">Complaint Status</label>
                    <select name="complaint.status" class="form-select" id="statusSelect">
                        <option value="">-- Select --</option>
                        <option value="Pending" <%= "Pending".equals(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= "Accepted".equals(complaint.getStatus()) ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= "Rejected".equals(complaint.getStatus()) ? "selected" : "" %>>Rejected</option>
                        <option value="Processing" <%= "Processing".equals(complaint.getStatus()) ? "selected" : "" %>>Processing</option>
                        <option value="Completed" <%= "Completed".equals(complaint.getStatus()) ? "selected" : "" %>>Completed</option>
                    </select>
                </div>

                <div class="col-12" id="reasonDiv" style="display: <%= "Rejected".equals(complaint.getStatus()) ? "block" : "none" %>;">
                    <label class="form-label">Rejection Reason</label>
                    <textarea name="complaint.rejectionReason" class="form-control" rows="3"><%= (complaint != null) ? complaint.getRejectionReason() : "" %></textarea>
                </div>
            <% } %>

            <div class="col-12">
                <label class="form-label">Upload Image</label>
                <input type="file" name="image" class="form-control">
                <% if (complaint != null && complaint.getImagePath() != null) { %>
                    <p class="mt-2">📎 Current Image:
                        <a href="<%= complaint.getImagePath() %>" target="_blank">View</a>
                    </p>
                <% } %>
            </div>

            <%-- Created Date in edit mode --%>
            <% if (complaint != null && complaint.getCreatedDate() != null) { %>
                <div class="col-12">
                    <label class="form-label">Created Date</label>
                    <input type="text" class="form-control"
                           value="<%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(complaint.getCreatedDate()) %>"
                           readonly>
                </div>
            <% } %>

            <div class="col-12 d-flex justify-content-between">
                <button type="submit" class="btn btn-success btn-custom">💾 Save</button>
                <a href="complaintList" class="btn btn-secondary btn-custom">❌ Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
    // Show/Hide rejection reason if "Rejected" selected
    document.getElementById('statusSelect')?.addEventListener('change', function () {
        document.getElementById('reasonDiv').style.display = (this.value === 'Rejected') ? 'block' : 'none';
    });
</script>

</body>
</html>
