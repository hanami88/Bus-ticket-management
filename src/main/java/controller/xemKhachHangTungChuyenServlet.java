package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.bean.ChuyenXe;
import model.bean.User;
import model.bo.chuyenXeBO;
import model.bo.khachHangBO;
import model.utils.SessionUtils;

@WebServlet("/xemKhachHangTungChuyenServlet")
public class xemKhachHangTungChuyenServlet extends HttpServlet{
    private static final long serialVersionUID = 1L;
    private final chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private final model.bo.khachHangBO khachHangBO = new khachHangBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }

        try {
            String chuyenXeIdStr = request.getParameter("chuyenXeId");
            if (chuyenXeIdStr == null || chuyenXeIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Chuyến xe không tồn tại");
                request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
                return;
            }
            
            int chuyenXeId = Integer.parseInt(chuyenXeIdStr);

            ChuyenXe chuyenXe = chuyenXeBO.getChuyenXeById(chuyenXeId);
            if (chuyenXe == null) {
                request.setAttribute("errorMessage", "Chuyến xe không tồn tại");
                request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
                return;
            }

            List<User> danhSachKhachHang = khachHangBO.getKhachHangByChuyenXeId(chuyenXeId);

            int tongSoVeDaDat = 0;
            if (danhSachKhachHang != null && !danhSachKhachHang.isEmpty()) {
                for (User user : danhSachKhachHang) {
                    tongSoVeDaDat += user.getSoLuongVeDat();
                }
            }

            request.setAttribute("chuyenXe", chuyenXe);
            request.setAttribute("danhSachKhachHang", danhSachKhachHang);
            request.setAttribute("tongSoVeDaDat", tongSoVeDaDat);

            request.getRequestDispatcher("xemKhachHangTungChuyen.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID chuyến xe không hợp lệ");
            request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi lấy thông tin khách hàng: " + e.getMessage());
            request.getRequestDispatcher("quanLyChuyenXeServlet").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }
    }
}
