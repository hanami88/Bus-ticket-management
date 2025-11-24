package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.bean.DatXe;
import model.bean.User;
import model.bo.adminBO;
import model.utils.SessionUtils;

@WebServlet({"/quanLyUserServlet"})
public class quanLyUserServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private adminBO adminBO = new adminBO();

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      this.doPost(request, response);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            List<User> allUsers = this.adminBO.getAllUsers();
            request.setAttribute("allUsers", allUsers);
            long totalUsers = this.adminBO.getNumberOfUsers();
            request.setAttribute("totalUsers", totalUsers);
            destination = "/quanLyUser.jsp";
         } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load users: " + e.getMessage());
            destination = "/dashboardServlet";
         }
      } else {
         String email;
         String phone;
         String name;
         if ("add".equals(action)) {
            name = request.getParameter("name");
            email = request.getParameter("email");
            phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String roleStr = request.getParameter("role");
            
            try {
               User user = new User();
               user.setName(name);
               user.setEmail(email);
               user.setPhone(phone);
               user.setPassword(password != null ? password : "123456");
               user.setRole(roleStr != null && !roleStr.isEmpty() ? Integer.parseInt(roleStr) : 1);
               
               boolean result = this.adminBO.addUser(user);
               if (result) {
                  request.setAttribute("successMessage", "User added successfully.");
               } else {
                  request.setAttribute("errorMessage", "Failed to add user. Please try again.");
               }
            } catch (Exception e) {
               request.setAttribute("errorMessage", "Failed to add user: " + e.getMessage());
            }

            destination = "/quanLyUserServlet?action=open";
         } else {
            int id;
            if ("update".equals(action)) {
               id = Integer.parseInt(request.getParameter("id"));
               name = request.getParameter("name");
               email = request.getParameter("email");
               phone = request.getParameter("phone");
               String roleStr = request.getParameter("role");
               
               try {
                  User user = new User();
                  user.setId(id);
                  user.setName(name);
                  user.setEmail(email);
                  user.setPhone(phone);
                  user.setRole(roleStr != null && !roleStr.isEmpty() ? Integer.parseInt(roleStr) : 1);
                  
                  boolean result = this.adminBO.updateUser(user);
                  if (result) {
                     request.setAttribute("successMessage", "User updated successfully.");
                  } else {
                     request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                  }
               } catch (Exception e) {
                  request.setAttribute("errorMessage", "Failed to update user: " + e.getMessage());
               }

               destination = "/quanLyUserServlet?action=open";
            } else if ("delete".equals(action)) {
               id = Integer.parseInt(request.getParameter("id"));
               try {
                  boolean result = this.adminBO.deleteUser(id);
                  if (result) {
                     request.setAttribute("successMessage", "User deleted successfully.");
                  } else {
                     request.setAttribute("errorMessage", "Failed to delete user. Please try again.");
                  }
               } catch (SQLException e) {
                  if (e.getErrorCode() == 1451) {
                     request.setAttribute("errorMessage", "Không thể xóa user! Người dùng này đã có lịch sử đặt vé. " +
                     "Hãy xóa các vé đã đặt trước khi xóa user.");
                  } else {
                     request.setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
                  }
               } catch (Exception e) {
                  request.setAttribute("errorMessage", "Error: " + e.getMessage());
               }

               destination = "/quanLyUserServlet?action=open";
            } else if ("viewHistory".equals(action)) {
    id = Integer.parseInt(request.getParameter("id"));
    try {
        // Lấy lịch sử đặt vé của user
        List<DatXe> lichSuDatXe = this.adminBO.getUserHistory(id);
        
        // Lấy thông tin user
        List<User> allUsers = this.adminBO.getAllUsers();
        User selectedUser = allUsers.stream().filter(u -> u.getId() == id).findFirst().orElse(null);
        
        if (selectedUser == null) {
            request.setAttribute("errorMessage", "Không tìm thấy người dùng!");
            destination = "/quanLyUserServlet?action=open";
        } else {
            // Tính toán thống kê
            int tongSoVeDaDat = 0;
            double tongTienDaChi = 0;
            
            for (DatXe datXe : lichSuDatXe) {
                tongSoVeDaDat += datXe.getSoLuong();
                if (datXe.getGiaVe() != null) {
                    tongTienDaChi += datXe.getGiaVe().doubleValue() * datXe.getSoLuong();
                }
            }
            
            // Set attributes với tên đúng
            request.setAttribute("selectedUser", selectedUser);
            request.setAttribute("lichSuDatXe", lichSuDatXe);
            request.setAttribute("tongSoVeDaDat", tongSoVeDaDat);
            request.setAttribute("tongTienDaChi", tongTienDaChi);
            request.setAttribute("soChuyenDaDat", lichSuDatXe.size());
            
            // Forward đến trang userHistory.jsp
            destination = "/userHistory.jsp";
        }
    } catch (Exception e) {
        e.printStackTrace(); // Thêm để debug
        request.setAttribute("errorMessage", "Failed to load user history: " + e.getMessage());
        destination = "/quanLyUserServlet?action=open";
    }
} else if ("search".equals(action)) {
               name = request.getParameter("name");
               email = request.getParameter("email");
               phone = request.getParameter("phone");
               String roleStr = request.getParameter("role");
               
               try {
                  // Simple search implementation - can be enhanced in DAO later
                  List<User> allUsers = this.adminBO.getAllUsers();
                  List<User> searchResults = allUsers;
                  
                  // Filter by name
                  if (name != null && !name.trim().isEmpty()) {
                     final String searchName = name.toLowerCase();
                     searchResults = searchResults.stream()
                        .filter(user -> user.getName().toLowerCase().contains(searchName))
                        .collect(java.util.stream.Collectors.toList());
                  }
                  
                  // Filter by email
                  if (email != null && !email.trim().isEmpty()) {
                     final String searchEmail = email.toLowerCase();
                     searchResults = searchResults.stream()
                        .filter(user -> user.getEmail().toLowerCase().contains(searchEmail))
                        .collect(java.util.stream.Collectors.toList());
                  }
                  
                  // Filter by role
                  if (roleStr != null && !roleStr.trim().isEmpty()) {
                     final int searchRole = Integer.parseInt(roleStr);
                     searchResults = searchResults.stream()
                        .filter(user -> user.getRole() == searchRole)
                        .collect(java.util.stream.Collectors.toList());
                  }
                  
                  request.setAttribute("allUsers", searchResults);
                  long totalUsers = this.adminBO.getNumberOfUsers();
                  request.setAttribute("totalUsers", totalUsers);
                  request.setAttribute("searchMessage", "Found " + searchResults.size() + " users");
                  destination = "/quanLyUser.jsp";
               } catch (Exception e) {
                  request.setAttribute("errorMessage", "Search failed: " + e.getMessage());
                  destination = "/quanLyUserServlet?action=open";
               }
            }
         }
      }

      RequestDispatcher rd;
      if (destination != null) {
         rd = request.getRequestDispatcher(destination);
         rd.forward(request, response);
      } else {
         request.setAttribute("errorMessage", "Invalid action specified.");
         destination = "/dashboardServlet";
         rd = request.getRequestDispatcher(destination);
         rd.forward(request, response);
      }
   }
}