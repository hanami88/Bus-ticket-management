package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bo.adminBO;
import model.utils.SessionUtils;

@WebServlet("/dashboardServlet")
public class dashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final adminBO adminBO = new adminBO();

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
        
        // Kiểm tra quyền admin
        if (!SessionUtils.isAdmin(request)) {
            response.sendRedirect("dangNhapServlet?error=access_denied");
            return;
        }
        
        try {
            // Lấy thống kê từ adminBO
            long numberOfChuyenXe = adminBO.getNumberOfChuyenXe();
            int numberOfNhaXe = adminBO.getNumberOfNhaXe();
            long numberOfUsers = adminBO.getNumberOfUsers();
            long todayBookings = adminBO.getTodayBookings();
            BigDecimal todayRevenue = adminBO.getTodayRevenue();
            
            // Format số tiền
            NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
            String formattedRevenue = formatter.format(todayRevenue);
            
            // Set attributes cho JSP
            request.setAttribute("numberOfChuyenXe", numberOfChuyenXe);
            request.setAttribute("numberOfNhaXe", numberOfNhaXe);
            request.setAttribute("numberOfUsers", numberOfUsers);
            request.setAttribute("todayBookings", todayBookings);
            request.setAttribute("todayRevenue", todayRevenue);
            request.setAttribute("formattedRevenue", formattedRevenue);
            
            // Lấy thông tin admin từ session
            HttpSession session = request.getSession();
            String adminName = (String) session.getAttribute("email");
            request.setAttribute("adminName", adminName);
            
            // Forward đến trang dashboard
            request.getRequestDispatcher("/dashboardAdmin.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
            request.getRequestDispatcher("/dashboardAdmin.jsp").forward(request, response);
        }
    }
}