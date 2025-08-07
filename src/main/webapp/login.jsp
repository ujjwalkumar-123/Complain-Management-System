<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Complaint Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(120deg, #89f7fe, #66a6ff);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card-glass {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 40px 30px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            border: 1px solid rgba(255, 255, 255, 0.25);
            animation: pop 0.6s ease;
        }
        @keyframes pop {
            0% { transform: scale(0.95); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        .card-glass h2 {
            text-align: center;
            color: #fff;
            font-weight: 700;
            margin-bottom: 25px;
        }
        .form-label {
            color: #fff;
            font-weight: 500;
        }
        .form-control {
            background-color: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 8px;
            padding: 10px;
        }
        .form-control:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(102,166,255,0.4);
        }
        .btn-login {
            background: linear-gradient(to right, #00c6ff, #0072ff);
            border: none;
            color: white;
            font-weight: bold;
            padding: 12px;
            width: 100%;
            border-radius: 8px;
            margin-top: 10px;
            transition: 0.3s ease;
        }
        .btn-login:hover {
            background: linear-gradient(to right, #0072ff, #00c6ff);
        }
        .form-footer {
            text-align: center;
            margin-top: 15px;
        }
        .form-footer a {
            color: #fff;
            font-weight: 500;
            text-decoration: none;
        }
        .form-footer a:hover {
            text-decoration: underline;
        }
        .msg {
            text-align: center;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .msg-success {
            color: #c3f5b5;
        }
        .msg-error {
            color: #ffd4d4;
        }
    </style>
</head>
<body>

<div class="card-glass">
    <h2>Login</h2>

    <div class="msg msg-success">
        <%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %>
    </div>
    <div class="msg msg-error">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </div>

    <form action="login" method="post">
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="text" name="email" class="form-control" placeholder="Enter your email" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn-login">Login</button>
    </form>

    <div class="form-footer mt-3">
        Don't have an account? <a href="registerPage">Register here</a>
    </div>
</div>

</body>
</html>
