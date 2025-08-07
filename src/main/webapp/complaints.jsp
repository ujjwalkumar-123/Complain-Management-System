<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.registration.model.Complaint" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("loginPage");
        return;
    }
    List<Complaint> complaintList = (List<Complaint>) request.getAttribute("complaintList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .header-bar {
            background: rgba(0, 0, 0, 0.7);
            color: #fff;
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
        }

        .btn-gradient {
            background: linear-gradient(to right, #6a11cb, #2575fc);
            color: #fff;
            font-weight: bold;
            border: none;
        }

        .btn-gradient:hover {
            background: linear-gradient(to right, #2575fc, #6a11cb);
        }

        table th, table td {
            vertical-align: middle !important;
        }

        .badge {
            font-size: 0.85rem;
            padding: 6px 12px;
        }

        .filter-search {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-search input,
        .filter-search select {
            max-width: 220px;
        }

        .no-complaint {
            text-align: center;
            font-weight: bold;
            padding: 20px;
            color: #555;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <div class="header-bar">
        <h4 class="mb-0">Welcome, <%= userName %> 👋</h4>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>

    <div class="dashboard-container mt-4">

        <div class="filter-search">
            <a href="complaintForm" class="btn btn-gradient">+ Add Complaint</a>
            <div class="d-flex gap-2">
                <input type="text" id="searchBox" class="form-control" placeholder="Search complaints...">
                <select id="statusFilter" class="form-select">
                    <option value="">All Status</option>
                    <option value="Pending">Pending</option>
                    <option value="Accepted">Accepted</option>
                    <option value="Rejected">Rejected</option>
                    <option value="Processing">Processing</option>
                    <option value="Completed">Completed</option>
                </select>
            </div>
        </div>

        <% if (complaintList == null || complaintList.isEmpty()) { %>
            <div class="no-complaint">No complaints found.</div>
        <% } else {
            int rowNum = 1;
        %>
            <div class="table-responsive">
                <table class="table table-bordered table-hover text-center">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Created Date</th>
                        <th>Image</th>
                        <th>Rejection Reason</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Complaint c : complaintList) { %>
                        <tr>
                            <td><%= rowNum++ %></td>
                            <td><%= c.getTitle() %></td>
                            <td><%= c.getDescription() %></td>
                            <td>
                                <%
                                    String status = c.getStatus();
                                    String badgeClass = "bg-secondary";
                                    if ("Pending".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
                                    else if ("Accepted".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                    else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                                    else if ("Processing".equalsIgnoreCase(status)) badgeClass = "bg-info text-dark";
                                    else if ("Completed".equalsIgnoreCase(status)) badgeClass = "bg-primary";
                                %>
                                <span class="badge <%= badgeClass %>"><%= status %></span>
                            </td>
                            <td><%= (c.getCreatedDate() != null) ? sdf.format(c.getCreatedDate()) : "-" %></td>
                            <td>
                                <% if (c.getImagePath() != null) { %>
                                    <img src="<%= request.getContextPath() + "/" + c.getImagePath() %>" style="height:50px;" />
                                <% } else { %>
                                    <span class="text-muted">No Image</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("Rejected".equalsIgnoreCase(c.getStatus())) {
                                    out.print((c.getRejectionReason() != null && !c.getRejectionReason().isEmpty()) ? c.getRejectionReason() : "-");
                                } else {
                                    out.print("-");
                                } %>
                            </td>
                            <td>
                                <a href="complaintForm?id=<%= c.getId() %>" class="btn btn-warning btn-sm">Edit</a>
                                <a href="deleteComplaint?id=<%= c.getId() %>" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<script>
    const searchBox = document.getElementById("searchBox");
    const statusFilter = document.getElementById("statusFilter");
    const rows = document.querySelectorAll("#complaintTable tbody tr");

    function filterTable() {
        const searchText = searchBox.value.toLowerCase();
        const statusValue = statusFilter.value;

        rows.forEach(row => {
            const title = row.cells[1].innerText.toLowerCase();
            const description = row.cells[2].innerText.toLowerCase();
            const status = row.cells[3].innerText.trim();

            const matchesSearch = title.includes(searchText) || description.includes(searchText);
            const matchesStatus = statusValue === "" || status === statusValue;

            row.style.display = matchesSearch && matchesStatus ? "" : "none";
        });
    }

    searchBox.addEventListener("keyup", filterTable);
    statusFilter.addEventListener("change", filterTable);
</script>

</body>
</html>
