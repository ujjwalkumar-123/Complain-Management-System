<%@ page import="java.sql.*" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_db", "root", "your_password");

        PreparedStatement ps = con.prepareStatement("SELECT first_name FROM users WHERE email=? AND password=?");
        ps.setString(1, email);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String name = rs.getString("first_name");
            session.setAttribute("userName", name); // Store name in session
            response.sendRedirect("complaints.jsp"); // Redirect to complaints page
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
