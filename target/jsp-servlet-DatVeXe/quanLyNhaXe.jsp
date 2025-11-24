<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.bean.NhaXe" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhà Xe - Admin Panel</title>
    <link rel="stylesheet" href="style/dashboardAdmin.css">
    <link rel="stylesheet" href="style/quanLyNhaXe.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="logo">
                <h2>🚌 Admin</h2>
            </div>
            <ul class="nav-menu">
                <li><a href="dashboardServlet">📊 Dashboard</a></li>
                <li><a href="quanLyUserServlet">👥 Quản lý Users</a></li>
                <li><a href="quanLyChuyenXeAdminServlet">🚌 Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet" class="active">🏢 Quản lý Nhà xe</a></li>
                <li><a href="quanLyChuyenXeServlet">👁️ Xem trang User</a></li>
                <li><a href="dangXuatServlet">🚪 Đăng xuất</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>🏢 Quản lý Nhà xe</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn btn-primary">
                        ➕ Thêm nhà xe mới
                    </button>
                </div>
            </header>

            <!-- Success/Error Messages -->
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    ✅ <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <!-- Table Section -->
            <div class="table-section">
                <h2>📋 Danh sách nhà xe</h2>
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
                                        ✏️ Sửa
                                    </button>
                                    <button onclick="deleteNhaXe(this)" 
                                            data-id="<%= nhaXe.getId() %>"
                                            data-tenNhaXe="<%= nhaXe.getTenNhaXe() %>"
                                            class="btn btn-danger" title="Xóa">
                                        🗑️ Xóa
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-state">
                                    <h3>📭 Chưa có nhà xe nào</h3>
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

    <!-- Add/Edit NhaXe Modal -->
    <div id="nhaXeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">➕ Thêm nhà xe mới</h3>
                <span class="close-btn" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="nhaXeForm" action="quanLyNhaXeServlet" method="post">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="nhaXeId" value="">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="tenNhaXe">Tên nhà xe *</label>
                            <input type="text" id="tenNhaXe" name="tenNhaXe" required>
                        </div>
                        <div class="form-group">
                            <label for="diaChi">Địa chỉ *</label>
                            <input type="text" id="diaChi" name="diaChi" required>
                        </div>
                        <div class="form-group">
                            <label for="sdt">Số điện thoại *</label>
                            <input type="text" id="sdt" name="sdt" required>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-danger" onclick="closeModal()">Hủy</button>
                        <button type="submit" class="btn btn-primary" id="submitBtn">Thêm nhà xe</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3>⚠️ Xác nhận xóa</h3>
                <span class="close-btn" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa nhà xe "<span id="deleteNhaXeName"></span>"?</p>
                <p><small style="color: #ef4444;">⚠️ Hành động này không thể hoàn tác!</small></p>
                <form id="deleteForm" action="quanLyNhaXeServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteNhaXeId" value="">
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary" onclick="closeDeleteModal()">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xác nhận xóa</button>
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
            
            document.getElementById('modalTitle').textContent = '✏️ Chỉnh sửa nhà xe';
            document.getElementById('formAction').value = 'update';
            document.getElementById('submitBtn').textContent = 'Cập nhật';
            document.getElementById('nhaXeId').value = id;
            
            // Fill form
            document.getElementById('tenNhaXe').value = tenNhaXe;
            document.getElementById('diaChi').value = diaChi;
            document.getElementById('sdt').value = sdt;
            
            document.getElementById('nhaXeModal').style.display = 'block';
        }

        function showAddModal() {
            document.getElementById('modalTitle').textContent = '➕ Thêm nhà xe mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('submitBtn').textContent = 'Thêm nhà xe';
            document.getElementById('nhaXeId').value = '';
            
            // Clear form
            document.getElementById('tenNhaXe').value = '';
            document.getElementById('diaChi').value = '';
            document.getElementById('sdt').value = '';
            
            document.getElementById('nhaXeModal').style.display = 'block';
        }

        function deleteNhaXe(button) {
            deleteId = button.getAttribute('data-id');
            deleteNhaXeNameGlobal = button.getAttribute('data-tenNhaXe');
            
            document.getElementById('deleteNhaXeId').value = deleteId;
            document.getElementById('deleteNhaXeName').textContent = deleteNhaXeNameGlobal;
            document.getElementById('deleteModal').style.display = 'block';
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
            const successMessages = document.querySelectorAll('.success-message');
            const errorMessages = document.querySelectorAll('.error-message');
            
            successMessages.forEach(function(message) {
                message.style.opacity = '0';
                setTimeout(function() {
                    message.style.display = 'none';
                }, 300);
            });
            
            errorMessages.forEach(function(message) {
                message.style.opacity = '0';
                setTimeout(function() {
                    message.style.display = 'none';
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>