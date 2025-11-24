<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loginRequired = request.getParameter("loginRequired");
    String logoutSuccess = request.getParameter("logout");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="style/style.css">
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>
        
        <% if ("true".equals(loginRequired)) { %>
            <div class="warning-message">
                🚫 <strong>Yêu cầu đăng nhập!</strong> Bạn cần đăng nhập để truy cập trang này.
            </div>
        <% } %>
        
        <% if ("success".equals(logoutSuccess)) { %>
            <div class="success-message">
                ✅ <strong>Đăng xuất thành công!</strong> Hẹn gặp lại bạn.
            </div>
        <% } %>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="error-message">
                ❌ <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="dangNhapServlet" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="text" id="email" name="email" required autofocus
                       placeholder="Nhập email của bạn">
            </div>
            
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required
                       placeholder="Nhập mật khẩu">
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn btn-primary">Đăng nhập</button>
                <button type="reset" class="btn btn-secondary">Xóa</button>
            </div>
        </form>
        
        <div class="form-links">
            <a href="quenMatKhauServlet">Quên mật khẩu?</a>
            <a href="dangKyServlet">Chưa có tài khoản? Đăng ký</a>
        </div>
    </div>
</body>
</html>