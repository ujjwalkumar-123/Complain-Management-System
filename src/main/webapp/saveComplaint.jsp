<%@ page import="java.sql.*" %>
<%@ page import="org.registration.model.Complaint" %>

<%
    request.setCharacterEncoding("UTF-8");

    // Session check
    String adminName = (String) session.getAttribute("userName");
    if (adminName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Form data
    String idStr = request.getParameter("id");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String status = request.getParameter("status");

    int id = (idStr != null && !idStr.trim().isEmpty()) ? Integer.parseInt(idStr) : 0;

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_db_name", "root", "your_password");

        if (id > 0) {
            // UPDATE complaint
            ps = conn.prepareStatement("UPDATE complaints SET title=?, description=?, status=? WHERE id=?");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, status);
            ps.setInt(4, id);
            ps.executeUpdate();
        } else {
            // INSERT new complaint
            ps = conn.prepareStatement("INSERT INTO complaints (title, description, status) VALUES (?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, status);
            ps.executeUpdate();
        }

        // Success message
        session.setAttribute("successMessage", "Complaint saved successfully!");
        response.sendRedirect("complaints.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Something went wrong!");
        response.sendRedirect("complaints.jsp");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
