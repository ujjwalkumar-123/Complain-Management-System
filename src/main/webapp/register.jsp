<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #43cea2, #185a9d);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }
        .form-box {
            max-width: 600px;
            background: #fff;
            margin: 50px auto;
            padding: 35px 40px;
            border-radius: 18px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            color: #185a9d;
        }
        .form-label {
            font-weight: 500;
        }
        .form-control, .form-select {
            border-radius: 10px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            font-weight: bold;
            border: none;
            border-radius: 10px;
            background: linear-gradient(to right, #185a9d, #43cea2);
            color: white;
            transition: 0.3s;
        }
        .btn-submit:hover {
            background: linear-gradient(to right, #43cea2, #185a9d);
        }
        .message-success { color: green; font-weight: bold; }
        .message-error { color: red; font-weight: bold; }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Registration Form</h2>

    <s:actionmessage cssClass="message-success" />
    <s:actionerror cssClass="message-error" />

    <form action="register" method="post">
        <div class="mb-3"><label class="form-label">First Name</label><input type="text" name="user.firstName" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Last Name</label><input type="text" name="user.lastName" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Username</label><input type="text" name="user.username" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Email</label><input type="email" name="user.email" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Password</label><input type="password" name="user.password" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Confirm Password</label><input type="password" name="user.confirmPassword" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">Country</label><input type="text" name="user.country" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">City</label><input type="text" name="user.city" class="form-control" required></div>

        <div class="mb-3">
            <label class="form-label">Role</label>
            <select name="user.role" class="form-select" required>
                <option value="">Select Role</option>
                <option value="USER">User</option>
                <option value="ADMIN">Admin</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Gender</label><br>
            <div class="form-check form-check-inline">
                <input type="radio" name="user.gender" value="male" class="form-check-input" required>
                <label class="form-check-label">Male</label>
            </div>
            <div class="form-check form-check-inline">
                <input type="radio" name="user.gender" value="female" class="form-check-input">
                <label class="form-check-label">Female</label>
            </div>
            <div class="form-check form-check-inline">
                <input type="radio" name="user.gender" value="other" class="form-check-input">
                <label class="form-check-label">Other</label>
            </div>
        </div>

        <button type="submit" class="btn btn-submit">Register</button>
    </form>

    <div class="text-center mt-3">
        <p>Already have an account? <a href="loginPage">Login here</a></p>
    </div>
</div>

</body>
</html>
