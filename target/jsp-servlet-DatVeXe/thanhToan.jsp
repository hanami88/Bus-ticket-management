<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="style/thanhToan.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1>💳 Thanh toán</h1>
            <div class="user-info">
                <%
                    String userName = (String) session.getAttribute("name");
                    if (userName == null || userName.isEmpty()) {
                        userName = (String) session.getAttribute("email");
                    }
                %>
                Xin chào: <strong><%= userName %></strong>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <%
                ChuyenXe chuyenXe = (ChuyenXe) request.getAttribute("chuyenXe");
                Integer soLuong = (Integer) request.getAttribute("soLuong");
                BigDecimal tongTien = (BigDecimal) request.getAttribute("tongTien");
                
                if (chuyenXe != null && soLuong != null && tongTien != null) {
                    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE", new Locale("vi", "VN"));
                    
                    String formattedDateTime = "N/A";
                    if (chuyenXe.getGioKhoiHanh() != null) {
                        String date = chuyenXe.getGioKhoiHanh().format(dateFormatter);
                        String time = chuyenXe.getGioKhoiHanh().format(timeFormatter);
                        String dayOfWeek = chuyenXe.getGioKhoiHanh().format(dayFormatter);
                        dayOfWeek = dayOfWeek.substring(0, 1).toUpperCase() + dayOfWeek.substring(1);
                        formattedDateTime = String.format("%s, %s lúc %s", dayOfWeek, date, time);
                    }
            %>
            
            <div class="payment-container">
                <!-- Thông tin đặt vé -->
                <div class="booking-summary">
                    <h2>📋 Thông tin đặt vé</h2>
                    <div class="summary-grid">
                        <div class="summary-item">
                            <span class="label">🚩 Tuyến:</span>
                            <span class="value"><%= chuyenXe.getTenDiemDi() %> → <%= chuyenXe.getTenDiemDen() %></span>
                        </div>
                        <div class="summary-item">
                            <span class="label">🕒 Thời gian:</span>
                            <span class="value"><%= formattedDateTime %></span>
                        </div>
                        <div class="summary-item">
                            <span class="label">🚌 Nhà xe:</span>
                            <span class="value"><%= chuyenXe.getTenNhaXe() %></span>
                        </div>
                        <div class="summary-item">
                            <span class="label">🎫 Số lượng vé:</span>
                            <span class="value"><%= soLuong %> vé</span>
                        </div>
                        <div class="summary-item">
                            <span class="label">💰 Giá vé:</span>
                            <span class="value"><%= formatter.format(chuyenXe.getGia()) %> VNĐ/vé</span>
                        </div>
                        <div class="summary-item total">
                            <span class="label">💵 Tổng tiền:</span>
                            <span class="value"><%= formatter.format(tongTien) %> VNĐ</span>
                        </div>
                    </div>
                </div>

                <!-- Mã QR thanh toán -->
                <div class="qr-payment">
                    <h2>📱 Quét mã QR để thanh toán</h2>
                    <div class="qr-container">
                        <div class="qr-code">
                            <img src="./style/images/qr-thanh-toan.jpg" 
                                 alt="QR Code" />
                        </div>
                        <p class="qr-description">
                            Quét mã QR này bằng ứng dụng ngân hàng để thanh toán
                            <br><strong>Số tiền: <%= formatter.format(tongTien) %> VNĐ</strong>
                            <br><small>Nội dung: DatVe-<%= chuyenXe.getId() %>-<%= soLuong %>ve</small>
                        </p>
                    </div>
                </div>

                <!-- Nút xác nhận -->
                <div class="confirm-section">
                    <div class="notice">
                        <p>⚠️ <strong>Lưu ý:</strong> Sau khi thanh toán thành công, vui lòng bấm "Xác nhận thanh toán" để hoàn tất việc đặt vé.</p>
                    </div>
                    
                    <form action="datXeServlet" method="post">
                        <input type="hidden" name="action" value="hoanthanh">
                        <input type="hidden" name="chuyenXeId" value="<%= chuyenXe.getId() %>">
                        <input type="hidden" name="soLuong" value="<%= soLuong %>">
                        
                        <div class="button-group">
                            <button type="button" onclick="goBack()" class="btn-back">← Quay lại</button>
                            <button type="submit" class="btn-confirm">✅ Xác nhận thanh toán</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <% } else { %>
                <div class="error-message">
                    ❌ Không tìm thấy thông tin đặt vé
                </div>
            <% } %>
        </main>
    </div>

    <script>
        function goBack() {
            history.back();
        }
        
        // Auto refresh QR code every 30 seconds
        setInterval(function() {
            const qrImg = document.querySelector('.qr-code img');
            if (qrImg) {
                const currentSrc = qrImg.src;
                qrImg.src = currentSrc + '&_=' + new Date().getTime();
            }
        }, 30000);
    </script>
</body>
</html>