package controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import model.utils.SessionUtils;

@WebServlet("/dangXuatServlet")
public class dangXuatServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = SessionUtils.getLoggedInUsername(request);
        
        SessionUtils.logout(request, response);
        
        if (username != null) {
            System.out.println("User " + username + " đã đăng xuất lúc: " + new java.util.Date());
        }
        
        response.sendRedirect("dangNhapServlet?logout=success");
    }
}