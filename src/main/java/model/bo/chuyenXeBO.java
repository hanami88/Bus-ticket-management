package model.bo;

import java.util.List;

import model.bean.ChuyenXe;
import model.dao.chuyenXeDAO;

public class chuyenXeBO {
    private final chuyenXeDAO chuyenXeDAO = new chuyenXeDAO();
    
    public List<ChuyenXe> getAllChuyenXe() throws Exception {
        return chuyenXeDAO.getAllChuyenXe();
    }

    public List<ChuyenXe> timKiemChuyenXe(Integer tuNoi, Integer denNoi, String ngayDi) throws Exception {
        return chuyenXeDAO.timKiemChuyenXe(tuNoi, denNoi, ngayDi);
    }
    
    public ChuyenXe getChuyenXeById(int id) throws Exception {
        if (id <= 0) {
            return null;
        }
        return chuyenXeDAO.getChuyenXeById(id);
    }
    
    // Kiểm tra và cập nhật số chỗ khi đặt vé
    public boolean datVeVaCapNhatSoCho(int chuyenXeId, int soLuongDat) throws Exception {
        if (chuyenXeId <= 0 || soLuongDat <= 0) {
            return false;
        }
        
        return chuyenXeDAO.capNhatSoCho(chuyenXeId, soLuongDat);
    }
    
    // Kiểm tra tính khả dụng
    public boolean kiemTraKhaDung(int chuyenXeId, int soLuongCanDat) throws Exception {
        return chuyenXeDAO.kiemTraKhaDung(chuyenXeId, soLuongCanDat);
    }
    
    // Lấy số chỗ còn lại
    public int getSoChoConLai(int chuyenXeId) throws Exception {
        return chuyenXeDAO.getSoChoConLai(chuyenXeId);
    }

    public List<ChuyenXe> getChuyenXeHoanThanh() throws Exception {
        return chuyenXeDAO.getChuyenXeHoanThanh();
    }

    public List<ChuyenXe> timKiemChuyenXeHoanThanh(Integer tuNoi, Integer denNoi, String ngayDi) throws Exception {
        return chuyenXeDAO.timKiemChuyenXeHoanThanh(tuNoi, denNoi, ngayDi);
    }
}