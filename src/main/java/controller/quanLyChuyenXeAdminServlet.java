package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bean.ChuyenXe;
import model.bean.DiaDiem;
import model.bean.NhaXe;
import model.bo.adminBO;
import model.bo.chuyenXeBO;
import model.bo.diaDiemBO;
import model.utils.SessionUtils;

@WebServlet("/quanLyChuyenXeAdminServlet")
public class quanLyChuyenXeAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final adminBO adminBO = new adminBO();
    private final chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private final diaDiemBO diaDiemBO = new diaDiemBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập và quyền admin
        if (!SessionUtils.isLoggedIn(request)) {
            response.sendRedirect("dangNhapServlet");
            return;
        }
        
        if (!SessionUtils.isAdmin(request)) {
            response.sendRedirect("quanLyChuyenXeServlet?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    handleListAction(request, response);
                    break;
                case "add":
                    handleAddAction(request, response);
                    break;
                case "update":
                    handleUpdateAction(request, response);
                    break;
                case "delete":
                    handleDeleteAction(request, response);
                    break;
                case "search":
                    handleSearchAction(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Hành động không hợp lệ!");
                    handleListAction(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            handleListAction(request, response);
        }
    }
    
    private void handleListAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy tất cả chuyến xe (bao gồm cả đã hoàn thành)
            List<ChuyenXe> allChuyenXe = adminBO.getAllChuyenXe();
            List<DiaDiem> allDiaDiem = diaDiemBO.getAllDiaDiem();
            List<NhaXe> allNhaXe = adminBO.getAllNhaXe();
            
            // Thống kê
            long totalTrips = adminBO.getNumberOfChuyenXe();
            long activeTrips = allChuyenXe.stream()
                .filter(cx -> cx.getGioKhoiHanh().isAfter(LocalDateTime.now()) && cx.getSoCho() > 0)
                .count();
            long completedTrips = allChuyenXe.stream()
                .filter(cx -> cx.getGioKhoiHanh().isBefore(LocalDateTime.now()) || cx.getSoCho() == 0)
                .count();
            
            // Set attributes
            request.setAttribute("allChuyenXe", allChuyenXe);
            request.setAttribute("allDiaDiem", allDiaDiem);
            request.setAttribute("allNhaXe", allNhaXe);
            request.setAttribute("totalTrips", totalTrips);
            request.setAttribute("activeTrips", activeTrips);
            request.setAttribute("completedTrips", completedTrips);
            
            request.getRequestDispatcher("/quanLyChuyenXe.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách chuyến xe: " + e.getMessage());
            request.getRequestDispatcher("/quanLyChuyenXe.jsp").forward(request, response);
        }
    }
    
    private void handleAddAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy parameters
            int tuNoi = Integer.parseInt(request.getParameter("tuNoi"));
            int denNoi = Integer.parseInt(request.getParameter("denNoi"));
            String gioKhoiHanhStr = request.getParameter("gioKhoiHanh");
            String giaStr = request.getParameter("gia");
            int soCho = Integer.parseInt(request.getParameter("soCho"));
            String bienSoXe = request.getParameter("bienSoXe");
            int nhaXeId = Integer.parseInt(request.getParameter("nhaXeId"));
            
            // Validate dữ liệu
            if (tuNoi == denNoi) {
                throw new Exception("Điểm đi và điểm đến không được giống nhau!");
            }
            
            if (soCho <= 0) {
                throw new Exception("Số chỗ phải lớn hơn 0!");
            }
            
            LocalDateTime gioKhoiHanh = LocalDateTime.parse(gioKhoiHanhStr);
            if (gioKhoiHanh.isBefore(LocalDateTime.now())) {
                throw new Exception("Giờ khởi hành phải sau thời điểm hiện tại!");
            }
            
            BigDecimal gia = new BigDecimal(giaStr);
            if (gia.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("Giá vé phải lớn hơn 0!");
            }
            
            // Tạo object ChuyenXe
            ChuyenXe chuyenXe = new ChuyenXe();
            chuyenXe.setTuNoi(tuNoi);
            chuyenXe.setDenNoi(denNoi);
            chuyenXe.setGioKhoiHanh(gioKhoiHanh);
            chuyenXe.setGia(gia);
            chuyenXe.setSoCho(soCho);
            chuyenXe.setBienSoXe(bienSoXe);
            chuyenXe.setNhaXeId(nhaXeId);
            
            // Thêm chuyến xe
            boolean isAdded = adminBO.addChuyenXe(chuyenXe);
            
            if (isAdded) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "✅ Thêm chuyến xe thành công!");
            } else {
                request.setAttribute("errorMessage", "❌ Thêm chuyến xe thất bại!");
            }
            
            response.sendRedirect("quanLyChuyenXeAdminServlet?action=list");
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "❌ Dữ liệu đầu vào không hợp lệ!");
            handleListAction(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "❌ Định dạng thời gian không hợp lệ!");
            handleListAction(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "❌ " + e.getMessage());
            handleListAction(request, response);
        }
    }
    
    private void handleUpdateAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy parameters
            int id = Integer.parseInt(request.getParameter("id"));
            int tuNoi = Integer.parseInt(request.getParameter("tuNoi"));
            int denNoi = Integer.parseInt(request.getParameter("denNoi"));
            String gioKhoiHanhStr = request.getParameter("gioKhoiHanh");
            String giaStr = request.getParameter("gia");
            int soCho = Integer.parseInt(request.getParameter("soCho"));
            String bienSoXe = request.getParameter("bienSoXe");
            int nhaXeId = Integer.parseInt(request.getParameter("nhaXeId"));
            
            // Validate dữ liệu
            if (tuNoi == denNoi) {
                throw new Exception("Điểm đi và điểm đến không được giống nhau!");
            }
            
            LocalDateTime gioKhoiHanh = LocalDateTime.parse(gioKhoiHanhStr);
            BigDecimal gia = new BigDecimal(giaStr);
            
            if (gia.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("Giá vé phải lớn hơn 0!");
            }
            
            // Tạo object ChuyenXe
            ChuyenXe chuyenXe = new ChuyenXe();
            chuyenXe.setId(id);
            chuyenXe.setTuNoi(tuNoi);
            chuyenXe.setDenNoi(denNoi);
            chuyenXe.setGioKhoiHanh(gioKhoiHanh);
            chuyenXe.setGia(gia);
            chuyenXe.setSoCho(soCho);
            chuyenXe.setBienSoXe(bienSoXe);
            chuyenXe.setNhaXeId(nhaXeId);
            
            // Cập nhật chuyến xe
            boolean isUpdated = adminBO.updateChuyenXe(chuyenXe);
            
            if (isUpdated) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "✅ Cập nhật chuyến xe thành công!");
            } else {
                request.setAttribute("errorMessage", "❌ Cập nhật chuyến xe thất bại!");
            }
            
            response.sendRedirect("quanLyChuyenXeAdminServlet?action=list");
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "❌ " + e.getMessage());
            handleListAction(request, response);
        }
    }
    
    private void handleDeleteAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            boolean isDeleted = adminBO.deleteChuyenXe(id);
            
            if (isDeleted) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "✅ Xóa chuyến xe thành công!");
            } else {
                request.setAttribute("errorMessage", "❌ Xóa chuyến xe thất bại!");
            }
            
            response.sendRedirect("quanLyChuyenXeAdminServlet?action=list");
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect("quanLyChuyenXeAdminServlet?action=list");
        }
    }
    
    private void handleSearchAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy parameters tìm kiếm
            String tuNoiStr = request.getParameter("tuNoi");
            String denNoiStr = request.getParameter("denNoi");
            String ngayDi = request.getParameter("ngayDi");
            
            Integer tuNoi = (tuNoiStr != null && !tuNoiStr.isEmpty()) ? Integer.parseInt(tuNoiStr) : null;
            Integer denNoi = (denNoiStr != null && !denNoiStr.isEmpty()) ? Integer.parseInt(denNoiStr) : null;
            
            // Tìm kiếm
            List<ChuyenXe> searchResults = chuyenXeBO.timKiemChuyenXe(tuNoi, denNoi, ngayDi);
            List<DiaDiem> allDiaDiem = diaDiemBO.getAllDiaDiem();
            List<NhaXe> allNhaXe = adminBO.getAllNhaXe();
            
            // Thống kê kết quả tìm kiếm
            long totalResults = searchResults.size();
            long activeResults = searchResults.stream()
                .filter(cx -> cx.getGioKhoiHanh().isAfter(LocalDateTime.now()) && cx.getSoCho() > 0)
                .count();
            
            // Set attributes
            request.setAttribute("allChuyenXe", searchResults);
            request.setAttribute("allDiaDiem", allDiaDiem);
            request.setAttribute("allNhaXe", allNhaXe);
            request.setAttribute("totalTrips", totalResults);
            request.setAttribute("activeTrips", activeResults);
            request.setAttribute("completedTrips", totalResults - activeResults);
            
            // Giữ lại giá trị search
            request.setAttribute("selectedTuNoi", tuNoi);
            request.setAttribute("selectedDenNoi", denNoi);
            request.setAttribute("selectedNgayDi", ngayDi);
            
            String message = "Tìm thấy " + totalResults + " chuyến xe";
            if (totalResults == 0) {
                message = "Không tìm thấy chuyến xe nào phù hợp";
            }
            request.setAttribute("searchMessage", message);
            
            request.getRequestDispatcher("/quanLyChuyenXe.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tìm kiếm: " + e.getMessage());
            handleListAction(request, response);
        }
    }
}