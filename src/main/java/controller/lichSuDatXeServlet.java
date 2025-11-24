package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bean.DatXe;
import model.bean.User;
import model.bo.authBO;
import model.bo.datXeBO;

@WebServlet("/lichSuDatXeServlet")
public class lichSuDatXeServlet extends HttpServlet {
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
            // Lấy thông tin user
            User user = authBO.getUserByEmail(email);
            if (user == null) {
                response.sendRedirect("dangNhapServlet");
                return;
            }
            
            // Lấy lịch sử đặt vé
            List<DatXe> lichSuDatXe = datXeBO.getLichSuDatXeWithDetails(user.getId());
            
            // Set attributes
            request.setAttribute("lichSuDatXe", lichSuDatXe);
            request.setAttribute("user", user);
            
            // Forward đến JSP
            request.getRequestDispatcher("/lichSuDatXe.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải lịch sử đặt vé: " + e.getMessage());
            request.getRequestDispatcher("/lichSuDatXe.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}