<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%
    // GIỮ NGUYÊN LOGIC JSP CŨ
    String loginRequired = request.getParameter("loginRequired");
    String logoutSuccess = request.getParameter("logout");
%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập tài khoản</title>
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
      .header img:hover {
        transform: scale(1.02);
      }
      .header h2 {
        font-weight: 700;
        font-size: 2rem;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      /* Form Container */
      .form-container {
        background: white;
        border-radius: 15px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
        padding: 2rem;
        margin: 2rem auto;
        max-width: 500px;
      }
      .form-container .form-label {
        font-weight: 500;
        color: #1e3a8a;
      }
      .form-container .form-control {
        border-radius: 10px;
        border: 1px solid #d1d5db;
        padding-left: 2.5rem;
        transition: all 0.3s ease;
      }
      #email, #password {
        border-radius: 20px !important;
      }

      .form-container .form-control:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
      }
      .form-container .input-group {
        position: relative;
      }
      .form-container .input-group i {
        position: absolute;
        top: 50%;
        left: 0.75rem;
        transform: translateY(-50%);
        color: #6b7280;
        z-index: 10;
      }
      .form-container .btn {
        border-radius: 25px;
        padding: 0.75rem 1.5rem;
        transition: all 0.3s ease;
        width: 100%; /* Đảm bảo nút chiếm toàn bộ chiều rộng */
      }
      .btn-primary {
        background-color: #ffe22a !important;
        color: #000 !important;
        border: none !important;
      }
      .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        background-color: #ffda00 !important;
      }
      
      /* Loại bỏ style cho nút secondary vì không còn dùng */
      
      .form-container .error-message {
        color: #dc3545;
        font-size: 0.9rem;
        margin-top: 0.25rem;
        padding: 1rem;
        background-color: #f8d7da;
        border-radius: 8px;
      }
      .warning-message,
      .success-message {
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 1rem;
      }
      .warning-message {
        background-color: #fff3cd; color: #856404;
      }
      .success-message {
        background-color: #d4edda; color: #155724;
      }

      /* Links */
      .action-links a {
        color: rgb(0, 125, 156);
        transition: all 0.3s ease;
      }
      .action-links a:hover {
        color: #3b82f6;
        text-decoration: underline;
      }

      /* Responsive */
      @media (max-width: 768px) {
        .header h2 {
          font-size: 1.5rem;
        }
        .form-container {
          padding: 1.5rem;
          margin: 1rem;
        }
        /* Loại bỏ sự phụ thuộc vào width: 100% trong media query vì đã đặt ở trên */
      }
    </style>
  </head>
  <body>
    <div
      style="
        background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52));
      "
      class="header"
    >
      <img
        src="/jsp-servlet-DatVeXe/images/logo-name-header.svg"
        alt="Hotel Banner"
        class="img-fluid"
      />
      <h2 style="color: #ffe22a"><i class="fas fa-lock me-2"></i> Đăng Nhập</h2>
    </div>

    <div class="container form-container">
      
      <% if ("true".equals(loginRequired)) { %>
      <div class="warning-message d-flex align-items-center">
        <i class="fas fa-exclamation-triangle me-2"></i>
        <strong>Yêu cầu đăng nhập!</strong> Bạn cần đăng nhập để truy cập trang này.
      </div>
      <% } %>
      
      <% if ("success".equals(logoutSuccess)) { %>
      <div class="success-message d-flex align-items-center">
        <i class="fas fa-check-circle me-2"></i>
        <strong>Đăng xuất thành công!</strong> Hẹn gặp lại bạn.
      </div>
      <% } %>
      
      <% if(request.getAttribute("error") != null) { %>
      <div class="error-message d-flex align-items-center">
        <i class="fas fa-times-circle me-2"></i>
        <div><%= request.getAttribute("error") %></div>
      </div>
      <% } %>

      <form id="loginForm" action="dangNhapServlet" method="post">
        
        <div class="mb-3">
          <label for="email" class="form-label" style="color: #333"
            >Email</label
          >
          <div class="input-group">
            <i class="fas fa-user"></i>
            <input
              type="text"
              class="form-control"
              id="email"
              name="email"
              required 
              autofocus
              placeholder="Nhập email của bạn"
            />
          </div>
          </div>

        <div class="mb-3">
          <label for="password" class="form-label" style="color: #333"
            >Mật khẩu</label
          >
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

        <div class="button-group mt-4">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-sign-in-alt me-2"></i> Đăng nhập
          </button>
        </div>
      </form>

      <div class="action-links mt-3 text-center">
        <p>
          Chưa có tài khoản?
          <a href="dangKyServlet" style="color: rgb(0, 125, 156)"
            >Đăng ký ngay</a
          >
        </p>
      </div>
    </div>
  </body>
</html>