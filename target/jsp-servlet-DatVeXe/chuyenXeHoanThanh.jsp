<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="model.bean.DiaDiem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chuyến xe đã hoàn thành</title>
    <link rel="stylesheet" href="style/danhSachChuyenXe.css">
    <link rel="stylesheet" href="style/chuyenXeHoanThanh.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1>🚌 Hệ thống đặt vé xe</h1>
            <div class="user-info">
                <%
                    String userName = (String) session.getAttribute("name");
                    if (userName == null || userName.isEmpty()) {
                        userName = (String) session.getAttribute("email");
                    }
                %>
                Xin chào: <strong><%= userName %></strong>
                <a href="lichSuDatXeServlet" class="history-btn">📋 Lịch sử đặt vé</a>
                <a href="dangXuatServlet" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main class="main-content">
            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <a href="quanLyChuyenXeServlet" class="tab-btn">
                    🚀 Chuyến xe khả dụng
                </a>
                <a href="quanLyChuyenXeHoanThanhServlet" class="tab-btn active">
                    ✅ Chuyến xe đã hoàn thành
                </a>
            </div>

            <!-- Hiển thị thông báo -->
            <% if(request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    ✅ <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <!-- Bộ lọc tìm kiếm -->
            <div class="filter-section">
                <form id="filterForm" action="timKiemChuyenXeHoanThanhServlet" method="get" class="filter-form">
                    <div class="filter-group">
                        <label>🚩 Từ:</label>
                        <select name="tuNoi">
                            <option value="">-- Chọn điểm đi --</option>
                            <%
                                List<DiaDiem> listDiaDiem = (List<DiaDiem>) request.getAttribute("listDiaDiem");
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
                    
                    <div class="filter-group">
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
                    
                    <div class="filter-group">
                        <label>📅 Ngày đi:</label>
                        <%
                            String selectedNgayDi = (String) request.getAttribute("selectedNgayDi");
                        %>
                        <input type="date" name="ngayDi" value="<%= selectedNgayDi != null ? selectedNgayDi : "" %>">
                    </div>
                    
                    <div class="filter-group button-group">
                        <button type="submit" class="btn-search">🔍 Tìm kiếm</button>
                        <button type="button" class="btn-reset" onclick="resetForm()">🔄 Xóa bộ lọc</button>
                    </div>
                </form>
                
                <!-- Hiển thị thông báo kết quả tìm kiếm -->
                <% if(request.getAttribute("message") != null) { %>
                    <div class="search-result-message">
                        ℹ️ <%= request.getAttribute("message") %>
                    </div>
                <% } %>
            </div>

            <!-- Bảng danh sách chuyến xe -->
            <div class="table-container">
                <table class="trip-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Từ</th>
                            <th>Đến</th>
                            <th>Giờ khởi hành</th>
                            <th>Giá vé</th>
                            <th>Tình trạng</th>
                            <th>Biển số xe</th>
                            <th>Nhà xe</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
<%
    List<ChuyenXe> listChuyenXe = (List<ChuyenXe>) request.getAttribute("listChuyenXe");
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    
    // Định dạng cho ngày giờ
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE", new Locale("vi", "VN"));
    
    if (listChuyenXe != null && !listChuyenXe.isEmpty()) {
        int stt = 1;
        for (ChuyenXe chuyenXe : listChuyenXe) {
            String formattedDateTime = "N/A";
            if (chuyenXe.getGioKhoiHanh() != null) {
                String date = chuyenXe.getGioKhoiHanh().format(dateFormatter);
                String time = chuyenXe.getGioKhoiHanh().format(timeFormatter);
                String dayOfWeek = chuyenXe.getGioKhoiHanh().format(dayFormatter);
                
                // Viết hoa chữ cái đầu của thứ
                dayOfWeek = dayOfWeek.substring(0, 1).toUpperCase() + dayOfWeek.substring(1);
                
                formattedDateTime = String.format("%s, %s<br><small>%s</small>", 
                                                dayOfWeek, date, time);
            }
            
            // Xác định trạng thái
            String statusText = "";
            String statusClass = "";
            if (chuyenXe.getSoCho() == 0) {
                statusText = "Hết chỗ";
                statusClass = "status-full";
            } else {
                statusText = "Đã khởi hành";
                statusClass = "status-completed";
            }
%>
<tr>
    <td><%= stt++ %></td>
    <td><%= chuyenXe.getTenDiemDi() != null ? chuyenXe.getTenDiemDi() : "N/A" %></td>
    <td><%= chuyenXe.getTenDiemDen() != null ? chuyenXe.getTenDiemDen() : "N/A" %></td>
    <td class="datetime-cell">
        🕒 <%= formattedDateTime %>
    </td>
    <td class="price">💰 <%= chuyenXe.getGia() != null ? formatter.format(chuyenXe.getGia()) : "0" %> VNĐ</td>
    <td>
        <span class="status-badge <%= statusClass %>"><%= statusText %></span>
    </td>
    <td><%= chuyenXe.getBienSoXe() != null ? chuyenXe.getBienSoXe() : "N/A" %></td>
    <td><%= chuyenXe.getTenNhaXe() != null ? chuyenXe.getTenNhaXe() : "N/A" %></td>
    <td>
        <button class="btn-view-customers" onclick="xemKhachHang('<%= chuyenXe.getId() %>')">
            👥 Xem khách hàng
        </button>
    </td>
</tr>
<%
        }
    } else {
%>
<tr>
    <td colspan="9" class="no-data">
        📭 Không có chuyến xe hoàn thành nào được tìm thấy
    </td>
</tr>
<%
    }
%>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script>
        function xemKhachHang(chuyenXeId) {
            window.location.href = 'xemKhachHangTungChuyenServlet?chuyenXeId=' + chuyenXeId;
        }
        
        function resetForm() {
            document.getElementById('filterForm').reset();
            window.location.href = 'quanLyChuyenXeHoanThanhServlet';
        }
    </script>
</body>
</html>