<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Hệ thống đặt vé xe</title>
    <link rel="stylesheet" href="style/dashboardAdmin.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="logo">
                <h2>🚌 Admin</h2>
            </div>
            <ul class="nav-menu">
                <li><a href="dashboardServlet" class="active">📊 Dashboard</a></li>
                <li><a href="quanLyUserServlet">👥 Quản lý Users</a></li>
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
                <h1>📊 Dashboard</h1>
                <div class="user-info">
                    <%
                        String adminName = (String) request.getAttribute("adminName");
                        if (adminName == null) {
                            adminName = (String) session.getAttribute("email");
                        }
                        if (adminName == null) {
                            adminName = "Admin";
                        }
                    %>
                    Xin chào: <strong><%= adminName %></strong>
                    <span class="current-time" id="currentTime"></span>
                </div>
            </header>

            <!-- Error/Success Messages -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    ✅ <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <!-- Dashboard Stats -->
            <div class="dashboard-stats">
                <div class="stat-card trips">
                    <div class="stat-icon">🚌</div>
                    <div class="stat-info">
                        <h3>Tổng chuyến xe</h3>
                        <p class="stat-number">
                            <%= request.getAttribute("numberOfChuyenXe") != null ? request.getAttribute("numberOfChuyenXe") : 0 %>
                        </p>
                        <span class="stat-trend">📈 Hoạt động</span>
                    </div>
                </div>
                
                <div class="stat-card companies">
                    <div class="stat-icon">🏢</div>
                    <div class="stat-info">
                        <h3>Nhà xe</h3>
                        <p class="stat-number">
                            <%= request.getAttribute("numberOfNhaXe") != null ? request.getAttribute("numberOfNhaXe") : 0 %>
                        </p>
                        <span class="stat-trend">🤝 Đối tác</span>
                    </div>
                </div>
                
                <div class="stat-card users">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <h3>Người dùng</h3>
                        <p class="stat-number">
                            <%= request.getAttribute("numberOfUsers") != null ? request.getAttribute("numberOfUsers") : 0 %>
                        </p>
                        <span class="stat-trend">👤 Khách hàng</span>
                    </div>
                </div>
                
                <div class="stat-card bookings">
                    <div class="stat-icon">🎫</div>
                    <div class="stat-info">
                        <h3>Vé hôm nay</h3>
                        <p class="stat-number">
                            <%= request.getAttribute("todayBookings") != null ? request.getAttribute("todayBookings") : 0 %>
                        </p>
                        <span class="stat-trend">📅 Hôm nay</span>
                    </div>
                </div>
                
                <div class="stat-card revenue">
                    <div class="stat-icon">💰</div>
                    <div class="stat-info">
                        <h3>Doanh thu hôm nay</h3>
                        <p class="stat-number revenue-number">
                            <%= request.getAttribute("formattedRevenue") != null ? request.getAttribute("formattedRevenue") : "0" %> VNĐ
                        </p>
                        <span class="stat-trend">💵 Thu nhập</span>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h2>🚀 Thao tác nhanh</h2>
                <div class="action-grid">
                    <a href="quanLyChuyenXeServlet" class="action-btn user-view">
                        <span class="action-icon">👁️</span>
                        <div class="action-content">
                            <h4>Xem trang User</h4>
                            <p>Kiểm tra giao diện người dùng</p>
                        </div>
                    </a>
                    
                    <a href="quanLyChuyenXeAdminServlet" class="action-btn add-trip">
                        <span class="action-icon">➕</span>
                        <div class="action-content">
                            <h4>Quản lý chuyến xe</h4>
                            <p>Thêm, sửa, xóa chuyến xe</p>
                        </div>
                    </a>
                    
                    <a href="quanLyNhaXeServlet" class="action-btn manage-company">
                        <span class="action-icon">🏢</span>
                        <div class="action-content">
                            <h4>Quản lý nhà xe</h4>
                            <p>Thông tin đối tác vận tải</p>
                        </div>
                    </a>
                    
                    <a href="quanLyUserServlet" class="action-btn manage-users">
                        <span class="action-icon">👥</span>
                        <div class="action-content">
                            <h4>Quản lý users</h4>
                            <p>Tài khoản và phân quyền</p>
                        </div>
                    </a>
                    
                    <a href="quanLyChuyenXeHoanThanhServlet" class="action-btn completed-trips">
                        <span class="action-icon">✅</span>
                        <div class="action-content">
                            <h4>Chuyến đã hoàn thành</h4>
                            <p>Lịch sử và báo cáo</p>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="recent-activity">
                <h2>📈 Hoạt động gần đây</h2>
                <div class="activity-list">
                    <div class="activity-item">
                        <span class="activity-icon">🎫</span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Có <%= request.getAttribute("todayBookings") != null ? request.getAttribute("todayBookings") : 0 %> vé được đặt hôm nay
                            </span>
                            <span class="activity-time">Cập nhật liên tục</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon">💰</span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Doanh thu hôm nay: <%= request.getAttribute("formattedRevenue") != null ? request.getAttribute("formattedRevenue") : "0" %> VNĐ
                            </span>
                            <span class="activity-time">Thống kê realtime</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon">🚌</span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Hệ thống có <%= request.getAttribute("numberOfChuyenXe") != null ? request.getAttribute("numberOfChuyenXe") : 0 %> chuyến xe đang hoạt động
                            </span>
                            <span class="activity-time">Tổng quan</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon">👥</span>
                        <div class="activity-content">
                            <span class="activity-text">
                                <%= request.getAttribute("numberOfUsers") != null ? request.getAttribute("numberOfUsers") : 0 %> người dùng đã đăng ký
                            </span>
                            <span class="activity-time">Tổng cộng</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Info -->
            <div class="system-info">
                <h2>ℹ️ Thông tin hệ thống</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">🌐 Trạng thái hệ thống:</span>
                        <span class="info-value status-online">Hoạt động</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">📅 Ngày cập nhật:</span>
                        <span class="info-value" id="currentDate"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">👨‍💼 Quản trị viên:</span>
                        <span class="info-value"><%= adminName %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">🔧 Phiên bản:</span>
                        <span class="info-value">v1.0.0</span>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Cập nhật thời gian real-time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('vi-VN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            
            document.getElementById('currentTime').textContent = timeString;
            
            const dateString = now.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            
            const dateElement = document.getElementById('currentDate');
            if (dateElement) {
                dateElement.textContent = dateString;
            }
        }

        // Cập nhật thời gian mỗi giây
        setInterval(updateTime, 1000);
        updateTime(); // Gọi ngay khi load trang

        // Animation cho stats cards
        document.addEventListener('DOMContentLoaded', function() {
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Refresh dashboard mỗi 5 phút
        setInterval(() => {
            window.location.reload();
        }, 300000); // 5 phút = 300000ms
    </script>
</body>
</html>