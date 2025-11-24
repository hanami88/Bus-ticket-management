package model.bo;

import java.math.BigDecimal;
import java.util.List;

import model.bean.ChuyenXe;
import model.bean.DatXe;
import model.bean.NhaXe;
import model.bean.User;
import model.dao.adminDAO;

public class adminBO {
    private final adminDAO adminDAO = new adminDAO();
    
    // ==================== THỐNG KÊ ====================
    
    public long getNumberOfChuyenXe() throws Exception {
        return adminDAO.getNumberOfChuyenXe();
    }
    
    public int getNumberOfNhaXe() throws Exception {
        return adminDAO.getNumberOfNhaXe();
    }
    
    public long getNumberOfUsers() throws Exception {
        return adminDAO.getNumberOfUsers();
    }
    
    public long getTodayBookings() throws Exception {
        return adminDAO.getTodayBookings();
    }
    
    public BigDecimal getTodayRevenue() throws Exception {
        return adminDAO.getTodayRevenue();
    }
    
    // ==================== QUẢN LÝ CHUYẾN XE ====================
    
    public List<ChuyenXe> getAllChuyenXe() throws Exception {
        return adminDAO.getAllChuyenXe();
    }

    public boolean addChuyenXe(ChuyenXe chuyenXe) throws Exception {
        // Validate dữ liệu
        if (chuyenXe.getTuNoi() == chuyenXe.getDenNoi()) {
            throw new Exception("Điểm đi và điểm đến không được giống nhau!");
        }
        
        if (chuyenXe.getSoCho() <= 0) {
            throw new Exception("Số chỗ phải lớn hơn 0!");
        }
        
        if (chuyenXe.getGia().compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Giá vé phải lớn hơn 0!");
        }
        
        return adminDAO.addChuyenXe(chuyenXe);
    }
    
    public boolean updateChuyenXe(ChuyenXe chuyenXe) throws Exception {
        return adminDAO.updateChuyenXe(chuyenXe);
    }
    
    public boolean deleteChuyenXe(int id) throws Exception {
        return adminDAO.deleteChuyenXe(id);
    }
    
    // ==================== QUẢN LÝ NHÀ XE ====================
    
    public List<NhaXe> getAllNhaXe() throws Exception {
        return adminDAO.getAllNhaXe();
    }
    
    public boolean addNhaXe(NhaXe nhaXe) throws Exception {
        // Validate dữ liệu
        if (nhaXe.getTenNhaXe() == null || nhaXe.getTenNhaXe().trim().isEmpty()) {
            throw new Exception("Tên nhà xe không được để trống!");
        }
        
        return adminDAO.addNhaXe(nhaXe);
    }
    
    public boolean updateNhaXe(NhaXe nhaXe) throws Exception {
        return adminDAO.updateNhaXe(nhaXe);
    }
    
    public boolean deleteNhaXe(int id) throws Exception {
        return adminDAO.deleteNhaXe(id);
    }
    
    // ==================== QUẢN LÝ USER ====================
    
    public List<User> getAllUsers() throws Exception {
        return adminDAO.getAllUsers();
    }
    
    public boolean addUser(User user) throws Exception {
        // Validate email
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            throw new Exception("Email không hợp lệ!");
        }
        
        return adminDAO.addUser(user);
    }
    
    public boolean updateUser(User user) throws Exception {
        return adminDAO.updateUser(user);
    }
    
    public boolean deleteUser(int id) throws Exception {
        return adminDAO.deleteUser(id);
    }
    
    public List<DatXe> getUserHistory(int userId) throws Exception {
        return adminDAO.getUserHistory(userId);
    }
    
    public List<DatXe> getAllBookings() throws Exception {
        return adminDAO.getAllBookings();
    }
}