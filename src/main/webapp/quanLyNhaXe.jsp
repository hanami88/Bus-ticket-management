<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.bean.NhaXe" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhà Xe - Admin Panel | Hệ thống đặt vé</title>
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
            font-family: 'Inter', sans-serif;
            background-color: var(--color-bg-dark);
            min-height: 100vh;
            color: var(--color-text-dark);
        }

        /* Admin Container Layout */
        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar (Reused from previous themes) */
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
            background-color: transparent;
        }
        
        /* Header */
        .header {
            background-color: var(--color-bg-light);
            padding: 30px 40px;
            border-radius: 15px;
            margin: 0 0 30px 0;
            box-shadow: var(--shadow-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            border: 1px solid #E5E7EB;
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

        .btn-success {
            background-color: var(--color-success);
            color: white;
            padding: 8px 15px;
            font-size: 0.8rem;
            border-radius: 6px;
        }

        .btn-success:hover {
            background-color: #059669;
        }

        .btn-danger {
            background-color: var(--color-danger);
            color: white;
            padding: 8px 15px;
            font-size: 0.8rem;
            border-radius: 6px;
        }

        .btn-danger:hover {
            background-color: #B91C1C;
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
            color: #065F46;
            border-left: 4px solid var(--color-success);
        }

        /* Table Section */
        .table-section {
            background-color: var(--color-bg-light);
            border-radius: 15px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid #E5E7EB;
        }

        .table-section h2 {
            background-color: var(--color-primary);
            color: var(--color-text-light);
            padding: 20px 25px;
            margin: 0;
            font-size: 1.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nhaxe-table {
            width: 100%;
            border-collapse: collapse;
        }

        .nhaxe-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #F9FAFB;
            color: #4B5563;
        }

        .nhaxe-table td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid #E5E7EB;
            font-size: 14px;
        }

        .nhaxe-table tr:hover {
            background: #F9FAFB;
        }

        .nhaxe-id {
            color: var(--color-info);
            font-weight: 600;
            font-family: monospace;
        }

        .nhaxe-name {
            color: var(--color-primary);
            font-weight: 600;
        }

        .actions {
            display: flex;
            gap: 8px;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6B7280;
            background-color: #F9FAFB;
        }
        
        .empty-state h3 {
            margin-top: 10px;
            color: var(--color-text-dark);
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 2000;
            overflow-y: auto;
            align-items: center; /* Center vertically */
            justify-content: center; /* Center horizontally */
        }

        .modal-content {
            background-color: var(--color-bg-light);
            margin: 5% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 550px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            animation: modalFadeIn 0.3s ease-out;
            border: 1px solid #E5E7EB;
        }

        .modal-header {
            padding: 25px 30px;
            background-color: var(--color-primary);
            color: white;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .close-btn {
            font-size: 1.8rem;
            cursor: pointer;
            transition: color 0.2s;
            line-height: 1;
        }

        .close-btn:hover {
            color: var(--color-secondary);
        }

        .modal-body {
            padding: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group label {
            color: var(--color-text-dark);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-group input {
            padding: 12px 15px;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--color-secondary);
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #E5E7EB;
        }
        
        .btn-modal-cancel {
            background-color: #9CA3AF;
            color: white;
        }

        .btn-modal-cancel:hover {
            background-color: #6B7280;
        }

        .btn-modal-save {
            background-color: var(--color-success);
            color: white;
        }

        .btn-modal-save:hover {
            background-color: #059669;
        }

        .btn-modal-delete {
            background-color: var(--color-danger);
            color: white;
        }

        .btn-modal-delete:hover {
            background-color: #B91C1C;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content { margin-left: 0; padding: 20px; }
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }
            .header { flex-direction: column; align-items: flex-start; margin-bottom: 20px; padding: 20px; }
            .header-actions { width: 100%; justify-content: center; }
            .nhaxe-table { min-width: 600px; }
            .table-container { overflow-x: auto; }
            .modal-content { margin: 10% auto; }
            .modal-header, .modal-body { padding: 20px; }
            .form-actions { flex-direction: column-reverse; }
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
                <li><a href="quanLyUserServlet"><i class="fas fa-users"></i> Quản lý Users</a></li>
                <li><a href="quanLyChuyenXeAdminServlet"> <i class="fas fa-bus"></i> Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet" class="active"><i class="fas fa-building"></i> Quản lý Nhà xe</a></li>
                <li><a href="dangXuatServlet"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <header class="header" >
                <h1><i class="fas fa-warehouse"></i> Quản lý Nhà xe</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm nhà xe mới
                    </button>
                </div>
            </header>

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error-message">
                    <i class="fas fa-times-circle"></i> <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <div class="table-section">
                <h2><i class="fas fa-list-alt"></i> Danh sách nhà xe</h2>
                <div class="table-container">
                    <table class="nhaxe-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên nhà xe</th>
                                <th>Địa chỉ</th>
                                <th>Số điện thoại</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<NhaXe> allNhaXe = (List<NhaXe>) request.getAttribute("allNhaXe");
                                if (allNhaXe != null && !allNhaXe.isEmpty()) {
                                    for (NhaXe nhaXe : allNhaXe) {
                            %>
                            <tr>
                                <td class="nhaxe-id">#<%= nhaXe.getId() %></td>
                                <td class="nhaxe-name"><%= nhaXe.getTenNhaXe() %></td>
                                <td><%= nhaXe.getDiaChi() %></td>
                                <td><%= nhaXe.getSoDienThoai() %></td>
                                <td class="actions">
                                    <button onclick="editNhaXe(this)" 
                                            data-id="<%= nhaXe.getId() %>"
                                            data-tenNhaXe="<%= nhaXe.getTenNhaXe() %>"
                                            data-diaChi="<%= nhaXe.getDiaChi() %>"
                                            data-sdt="<%= nhaXe.getSoDienThoai() %>"
                                            class="btn btn-success" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                    <button onclick="deleteNhaXe(this)" 
                                            data-id="<%= nhaXe.getId() %>"
                                            data-tenNhaXe="<%= nhaXe.getTenNhaXe() %>"
                                            class="btn btn-danger" title="Xóa">
                                        <i class="fas fa-trash-alt"></i> Xóa
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-state">
                                    <h3><i class="fas fa-box-open"></i> Chưa có nhà xe nào</h3>
                                    <p>Hãy thêm nhà xe đầu tiên của bạn!</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="nhaXeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle"><i class="fas fa-plus-circle"></i> Thêm nhà xe mới</h3>
                <span class="close-btn" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="nhaXeForm" action="quanLyNhaXeServlet" method="post">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="nhaXeId" value="">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="tenNhaXe"><i class="fas fa-building"></i> Tên nhà xe *</label>
                            <input type="text" id="tenNhaXe" name="tenNhaXe" required placeholder="Tên công ty vận tải">
                        </div>
                        <div class="form-group">
                            <label for="diaChi"><i class="fas fa-map-marker-alt"></i> Địa chỉ *</label>
                            <input type="text" id="diaChi" name="diaChi" required placeholder="Địa chỉ trụ sở chính">
                        </div>
                        <div class="form-group">
                            <label for="sdt"><i class="fas fa-phone"></i> Số điện thoại *</label>
                            <input type="text" id="sdt" name="sdt" required placeholder="Số điện thoại liên hệ">
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-modal-cancel" onclick="closeModal()"><i class="fas fa-times"></i> Hủy</button>
                        <button type="submit" class="btn btn-modal-save" id="submitBtn"><i class="fas fa-save"></i> Thêm nhà xe</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="deleteModal" class="modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h3>
                <span class="close-btn" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa nhà xe **<span id="deleteNhaXeName"></span>**?</p>
                <p><small style="color: var(--color-danger); font-weight: 600;"><i class="fas fa-skull-crossbones"></i> Hành động này không thể hoàn tác và có thể ảnh hưởng đến các chuyến xe liên quan!</small></p>
                <form id="deleteForm" action="quanLyNhaXeServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteNhaXeId" value="">
                    <div class="form-actions">
                        <button type="button" class="btn btn-modal-cancel" onclick="closeDeleteModal()"><i class="fas fa-times"></i> Hủy</button>
                        <button type="submit" class="btn btn-modal-delete"><i class="fas fa-trash-alt"></i> Xác nhận xóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        let deleteId = null;
        let deleteNhaXeNameGlobal = '';
        
        // Modal functions
        function editNhaXe(button) {
            const id = button.getAttribute('data-id');
            const tenNhaXe = button.getAttribute('data-tenNhaXe');
            const diaChi = button.getAttribute('data-diaChi');
            const sdt = button.getAttribute('data-sdt');
            
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa nhà xe';
            document.getElementById('formAction').value = 'update';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Cập nhật';
            document.getElementById('nhaXeId').value = id;
            
            // Fill form
            document.getElementById('tenNhaXe').value = tenNhaXe;
            document.getElementById('diaChi').value = diaChi;
            document.getElementById('sdt').value = sdt;
            
            document.getElementById('nhaXeModal').style.display = 'flex'; // Use flex for centering
        }

        function showAddModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> Thêm nhà xe mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Thêm nhà xe';
            document.getElementById('nhaXeId').value = '';
            
            // Clear form
            document.getElementById('nhaXeForm').reset();
            
            document.getElementById('nhaXeModal').style.display = 'flex';
        }

        function deleteNhaXe(button) {
            deleteId = button.getAttribute('data-id');
            deleteNhaXeNameGlobal = button.getAttribute('data-tenNhaXe');
            
            document.getElementById('deleteNhaXeId').value = deleteId;
            document.getElementById('deleteNhaXeName').textContent = deleteNhaXeNameGlobal;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('nhaXeModal').style.display = 'none';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('nhaXeModal');
            const deleteModal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeModal();
            }
            if (event.target == deleteModal) {
                closeDeleteModal();
            }
        }

        // Auto-hide success/error messages after 5 seconds
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