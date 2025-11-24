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
    <title>Quản lý người dùng - Admin</title>
    <link rel="stylesheet" href="style/dashboardAdmin.css">
    <link rel="stylesheet" href="style/quanLyUser.css">
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
                <li><a href="quanLyUserServlet" class="active">👥 Quản lý Users</a></li>
                <li><a href="quanLyChuyenXeAdminServlet">🚌 Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet">🏢 Quản lý Nhà xe</a></li>
                <li><a href="quanLyChuyenXeServlet">👁️ Xem trang User</a></li>
                <li><a href="dangXuatServlet">🚪 Đăng xuất</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>👥 Quản lý người dùng</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn-primary">
                        ➕ Thêm người dùng
                    </button>
                    <a href="dashboardServlet" class="btn-secondary">
                        🔙 Quay lại Dashboard
                    </a>
                </div>
            </header>

            <!-- Messages -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    ✅ <%= session.getAttribute("successMessage") %>
                </div>
                <%
                    session.removeAttribute("successMessage");
                %>
            <% } %>

            <% if (request.getAttribute("searchMessage") != null) { %>
                <div class="info-message">
                    ℹ️ <%= request.getAttribute("searchMessage") %>
                </div>
            <% } %>

            <!-- Statistics Cards -->
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <h3>Tổng người dùng</h3>
                        <p class="stat-number"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card active">
                    <div class="stat-icon">👤</div>
                    <div class="stat-info">
                        <h3>User thường</h3>
                        <p class="stat-number" id="regularUserCount">0</p>
                    </div>
                </div>
                
                <div class="stat-card admin">
                    <div class="stat-icon">👨‍💼</div>
                    <div class="stat-info">
                        <h3>Admin</h3>
                        <p class="stat-number" id="adminUserCount">0</p>
                    </div>
                </div>
            </div>


            <!-- Users Table -->
            <div class="table-section">
                <h2>📋 Danh sách người dùng</h2>
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
                                    <strong><%= user.getName() %></strong>
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
                                            class="btn-edit" title="Chỉnh sửa">
                                        ✏️
                                    </button>
                                    <button onclick="viewHistory(this)" 
                                            data-id="<%= user.getId() %>"
                                            class="btn-view" title="Xem lịch sử">
                                        📜
                                    </button>
                                    <button onclick="deleteUser(this)" 
                                            data-id="<%= user.getId() %>"
                                            data-name="<%= user.getName() %>"
                                            class="btn-delete" title="Xóa">
                                        🗑️
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                            %>
                            <script>
                                document.getElementById('regularUserCount').textContent = '<%= regularUserCount %>';
                                document.getElementById('adminUserCount').textContent = '<%= adminUserCount %>';
                            </script>
                            <%
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="no-data">
                                    📭 Không có người dùng nào
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit User Modal -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">➕ Thêm người dùng mới</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            
            <form id="userForm" action="quanLyUserServlet" method="post">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="userId">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">👤 Họ và tên:</label>
                        <input type="text" name="name" id="name" required placeholder="Nguyễn Văn A">
                    </div>
                    
                    <div class="form-group">
                        <label for="email">📧 Email:</label>
                        <input type="email" name="email" id="email" required placeholder="user@example.com">
                    </div>
                    
                    <div class="form-group" id="passwordGroup">
                        <label for="password">🔒 Mật khẩu:</label>
                        <input type="password" name="password" id="password" placeholder="Tối thiểu 6 ký tự">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">📱 Số điện thoại:</label>
                        <input type="tel" name="phone" id="phone" placeholder="0987654321">
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="role">🎭 Vai trò:</label>
                        <select name="role" id="role" required>
                            <option value="1">User</option>
                            <option value="2">Admin</option>
                        </select>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" onclick="closeModal()" class="btn-cancel">❌ Hủy</button>
                    <button type="submit" class="btn-save">💾 Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content small">
            <div class="modal-header">
                <h2>⚠️ Xác nhận xóa</h2>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa người dùng <strong id="deleteUserName"></strong>?</p>
                <p class="warning">⚠️ Hành động này không thể hoàn tác!</p>
            </div>
            
            <div class="modal-footer">
                <button type="button" onclick="closeDeleteModal()" class="btn-cancel">❌ Hủy</button>
                <button type="button" onclick="confirmDelete()" class="btn-delete-confirm">🗑️ Xóa</button>
            </div>
        </div>
    </div>

    <script>
        let deleteId = null;
        let deleteUserNameGlobal = '';

        // Modal functions
        function showAddModal() {
            document.getElementById('modalTitle').textContent = '➕ Thêm người dùng mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('userId').value = '';
            document.getElementById('userForm').reset();
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = true;
            document.getElementById('userModal').style.display = 'block';
        }

        function editUser(button) {
            // Read data from button's data attributes
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const email = button.getAttribute('data-email');
            const phone = button.getAttribute('data-phone');
            const role = button.getAttribute('data-role');
            
            document.getElementById('modalTitle').textContent = '✏️ Chỉnh sửa người dùng';
            document.getElementById('formAction').value = 'update';
            document.getElementById('userId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('email').value = email;
            document.getElementById('phone').value = phone;
            document.getElementById('role').value = role;
            
            // Hide password field for edit
            document.getElementById('passwordGroup').style.display = 'none';
            document.getElementById('password').required = false;
            
            document.getElementById('userModal').style.display = 'block';
        }

        function deleteUser(button) {
            deleteId = button.getAttribute('data-id');
            deleteUserNameGlobal = button.getAttribute('data-name');
            document.getElementById('deleteUserName').textContent = deleteUserNameGlobal;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function confirmDelete() {
            if (deleteId) {
                window.location.href = 'quanLyUserServlet?action=delete&id=' + deleteId;
            }
        }

        function viewHistory(button) {
            const id = button.getAttribute('data-id');
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

        function resetSearch() {
            document.getElementById('searchForm').reset();
            window.location.href = 'quanLyUserServlet?action=open';
        }

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
            
            // Email validation
            if (!email.includes('@')) {
                e.preventDefault();
                alert('❌ Email không hợp lệ!');
                return false;
            }
            
            // Password validation for add action
            if (isAdd && password.length < 6) {
                e.preventDefault();
                alert('❌ Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
            
            return true;
        });

        // Auto-hide messages after 5 seconds
        setTimeout(function() {
            const messages = document.querySelectorAll('.error-message, .success-message, .info-message');
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