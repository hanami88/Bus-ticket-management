<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.DatXe" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đặt Vé - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* =================================
             GLOBAL STYLES (New Theme)
             ================================= */
        :root {
            --color-primary: #1F2937; /* Dark Navy/Slate - Main background */
            --color-secondary: #FFC107; /* Amber/Gold - Accent color */
            --color-text-dark: #374151;
            --color-text-light: #F9FAFB;
            --color-bg-light: #FFFFFF;
            --color-bg-medium: #F3F4F6;
            --color-success: #10B981;
            --color-danger: #EF4444;
            --color-info: #3B82F6;
            --shadow-md: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--color-bg-medium);
            color: var(--color-text-dark);
            min-height: 100vh;
            padding: 20px;
        }
        
        /* Back Button */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            margin-bottom: 25px;
            background-color: var(--color-primary);
            color: var(--color-text-light);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .back-btn:hover {
            background-color: #374151;
            transform: translateY(-2px);
        }

        .back-icon {
            font-size: 1.2rem;
        }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: var(--color-bg-light);
            border-radius: 15px;
            box-shadow: var(--shadow-md);
            padding: 40px;
            border: 1px solid #E5E7EB;
        }

        .header {
            margin-bottom: 30px;
            border-bottom: 2px solid #E5E7EB;
            padding-bottom: 20px;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--color-primary);
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 5px;
        }

        .header p {
            color: #6B7280;
            font-size: 1.05rem;
        }
        
        /* Error Message */
        .error-message {
            margin: 0 0 25px 0;
            padding: 16px 24px;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            background-color: #FEE2E2;
            color: var(--color-danger);
            border-left: 4px solid var(--color-danger);
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.1);
        }

        /* User Info Section */
        .user-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            background-color: var(--color-bg-medium);
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #D1D5DB;
        }

        .user-info-item {
            padding: 10px 0;
        }

        .user-info-label {
            font-size: 13px;
            font-weight: 600;
            color: #6B7280;
            text-transform: uppercase;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .user-info-label::before {
            content: attr(data-icon);
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: var(--color-secondary);
        }

        .user-info-value {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--color-primary);
        }
        
        .user-info-value.role-admin {
            color: #8B5CF6; /* Violet */
        }
        
        /* Statistics */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background-color: var(--color-bg-light);
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease;
            border-left: 5px solid;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-card h3 {
            font-size: 14px;
            color: #6B7280;
            text-transform: uppercase;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--color-primary);
            line-height: 1;
        }

        .stat-card small {
            color: #6B7280;
            font-weight: 500;
            display: block;
            margin-top: 5px;
        }

        .stat-card.total { border-left-color: var(--color-info); }
        .stat-card.money { border-left-color: var(--color-success); }
        .stat-card.trips { border-left-color: var(--color-secondary); }

        /* History Table */
        .history-section {
            padding: 20px 0;
        }
        
        .history-section h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--color-primary);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #E5E7EB;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .history-table {
            width: 100%;
            border-collapse: collapse;
            background-color: var(--color-bg-light);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .history-table thead {
            background-color: var(--color-primary);
            color: var(--color-text-light);
        }

        .history-table th {
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .history-table td {
            padding: 15px;
            border-bottom: 1px solid #F3F4F6;
            vertical-align: middle;
            font-size: 14px;
        }

        .history-table tbody tr:hover {
            background-color: var(--color-bg-medium);
        }

        .ticket-id {
            color: var(--color-info);
            font-weight: 600;
            font-family: monospace;
        }

        .route-info {
            font-weight: 600;
            color: var(--color-text-dark);
            min-width: 200px;
        }
        
        .company {
            color: #6B7280;
            font-weight: 500;
        }

        .quantity {
            text-align: center;
            color: var(--color-secondary);
            font-weight: 700;
        }
        
        .price {
            color: var(--color-success);
            font-weight: 500;
            font-family: monospace;
        }
        
        .price strong {
            color: var(--color-danger);
            font-weight: 700;
        }
        
        .date {
            color: #6B7280;
            font-size: 13px;
            font-style: italic;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background-color: var(--color-bg-medium);
            border-radius: 10px;
            margin-top: 20px;
            border: 1px dashed #D1D5DB;
        }

        .empty-state svg {
            width: 50px;
            height: 50px;
            color: #9CA3AF;
            margin-bottom: 15px;
        }

        .empty-state h3 {
            color: var(--color-primary);
            font-size: 1.4rem;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #6B7280;
        }
        
        /* Utility Classes for Icons in Info Section */
        .info-user::before { content: '\f007'; } /* fa-user */
        .info-id::before { content: '\f02b'; } /* fa-tag */
        .info-email::before { content: '\f0e0'; } /* fa-envelope */
        .info-phone::before { content: '\f095'; } /* fa-phone */
        .info-role::before { content: '\f505'; } /* fa-id-badge */

        /* Responsive */
        @media (max-width: 1200px) {
            .history-table {
                min-width: 1000px;
            }
            .history-section {
                overflow-x: auto;
            }
        }
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .header h1 {
                font-size: 1.8rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            .stats-container {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .user-info {
                grid-template-columns: 1fr;
            }
            .back-btn {
                margin-left: 0;
            }
            .history-table {
                min-width: 800px;
            }
        }

    </style>
</head>
<body>
    <a href="quanLyUserServlet" class="back-btn">
        <span class="back-icon"><i class="fas fa-arrow-left"></i></span>
        Quay lại Quản lý Users
    </a>
    
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-history"></i> Lịch Sử Đặt Vé Người Dùng</h1>
            <p>Thông tin chi tiết các chuyến xe đã đặt</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-times-circle"></i> <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% 
            User selectedUser = (User) request.getAttribute("selectedUser");
            List<DatXe> lichSuDatXe = (List<DatXe>) request.getAttribute("lichSuDatXe");
            Integer tongSoVeDaDat = (Integer) request.getAttribute("tongSoVeDaDat");
            Double tongTienDaChi = (Double) request.getAttribute("tongTienDaChi");
            Integer soChuyenDaDat = (Integer) request.getAttribute("soChuyenDaDat");
            
            // Formatters
            NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        %>

        <% if (selectedUser != null) { %>
            <div class="user-info">
                <div class="user-info-item">
                    <div class="user-info-label info-id" data-icon="&#xf02b;">ID Người dùng</div>
                    <div class="user-info-value">#<%= selectedUser.getId() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label info-user" data-icon="&#xf007;">Họ và Tên</div>
                    <div class="user-info-value"><%= selectedUser.getName() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label info-email" data-icon="&#xf0e0;">Email</div>
                    <div class="user-info-value"><%= selectedUser.getEmail() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label info-phone" data-icon="&#xf095;">Số Điện Thoại</div>
                    <div class="user-info-value"><%= selectedUser.getPhone() != null ? selectedUser.getPhone() : "N/A" %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label info-role" data-icon="&#xf505;">Vai trò</div>
                    <div class="user-info-value <%= selectedUser.getRole() == 2 ? "role-admin" : "" %>"><%= selectedUser.getRole() == 2 ? "Admin" : "User" %></div>
                </div>
            </div>

            <div class="stats-container">
                <div class="stat-card total">
                    <h3><i class="fas fa-ticket-alt"></i> Tổng Số Vé Đã Đặt</h3>
                    <div class="stat-number"><%= tongSoVeDaDat != null ? formatter.format(tongSoVeDaDat) : 0 %></div>
                </div>
                
                <div class="stat-card money">
                    <h3><i class="fas fa-money-bill-wave"></i> Tổng Tiền Đã Chi</h3>
                    <div class="stat-number"><%= tongTienDaChi != null ? formatter.format(tongTienDaChi) : "0" %></div>
                    <small>VNĐ</small>
                </div>
                
                <div class="stat-card trips">
                    <h3><i class="fas fa-bus-simple"></i> Số Chuyến Đã Đặt</h3>
                    <div class="stat-number"><%= soChuyenDaDat != null ? formatter.format(soChuyenDaDat) : 0 %></div>
                </div>
            </div>

            <div class="history-section">
                <h2><i class="fas fa-clipboard-list"></i> Danh Sách Chi Tiết Đặt Vé</h2>
                
                <% if (lichSuDatXe != null && !lichSuDatXe.isEmpty()) { %>
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Mã Đặt Vé</th>
                                <th>Tuyến Xe</th>
                                <th>Nhà Xe</th>
                                <th>Thời Gian Khởi Hành</th>
                                <th>Biển Số Xe</th>
                                <th class="quantity">Số Lượng Vé</th>
                                <th>Đơn Giá</th>
                                <th>Thành Tiền</th>
                                <th>Ngày Đặt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (DatXe datXe : lichSuDatXe) { %>
                            <tr>
                                <td class="ticket-id">#<%= datXe.getId() %></td>
                                <td class="route-info">
                                    <i class="fas fa-location-arrow" style="color:var(--color-info)"></i> 
                                    <%= datXe.getTenDiemDi() != null ? datXe.getTenDiemDi() : "N/A" %>
                                    <br>
                                    <small style="color: #6b7280;"><i class="fas fa-map-pin"></i> → <%= datXe.getTenDiemDen() != null ? datXe.getTenDiemDen() : "N/A" %></small>
                                </td>
                                <td class="company">
                                    <i class="fas fa-building" style="color:var(--color-primary)"></i> <%= datXe.getTenNhaXe() != null ? datXe.getTenNhaXe() : "N/A" %>
                                </td>
                                <td>
                                    <i class="fas fa-clock" style="color:#8B5CF6"></i> <%= datXe.getGioKhoiHanh() != null ? datXe.getGioKhoiHanh().format(timeFormatter) : "N/A" %>
                                </td>
                                <td>
                                    <strong><i class="fas fa-car-side" style="color:var(--color-secondary)"></i> <%= datXe.getBienSoXe() != null ? datXe.getBienSoXe() : "N/A" %></strong>
                                </td>
                                <td class="quantity">
                                    <%= datXe.getSoLuong() %> <i class="fas fa-chair"></i>
                                </td>
                                <td class="price">
                                    <%= datXe.getGiaVe() != null ? formatter.format(datXe.getGiaVe()) : "0" %> VNĐ
                                </td>
                                <td class="price">
                                    <strong>
                                        <%= datXe.getGiaVe() != null ? formatter.format(datXe.getGiaVe().doubleValue() * datXe.getSoLuong()) : "0" %> VNĐ
                                    </strong>
                                </td>
                                <td class="date">
                                    <i class="fas fa-calendar-alt" style="color:#9CA3AF"></i> <%= datXe.getNgayDat() != null ? datXe.getNgayDat().format(dateFormatter) : "N/A" %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-box-open" style="font-size: 50px; color: #9CA3AF;"></i>
                        <h3>Chưa có vé nào được đặt</h3>
                        <p>Người dùng này chưa đặt vé nào trong hệ thống</p>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state" style="padding: 100px 20px;">
                <i class="fas fa-user-slash" style="font-size: 50px; color: var(--color-danger);"></i>
                <h3>Không tìm thấy thông tin người dùng</h3>
                <p>Vui lòng kiểm tra ID người dùng và thử lại sau</p>
            </div>
        <% } %>
    </div>

    <script>
        // Auto-hide error messages after 5 seconds
        setTimeout(function() {
            const errorMessages = document.querySelectorAll('.error-message');
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