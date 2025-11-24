<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.utils.PrivacyUtils" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách khách hàng</title>
    <link rel="stylesheet" href="style/xemKhachHangTungChuyen.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1>👥 Danh sách khách hàng</h1>
            <div class="header-actions">
                <button onclick="goBack()" class="btn-back">🔙 Quay lại</button>
            </div>
        </header>

        <!-- Thông tin chuyến xe -->
        <%
            ChuyenXe chuyenXe = (ChuyenXe) request.getAttribute("chuyenXe");
            List<User> danhSachKhachHang = (List<User>) request.getAttribute("danhSachKhachHang");
            Integer tongSoVeDaDat = (Integer) request.getAttribute("tongSoVeDaDat");
            
            NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
        %>
        
        <% if (chuyenXe != null) { %>
        <div class="trip-info">
            <h2>🚌 Thông tin chuyến xe</h2>
            <div class="trip-details">
                <div class="detail-row">
                    <span class="label">🗺️ Tuyến đường:</span>
                    <span class="value"><%= chuyenXe.getTenDiemDi() %> → <%= chuyenXe.getTenDiemDen() %></span>
                </div>
                <div class="detail-row">
                    <span class="label">🕐 Giờ khởi hành:</span>
                    <span class="value">
                        <%= chuyenXe.getGioKhoiHanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="label">🚌 Biển số xe:</span>
                    <span class="value"><%= chuyenXe.getBienSoXe() %></span>
                </div>
                <div class="detail-row">
                    <span class="label">💰 Giá vé:</span>
                    <span class="value price"><%= formatter.format(chuyenXe.getGia()) %> VNĐ</span>
                </div>
                <div class="detail-row">
                    <span class="label">🪑 Tổng số chỗ:</span>
                    <span class="value"><%= chuyenXe.getSoCho() + (tongSoVeDaDat != null ? tongSoVeDaDat : 0) %></span>
                </div>
                <div class="detail-row">
                    <span class="label">📊 Đã đặt:</span>
                    <span class="value booked"><%= tongSoVeDaDat != null ? tongSoVeDaDat : 0 %> vé</span>
                </div>
                <div class="detail-row">
                    <span class="label">🔢 Còn lại:</span>
                    <span class="value available"><%= chuyenXe.getSoCho() %> chỗ</span>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Danh sách khách hàng -->
        <div class="customers-section">
            <div class="section-header">
                <h2>👥 Danh sách khách hàng đã đặt vé</h2>
                <div class="stats">
                    <span class="total-customers">
                        Tổng: <%= danhSachKhachHang != null ? danhSachKhachHang.size() : 0 %> khách hàng
                    </span>
                </div>
            </div>

            <% if (danhSachKhachHang != null && !danhSachKhachHang.isEmpty()) { %>
            <div class="table-container">
                <table class="customers-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên khách hàng</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Số lượng vé</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int stt = 1;
                            for (User khachHang : danhSachKhachHang) {
                                double thanhTien = chuyenXe.getGia().doubleValue() * khachHang.getSoLuongVeDat();
                        %>
                        <tr>
                            <td><%= stt++ %></td>
                            <td class="customer-name">
                                <div class="name-info">
                                    <strong><%= khachHang.getName() != null ? khachHang.getName() : "N/A" %></strong>
                                </div>
                            </td>
                            <td><%= PrivacyUtils.maskEmail(khachHang.getEmail()) %></td>
                            <td><%= PrivacyUtils.maskPhone(khachHang.getPhone()) %></td>
                            <td class="ticket-count">
                                <span class="count-badge"><%= khachHang.getSoLuongVeDat() %> vé</span>
                            </td>
                            <td class="amount">
                                <span class="price"><%= formatter.format(thanhTien) %> VNĐ</span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="no-customers">
                <div class="empty-state">
                    <div class="empty-icon">📭</div>
                    <h3>Chưa có khách hàng nào đặt vé</h3>
                    <p>Chuyến xe này chưa có khách hàng nào đặt vé.</p>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <script>
        function goBack() {
            window.location.href = 'quanLyChuyenXeServlet';
        }
    </script>
</body>
</html>