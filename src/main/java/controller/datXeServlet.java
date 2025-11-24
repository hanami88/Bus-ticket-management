package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bean.ChuyenXe;
import model.bean.User;
import model.bo.authBO;
import model.bo.chuyenXeBO;
import model.bo.datXeBO;
import model.utils.EmailUtils;

@WebServlet("/datXeServlet")
public class datXeServlet extends HttpServlet {
    private final chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private final datXeBO datXeBO = new datXeBO();
    private final authBO authBO = new authBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        if (email == null) {
            response.sendRedirect("dangNhapServlet");
            return;
        }
        
        try {
            String chuyenXeIdStr = request.getParameter("chuyenXeId");
            if (chuyenXeIdStr == null || chuyenXeIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin chuyến xe");
                request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
                return;
            }
            
            int chuyenXeId = Integer.parseInt(chuyenXeIdStr);
            ChuyenXe chuyenXe = chuyenXeBO.getChuyenXeById(chuyenXeId);
            
            if (chuyenXe == null) {
                request.setAttribute("errorMessage", "Chuyến xe không tồn tại");
                request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
                return;
            }
            
            request.setAttribute("chuyenXe", chuyenXe);
            request.getRequestDispatcher("/datXe.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        if (email == null) {
            response.sendRedirect("dangNhapServlet");
            return;
        }
        
        try {
            // Lấy thông tin từ form
            String chuyenXeIdStr = request.getParameter("chuyenXeId");
            String soLuongStr = request.getParameter("soLuong");
            String action = request.getParameter("action");
            
            if ("xacnhan".equals(action)) {
                // Xác nhận đặt vé - CHƯA LƯU VÀO DATABASE
                int chuyenXeId = Integer.parseInt(chuyenXeIdStr);
                int soLuong = Integer.parseInt(soLuongStr);
                
                // Validate cơ bản
                if (soLuong <= 0) {
                    request.setAttribute("errorMessage", "Số lượng vé phải lớn hơn 0");
                    doGet(request, response);
                    return;
                }
                
                // Lấy thông tin chuyến xe
                ChuyenXe chuyenXe = chuyenXeBO.getChuyenXeById(chuyenXeId);
                if (chuyenXe == null) {
                    request.setAttribute("errorMessage", "Chuyến xe không tồn tại");
                    doGet(request, response);
                    return;
                }
                
                // Kiểm tra số chỗ còn lại
                int soChoConLai = chuyenXeBO.getSoChoConLai(chuyenXeId);
                
                if (soChoConLai <= 0) {
                    request.setAttribute("errorMessage", "⚠️ Chuyến xe này đã hết vé!");
                    doGet(request, response);
                    return;
                }
                
                if (soLuong > soChoConLai) {
                    request.setAttribute("errorMessage", 
                        String.format("⚠️ Số lượng vé vượt quá số chỗ còn lại! Còn lại: %d vé", soChoConLai));
                    doGet(request, response);
                    return;
                }
                
                // Kiểm tra tính khả dụng
                if (!chuyenXeBO.kiemTraKhaDung(chuyenXeId, soLuong)) {
                    request.setAttribute("errorMessage", "⚠️ Không đủ chỗ trống cho số lượng vé yêu cầu!");
                    doGet(request, response);
                    return;
                }
                
                BigDecimal tongTien = chuyenXe.getGia().multiply(new BigDecimal(soLuong));
                
                // Cập nhật số chỗ còn lại hiện tại để hiển thị
                chuyenXe.setSoCho(soChoConLai);
                
                // Chuyển đến trang thanh toán (CHƯA LƯU DATABASE)
                request.setAttribute("chuyenXe", chuyenXe);
                request.setAttribute("soLuong", soLuong);
                request.setAttribute("tongTien", tongTien);
                request.getRequestDispatcher("/thanhToan.jsp").forward(request, response);
                
            } else if ("hoanthanh".equals(action)) {
                // Hoàn thành thanh toán - BÂY GIỜ MỚI LƯU VÀO DATABASE
                User user = authBO.getUserByEmail(email);
                if (user == null) {
                    response.sendRedirect("dangNhapServlet");
                    return;
                }
                
                int chuyenXeId = Integer.parseInt(chuyenXeIdStr);
                int soLuong = Integer.parseInt(soLuongStr);
                
                // Validate lại một lần nữa trước khi lưu
                if (soLuong <= 0) {
                    session.setAttribute("errorMessage", "Số lượng vé không hợp lệ");
                    response.sendRedirect("quanLyChuyenXeServlet");
                    return;
                }
                
                // Kiểm tra lại số chỗ còn lại (có thể có người khác đặt trong lúc này)
                if (!chuyenXeBO.kiemTraKhaDung(chuyenXeId, soLuong)) {
                    session.setAttribute("errorMessage", "⚠️ Không còn đủ chỗ trống! Vui lòng thử lại với số lượng ít hơn.");
                    response.sendRedirect("quanLyChuyenXeServlet");
                    return;
                }
                
                try {
                    // Bắt đầu transaction
                    // 1. Lưu thông tin đặt vé
                    boolean datVeSuccess = datXeBO.datVe(user.getId(), chuyenXeId, soLuong);
                    
                    // 2. Cập nhật số chỗ còn lại
                    boolean capNhatSuccess = false;
                    if (datVeSuccess) {
                        capNhatSuccess = chuyenXeBO.datVeVaCapNhatSoCho(chuyenXeId, soLuong);
                    }
                    
                    if (datVeSuccess && capNhatSuccess) {
                        // Đặt vé thành công
                        ChuyenXe chuyenXeInfo = chuyenXeBO.getChuyenXeById(chuyenXeId);
                        BigDecimal tongTien = chuyenXeInfo.getGia().multiply(new BigDecimal(soLuong));

                        NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
                        String tongTienFormatted = formatter.format(tongTien);

                        String ngayDat = LocalDateTime.now()
                            .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
                        String gioKhoiHanhFormatted = chuyenXeInfo.getGioKhoiHanh()
                            .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

                        boolean emailSent = EmailUtils.sendBookingConfirmation(
                            email,
                            user.getName() != null ? user.getName() : email,
                            chuyenXeInfo.getTenDiemDi(),
                            chuyenXeInfo.getTenDiemDen(),
                            gioKhoiHanhFormatted,
                            soLuong,
                            tongTienFormatted,
                            chuyenXeInfo.getBienSoXe(),
                            ngayDat
                        );
                        
                        if (emailSent) {
                            session.setAttribute("successMessage", "✅ Đặt vé thành công! Cảm ơn bạn đã sử dụng dịch vụ.");
                            response.sendRedirect("quanLyChuyenXeServlet");
                        } else {
                            session.setAttribute("errorMessage", "❌ Đặt vé thất bại. Vui lòng thử lại!");
                            response.sendRedirect("quanLyChuyenXeServlet");
                        }
                    } else {
                        // Đặt vé thất bại
                        session.setAttribute("errorMessage", "❌ Đặt vé thất bại. Vui lòng thử lại!");
                        response.sendRedirect("quanLyChuyenXeServlet");
                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "❌ Có lỗi xảy ra trong quá trình đặt vé: " + e.getMessage());
                    response.sendRedirect("quanLyChuyenXeServlet");
                }
                
            } else {
                doGet(request, response);
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}