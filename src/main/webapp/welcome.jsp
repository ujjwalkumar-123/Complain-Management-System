<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: white;
        }
        .navbar {
            background: rgba(0,0,0,0.4);
            padding: 15px 20px;
        }
        .navbar a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
        }
        .navbar a:hover {
            color: #ffcc70;
        }
        .hero {
            text-align: center;
            padding: 80px 20px;
        }
        .btn-logout {
            background: #ff4b5c;
            border: none;
            padding: 10px 25px;
            color: white;
            font-weight: bold;
            border-radius: 5px;
        }
        .btn-logout:hover {
            background: #e63946;
        }
    </style>
</head>
<body>

<nav class="navbar d-flex justify-content-between">
    <div>
        <a href="complaints">Complaints</a>
    </div>
    <div>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="hero">
    <h1>Welcome, <%= userName %>!</h1>
    <p>Glad to have you on your dashboard. Explore and enjoy!</p>
</div>

</body>
</html>
