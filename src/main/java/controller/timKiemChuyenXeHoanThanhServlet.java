package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.bean.ChuyenXe;
import model.bean.DiaDiem;
import model.bo.chuyenXeBO;
import model.bo.diaDiemBO;
import model.utils.SessionUtils;

@WebServlet("/timKiemChuyenXeHoanThanhServlet") 
public class timKiemChuyenXeHoanThanhServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private diaDiemBO diaDiemBO = new diaDiemBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }
        
        try {
            // Lấy parameters từ form tìm kiếm
            String tuNoiStr = request.getParameter("tuNoi");
            String denNoiStr = request.getParameter("denNoi");
            String ngayDi = request.getParameter("ngayDi");
            
            Integer tuNoi = (tuNoiStr != null && !tuNoiStr.isEmpty()) ? Integer.parseInt(tuNoiStr) : null;
            Integer denNoi = (denNoiStr != null && !denNoiStr.isEmpty()) ? Integer.parseInt(denNoiStr) : null;
            
            // Tìm kiếm chuyến xe đã hoàn thành
            List<ChuyenXe> listChuyenXe = chuyenXeBO.timKiemChuyenXeHoanThanh(tuNoi, denNoi, ngayDi);
            
            // Lấy danh sách địa điểm cho bộ lọc
            List<DiaDiem> listDiaDiem = diaDiemBO.getAllDiaDiem();
            
            // Thiết lập attributes
            request.setAttribute("listChuyenXe", listChuyenXe);
            request.setAttribute("listDiaDiem", listDiaDiem);
            request.setAttribute("isCompletedTrips", true);
            
            // Giữ lại giá trị đã chọn trong form
            request.setAttribute("selectedTuNoi", tuNoi);
            request.setAttribute("selectedDenNoi", denNoi);
            request.setAttribute("selectedNgayDi", ngayDi);
            
            // Hiển thị thông báo kết quả
            String message = "Tìm thấy " + listChuyenXe.size() + " chuyến xe đã hoàn thành";
            if (listChuyenXe.isEmpty()) {
                message = "Không tìm thấy chuyến xe nào phù hợp với điều kiện tìm kiếm";
            }
            request.setAttribute("message", message);
            
            // Forward đến JSP
            request.getRequestDispatcher("/chuyenXeHoanThanh.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tìm kiếm: " + e.getMessage());
            request.getRequestDispatcher("/chuyenXeHoanThanh.jsp").forward(request, response);
        }
    }
}