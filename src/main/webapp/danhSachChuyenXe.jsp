<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.bean.ChuyenXe" %>
<%@ page import="model.bean.DiaDiem" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%-- THÊM JSTL Taglib để dùng ${pageContext.request.contextPath} --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách chuyến xe - Tân Quang Dũng</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
      integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
      crossorigin="anonymous"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      /* CSS TỪ GIAO DIỆN MỚI */
      body {
        background-color: #f4f7fc;
        font-family: "Inter", sans-serif;
        color: #333;
        overflow-x: hidden;
      }

      /* Header */
      .header {
        background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52));
        color: white;
        /* TĂNG padding-top để tạo thêm không gian phía trên */
        padding: 6rem 0 0rem; 
        text-align: center;
        border-radius: 0 0 20px 20px;
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        position: relative;
        overflow: hidden;
        z-index: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 200px; 
      }
      .header img {
          max-height: 80px; 
          margin-bottom: 0.5rem;
          position: relative;
          z-index: 2;
      }
      .header h1 {
        font-weight: 700;
        font-size: 2.5rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        position: relative;
        z-index: 2;
        color: #ffe22a;
        margin-bottom: 3rem; /* GIẢM MARGIN BOTTOM ĐỂ KÉO TIÊU ĐỀ LÊN */
      }
      .header .user-info {
        position: absolute;
        top: 20px;
        right: 20px;
        z-index: 10;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
      }
      .header .user-info strong {
        color: #ffe22a;
        margin-right: 15px;
      }
      .header .history-btn, .header .logout-btn {
        color: white;
        text-decoration: none;
        margin-left: 10px;
        padding: 5px 10px;
        border-radius: 5px;
        transition: background-color 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.5);
      }
      .header .history-btn:hover, .header .logout-btn:hover {
        background-color: rgba(255, 255, 255, 0.1);
      }

      /* Form tìm kiếm (Thay thế Filter Section) */
      .search-form-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: -3rem; /* GIỮ NGUYÊN -3rem để chồng lên HEADER (nhưng tiêu đề đã được nâng lên) */
        position: relative;
        z-index: 10;
      }
      .filter-form-custom {
        display: flex;
        justify-content: center;
        width: 85vw;
        max-width: 1200px;
        background-color: white;
        height: auto;
        padding: 1.5rem 2rem;
        border-radius: 1rem;
        box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
        flex-wrap: wrap;
        gap: 1rem;
      }
      .filter-group-custom {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        min-width: 150px;
      }
      .filter-group-custom label {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 0.25rem;
      }
      .filter-group-custom select,
      .filter-group-custom input[type="date"] {
        width: 100%;
        height: 65px;
        border-radius: 0.5rem;
        padding: 0 1rem;
        font-size: 16px;
        font-weight: 600;
        background-color: #f3f3f3;
        border: 1px solid #cfcfcf;
      }
      .button-group-custom button {
        width: 100%;
        height: 65px;
        border-radius: 0.5rem;
        font-size: 18px;
        font-weight: 600;
        border: none;
        align-self: flex-end;
        margin-top: auto;
      }
      .btn-search {
        background-color: #ffe22a;
      }
      
      /* Main Content và Bảng (Không thay đổi) */
      .main-content {
        max-width: 1200px;
        margin: 2rem auto;
        padding: 0 1rem;
      }
      .trip-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1.5rem;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
      }
      .trip-table th, .trip-table td {
        padding: 12px 15px;
        text-align: center;
        border-bottom: 1px solid #ddd;
      }
      .trip-table thead {
        background-color: rgb(0, 42, 52);
        color: white;
      }
      .trip-table tbody tr:hover {
        background-color: #f1f1f1;
      }
      .price {
        font-weight: 700;
        color: #dc3545;
      }
      .datetime-cell {
        line-height: 1.4;
      }
      .no-data {
        padding: 20px;
        font-weight: 600;
        color: #6c757d;
      }
      .action-buttons button {
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin: 2px;
        font-size: 0.9rem;
        transition: background-color 0.3s;
      }
      .btn-book {
        background-color: #007bff;
        color: white;
      }
      .btn-book:hover {
        background-color: #0056b3;
      }
      .btn-view-customers {
        background-color: #6c757d;
        color: white;
      }
      .btn-view-customers:hover {
        background-color: #5a6268;
      }
      
      /* Thông báo (Không thay đổi) */
      .error-message, .success-message, .search-result-message {
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 8px;
        font-weight: 600;
      }
      .error-message {
        background-color: #f8d7da;
        color: #721c24;
      }
      .success-message {
        background-color: #d4edda;
        color: #155724;
      }
      .search-result-message {
        background-color: #e2f2ff;
        color: #004085;
      }
      
      /* Footer (Không thay đổi) */
      .footer {
        background: linear-gradient(135deg, rgb(0, 64, 80), rgb(0, 42, 52));
        color: white;
        padding: 2rem 0;
        text-align: center;
        margin-top: 3rem;
      }
      .footer a {
        color: #a1bffa;
        margin: 0 0.5rem;
        transition: color 0.3s ease;
      }
      .footer a:hover {
        color: white;
      }

      /* Responsive (Không thay đổi) */
      @media (max-width: 992px) {
        .filter-form-custom {
          flex-direction: column;
          align-items: stretch;
          height: auto;
        }
        .filter-group-custom {
            width: 100%;
        }
        .button-group-custom {
            margin-top: 0.5rem;
        }
      }
    </style>
</head>
<body>
    <div class="header">
        <img
            src="${pageContext.request.contextPath}/images/logo-name-header.svg"
        />
        <h1 style="color: #ffe22a">
            <i class="fas fa-bus-alt me-2"></i> Hệ thống đặt vé xe
        </h1>
        
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
    </div>
    
    <div class="search-form-wrapper">
        <form id="filterForm" action="timKiemChuyenXeServlet" method="get" class="filter-form-custom">
            
            <div class="filter-group-custom" style="min-width: 250px;">
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
            
            <div class="filter-group-custom" style="min-width: 250px;">
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
            
            <div class="filter-group-custom" style="min-width: 180px;">
                <label>📅 Ngày đi:</label>
                <%
                    String selectedNgayDi = (String) request.getAttribute("selectedNgayDi");
                %>
                <input type="date" name="ngayDi" value="<%= selectedNgayDi != null ? selectedNgayDi : "" %>">
            </div>
            
            <div class="filter-group-custom button-group-custom" style="min-width: 150px;">
                <button type="submit" class="btn-search">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>
            </div>
        </form>
    </div>

    <main class="main-content">
        <h2 class="mb-4" style="font-size: 24px; font-weight: 700; color: rgb(0, 42, 52);">
            📋 Danh sách chuyến xe 
        </h2>
        
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                ❌ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <% if(session.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                ✅ <%= session.getAttribute("successMessage") %>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>
        
        <% if(session.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                ❌ <%= session.getAttribute("errorMessage") %>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="search-result-message">
                ℹ️ <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <div class="table-container">
            <table class="trip-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Từ</th>
                        <th>Đến</th>
                        <th>Giờ khởi hành</th>
                        <th>Giá vé</th>
                        <th>Số chỗ</th>
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
%>
<tr>
    <td><%= stt++ %></td>
    <td><%= chuyenXe.getTenDiemDi() != null ? chuyenXe.getTenDiemDi() : "N/A" %></td>
    <td><%= chuyenXe.getTenDiemDen() != null ? chuyenXe.getTenDiemDen() : "N/A" %></td>
    <td class="datetime-cell">
        🕒 <%= formattedDateTime %>
    </td>
    <td class="price">💰 <%= chuyenXe.getGia() != null ? formatter.format(chuyenXe.getGia()) : "0" %> VNĐ</td>
    <td>🪑 <%= chuyenXe.getSoCho() %></td>
    <td><%= chuyenXe.getBienSoXe() != null ? chuyenXe.getBienSoXe() : "N/A" %></td>
    <td><%= chuyenXe.getTenNhaXe() != null ? chuyenXe.getTenNhaXe() : "N/A" %></td>
    <td>
        <div class="action-buttons">
            <button class="btn-book" onclick="datVe('<%= chuyenXe.getId() %>')">
                🎫 Đặt vé
            </button>
            <button class="btn-view-customers" onclick="xemKhachHang('<%= chuyenXe.getId() %>')">
                👥 Khách hàng
            </button>
        </div>
    </td>
</tr>
<%
        }
    } else {
%>
<tr>
    <td colspan="9" class="no-data">
        📭 Không có chuyến xe nào được tìm thấy
    </td>
</tr>
<%
    }
%>
</tbody>
            </table>
        </div>
    </main>
    
    <div class="footer">
      <p>Tân Quang Dũng</p>
      <p>
        <a href="#"><i class="fab fa-facebook-f"></i></a>
        <a href="#"><i class="fab fa-twitter"></i></a>
        <a href="#"><i class="fab fa-instagram"></i></a>
      </p>
    </div>

    <script>
        function datVe(chuyenXeId) {
            window.location.href = 'datXeServlet?chuyenXeId=' + chuyenXeId;
        }
        
        function xemKhachHang(chuyenXeId) {
            window.location.href = 'xemKhachHangTungChuyenServlet?chuyenXeId=' + chuyenXeId;
        }
    </script>
    
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>
</body>
</html>