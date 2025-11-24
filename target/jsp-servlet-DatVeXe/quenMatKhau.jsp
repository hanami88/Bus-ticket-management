<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Hệ thống đặt vé xe</title>
    <link rel="stylesheet" href="style/auth.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>🔐 Quên mật khẩu</h2>
                <p>Khôi phục tài khoản của bạn</p>
            </div>

            <% 
                String step = (String) request.getAttribute("step");
                if (step == null) step = "1";
            %>

            <!-- Bước 1: Nhập email -->
            <% if ("1".equals(step)) { %>
                <form action="quenMatKhauServlet" method="post" class="auth-form">
                    <input type="hidden" name="step" value="1">
                    
                    <div class="step-indicator">
                        <div class="step active">1</div>
                        <div class="step">2</div>
                        <div class="step">3</div>
                    </div>
                    
                    <h3>📧 Nhập email của bạn</h3>
                    <p>Chúng tôi sẽ gửi mã OTP đến email này</p>
                    
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Nhập địa chỉ email" required>
                    </div>
                    
                    <button type="submit" class="btn-primary">Gửi mã OTP</button>
                </form>

            <!-- Bước 2: Nhập OTP -->
            <% } else if ("2".equals(step)) { %>
                <form action="quenMatKhauServlet" method="post" class="auth-form">
                    <input type="hidden" name="step" value="2">
                    
                    <div class="step-indicator">
                        <div class="step completed">✓</div>
                        <div class="step active">2</div>
                        <div class="step">3</div>
                    </div>
                    
                    <h3>🔢 Nhập mã OTP</h3>
                    <p>Mã OTP đã được gửi đến email của bạn</p>
                    
                    <div class="form-group">
                        <input type="text" name="otp" placeholder="Nhập mã OTP (6 số)" maxlength="6" required>
                    </div>
                    
                    <button type="submit" class="btn-primary">Xác thực OTP</button>
                    
                    <div class="form-links">
                        <a href="quenMatKhauServlet?step=1">← Quay lại nhập email</a>
                    </div>
                </form>

            <!-- Bước 3: Đặt lại mật khẩu -->
            <% } else if ("3".equals(step)) { %>
                <form action="quenMatKhauServlet" method="post" class="auth-form">
                    <input type="hidden" name="step" value="3">
                    
                    <div class="step-indicator">
                        <div class="step completed">✓</div>
                        <div class="step completed">✓</div>
                        <div class="step active">3</div>
                    </div>
                    
                    <h3>🔑 Đặt mật khẩu mới</h3>
                    <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
                    
                    <div class="form-group">
                        <input type="password" name="newPassword" placeholder="Mật khẩu mới (tối thiểu 6 ký tự)" required>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                    </div>
                    
                    <button type="submit" class="btn-primary">Đặt lại mật khẩu</button>
                </form>
            <% } %>

            <!-- Hiển thị thông báo -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="message error">
                    ❌ <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="message success">
                    ✅ <%= request.getAttribute("message") %>
                </div>
            <% } %>

            <div class="auth-footer">
                <p>Nhớ mật khẩu? <a href="dangNhapServlet">Đăng nhập ngay</a></p>
            </div>
        </div>
    </div>

    <script>
        // Auto focus vào input đầu tiên
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('input[type="email"], input[type="text"], input[type="password"]');
            if (firstInput) {
                firstInput.focus();
            }
        });

        // Chỉ cho phép nhập số cho OTP
        const otpInput = document.querySelector('input[name="otp"]');
        if (otpInput) {
            otpInput.addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }
    </script>
</body>
</html>