<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản</title>
    <link rel="stylesheet" href="style/style.css">
</head>
<body>
    <div class="login-container">
        <h2>Đăng ký tài khoản</h2>
        
        <!-- Hiển thị thông báo lỗi -->
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                ❌ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <!-- Hiển thị thông báo thành công -->
        <% if(request.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                ✅ <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        
        <form action="dangKyServlet" method="post">
            <div class="form-group">
                <label for="name">Họ và tên</label>
                <input type="text" id="name" name="name" required 
                       value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>"
                       placeholder="Nhập họ và tên của bạn">
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                       placeholder="Nhập email của bạn">
            </div>
            
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone" required
                       value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                       placeholder="Nhập số điện thoại">
            </div>
            
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required
                       placeholder="Nhập mật khẩu">
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       placeholder="Nhập lại mật khẩu">
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn btn-primary">Đăng ký</button>
                <button type="reset" class="btn btn-secondary">Xóa</button>
            </div>
        </form>
        
        <div style="text-align: center; margin-top: 20px;">
            <p>Đã có tài khoản? <a href="dangNhapServlet" style="color: #4CAF50; text-decoration: none;">Đăng nhập ngay</a></p>
        </div>
    </div>
    
    <script>
        // Kiểm tra mật khẩu khớp nhau
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                document.getElementById('confirmPassword').focus();
            }
        });
    </script>
</body>
</html>