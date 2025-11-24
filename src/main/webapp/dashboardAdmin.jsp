<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Hệ thống đặt vé xe</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* =================================
             GLOBAL STYLES (New Theme)
             ================================= */
        :root {
            --color-primary: #1F2937; /* Dark Navy/Slate - Main background for sidebar */
            --color-secondary: #FFC107; /* Amber/Gold - Accent color */
            --color-text-dark: #1E293B;
            --color-text-light: #F9FAFB;
            --color-bg-light: #FFFFFF;
            --color-bg-dark: #F3F4F6;
            --color-success: #10B981;
            --color-danger: #EF4444;
            --color-info: #3B82F6;
            --shadow-light: 0 4px 12px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        /* Reset và base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--color-bg-dark);
            color: var(--color-text-dark);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Admin Container */
        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* ==================== SIDEBAR ==================== */
        .sidebar {
            width: 280px;
            background-color: var(--color-primary);
            color: var(--color-text-light);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.15);
        }
        
        .logo {
            text-align: center;
            padding: 30px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            margin-bottom: 20px;
        }
        
        .logo h2 {
            font-size: 1.8em;
            font-weight: 800;
            color: var(--color-secondary);
            margin: 0;
            letter-spacing: 1px;
        }

        .nav-menu {
            list-style: none;
            padding: 0 15px;
        }

        .nav-menu li {
            margin: 8px 0;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            border-left: 5px solid transparent;
        }
        
        .nav-menu a i {
            font-size: 1.2rem;
            width: 20px;
            text-align: center;
        }

        .nav-menu a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--color-text-light);
            border-left-color: var(--color-secondary);
        }

        .nav-menu a.active {
            background-color: rgba(255, 255, 255, 0.15);
            color: var(--color-secondary);
            border-left-color: var(--color-secondary);
            font-weight: 600;
        }

        /* ==================== MAIN CONTENT ==================== */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 0;
            background: var(--color-bg-dark);
            min-height: 100vh;
        }

        /* Header */
        .header {
            background: var(--color-bg-light);
            padding: 25px 40px;
            border-bottom: 1px solid #E5E7EB;
            box-shadow: 0 1px 10px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: var(--color-primary);
            font-size: 2.2em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 15px;
            color: #6B7280;
        }

        .user-info strong {
            color: var(--color-text-dark);
            font-weight: 600;
        }

        .current-time {
            background-color: var(--color-primary);
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(31, 41, 55, 0.3);
        }

        /* ==================== MESSAGES ==================== */
        .message {
            margin: 20px 40px;
            padding: 16px 20px;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: var(--shadow-light);
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

        /* ==================== DASHBOARD STATS ==================== */
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            padding: 30px 40px;
        }

        .stat-card {
            background: var(--color-bg-light);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid #E5E7EB;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
            color: white;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .stat-info {
            text-align: right;
        }

        .stat-info h3 {
            color: #6B7280;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .stat-number {
            font-size: 2.2em;
            font-weight: 800;
            color: var(--color-text-dark);
            line-height: 1.2;
        }

        .stat-trend {
            font-size: 13px;
            color: #6B7280;
            font-weight: 500;
            display: block;
            margin-top: 5px;
        }

        /* Specific stat card colors */
        .stat-card.trips .stat-icon { background: var(--color-info); }
        .stat-card.companies .stat-icon { background: #8B5CF6; } /* Violet */
        .stat-card.users .stat-icon { background: var(--color-secondary); }
        .stat-card.bookings .stat-icon { background: var(--color-success); }
        
        .stat-card.revenue {
            background: var(--color-primary);
        }

        .stat-card.revenue .stat-icon {
            background: rgba(255, 255, 255, 0.2);
            color: var(--color-secondary);
        }

        .stat-card.revenue h3,
        .stat-card.revenue .stat-trend {
            color: rgba(255, 255, 255, 0.8);
        }

        .stat-card.revenue .stat-number {
            color: var(--color-text-light);
        }
        
        .revenue-number {
            font-size: 1.8em !important;
        }


        /* ==================== QUICK ACTIONS ==================== */
        .quick-actions {
            padding: 0 40px 30px;
        }

        .quick-actions h2 {
            color: var(--color-primary);
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .action-btn {
            background: var(--color-bg-light);
            border: 1px solid #E5E7EB;
            border-radius: 12px;
            padding: 20px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-light);
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--color-info);
        }

        .action-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
            color: white;
            flex-shrink: 0;
        }

        .action-content h4 {
            color: var(--color-text-dark);
            font-size: 1.05em;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .action-content p {
            color: #6B7280;
            font-size: 13px;
            line-height: 1.4;
        }

        /* Action button specific colors */
        .action-btn.manage-users .action-icon { background: var(--color-secondary); }
        .action-btn.manage-trips .action-icon { background: var(--color-info); }
        .action-btn.manage-companies .action-icon { background: #8B5CF6; }
        .action-btn.completed-trips .action-icon { background: var(--color-success); }
        .action-btn.logout .action-icon { background: var(--color-danger); }


        /* ==================== RECENT ACTIVITY ==================== */
        .recent-activity {
            padding: 0 40px 30px;
        }

        .recent-activity h2 {
            color: var(--color-primary);
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .activity-list {
            background: var(--color-bg-light);
            border-radius: 15px;
            padding: 25px;
            box-shadow: var(--shadow-md);
            border: 1px solid #E5E7EB;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 15px 0;
            border-bottom: 1px solid #F3F4F6;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            background: #DBEAFE;
            color: var(--color-info);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1em;
            flex-shrink: 0;
        }
        
        .activity-item:nth-child(2) .activity-icon { background: #D1FAE5; color: var(--color-success); }
        .activity-item:nth-child(3) .activity-icon { background: #FDE68A; color: var(--color-secondary); }
        .activity-item:nth-child(4) .activity-icon { background: #EDE9FE; color: #8B5CF6; }


        .activity-content {
            flex: 1;
        }

        .activity-text {
            color: var(--color-text-dark);
            font-weight: 500;
            margin-bottom: 4px;
        }

        .activity-time {
            color: #6B7280;
            font-size: 13px;
        }

        /* ==================== SYSTEM INFO ==================== */
        .system-info {
            padding: 0 40px 40px;
        }

        .system-info h2 {
            color: var(--color-primary);
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 15px;
            background: var(--color-bg-light);
            border-radius: 15px;
            padding: 25px;
            box-shadow: var(--shadow-md);
            border: 1px solid #E5E7EB;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: var(--color-bg-dark);
            border-radius: 10px;
            border: 1px solid #E5E7EB;
        }

        .info-label {
            color: #6B7280;
            font-weight: 500;
        }

        .info-value {
            color: var(--color-text-dark);
            font-weight: 600;
        }

        .status-online {
            color: var(--color-success);
            font-weight: 700;
        }

        /* ==================== RESPONSIVE DESIGN ==================== */
        @media (max-width: 1200px) {
            .main-content { margin-left: 260px; }
            .dashboard-stats { grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); }
        }

        @media (max-width: 768px) {
            .sidebar { width: 100%; height: auto; position: relative; }
            .main-content { margin-left: 0; }
            .header { padding: 20px; flex-direction: column; align-items: flex-start; gap: 15px;}
            .header h1 { font-size: 1.8em; }
            .user-info { flex-direction: column; align-items: flex-start; gap: 8px; }
            .dashboard-stats { grid-template-columns: 1fr; padding: 20px; }
            .quick-actions, .recent-activity, .system-info { padding: 0 20px 20px; }
            .action-grid { grid-template-columns: 1fr; }
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
                <li><a href="dashboardServlet" class="active"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                <li><a href="quanLyUserServlet"><i class="fas fa-users"></i> Quản lý Users</a></li>
                <li><a href="quanLyChuyenXeAdminServlet"><i class="fas fa-bus"></i> Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet"><i class="fas fa-building"></i> Quản lý Nhà xe</a></li>
                <li><a href="dangXuatServlet"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <header class="header">
                <h1><i class="fas fa-gauge-high"></i> Dashboard</h1>
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

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error-message">
                    <i class="fas fa-times-circle"></i> <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <div class="dashboard-stats">
                <div class="stat-card trips">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Tổng chuyến xe</h3>
                            <p class="stat-number">
                                <%= request.getAttribute("numberOfChuyenXe") != null ? request.getAttribute("numberOfChuyenXe") : 0 %>
                            </p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-route"></i></div>
                    </div>
                    <span class="stat-trend">🚌 Đang hoạt động</span>
                </div>
                
                <div class="stat-card companies">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Nhà xe</h3>
                            <p class="stat-number">
                                <%= request.getAttribute("numberOfNhaXe") != null ? request.getAttribute("numberOfNhaXe") : 0 %>
                            </p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-building"></i></div>
                    </div>
                    <span class="stat-trend">🤝 Đối tác</span>
                </div>
                
                <div class="stat-card users">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Người dùng</h3>
                            <p class="stat-number">
                                <%= request.getAttribute("numberOfUsers") != null ? request.getAttribute("numberOfUsers") : 0 %>
                            </p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-users"></i></div>
                    </div>
                    <span class="stat-trend">👤 Khách hàng</span>
                </div>
                
                <div class="stat-card bookings">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Vé hôm nay</h3>
                            <p class="stat-number">
                                <%= request.getAttribute("todayBookings") != null ? request.getAttribute("todayBookings") : 0 %>
                            </p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-ticket-alt"></i></div>
                    </div>
                    <span class="stat-trend">📅 Đặt vé hôm nay</span>
                </div>
                
                <div class="stat-card revenue">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Doanh thu hôm nay</h3>
                            <p class="stat-number revenue-number">
                                <%= request.getAttribute("formattedRevenue") != null ? request.getAttribute("formattedRevenue") : "0" %> VNĐ
                            </p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-hand-holding-dollar"></i></div>
                    </div>
                    <span class="stat-trend">💵 Thu nhập</span>
                </div>
            </div>

            <div class="quick-actions">
                <h2><i class="fas fa-bolt"></i> Thao tác nhanh</h2>
                <div class="action-grid">
                    <a href="quanLyUserServlet" class="action-btn manage-users">
                        <span class="action-icon"><i class="fas fa-user-shield"></i></span>
                        <div class="action-content">
                            <h4>Quản lý Người dùng</h4>
                            <p>Thêm, sửa, xóa, phân quyền tài khoản.</p>
                        </div>
                    </a>
                    
                    <a href="quanLyChuyenXeAdminServlet" class="action-btn manage-trips">
                        <span class="action-icon"><i class="fas fa-bus-simple"></i></span>
                        <div class="action-content">
                            <h4>Quản lý Chuyến xe</h4>
                            <p>Thêm, sửa, tìm kiếm, kiểm tra khách hàng.</p>
                        </div>
                    </a>
                    
                    <a href="quanLyNhaXeServlet" class="action-btn manage-companies">
                        <span class="action-icon"><i class="fas fa-warehouse"></i></span>
                        <div class="action-content">
                            <h4>Quản lý Nhà xe</h4>
                            <p>Thêm/cập nhật thông tin các đối tác vận tải.</p>
                        </div>
                    </a>
                    
                    <a href="quanLyChuyenXeHoanThanhServlet" class="action-btn completed-trips">
                        <span class="action-icon"><i class="fas fa-check-to-slot"></i></span>
                        <div class="action-content">
                            <h4>Chuyến đã hoàn thành</h4>
                            <p>Xem lịch sử và báo cáo chuyến xe đã kết thúc.</p>
                        </div>
                    </a>
                    
                    <a href="dangXuatServlet" class="action-btn logout">
                        <span class="action-icon"><i class="fas fa-sign-out-alt"></i></span>
                        <div class="action-content">
                            <h4>Đăng xuất</h4>
                            <p>Thoát khỏi phiên làm việc hiện tại.</p>
                        </div>
                    </a>
                </div>
            </div>

            <div class="recent-activity">
                <h2><i class="fas fa-chart-area"></i> Hoạt động gần đây</h2>
                <div class="activity-list">
                    <div class="activity-item">
                        <span class="activity-icon"><i class="fas fa-ticket-alt"></i></span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Có **<%= request.getAttribute("todayBookings") != null ? request.getAttribute("todayBookings") : 0 %>** vé được đặt hôm nay
                            </span>
                            <span class="activity-time">Cập nhật theo giao dịch</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon"><i class="fas fa-coins"></i></span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Doanh thu hôm nay đạt **<%= request.getAttribute("formattedRevenue") != null ? request.getAttribute("formattedRevenue") : "0" %> VNĐ**
                            </span>
                            <span class="activity-time">Thống kê realtime</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon"><i class="fas fa-road"></i></span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Hệ thống có **<%= request.getAttribute("numberOfChuyenXe") != null ? request.getAttribute("numberOfChuyenXe") : 0 %>** chuyến xe đang hoạt động
                            </span>
                            <span class="activity-time">Tổng quan</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <span class="activity-icon"><i class="fas fa-users-viewfinder"></i></span>
                        <div class="activity-content">
                            <span class="activity-text">
                                Tổng cộng **<%= request.getAttribute("numberOfUsers") != null ? request.getAttribute("numberOfUsers") : 0 %>** người dùng đã đăng ký
                            </span>
                            <span class="activity-time">Tổng cộng</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="system-info">
                <h2><i class="fas fa-info-circle"></i> Thông tin hệ thống</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">🌐 Trạng thái hệ thống:</span>
                        <span class="info-value status-online"><i class="fas fa-circle-check"></i> Hoạt động</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">📅 Ngày hiện tại:</span>
                        <span class="info-value" id="currentDateDisplay"></span>
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
            const formatterOptions = {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            };
            
            const timeString = now.toLocaleDateString('vi-VN', formatterOptions).replace(/\//g, '-') + ' ' + 
                               now.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

            document.getElementById('currentTime').textContent = timeString;
            
            const dateString = now.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            
            const dateElement = document.getElementById('currentDateDisplay');
            if (dateElement) {
                dateElement.textContent = dateString;
            }
        }

        // Cập nhật thời gian mỗi giây
        setInterval(updateTime, 1000);
        updateTime(); // Gọi ngay khi load trang

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

        // Refresh dashboard mỗi 5 phút (nếu cần dữ liệu mới nhất)
        /* setInterval(() => {
            window.location.reload();
        }, 300000); */
    </script>
</body>
</html>