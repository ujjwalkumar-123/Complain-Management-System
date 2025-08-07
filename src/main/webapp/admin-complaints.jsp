<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.registration.model.Complaint" %>
<%
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaintList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>All Complaints - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
            padding: 20px;
        }
        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            margin-top: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        h2 {
            font-weight: bold;
            color: #2c3e50;
        }
        .table {
            border-radius: 12px;
            overflow: hidden;
        }
        .table th {
            background-color: #2c3e50;
            color: #ffffff;
            text-align: center;
        }
        .table tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.1);
            transition: 0.3s ease-in-out;
        }
        .form-select, .form-control {
            border-radius: 8px;
        }
        .btn-primary {
            background-color: #2980b9;
            border: none;
        }
        .btn-primary:hover {
            background-color: #1c5980;
        }
        .btn-success {
            background-color: #27ae60;
            border: none;
        }
        .btn-danger {
            background-color: #e74c3c;
            border: none;
        }
    </style>
    <script>
        function toggleReason(selectElem, id) {
            const reasonInput = document.getElementById("reason_" + id);
            if (selectElem.value === "reject") {
                reasonInput.style.display = "inline-block";
                reasonInput.required = true;
            } else {
                reasonInput.style.display = "none";
                reasonInput.required = false;
                reasonInput.value = "";
            }
        }
    </script>
</head>
<body>

<div class="container">
    <h2 class="mb-4 text-center">🛠️ All Complaints (Admin View)</h2>

    <table class="table table-bordered table-hover align-middle">
        <thead>
        <tr>
            <th>#</th>
            <th>User Name</th>
            <th>Title</th>
            <th>Description</th>
            <th>Image</th>
            <th>Status</th>
            <th>Rejection Reason</th>
            <th>Update</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (complaints != null && !complaints.isEmpty()) {
                int rowNum = 1;
                for (Complaint c : complaints) {
        %>
        <tr>
            <td class="text-center"><%= rowNum++ %></td>
            <td><%= c.getUserName() %></td>
            <td><%= c.getTitle() %></td>
            <td><%= c.getDescription() %></td>
            <td class="text-center">
                <% if (c.getImagePath() != null) { %>
                   <img src="<%= request.getContextPath() + "/" + c.getImagePath() %>" width="80" height="80" class="rounded shadow-sm" />
                <% } else { %>
                    <span class="text-muted">N/A</span>
                <% } %>
            </td>
            <td class="text-center"><%= c.getStatus() %></td>
            <td class="text-center"><%= c.getRejectionReason() != null ? c.getRejectionReason() : "-" %></td>
            <td>
                <form action="updateStatus" method="post" class="d-flex flex-column gap-2">
                    <input type="hidden" name="id" value="<%= c.getId() %>">

                    <select name="status" class="form-select form-select-sm">
                        <option value="Pending" <%= "Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="Processing" <%= "Processing".equals(c.getStatus()) ? "selected" : "" %>>Processing</option>
                        <option value="Completed" <%= "Completed".equals(c.getStatus()) ? "selected" : "" %>>Completed</option>
                    </select>

                    <select name="actionType" class="form-select form-select-sm"
                            onchange="toggleReason(this, <%= c.getId() %>)">
                        <option value="">-- Select Action --</option>
                        <option value="accept" <%= "Accepted".equals(c.getStatus()) ? "selected" : "" %>>Accept</option>
                        <option value="reject" <%= "Rejected".equals(c.getStatus()) ? "selected" : "" %>>Reject</option>
                    </select>

                    <input type="text" name="rejectionReason"
                           id="reason_<%= c.getId() %>"
                           placeholder="Rejection reason"
                           value="<%= c.getRejectionReason() != null ? c.getRejectionReason() : "" %>"
                           class="form-control form-control-sm"
                           style="<%= "Rejected".equals(c.getStatus()) ? "" : "display:none;" %>" />

                    <button type="submit" class="btn btn-primary btn-sm">Update</button>
                </form>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="8" class="text-center text-muted">No complaints found</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="text-center mt-4">
        <a href="exportComplaintsExcel" class="btn btn-success me-2">📥 Export to Excel</a>
        <a href="logout" class="btn btn-danger">Logout</a>
    </div>
</div>

</body>
</html>
