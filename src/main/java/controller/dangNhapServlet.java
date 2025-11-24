package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.bean.User;
import model.bo.authBO;

@WebServlet("/dangNhapServlet")
public class dangNhapServlet extends HttpServlet {
    private final authBO authBO = new authBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = authBO.dangNhap(email, password);
            if (user != null && user.getRole() == 1) {
                HttpSession session = request.getSession(true);

                session.setAttribute("isLoggedIn", true);
                session.setAttribute("email", email);

                session.setAttribute("loginTime", System.currentTimeMillis());

                session.setMaxInactiveInterval(30 * 60);

                response.sendRedirect("quanLyChuyenXeServlet");
            } else if (user != null && user.getRole() == 2) {
                HttpSession session = request.getSession(true);

                session.setAttribute("isLoggedIn", true);
                session.setAttribute("email", email);
                session.setAttribute("name", user.getName());
                session.setAttribute("role", user.getRole());
                session.setAttribute("loginTime", System.currentTimeMillis());

                session.setMaxInactiveInterval(30 * 60);

                response.sendRedirect("dashboardServlet");
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi đăng nhập");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
