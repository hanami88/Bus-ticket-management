<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="model.bean.DiaDiem" %>
<%@ page import="model.bean.NhaXe" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý chuyến xe - Admin | Hệ thống đặt vé</title>
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
        
        /* Search/Filter Buttons */
        .btn-search {
            background-color: var(--color-info);
            color: white;
            box-shadow: 0 4px 10px rgba(59, 130, 246, 0.4);
        }

        .btn-search:hover {
            background-color: #2563EB;
        }

        .btn-reset {
            background-color: #9CA3AF;
            color: white;
        }

        .btn-reset:hover {
            background-color: #6B7280;
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

        .stat-card.completed .stat-icon {
            color: var(--color-secondary);
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

        /* Filter Section */
        .filter-section {
            padding: 0 0 30px;
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

        .search-form {
            background-color: var(--color-bg-light);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow-light);
            border: 1px solid #E5E7EB;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .search-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .search-group label {
            color: var(--color-text-dark);
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .search-group select,
        .search-group input {
            padding: 12px 15px;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
            background-color: white;
            color: var(--color-text-dark);
            font-family: inherit;
        }
        
        .search-group select:focus,
        .search-group input:focus {
            outline: none;
            border-color: var(--color-info);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        .search-actions {
            display: flex;
            gap: 15px;
            grid-column: span 1; /* Reset span to 1 or remove if not needed */
            justify-content: flex-start;
        }

        /* Table Section */
        .table-section {
            padding: 0;
        }

        .table-container {
            background-color: var(--color-bg-light);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
            border: 1px solid #E5E7EB;
        }

        .trips-table {
            width: 100%;
            border-collapse: collapse;
        }

        .trips-table thead {
            background-color: var(--color-primary);
            color: var(--color-text-light);
        }

        .trips-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .trips-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #E5E7EB;
            vertical-align: middle;
            font-size: 14px;
        }

        .trips-table tbody tr:hover {
            background-color: #F9FAFB;
        }

        /* Table Cell Styles */
        .route-info {
            font-weight: 600;
            color: var(--color-primary);
            min-width: 250px;
        }

        .route-info .arrow {
            color: var(--color-secondary);
            margin: 0 8px;
            font-weight: bold;
            font-size: 16px;
        }

        .datetime {
            color: #6B7280;
            font-size: 13px;
            font-weight: 500;
            min-width: 140px;
        }

        .price {
            color: var(--color-success);
            font-weight: 700;
            font-size: 15px;
            min-width: 120px;
        }

        .seats .seat-count {
            background-color: #DBEAFE;
            color: #1E40AF;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
            display: inline-block;
            min-width: 50px;
            text-align: center;
        }
        
        .license-plate {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            background-color: #F3F4F6;
            padding: 8px 12px;
            border-radius: 6px;
            text-align: center;
            color: #374151;
            font-size: 13px;
            min-width: 100px;
            display: inline-block;
        }

        .company {
            color: #374151;
            font-weight: 500;
            font-size: 14px;
        }

        /* Status Badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }

        .status-active {
            background-color: #D1FAE5;
            color: #065F46;
        }

        .status-completed {
            background-color: #FDE68A;
            color: #92400E;
        }

        .status-full {
            background-color: #FEE2E2;
            color: #991B1B;
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
            background-color: var(--color-info);
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
            max-width: 750px;
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
            .main-content { margin-left: 250px; padding: 20px; }
            .header { padding: 25px 30px; }
        }
        @media (max-width: 900px) {
            .header h1 { font-size: 1.8rem; }
            .stats-container { grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
            .search-form { grid-template-columns: 1fr; }
            .search-actions { grid-column: span 1; justify-content: center; }
            .trips-table th, .trips-table td { padding: 14px 15px; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: span 1; }
        }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }
            .main-content { margin-left: 0; }
            .header { flex-direction: column; align-items: flex-start; margin-bottom: 20px; }
            .header-actions { justify-content: flex-start; width: 100%; margin-top: 15px; }
            .trips-table { min-width: 850px; }
            .table-container { overflow-x: auto; }
            .modal-content { margin: 10% auto; width: 95%; }
            .modal-body, .modal-footer { padding: 20px; }
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
                <li><a href="quanLyChuyenXeAdminServlet" class="active"><i class="fas fa-bus"></i> Quản lý Chuyến xe</a></li>
                <li><a href="quanLyNhaXeServlet"><i class="fas fa-building"></i> Quản lý Nhà xe</a></li>
                <li><a href="dangXuatServlet"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <header class="header">
                <h1><i class="fas fa-route"></i> Quản lý Chuyến xe</h1>
                <div class="header-actions">
                    <button onclick="showAddModal()" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm chuyến xe
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
                    <div class="stat-icon"><i class="fas fa-road"></i></div>
                    <div class="stat-info">
                        <h3>Tổng chuyến xe</h3>
                        <p class="stat-number"><%= request.getAttribute("totalTrips") != null ? request.getAttribute("totalTrips") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card active">
                    <div class="stat-icon"><i class="fas fa-running"></i></div>
                    <div class="stat-info">
                        <h3>Đang hoạt động</h3>
                        <p class="stat-number"><%= request.getAttribute("activeTrips") != null ? request.getAttribute("activeTrips") : 0 %></p>
                    </div>
                </div>
                
                <div class="stat-card completed">
                    <div class="stat-icon"><i class="fas fa-check-double"></i></div>
                    <div class="stat-info">
                        <h3>Đã hoàn thành</h3>
                        <p class="stat-number"><%= request.getAttribute("completedTrips") != null ? request.getAttribute("completedTrips") : 0 %></p>
                    </div>
                </div>
            </div>

            <div class="filter-section">
                <h2 class="section-title"><i class="fas fa-filter"></i> Tìm kiếm và lọc</h2>
                <form id="searchForm" action="quanLyChuyenXeAdminServlet" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="search-group">
                        <label for="searchTuNoi"><i class="fas fa-map-marker-alt"></i> Từ:</label>
                        <select name="tuNoi" id="searchTuNoi">
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
                        <label for="searchDenNoi"><i class="fas fa-map-pin"></i> Đến:</label>
                        <select name="denNoi" id="searchDenNoi">
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
                        <label for="searchNgayDi"><i class="fas fa-calendar-alt"></i> Ngày đi:</label>
                        <%
                            String selectedNgayDi = (String) request.getAttribute("selectedNgayDi");
                        %>
                        <input type="date" name="ngayDi" id="searchNgayDi" value="<%= selectedNgayDi != null ? selectedNgayDi : "" %>">
                    </div>
                    
                    <div class="search-actions">
                        <button type="submit" class="btn btn-search"><i class="fas fa-search"></i> Tìm kiếm</button>
                        <button type="button" onclick="resetSearch()" class="btn btn-reset"><i class="fas fa-sync-alt"></i> Xóa bộ lọc</button>
                    </div>
                </form>
            </div>

            <div class="table-section">
                <h2 class="section-title"><i class="fas fa-list-ul"></i> Danh sách chuyến xe</h2>
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
                                LocalDateTime now = LocalDateTime.now();
                                
                                if (allChuyenXe != null && !allChuyenXe.isEmpty()) {
                                    for (ChuyenXe chuyenXe : allChuyenXe) {
                                        // Xác định trạng thái
                                        String status = "";
                                        String statusClass = "";
                                        if (chuyenXe.getGioKhoiHanh().isBefore(now)) {
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
                                    <%= chuyenXe.getTenDiemDi() %>
                                    <span class="arrow"><i class="fas fa-arrow-right"></i></span>
                                    <%= chuyenXe.getTenDiemDen() %>
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
                                <td>
                                    <span class="license-plate"><%= chuyenXe.getBienSoXe() %></span>
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
                                            class="btn-action btn-edit" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="viewCustomers(this)" 
                                            data-id="<%= chuyenXe.getId() %>"
                                            class="btn-action btn-view" title="Xem khách hàng đã đặt">
                                        <i class="fas fa-users"></i>
                                    </button>
                                    <button onclick="deleteTrip(this)" 
                                            data-id="<%= chuyenXe.getId() %>"
                                            class="btn-action btn-delete" title="Xóa">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="no-data">
                                    <i class="fas fa-box-open"></i> Không có chuyến xe nào được tìm thấy
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="tripModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle"><i class="fas fa-plus-circle"></i> Thêm chuyến xe mới</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            
            <form id="tripForm" action="quanLyChuyenXeAdminServlet" method="post">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="tripId">
                
                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="tuNoi"><i class="fas fa-map-marker-alt"></i> Điểm đi:</label>
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
                            <label for="denNoi"><i class="fas fa-map-pin"></i> Điểm đến:</label>
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
                            <label for="gioKhoiHanh"><i class="fas fa-clock"></i> Giờ khởi hành:</label>
                            <input type="datetime-local" name="gioKhoiHanh" id="gioKhoiHanh" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="gia"><i class="fas fa-dollar-sign"></i> Giá vé (VNĐ):</label>
                            <input type="number" name="gia" id="gia" min="1000" step="1000" required placeholder="Ví dụ: 250000">
                        </div>
                        
                        <div class="form-group">
                            <label for="soCho"><i class="fas fa-chair"></i> Số chỗ:</label>
                            <input type="number" name="soCho" id="soCho" min="1" max="50" required placeholder="Ví dụ: 40">
                        </div>
                        
                        <div class="form-group">
                            <label for="bienSoXe"><i class="fas fa-car-side"></i> Biển số xe:</label>
                            <input type="text" name="bienSoXe" id="bienSoXe" placeholder="VD: 29A-123.45" required>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="nhaXeId"><i class="fas fa-warehouse"></i> Nhà xe:</label>
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
                <p>Bạn có chắc chắn muốn xóa chuyến xe này?</p>
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

        // Modal functions
        function showAddModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> Thêm chuyến xe mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('tripId').value = '';
            document.getElementById('tripForm').reset();
            document.getElementById('tripModal').style.display = 'flex';
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
            
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa chuyến xe';
            document.getElementById('formAction').value = 'update';
            document.getElementById('tripId').value = id;
            document.getElementById('tuNoi').value = tuNoi;
            document.getElementById('denNoi').value = denNoi;
            
            // Convert datetime format from "YYYY-MM-DD HH:MM:SS.ms" to "YYYY-MM-DDTHH:MM"
            let dateTime = gioKhoiHanh.substring(0, 16); // Lấy phần YYYY-MM-DD HH:MM
            dateTime = dateTime.replace(' ', 'T');
            document.getElementById('gioKhoiHanh').value = dateTime;
            
            document.getElementById('gia').value = parseFloat(gia); // Đảm bảo là số
            document.getElementById('soCho').value = soCho;
            document.getElementById('bienSoXe').value = bienSoXe;
            document.getElementById('nhaXeId').value = nhaXeId;
            
            document.getElementById('tripModal').style.display = 'flex';
        }

        function deleteTrip(button) {
            deleteId = button.getAttribute('data-id');
            document.getElementById('deleteModal').style.display = 'flex';
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
            // Đặt lại các trường filter về giá trị mặc định
            document.getElementById('searchTuNoi').value = '';
            document.getElementById('searchDenNoi').value = '';
            document.getElementById('searchNgayDi').value = '';
            
            // Gửi yêu cầu trở lại trang danh sách ban đầu
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
            
            // Cho phép sửa chuyến xe đã qua, chỉ chặn thêm mới chuyến xe trong quá khứ
            const formAction = document.getElementById('formAction').value;
            if (formAction === 'add' && gioKhoiHanh <= now) {
                e.preventDefault();
                alert('❌ Giờ khởi hành phải sau thời điểm hiện tại khi thêm mới!');
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