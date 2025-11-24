<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="model.bean.DiaDiem" %>
<%@ page import="model.bean.NhaXe" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý chuyến xe - Admin</title>
    <link rel="stylesheet" href="style/dashboardAdmin.css">
    <link rel="stylesheet" href="style/quanLyChuyenXe.css">
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
                <li><a href="quanLyChuyenXeAdminServlet" class="active">🚌 Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet">🏢 Quản lý Nhà xe</a></li>
                <li><a href="quanLyChuyenXeServlet">👁️ Xem trang User</a></li>
                <li><a href="dangXuatServlet">🚪 Đăng xuất</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>🚌 Quản lý chuyến xe</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn-primary">
                        ➕ Thêm chuyến xe
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
                    <div class="stat-icon">🚌</div>
                    <div class="stat-info">
                        <h3>Tổng chuyến xe</h3>
                        <p class="stat-number"><%= request.getAttribute("totalTrips") != null ? request.getAttribute("totalTrips") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card active">
                    <div class="stat-icon">🚀</div>
                    <div class="stat-info">
                        <h3>Đang hoạt động</h3>
                        <p class="stat-number"><%= request.getAttribute("activeTrips") != null ? request.getAttribute("activeTrips") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card completed">
                    <div class="stat-icon">✅</div>
                    <div class="stat-info">
                        <h3>Đã hoàn thành</h3>
                        <p class="stat-number"><%= request.getAttribute("completedTrips") != null ? request.getAttribute("completedTrips") : 0 %></p>
                    </div>
                </div>
            </div>

            <!-- Search/Filter Section -->
            <div class="filter-section">
                <h2>🔍 Tìm kiếm và lọc</h2>
                <form id="searchForm" action="quanLyChuyenXeAdminServlet" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="search-group">
                        <label>🚩 Từ:</label>
                        <select name="tuNoi">
                            <option value="">-- Chọn điểm đi --</option>
                            <%
                                List<DiaDiem> listDiaDiem = (List<DiaDiem>) request.getAttribute("allDiaDiem");
                                Integer selectedTuNoi = (Integer) request.getAttribute("selectedTuNoi");
                                
                                if (listDiaDiem != null) {
                                    for (DiaDiem diaDiem : listDiaDiem) {
                                        boolean isSelected = selectedTuNoi != null && selectedTuNoi.equals(diaDiem.getId());
                            %>
                            <option value="<%= diaDiem.getId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= diaDiem.getTenTinh() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="search-group">
                        <label>🏁 Đến:</label>
                        <select name="denNoi">
                            <option value="">-- Chọn điểm đến --</option>
                            <%
                                Integer selectedDenNoi = (Integer) request.getAttribute("selectedDenNoi");
                                
                                if (listDiaDiem != null) {
                                    for (DiaDiem diaDiem : listDiaDiem) {
                                        boolean isSelected = selectedDenNoi != null && selectedDenNoi.equals(diaDiem.getId());
                            %>
                            <option value="<%= diaDiem.getId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= diaDiem.getTenTinh() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="search-group">
                        <label>📅 Ngày đi:</label>
                        <%
                            String selectedNgayDi = (String) request.getAttribute("selectedNgayDi");
                        %>
                        <input type="date" name="ngayDi" value="<%= selectedNgayDi != null ? selectedNgayDi : "" %>">
                    </div>
                    
                    <div class="search-actions">
                        <button type="submit" class="btn-search">🔍 Tìm kiếm</button>
                        <button type="button" onclick="resetSearch()" class="btn-reset">🔄 Xóa bộ lọc</button>
                    </div>
                </form>
            </div>

            <!-- Trips Table -->
            <div class="table-section">
                <h2>📋 Danh sách chuyến xe</h2>
                <div class="table-container">
                    <table class="trips-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tuyến đường</th>
                                <th>Giờ khởi hành</th>
                                <th>Giá vé</th>
                                <th>Số chỗ</th>
                                <th>Biển số xe</th>
                                <th>Nhà xe</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<ChuyenXe> allChuyenXe = (List<ChuyenXe>) request.getAttribute("allChuyenXe");
                                NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
                                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                
                                if (allChuyenXe != null && !allChuyenXe.isEmpty()) {
                                    for (ChuyenXe chuyenXe : allChuyenXe) {
                                        // Xác định trạng thái
                                        String status = "";
                                        String statusClass = "";
                                        if (chuyenXe.getGioKhoiHanh().isBefore(java.time.LocalDateTime.now())) {
                                            status = "Đã khởi hành";
                                            statusClass = "status-completed";
                                        } else if (chuyenXe.getSoCho() == 0) {
                                            status = "Hết chỗ";
                                            statusClass = "status-full";
                                        } else {
                                            status = "Hoạt động";
                                            statusClass = "status-active";
                                        }
                            %>
                            <tr>
                                <td><%= chuyenXe.getId() %></td>
                                <td class="route-info">
                                    <strong><%= chuyenXe.getTenDiemDi() %></strong>
                                    <span class="arrow">→</span>
                                    <strong><%= chuyenXe.getTenDiemDen() %></strong>
                                </td>
                                <td class="datetime">
                                    <%= chuyenXe.getGioKhoiHanh().format(dateFormatter) %>
                                </td>
                                <td class="price">
                                    <%= formatter.format(chuyenXe.getGia()) %> VNĐ
                                </td>
                                <td class="seats">
                                    <span class="seat-count"><%= chuyenXe.getSoCho() %></span>
                                </td>
                                <td class="license-plate">
                                    <%= chuyenXe.getBienSoXe() %>
                                </td>
                                <td class="company">
                                    <%= chuyenXe.getTenNhaXe() %>
                                </td>
                                <td>
                                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                                </td>
                                <td class="actions">
                                    <%
                                        // Prepare safe values for data attributes
                                        String safeDateTime = chuyenXe.getGioKhoiHanh().toString().replace("T", " ");
                                        String safeBienSo = chuyenXe.getBienSoXe().replace("'", "&apos;");
                                        String safeGia = chuyenXe.getGia().toString();
                                    %>
                                    <button onclick="editTrip(this)" 
                                            data-id="<%= chuyenXe.getId() %>"
                                            data-tu-noi="<%= chuyenXe.getTuNoi() %>"
                                            data-den-noi="<%= chuyenXe.getDenNoi() %>"
                                            data-gio-khoi-hanh="<%= safeDateTime %>"
                                            data-gia="<%= safeGia %>"
                                            data-so-cho="<%= chuyenXe.getSoCho() %>"
                                            data-bien-so-xe="<%= safeBienSo %>"
                                            data-nha-xe-id="<%= chuyenXe.getNhaXeId() %>"
                                            class="btn-edit" title="Chỉnh sửa">
                                        ✏️
                                    </button>
                                    <button onclick="viewCustomers(this)" 
                                            data-id="<%= chuyenXe.getId() %>"
                                            class="btn-view" title="Xem khách hàng">
                                        👥
                                    </button>
                                    <button onclick="deleteTrip(this)" 
                                            data-id="<%= chuyenXe.getId() %>"
                                            class="btn-delete" title="Xóa">
                                        🗑️
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="no-data">
                                    📭 Không có chuyến xe nào
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit Modal -->
    <div id="tripModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">➕ Thêm chuyến xe mới</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            
            <form id="tripForm" action="quanLyChuyenXeAdminServlet" method="post">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="tripId">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="tuNoi">🚩 Điểm đi:</label>
                        <select name="tuNoi" id="tuNoi" required>
                            <option value="">-- Chọn điểm đi --</option>
                            <%
                                if (listDiaDiem != null) {
                                    for (DiaDiem diaDiem : listDiaDiem) {
                            %>
                            <option value="<%= diaDiem.getId() %>"><%= diaDiem.getTenTinh() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="denNoi">🏁 Điểm đến:</label>
                        <select name="denNoi" id="denNoi" required>
                            <option value="">-- Chọn điểm đến --</option>
                            <%
                                if (listDiaDiem != null) {
                                    for (DiaDiem diaDiem : listDiaDiem) {
                            %>
                            <option value="<%= diaDiem.getId() %>"><%= diaDiem.getTenTinh() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="gioKhoiHanh">⏰ Giờ khởi hành:</label>
                        <input type="datetime-local" name="gioKhoiHanh" id="gioKhoiHanh" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="gia">💰 Giá vé (VNĐ):</label>
                        <input type="number" name="gia" id="gia" min="1000" step="1000" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="soCho">🪑 Số chỗ:</label>
                        <input type="number" name="soCho" id="soCho" min="1" max="50" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="bienSoXe">🚌 Biển số xe:</label>
                        <input type="text" name="bienSoXe" id="bienSoXe" placeholder="VD: 29A-12345" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="nhaXeId">🏢 Nhà xe:</label>
                        <select name="nhaXeId" id="nhaXeId" required>
                            <option value="">-- Chọn nhà xe --</option>
                            <%
                                List<NhaXe> allNhaXe = (List<NhaXe>) request.getAttribute("allNhaXe");
                                if (allNhaXe != null) {
                                    for (NhaXe nhaXe : allNhaXe) {
                            %>
                            <option value="<%= nhaXe.getId() %>"><%= nhaXe.getTenNhaXe() %></option>
                            <%
                                    }
                                }
                            %>
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
                <p>Bạn có chắc chắn muốn xóa chuyến xe này?</p>
                <p class="warning">⚠️ Hành động này không thể hoàn tác!</p>
            </div>
            
            <div class="modal-footer">
                <button type="button" onclick="closeDeleteModal()" class="btn-cancel">❌ Hủy</button>
                <button type="button" onclick="confirmDelete()" class="btn-delete-confirm">🗑️ Xóa</button>
                <script>
                    let deleteId = null;
            
                    // Modal functions
                    function showAddModal() {
                        document.getElementById('modalTitle').textContent = '➕ Thêm chuyến xe mới';
                        document.getElementById('formAction').value = 'add';
                        document.getElementById('tripId').value = '';
                        document.getElementById('tripForm').reset();
                        document.getElementById('tripModal').style.display = 'block';
                    }
            
                    function editTrip(button) {
                        // Read data from button's data attributes
                        const id = button.getAttribute('data-id');
                        const tuNoi = button.getAttribute('data-tu-noi');
                        const denNoi = button.getAttribute('data-den-noi');
                        const gioKhoiHanh = button.getAttribute('data-gio-khoi-hanh');
                        const gia = button.getAttribute('data-gia');
                        const soCho = button.getAttribute('data-so-cho');
                        const bienSoXe = button.getAttribute('data-bien-so-xe');
                        const nhaXeId = button.getAttribute('data-nha-xe-id');
                        
                        document.getElementById('modalTitle').textContent = '✏️ Chỉnh sửa chuyến xe';
                        document.getElementById('formAction').value = 'update';
                        document.getElementById('tripId').value = id;
                        document.getElementById('tuNoi').value = tuNoi;
                        document.getElementById('denNoi').value = denNoi;
                        
                        // Convert datetime format from "2024-01-01 10:00" to "2024-01-01T10:00"
                        const dateTime = gioKhoiHanh.replace(' ', 'T');
                        document.getElementById('gioKhoiHanh').value = dateTime;
                        
                        document.getElementById('gia').value = gia;
                        document.getElementById('soCho').value = soCho;
                        document.getElementById('bienSoXe').value = bienSoXe;
                        document.getElementById('nhaXeId').value = nhaXeId;
                        
                        document.getElementById('tripModal').style.display = 'block';
                    }
            
                    function deleteTrip(button) {
                        deleteId = button.getAttribute('data-id');
                        document.getElementById('deleteModal').style.display = 'block';
                    }
            
                    function confirmDelete() {
                        if (deleteId) {
                            window.location.href = 'quanLyChuyenXeAdminServlet?action=delete&id=' + deleteId;
                        }
                    }
            
                    function viewCustomers(button) {
                        const id = button.getAttribute('data-id');
                        window.location.href = 'xemKhachHangTungChuyenServlet?chuyenXeId=' + id;
                    }
            
                    function closeModal() {
                        document.getElementById('tripModal').style.display = 'none';
                    }
            
                    function closeDeleteModal() {
                        document.getElementById('deleteModal').style.display = 'none';
                        deleteId = null;
                    }
            
                    function resetSearch() {
                        document.getElementById('searchForm').reset();
                        window.location.href = 'quanLyChuyenXeAdminServlet?action=list';
                    }
            
                    // Close modal when clicking outside
                    window.onclick = function(event) {
                        const tripModal = document.getElementById('tripModal');
                        const deleteModal = document.getElementById('deleteModal');
                        
                        if (event.target == tripModal) {
                            closeModal();
                        }
                        if (event.target == deleteModal) {
                            closeDeleteModal();
                        }
                    }
            
                    // Form validation
                    document.getElementById('tripForm').addEventListener('submit', function(e) {
                        const tuNoi = document.getElementById('tuNoi').value;
                        const denNoi = document.getElementById('denNoi').value;
                        
                        if (tuNoi === denNoi) {
                            e.preventDefault();
                            alert('❌ Điểm đi và điểm đến không được giống nhau!');
                            return false;
                        }
                        
                        const gioKhoiHanh = new Date(document.getElementById('gioKhoiHanh').value);
                        const now = new Date();
                        
                        if (gioKhoiHanh <= now) {
                            e.preventDefault();
                            alert('❌ Giờ khởi hành phải sau thời điểm hiện tại!');
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
    </script>
</body>
</html>