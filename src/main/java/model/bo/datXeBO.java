package model.bo;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import model.bean.DatXe;
import model.dao.datXeDAO;

public class datXeBO {
    private final datXeDAO datXeDAO = new datXeDAO();
    
    public boolean datVe(int userId, int chuyenXeId, int soLuong) throws Exception {
        if (userId <= 0 || chuyenXeId <= 0 || soLuong <= 0) {
            return false;
        }
        
        DatXe datXe = new DatXe();
        datXe.setUserId(userId);
        datXe.setChuyenXeId(chuyenXeId);
        datXe.setSoLuong(soLuong);
        datXe.setNgayDat(LocalDateTime.now());
        
        return datXeDAO.datVe(datXe);
    }
    
    public List<DatXe> getDatXeByUserId(int userId) throws Exception {
        if (userId <= 0) {
            return null;
        }
        return datXeDAO.getDatXeByUserId(userId);
    }

    // Lấy lịch sử đặt vé với thông tin chi tiết
    public List<DatXe> getLichSuDatXeWithDetails(int userId) throws Exception {
        if (userId <= 0) {
            return new ArrayList<>();
        }
        return datXeDAO.getLichSuDatXeWithDetails(userId);
    }
}