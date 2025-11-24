<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin | Hệ thống đặt vé</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style/dashboardAdmin.css">
    
    <style>
        /* =================================
             GLOBAL STYLES (New Theme)
             ================================= */
        :root {
            --color-primary: #1F2937; /* Dark Navy/Slate - Main background for sidebar/header/table-head */
            --color-secondary: #FFC107; /* Amber/Gold - Accent color */
            --color-text-dark: #374151;
            --color-text-light: #F9FAFB;
            --color-bg-light: #FFFFFF;
            --color-bg-dark: #F3F4F6;
            --color-success: #10B981;
            --color-danger: #EF4444;
            --color-info: #3B82F6;
            --shadow-light: 0 4px 12px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif; /* Sử dụng font hiện đại hơn */
            background-color: var(--color-bg-dark);
            min-height: 100vh;
            color: var(--color-text-dark);
        }

        /* Admin Container Layout */
        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background-color: var(--color-primary);
            color: var(--color-text-light);
            box-shadow: 2px 0 15px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }

        .logo {
            padding: 30px 25px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .logo h2 {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--color-secondary);
            margin: 0;
            letter-spacing: 1px;
        }

        .nav-menu {
            list-style: none;
            padding: 20px 0;
        }

        .nav-menu li {
            margin: 0;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            padding: 18px 25px;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border-left: 5px solid transparent;
            gap: 12px;
            font-size: 1.05rem;
        }

        .nav-menu a i {
            font-size: 1.2rem;
            width: 20px;
            text-align: center;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: var(--color-text-light);
            border-left-color: var(--color-secondary);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }

        /* Header */
        .header {
            background-color: var(--color-bg-light);
            padding: 30px 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        /* Button Styles */
        .btn {
            padding: 12px 22px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-primary {
            background-color: var(--color-secondary);
            color: var(--color-primary);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.4);
        }

        .btn-primary:hover {
            background-color: #FFB300;
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(255, 193, 7, 0.6);
        }

        .btn-secondary {
            background-color: #6B7280;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #4B5563;
            transform: translateY(-1px);
        }

        /* Messages */
        .message {
            margin: 0 0 25px 0;
            padding: 16px 24px;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: var(--shadow-light);
            transition: opacity 0.3s ease;
        }

        .message i {
            font-size: 1.2rem;
        }

        .error-message {
            background-color: #FEE2E2;
            color: var(--color-danger);
            border-left: 4px solid var(--color-danger);
        }

        .success-message {
            background-color: #D1FAE5;
            color: var(--color-success);
            border-left: 4px solid var(--color-success);
        }

        .info-message {
            background-color: #DBEAFE;
            color: var(--color-info);
            border-left: 4px solid var(--color-info);
        }

        /* Statistics Container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            padding: 0 0 30px;
        }

        .stat-card {
            background-color: var(--color-bg-light);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 20px;
            border: 1px solid #E5E7EB;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .stat-icon {
            font-size: 2.5rem;
            line-height: 1;
            color: var(--color-primary);
        }

        .stat-card.active .stat-icon {
            color: var(--color-success);
        }

        .stat-card.admin .stat-icon {
            color: #8B5CF6; /* Violet */
        }

        .stat-info h3 {
            color: #6B7280;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 0 0 5px 0;
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--color-text-dark);
            line-height: 1;
            margin: 0;
        }

        /* Table Section */
        .table-section {
            padding: 0;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--color-primary);
            margin: 25px 0 20px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-container {
            background-color: var(--color-bg-light);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
            border: 1px solid #E5E7EB;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table thead {
            background-color: var(--color-primary);
            color: var(--color-text-light);
        }

        .users-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .users-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #E5E7EB;
            vertical-align: middle;
            font-size: 14px;
        }

        .users-table tbody tr:hover {
            background-color: #F9FAFB;
        }

        .users-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Table Cell Styles */
        .user-name {
            font-weight: 600;
            color: var(--color-primary);
        }

        .user-email, .user-phone {
            color: #6B7280;
            font-weight: 400;
        }

        /* Role Badges */
        .role-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            min-width: 60px;
            text-align: center;
        }

        .role-user {
            background-color: #DBEAFE;
            color: #1E40AF;
        }

        .role-admin {
            background-color: #EDE9FE;
            color: #7C3AED;
        }

        /* Action Buttons in Table */
        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn-action {
            width: 38px;
            height: 38px;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-edit {
            background-color: var(--color-secondary);
            color: var(--color-primary);
        }

        .btn-view {
            background-color: #8B5CF6; /* Violet */
            color: white;
        }

        .btn-delete {
            background-color: var(--color-danger);
            color: white;
        }
        
        .btn-action:hover {
            transform: scale(1.1);
        }

        /* No Data */
        .no-data {
            text-align: center;
            color: #6B7280;
            font-style: italic;
            padding: 40px;
            font-size: 16px;
            background-color: #F9FAFB;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            overflow-y: auto;
        }

        .modal-content {
            background-color: var(--color-bg-light);
            margin: 5% auto;
            border-radius: 15px;
            width: 90%;
            max-width: 700px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            animation: modalFadeIn 0.3s ease-out;
            border: 1px solid #E5E7EB;
        }

        .modal-content.small {
            max-width: 450px;
        }

        .modal-header {
            background-color: var(--color-primary);
            color: white;
            padding: 25px 30px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 700;
        }

        .close {
            color: white;
            font-size: 30px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
            transition: color 0.2s ease;
        }

        .close:hover {
            color: var(--color-secondary);
        }

        .modal-body {
            padding: 30px;
        }

        .modal-body p {
            margin-bottom: 20px;
            font-size: 15px;
            line-height: 1.6;
        }

        .modal-body .warning {
            color: var(--color-danger);
            font-weight: 600;
            background-color: #FEE2E2;
            padding: 12px 16px;
            border-radius: 8px;
            border-left: 4px solid var(--color-danger);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-group label {
            color: var(--color-text-dark);
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-group input,
        .form-group select {
            padding: 12px 15px;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
            background-color: white;
            color: var(--color-text-dark);
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--color-secondary);
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }

        .modal-footer {
            padding: 20px 30px 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            border-top: 1px solid #E5E7EB;
            background-color: #F9FAFB;
            border-radius: 0 0 15px 15px;
        }

        .btn-modal {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 15px;
        }

        .btn-cancel {
            background-color: #9CA3AF;
            color: white;
        }

        .btn-cancel:hover {
            background-color: #6B7280;
        }

        .btn-save {
            background-color: var(--color-success);
            color: white;
        }

        .btn-save:hover {
            background-color: #059669;
        }

        .btn-delete-confirm {
            background-color: var(--color-danger);
            color: white;
        }

        .btn-delete-confirm:hover {
            background-color: #B91C1C;
        }

        /* Animations */
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95) translateY(-20px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .sidebar { width: 250px; }
            .main-content { margin-left: 250px; padding: 20px; }
            .header { padding: 25px 30px; }
        }

        @media (max-width: 900px) {
            .header h1 { font-size: 1.8rem; }
            .stats-container { grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
            .users-table th, .users-table td { padding: 14px 15px; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: span 1; }
        }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }
            .main-content { margin-left: 0; }
            .header { flex-direction: column; align-items: flex-start; margin-bottom: 20px; }
            .header-actions { justify-content: flex-start; width: 100%; margin-top: 15px; }
            .users-table { min-width: 800px; } /* Force scroll for small screens */
            .table-container { overflow-x: auto; }
            .modal-content { margin: 10% auto; width: 95%; }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <nav class="sidebar">
            <div class="logo">
                <img
        src="/jsp-servlet-DatVeXe/images/logo-name-header.svg"
        alt="Hotel Banner"
        class="img-fluid"
      />
                <h2>ADMIN</h2>
            </div>
            <ul class="nav-menu">
                <li><a href="dashboardServlet"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                <li><a href="quanLyUserServlet" class="active"><i class="fas fa-users"></i> Quản lý Users</a></li>
                <li><a href="quanLyChuyenXeAdminServlet"><i class="fas fa-bus-alt"></i> Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet"><i class="fas fa-building"></i> Quản lý Nhà xe</a></li>
                <li><a href="dangXuatServlet"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <header class="header">
                <h1><i class="fas fa-user-shield"></i> Quản lý Người Dùng</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Thêm người dùng
                    </button>
                    <a href="dashboardServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                    </a>
                </div>
            </header>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error-message">
                    <i class="fas fa-times-circle"></i> <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i> <%= session.getAttribute("successMessage") %>
                </div>
                <%
                    session.removeAttribute("successMessage");
                %>
            <% } %>

            <% if (request.getAttribute("searchMessage") != null) { %>
                <div class="message info-message">
                    <i class="fas fa-info-circle"></i> <%= request.getAttribute("searchMessage") %>
                </div>
            <% } %>

            <div class="stats-container">
                <div class="stat-card total">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-info">
                        <h3>Tổng người dùng</h3>
                        <p class="stat-number"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card active">
                    <div class="stat-icon"><i class="fas fa-user"></i></div>
                    <div class="stat-info">
                        <h3>User thường</h3>
                        <p class="stat-number" id="regularUserCount">0</p>
                    </div>
                </div>
                
                <div class="stat-card admin">
                    <div class="stat-icon"><i class="fas fa-user-tie"></i></div>
                    <div class="stat-info">
                        <h3>Admin</h3>
                        <p class="stat-number" id="adminUserCount">0</p>
                    </div>
                </div>
            </div>


            <div class="table-section">
                <h2 class="section-title"><i class="fas fa-table"></i> Danh sách người dùng</h2>
                <div class="table-container">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Vai trò</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                                
                                if (allUsers != null && !allUsers.isEmpty()) {
                                    int regularUserCount = 0;
                                    int adminUserCount = 0;
                                    
                                    for (User user : allUsers) {
                                        if (user.getRole() == 1) regularUserCount++;
                                        if (user.getRole() == 2) adminUserCount++;
                                        
                                        String roleText = user.getRole() == 2 ? "Admin" : "User";
                                        String roleClass = user.getRole() == 2 ? "role-admin" : "role-user";
                            %>
                            <tr>
                                <td><%= user.getId() %></td>
                                <td class="user-name">
                                    <%= user.getName() %>
                                </td>
                                <td class="user-email">
                                    <%= user.getEmail() %>
                                </td>
                                <td class="user-phone">
                                    <%= user.getPhone() != null ? user.getPhone() : "N/A" %>
                                </td>
                                <td>
                                    <span class="role-badge <%= roleClass %>"><%= roleText %></span>
                                </td>
                                <td class="actions">
                                    <button onclick="editUser(this)" 
                                            data-id="<%= user.getId() %>"
                                            data-name="<%= user.getName() %>"
                                            data-email="<%= user.getEmail() %>"
                                            data-phone="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                            data-role="<%= user.getRole() %>"
                                            class="btn-action btn-edit" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="viewHistory(this)" 
                                            data-id="<%= user.getId() %>"
                                            class="btn-action btn-view" title="Xem lịch sử đặt vé">
                                        <i class="fas fa-history"></i>
                                    </button>
                                    <button onclick="deleteUser(this)" 
                                            data-id="<%= user.getId() %>"
                                            data-name="<%= user.getName() %>"
                                            class="btn-action btn-delete" title="Xóa">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                            %>
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    document.getElementById('regularUserCount').textContent = '<%= regularUserCount %>';
                                    document.getElementById('adminUserCount').textContent = '<%= adminUserCount %>';
                                });
                            </script>
                            <%
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="no-data">
                                    <i class="fas fa-box-open"></i> Không có người dùng nào được tìm thấy
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle"><i class="fas fa-user-plus"></i> Thêm người dùng mới</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            
            <form id="userForm" action="quanLyUserServlet" method="post">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="userId">
                
                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name"><i class="fas fa-user"></i> Họ và tên:</label>
                            <input type="text" name="name" id="name" required placeholder="Nguyễn Văn A">
                        </div>
                        
                        <div class="form-group">
                            <label for="email"><i class="fas fa-envelope"></i> Email:</label>
                            <input type="email" name="email" id="email" required placeholder="user@example.com">
                        </div>
                        
                        <div class="form-group" id="passwordGroup">
                            <label for="password"><i class="fas fa-lock"></i> Mật khẩu:</label>
                            <input type="password" name="password" id="password" placeholder="Tối thiểu 6 ký tự">
                        </div>
                        
                        <div class="form-group">
                            <label for="phone"><i class="fas fa-phone"></i> Số điện thoại:</label>
                            <input type="tel" name="phone" id="phone" placeholder="0987654321">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="role"><i class="fas fa-id-badge"></i> Vai trò:</label>
                            <select name="role" id="role" required>
                                <option value="1">User</option>
                                <option value="2">Admin</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" onclick="closeModal()" class="btn btn-modal btn-cancel"><i class="fas fa-times"></i> Hủy</button>
                    <button type="submit" class="btn btn-modal btn-save"><i class="fas fa-save"></i> Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <div id="deleteModal" class="modal">
        <div class="modal-content small">
            <div class="modal-header">
                <h2><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h2>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa người dùng <strong id="deleteUserName"></strong>?</p>
                <p class="warning"><i class="fas fa-skull-crossbones"></i> Hành động này không thể hoàn tác!</p>
            </div>
            
            <div class="modal-footer">
                <button type="button" onclick="closeDeleteModal()" class="btn btn-modal btn-cancel"><i class="fas fa-times"></i> Hủy</button>
                <button type="button" onclick="confirmDelete()" class="btn btn-modal btn-delete-confirm"><i class="fas fa-trash-alt"></i> Xóa</button>
            </div>
        </div>
    </div>

    <script>
        let deleteId = null;
        let deleteUserNameGlobal = '';

        // Modal functions
        function showAddModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-user-plus"></i> Thêm người dùng mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('userId').value = '';
            document.getElementById('userForm').reset();
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = true;
            document.getElementById('userModal').style.display = 'flex'; // Use flex for better centering
        }

        function editUser(button) {
            // Read data from button's data attributes
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const email = button.getAttribute('data-email');
            const phone = button.getAttribute('data-phone');
            const role = button.getAttribute('data-role');
            
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa người dùng';
            document.getElementById('formAction').value = 'update';
            document.getElementById('userId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('email').value = email;
            document.getElementById('phone').value = phone;
            document.getElementById('role').value = role;
            
            // Hide password field for edit, and make it not required
            document.getElementById('passwordGroup').style.display = 'none';
            document.getElementById('password').required = false;
            
            document.getElementById('userModal').style.display = 'flex';
        }

        function deleteUser(button) {
            deleteId = button.getAttribute('data-id');
            deleteUserNameGlobal = button.getAttribute('data-name');
            document.getElementById('deleteUserName').textContent = deleteUserNameGlobal;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        function confirmDelete() {
            if (deleteId) {
                // Sử dụng phương thức POST để đảm bảo an toàn, thay vì GET
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'quanLyUserServlet';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = deleteId;
                form.appendChild(idInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        function viewHistory(button) {
            const id = button.getAttribute('data-id');
            // Chuyển hướng đến servlet để xem lịch sử
            window.location.href = 'quanLyUserServlet?action=viewHistory&id=' + id;
        }

        function closeModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            deleteId = null;
            deleteUserNameGlobal = '';
        }

        // Logic resetSearch không được sử dụng trong giao diện mới này vì không có form tìm kiếm
        // function resetSearch() {
        //     window.location.href = 'quanLyUserServlet?action=open';
        // }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const userModal = document.getElementById('userModal');
            const deleteModal = document.getElementById('deleteModal');
            
            if (event.target == userModal) {
                closeModal();
            }
            if (event.target == deleteModal) {
                closeDeleteModal();
            }
        }

        // Form validation
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const isAdd = document.getElementById('formAction').value === 'add';
            
            // Email validation (basic check for '@' and length)
            if (!email || email.length < 5 || !email.includes('@') || !email.includes('.')) {
                e.preventDefault();
                alert('❌ Email không hợp lệ hoặc bị bỏ trống!');
                return false;
            }
            
            // Password validation for add action
            if (isAdd && (!password || password.length < 6)) {
                e.preventDefault();
                alert('❌ Mật khẩu phải có ít nhất 6 ký tự và không được bỏ trống!');
                return false;
            }
            
            return true;
        });

        // Auto-hide messages after 5 seconds
        setTimeout(function() {
            const messages = document.querySelectorAll('.message');
            messages.forEach(function(message) {
                message.style.opacity = '0';
                setTimeout(function() {
                    message.style.display = 'none';
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>