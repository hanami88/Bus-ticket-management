<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.bean.DatXe" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đặt vé</title>
    <link rel="stylesheet" href="style/lichSuDatXe.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header" style="background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52))">
            <h1 style="display: flex; justify-content: center; align-items: center; "><img
        src="/jsp-servlet-DatVeXe/images/logo-name-header.svg"
        alt="Hotel Banner"
        class="img-fluid"
      /><div style="color: #ffe22a">Lịch sử đặt vé</div></h1>
            <div class="user-info">
                <%
                    String userName = (String) session.getAttribute("name");
                    if (userName == null || userName.isEmpty()) {
                        userName = (String) session.getAttribute("email");
                    }
                %>
                Xin chào: <strong><%= userName %></strong>
                <a href="quanLyChuyenXeServlet" class="back-btn">← Quay lại danh sách</a>
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
                List<DatXe> lichSuDatXe = (List<DatXe>) request.getAttribute("lichSuDatXe");
                NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
                DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                
                if (lichSuDatXe != null && !lichSuDatXe.isEmpty()) {
            %>
            
            <div class="history-summary">
                <h2 style="color: rgb(0, 42, 52)">📊 Tổng quan</h2>
                <div class="summary-cards">
                    <div class="summary-card">
                        <div class="card-icon">🎫</div>
                        <div class="card-content">
                            <div class="card-number" style="color: rgb(0, 42, 52)" ><%= lichSuDatXe.size() %></div>
                            <div class="card-label">Lần đặt vé</div>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="card-icon">🚌</div>
                        <div class="card-content">
                            <div class="card-number" style="color: rgb(0, 42, 52)">
                                <%= lichSuDatXe.stream().mapToInt(DatXe::getSoLuong).sum() %>
                            </div>
                            <div class="card-label">Tổng số vé</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="history-list">
                <h2 style="color: rgb(0, 42, 52)"">📋 Chi tiết lịch sử</h2>
                
                <% for (DatXe datXe : lichSuDatXe) { 
                    String ngayDat = datXe.getNgayDat() != null ? datXe.getNgayDat().format(dateTimeFormatter) : "N/A";
                    String ngayKhoiHanh = "N/A";
                    String gioKhoiHanh = "N/A";
                    
                    if (datXe.getGioKhoiHanh() != null) {
                        ngayKhoiHanh = datXe.getGioKhoiHanh().format(dateFormatter);
                        gioKhoiHanh = datXe.getGioKhoiHanh().format(timeFormatter);
                    }
                %>
                
                <div class="history-item" style="background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52))">
                    <div class="item-header" style="background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52))">
                        <div class="trip-route">
                            <span class="route-text">
                                🚩 <%= datXe.getTenDiemDi() != null ? datXe.getTenDiemDi() : "N/A" %> 
                                → 
                                🏁 <%= datXe.getTenDiemDen() != null ? datXe.getTenDiemDen() : "N/A" %>
                            </span>
                        </div>
                        <div class="booking-date">
                            📅 Đặt lúc: <%= ngayDat %>
                        </div>
                    </div>
                    
                    <div class="item-details">
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="label">🕒 Ngày khởi hành:</span>
                                <span class="value"><%= ngayKhoiHanh %></span>
                            </div>
                            <div class="detail-item">
                                <span class="label">⏰ Giờ khởi hành:</span>
                                <span class="value"><%= gioKhoiHanh %></span>
                            </div>
                            <div class="detail-item">
                                <span class="label">🚌 Nhà xe:</span>
                                <span class="value"><%= datXe.getTenNhaXe() != null ? datXe.getTenNhaXe() : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="label">🚗 Biển số:</span>
                                <span class="value"><%= datXe.getBienSoXe() != null ? datXe.getBienSoXe() : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="label">🎫 Số lượng vé:</span>
                                <span class="value highlight" style="color: rgb(0, 64, 80)"><%= datXe.getSoLuong() %> vé</span>
                            </div>
                            <div class="detail-item">
                                <span class="label">💰 Tổng tiền:</span>
                                <span class="value price">
                                    <%= datXe.getTongTien() != null ? formatter.format(datXe.getTongTien()) : "0" %> VNĐ
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <% } %>
            </div>
            
            <% } else { %>
                <div class="empty-state">
                    <div class="empty-icon">📭</div>
                    <h3 style="color: rgb(0, 64, 80)">Chưa có lịch sử đặt vé</h3>
                    <p>Bạn chưa đặt vé chuyến xe nào. Hãy đặt vé đầu tiên của bạn!</p>
                    <a href="quanLyChuyenXeServlet" class="btn-primary" style="background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52));">🚌 Đặt vé ngay</a>
                </div>
            <% } %>
        </main>
    </div>
</body>
</html>