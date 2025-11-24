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
    <link rel="stylesheet" href="style/userHistory.css">
</head>
<body>
    <a href="quanLyUserServlet" class="back-btn">
        <span class="back-icon">↩</span>
        Quay lại
    </a>
    
    <div class="container">
        <div class="header">
            <h1>📜 Lịch Sử Đặt Vé Người Dùng</h1>
            <p>Thông tin chi tiết các chuyến xe đã đặt</p>
        </div>

        <!-- Error Message -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                ❌ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% 
            User selectedUser = (User) request.getAttribute("selectedUser");
            List<DatXe> lichSuDatXe = (List<DatXe>) request.getAttribute("lichSuDatXe");
            Integer tongSoVeDaDat = (Integer) request.getAttribute("tongSoVeDaDat");
            Double tongTienDaChi = (Double) request.getAttribute("tongTienDaChi");
            Integer soChuyenDaDat = (Integer) request.getAttribute("soChuyenDaDat");
            
            NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        %>

        <% if (selectedUser != null) { %>
            <!-- User Info -->
            <div class="user-info">
                <div class="user-info-item">
                    <div class="user-info-label">👤 ID Người dùng</div>
                    <div class="user-info-value">#<%= selectedUser.getId() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label">🏷️ Họ và Tên</div>
                    <div class="user-info-value"><%= selectedUser.getName() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label">📧 Email</div>
                    <div class="user-info-value"><%= selectedUser.getEmail() %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label">📱 Số Điện Thoại</div>
                    <div class="user-info-value"><%= selectedUser.getPhone() != null ? selectedUser.getPhone() : "N/A" %></div>
                </div>
                <div class="user-info-item">
                    <div class="user-info-label">🎭 Vai trò</div>
                    <div class="user-info-value"><%= selectedUser.getRole() == 2 ? "Admin" : "User" %></div>
                </div>
            </div>

            <!-- Statistics -->
            <div class="stats-container">
                <div class="stat-card total">
                    <h3>🎫 Tổng Số Vé Đã Đặt</h3>
                    <div class="stat-number"><%= tongSoVeDaDat != null ? tongSoVeDaDat : 0 %></div>
                </div>
                
                <div class="stat-card money">
                    <h3>💰 Tổng Tiền Đã Chi</h3>
                    <div class="stat-number"><%= tongTienDaChi != null ? formatter.format(tongTienDaChi) : "0" %></div>
                    <small>VNĐ</small>
                </div>
                
                <div class="stat-card trips">
                    <h3>🚌 Số Chuyến Đã Đặt</h3>
                    <div class="stat-number"><%= soChuyenDaDat != null ? soChuyenDaDat : 0 %></div>
                </div>
            </div>

            <!-- History Table -->
            <div class="history-section">
                <h2>📋 Danh Sách Chi Tiết Đặt Vé</h2>
                
                <% if (lichSuDatXe != null && !lichSuDatXe.isEmpty()) { %>
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Mã Đặt Vé</th>
                                <th>Tuyến Xe</th>
                                <th>Nhà Xe</th>
                                <th>Thời Gian Khởi Hành</th>
                                <th>Biển Số Xe</th>
                                <th>Số Lượng Vé</th>
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
                                    <%= datXe.getTenDiemDi() != null ? datXe.getTenDiemDi() : "N/A" %>
                                    <br>
                                    <small style="color: #6b7280;">→ <%= datXe.getTenDiemDen() != null ? datXe.getTenDiemDen() : "N/A" %></small>
                                </td>
                                <td class="company">
                                    <%= datXe.getTenNhaXe() != null ? datXe.getTenNhaXe() : "N/A" %>
                                </td>
                                <td>
                                    <%= datXe.getGioKhoiHanh() != null ? datXe.getGioKhoiHanh().format(timeFormatter) : "N/A" %>
                                </td>
                                <td>
                                    <strong><%= datXe.getBienSoXe() != null ? datXe.getBienSoXe() : "N/A" %></strong>
                                </td>
                                <td class="quantity">
                                    <%= datXe.getSoLuong() %> vé
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
                                    <%= datXe.getNgayDat() != null ? datXe.getNgayDat().format(dateFormatter) : "N/A" %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M17 20H7V21C7 21.6 6.6 22 6 22H5C4.4 22 4 21.6 4 21V20H2V18H4.2L5.2 8.2C5.3 7.7 5.7 7.3 6.2 7.3H17.8C18.3 7.3 18.7 7.7 18.8 8.2L19.8 18H22V20H19V21C19 21.6 18.6 22 18 22H17C16.4 22 16 21.6 16 21V20ZM17.2 18L16.4 9.3H7.6L6.8 18H17.2ZM9 1H15V3H9V1ZM11 4H13V6H11V4Z"/>
                        </svg>
                        <h3>Chưa có vé nào được đặt</h3>
                        <p>Người dùng này chưa đặt vé nào trong hệ thống</p>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state" style="padding: 100px 20px;">
                <h3>Không tìm thấy thông tin người dùng</h3>
                <p>Vui lòng thử lại sau</p>
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