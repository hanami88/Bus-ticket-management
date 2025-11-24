package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bean.ChuyenXe;
import model.bean.DiaDiem;
import model.bo.chuyenXeBO;
import model.bo.diaDiemBO;
import model.utils.SessionUtils;

@WebServlet("/quanLyChuyenXeHoanThanhServlet")
public class quanLyChuyenXeHoanThanhServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private diaDiemBO diaDiemBO = new diaDiemBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }
        
        try {
            // Lấy danh sách chuyến xe đã hoàn thành
            List<ChuyenXe> listChuyenXe = chuyenXeBO.getChuyenXeHoanThanh();
            
            // Lấy danh sách địa điểm cho bộ lọc
            List<DiaDiem> listDiaDiem = diaDiemBO.getAllDiaDiem();
            
            // Thiết lập attributes
            request.setAttribute("listChuyenXe", listChuyenXe);
            request.setAttribute("listDiaDiem", listDiaDiem);
            request.setAttribute("isCompletedTrips", true); // Flag để phân biệt với trang chính
            
            // Hiển thị thông báo nếu có
            HttpSession session = request.getSession();
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }
            
            // Forward đến JSP
            request.getRequestDispatcher("/chuyenXeHoanThanh.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách chuyến xe: " + e.getMessage());
            request.getRequestDispatcher("/chuyenXeHoanThanh.jsp").forward(request, response);
        }
    }
}