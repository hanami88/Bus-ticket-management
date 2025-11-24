<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt vé xe</title>
    <link rel="stylesheet" href="style/datXe.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1>🚌 Đặt vé xe</h1>
            <div class="user-info">
                <%
                    String userName = (String) session.getAttribute("name");
                    if (userName == null || userName.isEmpty()) {
                        userName = (String) session.getAttribute("email");
                    }
                %>
                Xin chào: <strong><%= userName %></strong>
                <a href="quanLyChuyenXeServlet" class="back-btn">← Quay lại</a>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <%
                ChuyenXe chuyenXe = (ChuyenXe) request.getAttribute("chuyenXe");
                if (chuyenXe != null) {
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
            
            <!-- Thông tin chuyến xe -->
            <div class="trip-info">
                <h2>📋 Thông tin chuyến xe</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">🚩 Từ:</span>
                        <span class="value"><%= chuyenXe.getTenDiemDi() != null ? chuyenXe.getTenDiemDi() : "N/A" %></span>
                    </div>
                    <div class="info-item">
                        <span class="label">🏁 Đến:</span>
                        <span class="value"><%= chuyenXe.getTenDiemDen() != null ? chuyenXe.getTenDiemDen() : "N/A" %></span>
                    </div>
                    <div class="info-item">
                        <span class="label">🕒 Thời gian:</span>
                        <span class="value"><%= formattedDateTime %></span>
                    </div>
                    <div class="info-item">
                        <span class="label">💰 Giá vé:</span>
                        <span class="value price"><%= chuyenXe.getGia() != null ? formatter.format(chuyenXe.getGia()) : "0" %> VNĐ</span>
                    </div>
                    <div class="info-item">
                        <span class="label">🪑 Số chỗ còn lại:</span>
                        <span class="value seats-available">
                            <% if (chuyenXe.getSoCho() <= 0) { %>
                                <span class="sold-out">❌ Hết vé</span>
                            <% } else if (chuyenXe.getSoCho() <= 5) { %>
                                <span class="limited">⚠️ <%= chuyenXe.getSoCho() %> chỗ</span>
                            <% } else { %>
                                <span class="available">✅ <%= chuyenXe.getSoCho() %> chỗ</span>
                            <% } %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="label">🚌 Biển số xe:</span>
                        <span class="value"><%= chuyenXe.getBienSoXe() != null ? chuyenXe.getBienSoXe() : "N/A" %></span>
                    </div>
                </div>
            </div>

            <!-- Form đặt vé -->
            <div class="booking-form">
                <h2>🎫 Thông tin đặt vé</h2>
                
                <% if (chuyenXe.getSoCho() <= 0) { %>
                    <!-- Hiển thị khi hết vé -->
                    <div class="sold-out-notice">
                        <h3>❌ Chuyến xe này đã hết vé</h3>
                        <p>Vui lòng chọn chuyến xe khác hoặc thử lại vào thời gian khác.</p>
                        <div class="button-group">
                            <button type="button" onclick="goBack()" class="btn-back">← Quay lại danh sách</button>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Form đặt vé bình thường -->
                    <form action="datXeServlet" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="chuyenXeId" value="<%= chuyenXe.getId() %>">
                        <input type="hidden" name="action" value="xacnhan">
                        
                        <div class="form-group">
                            <label for="soLuong">Số lượng vé:</label>
                            <input type="number" id="soLuong" name="soLuong" 
                                   min="1" max="<%= chuyenXe.getSoCho() %>" value="1" required>
                            <div class="availability-info">
                                <% if (chuyenXe.getSoCho() <= 5) { %>
                                    <span class="limited">⚠️ Chỉ còn <%= chuyenXe.getSoCho() %> vé</span>
                                <% } else { %>
                                    <span class="available">✅ Còn <%= chuyenXe.getSoCho() %> vé</span>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="form-group total-price-group">
                            <label>Tổng tiền:</label>
                            <div class="total-price" id="totalPrice">
                                <%= chuyenXe.getGia() != null ? formatter.format(chuyenXe.getGia()) : "0" %> VNĐ
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="button-group">
                                <button type="button" onclick="goBack()" class="btn-cancel">❌ Hủy</button>
                                <button type="submit" class="btn-confirm">✅ Xác nhận đặt vé</button>
                            </div>
                        </div>
                    </form>
                <% } %>
            </div>
            
            <!-- Hidden element để lưu giá trị -->
            <div id="priceData" data-price="<%= chuyenXe.getGia() != null ? chuyenXe.getGia().toString() : "0" %>" style="display: none;"></div>
            
            <% } else { %>
                <div class="error-message">
                    ❌ Không tìm thấy thông tin chuyến xe
                </div>
            <% } %>
        </main>
    </div>

    <script>
        function goBack() {
            window.location.href = 'quanLyChuyenXeServlet';
        }
        
        // Validation form trước khi submit
        function validateForm() {
            const soLuongInput = document.getElementById('soLuong');
            if (!soLuongInput) return true;
            
            const soLuong = parseInt(soLuongInput.value);
            const maxSoCho = parseInt(soLuongInput.getAttribute('max'));
            
            if (soLuong <= 0) {
                alert('❌ Số lượng vé phải lớn hơn 0!');
                soLuongInput.focus();
                return false;
            }
            
            if (soLuong > maxSoCho) {
                alert(`❌ Số lượng vé không được vượt quá ${maxSoCho} vé!`);
                soLuongInput.focus();
                return false;
            }
            
            // Xác nhận đặt vé
            const confirmMessage = `Bạn có chắc chắn muốn đặt ${soLuong} vé cho chuyến xe này?`;
            return confirm(confirmMessage);
        }
        
        // Tính tổng tiền khi thay đổi số lượng
        document.addEventListener('DOMContentLoaded', function() {
            const priceElement = document.getElementById('priceData');
            const soLuongInput = document.getElementById('soLuong');
            
            if (priceElement && soLuongInput) {
                const giaVe = parseFloat(priceElement.dataset.price) || 0;
                
                soLuongInput.addEventListener('input', function() {
                    const soLuong = parseInt(this.value) || 1;
                    const maxSoCho = parseInt(this.getAttribute('max'));
                    
                    // Validate real-time
                    if (soLuong > maxSoCho) {
                        this.value = maxSoCho;
                        alert(`⚠️ Chỉ còn ${maxSoCho} vé!`);
                    }
                    
                    const finalSoLuong = parseInt(this.value) || 1;
                    const tongTien = finalSoLuong * giaVe;
                    
                    // Format số tiền
                    const formatter = new Intl.NumberFormat('vi-VN');
                    const totalPriceElement = document.getElementById('totalPrice');
                    if (totalPriceElement) {
                        totalPriceElement.textContent = formatter.format(tongTien) + ' VNĐ';
                    }
                });
            }
        });
    </script>
</body>
</html>