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


@WebServlet("/timKiemChuyenXeServlet")
public class timKiemChuyenXeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final chuyenXeBO chuyenXeBO = new chuyenXeBO();
    private final diaDiemBO diaDiemBO = new diaDiemBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtils.requireLogin(request, response)) {
            return;
        }

        try {
            String tuNoiStr = request.getParameter("tuNoi");
            String denNoiStr = request.getParameter("denNoi");
            String ngayDi = request.getParameter("ngayDi");

            Integer tuNoi = null;
            Integer denNoi = null;

            if (tuNoiStr != null && !tuNoiStr.trim().isEmpty() && !tuNoiStr.equals("0")) {
                tuNoi = Integer.parseInt(tuNoiStr);
            }

            if (denNoiStr != null && !denNoiStr.trim().isEmpty() && !denNoiStr.equals("0")) {
                denNoi = Integer.parseInt(denNoiStr);
            }

            // Xử lý tìm kiếm chuyến xe 
            List<ChuyenXe> listChuyenXe;
            if (tuNoi == null && denNoi == null && (ngayDi == null || ngayDi.trim().isEmpty())) {
                listChuyenXe = chuyenXeBO.getAllChuyenXe();
            } else {
                listChuyenXe = chuyenXeBO.timKiemChuyenXe(tuNoi, denNoi, ngayDi);
            }

            List<DiaDiem> listDiaDiem = diaDiemBO.getAllDiaDiem();

            request.setAttribute("listChuyenXe", listChuyenXe);
            request.setAttribute("listDiaDiem", listDiaDiem);

            request.setAttribute("selectedTuNoi", tuNoi);
            request.setAttribute("selectedDenNoi", denNoi);
            request.setAttribute("selectedNgayDi", ngayDi);

            request.getRequestDispatcher("danhSachChuyenXe.jsp").forward(request, response);

        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tìm kiếm chuyến xe");
            request.getRequestDispatcher("danhSachChuyenXe.jsp").forward(request, response);
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
