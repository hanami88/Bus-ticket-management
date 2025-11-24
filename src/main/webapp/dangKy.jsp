<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<% 
    // GIỮ NGUYÊN LOGIC JSP CŨ
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký tài khoản</title>
    
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
      integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
      crossorigin="anonymous"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    
    <style>
      /* CSS TỪ GIAO DIỆN MỚI */
      body {
        background-color: #f4f7fc;
        font-family: "Inter", sans-serif;
        color: #333;
      }

      /* Header */
      .header {
        background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52));
        color: white;
        padding: 3rem 0;
        text-align: center;
        border-radius: 0 0 20px 20px;
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        position: relative;
        overflow: hidden;
      }
      .header img {
        max-width: 100%;
        height: auto;
        border-radius: 15px;
        margin-bottom: 1.5rem;
        opacity: 0.9;
        transition: transform 0.3s ease;
      }
      .header h2 {
        font-weight: 700;
        font-size: 2rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #ffe22a;
      }

      /* Form Container (Đã dùng class form-container) */
      .login-container { 
        background: white;
        border-radius: 15px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
        padding: 2rem;
        margin: 2rem auto;
        max-width: 500px;
      }
      .login-container .form-label {
        font-weight: 500;
        color: #1e3a8a;
      }
      .login-container .form-control {
        border-radius: 20px !important; /* Áp dụng border-radius 20px cho tất cả input */
        border: 1px solid #d1d5db;
        padding-left: 2.5rem;
        transition: all 0.3s ease;
      }
      .login-container .form-control:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
      }
      .login-container .input-group {
        position: relative;
      }
      .login-container .input-group i {
        position: absolute;
        top: 50%;
        left: 0.75rem;
        transform: translateY(-50%);
        color: #6b7280;
        z-index: 10;
      }
      .login-container .btn {
        border-radius: 25px;
        padding: 0.75rem 1.5rem; /* Sửa padding nút */
        transition: all 0.3s ease;
      }
      .login-container .btn-primary {
        background-color: #ffe22a !important; /* Màu Vàng từ mẫu mới */
        color: #000 !important;
        border: none !important;
        width: 100%; /* Nút chiếm toàn bộ chiều rộng (vì đã bỏ nút Xóa) */
      }
      .login-container .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      
      /* Cấu hình thông báo */
      .error-message {
        background-color: #f8d7da;
        color: #721c24;
        border-color: #f5c6cb;
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 1rem;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
      }
      .success-message {
        background-color: #d4edda;
        color: #155724;
        border-color: #c3e6cb;
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 1rem;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
      }
      
      /* Links (Đã đổi style link) */
      .action-links a {
        color: rgb(0, 125, 156);
        text-decoration: none;
        transition: color 0.3s ease;
      }
      .action-links a:hover {
        color: #3b82f6;
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="header">
      <img
        src="/jsp-servlet-DatVeXe/images/logo-name-header.svg"
        alt="Hotel Banner"
        class="img-fluid"
      />
      <h2 style="color: #ffe22a">
        <i class="fas fa-user-plus me-2"></i> Đăng Ký
      </h2>
    </div>

    <div class="container login-container">
      
      <h2>Đăng ký tài khoản</h2>

      <% if(errorMessage != null) { %>
      <div class="error-message">
        <i class="fas fa-times-circle me-2"></i>
        <%= errorMessage %>
      </div>
      <% } %>

      <% if(successMessage != null) { %>
      <div class="success-message">
        <i class="fas fa-check-circle me-2"></i>
        <%= successMessage %>
      </div>
      <% } %>

      <form action="dangKyServlet" method="post">
        
        <div class="mb-3">
          <label for="name" class="form-label" style="color: #333">Họ và tên</label>
          <div class="input-group">
            <i class="fas fa-user"></i>
            <input 
              type="text" 
              class="form-control"
              id="name" 
              name="name" 
              required 
              value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" 
              placeholder="Nhập họ và tên của bạn"
            />
          </div>
        </div>

        <div class="mb-3">
          <label for="email" class="form-label" style="color: #333">Email</label>
          <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input 
              type="email" 
              class="form-control"
              id="email" 
              name="email" 
              required 
              value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" 
              placeholder="Nhập email của bạn"
            />
          </div>
        </div>

        <div class="mb-3">
          <label for="phone" class="form-label" style="color: #333">Số điện thoại</label>
          <div class="input-group">
            <i class="fas fa-phone"></i>
            <input 
              type="tel" 
              class="form-control"
              id="phone" 
              name="phone" 
              required 
              value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" 
              placeholder="Nhập số điện thoại"
            />
          </div>
        </div>

        <div class="mb-3">
          <label for="password" class="form-label" style="color: #333">Mật khẩu</label>
          <div class="input-group">
            <i class="fas fa-lock"></i>
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              required
              placeholder="Nhập mật khẩu"
            />
          </div>
        </div>

        <div class="mb-3">
          <label for="confirmPassword" class="form-label" style="color: #333">Xác nhận mật khẩu</label>
          <div class="input-group">
            <i class="fas fa-lock"></i>
            <input
              type="password"
              class="form-control"
              id="confirmPassword"
              name="confirmPassword"
              required
              placeholder="Nhập lại mật khẩu"
            />
          </div>
        </div>

        <div class="button-group mt-4">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-user-plus me-2"></i> Đăng ký
          </button>
        </div>
      </form>

      <div class="action-links mt-3 text-center">
        <p>
          Đã có tài khoản?
          <a href="dangNhapServlet">Đăng nhập ngay</a>
        </p>
      </div>
    </div>

    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>
   
  </body>
</html>