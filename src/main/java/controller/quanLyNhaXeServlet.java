package controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.bean.NhaXe;
import model.bo.adminBO;
import model.utils.SessionUtils;

@WebServlet({"/quanLyNhaXeServlet"})
public class quanLyNhaXeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private adminBO adminBO = new adminBO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        this.doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String destination = null;
        String action = request.getParameter("action");
        if (action == null) {
            action = "open";
        }

        // Kiểm tra đăng nhập và quyền admin
        if (!SessionUtils.isLoggedIn(request)) {
            request.setAttribute("errorMessage", "You must be logged in to access this page.");
            destination = "/login.jsp";
        } else if (!SessionUtils.isAdmin(request)) {
            request.setAttribute("errorMessage", "You don't have permission to access this page.");
            destination = "/dashboardServlet";
        } else if ("open".equals(action)) {
            try {
                List<NhaXe> allNhaXe = this.adminBO.getAllNhaXe();
                request.setAttribute("allNhaXe", allNhaXe);
                int totalNhaXe = this.adminBO.getNumberOfNhaXe();
                request.setAttribute("totalNhaXe", totalNhaXe);
                destination = "/quanLyNhaXe.jsp";
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to load nhà xe: " + e.getMessage());
                destination = "/dashboardServlet";
            }
        } else {
            String diaChi;
            String sdt;
            String tenNhaXe;
            String email;
            
            if ("add".equals(action)) {
                tenNhaXe = request.getParameter("tenNhaXe");
                diaChi = request.getParameter("diaChi");
                sdt = request.getParameter("sdt");
                email = request.getParameter("email");
                
                try {
                    NhaXe nhaXe = new NhaXe();
                    nhaXe.setTenNhaXe(tenNhaXe);
                    nhaXe.setDiaChi(diaChi);
                    nhaXe.setSoDienThoai(sdt);
                    
                    
                    boolean result = this.adminBO.addNhaXe(nhaXe);
                    if (result) {
                        request.setAttribute("successMessage", "Nhà xe added successfully.");
                    } else {
                        request.setAttribute("errorMessage", "Failed to add nhà xe. Please try again.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Failed to add nhà xe: " + e.getMessage());
                }
                
                destination = "/quanLyNhaXeServlet?action=open";
            } else {
                int id;
                if ("update".equals(action)) {
                    id = Integer.parseInt(request.getParameter("id"));
                    tenNhaXe = request.getParameter("tenNhaXe");
                    diaChi = request.getParameter("diaChi");
                    sdt = request.getParameter("sdt");
                    email = request.getParameter("email");
                    
                    try {
                        NhaXe nhaXe = new NhaXe();
                        nhaXe.setId(id);
                        nhaXe.setTenNhaXe(tenNhaXe);
                        nhaXe.setDiaChi(diaChi);
                        nhaXe.setSoDienThoai(sdt);
                        
                        boolean result = this.adminBO.updateNhaXe(nhaXe);
                        if (result) {
                            request.setAttribute("successMessage", "Nhà xe updated successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Failed to update nhà xe. Please try again.");
                        }
                    } catch (Exception e) {
                        request.setAttribute("errorMessage", "Failed to update nhà xe: " + e.getMessage());
                    }
                    
                    destination = "/quanLyNhaXeServlet?action=open";
                } else if ("delete".equals(action)) {
                    id = Integer.parseInt(request.getParameter("id"));
                    
                    try {
                        boolean result = this.adminBO.deleteNhaXe(id);
                        if (result) {
                            request.setAttribute("successMessage", "Nhà xe deleted successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Failed to delete nhà xe. Please try again.");
                        }
                    } catch (Exception e) {
                        request.setAttribute("errorMessage", "Failed to delete nhà xe: " + e.getMessage());
                    }
                    
                    destination = "/quanLyNhaXeServlet?action=open";
                }
            }
        }

        RequestDispatcher dispatcher;
        if (destination != null) {
            dispatcher = request.getRequestDispatcher(destination);
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Invalid action specified.");
            destination = "/dashboardServlet";
            dispatcher = request.getRequestDispatcher(destination);
            dispatcher.forward(request, response);
        }
    }
}