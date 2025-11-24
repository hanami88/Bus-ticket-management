package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import middleware.checkInputRegister;
import model.bean.User;
import model.bo.authBO;

@WebServlet("/dangKyServlet")
public class dangKyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final authBO authBO = new authBO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("dangKy.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        // Validate input
        if (!checkInputRegister.isValidInputRegister(name, email, password, phone)) {
            request.setAttribute("errorMessage", "Invalid input");
            request.getRequestDispatcher("dangKy.jsp").forward(request, response);
            return;
        }

        // Proceed with registration

        try {
            User newUser = new User();
            newUser.setName(name);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setPhone(phone);
            newUser.setRole(1); // Default role for user

            boolean isRegistered = authBO.dangKy(newUser);
            if (isRegistered) {
                request.setAttribute("successMessage", "Registration successful");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Email đã tồn tại");
                request.getRequestDispatcher("dangKy.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during registration");
            request.getRequestDispatcher("dangKy.jsp").forward(request, response);
        }
    }
}
