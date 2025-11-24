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

@WebServlet("/quanLyChuyenXeServlet")
public class quanLyChuyenXeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private final diaDiemBO diaDiemBO = new diaDiemBO();

    @Override
    protected  void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            List<ChuyenXe> listChuyenXe = chuyenXeBO.getAllChuyenXe();
            List<DiaDiem> listDiaDiem = diaDiemBO.getAllDiaDiem();
            request.setAttribute("listChuyenXe", listChuyenXe);
            request.setAttribute("listDiaDiem", listDiaDiem);
            request.getRequestDispatcher("danhSachChuyenXe.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách chuyến xe");
        }
    }  

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }
        doGet(request, response);
    }
}
