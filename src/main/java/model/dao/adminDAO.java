package model.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.bean.ChuyenXe;
import model.bean.DatXe;
import model.bean.NhaXe;
import model.bean.User;
import model.utils.DBConnect;

public class adminDAO {
    
    // ==================== THỐNG KÊ ====================
    
    /**
     * Lấy tổng số chuyến xe
     */
    public long getNumberOfChuyenXe() throws Exception {
        long count = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT COUNT(*) FROM chuyenxe";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return count;
    }
    
    /**
     * Lấy tổng số nhà xe
     */
    public int getNumberOfNhaXe() throws Exception {
        int count = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT COUNT(*) FROM nhaxe";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return count;
    }
    
    /**
     * Lấy tổng số user
     */
    public long getNumberOfUsers() throws Exception {
        long count = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT COUNT(*) FROM user WHERE role = 1"; // Chỉ đếm user, không đếm admin
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return count;
    }
    
    /**
     * Lấy số vé đặt hôm nay
     */
    public long getTodayBookings() throws Exception {
        long count = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT SUM(so_luong) FROM datxe WHERE DATE(ngay_dat) = CURDATE()";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return count;
    }
    
    /**
     * Lấy doanh thu hôm nay
     */
    public BigDecimal getTodayRevenue() throws Exception {
        BigDecimal revenue = BigDecimal.ZERO;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT SUM(dx.so_luong * cx.gia) " +
                        "FROM datxe dx " +
                        "JOIN chuyenxe cx ON dx.chuyenxe_id = cx.id " +
                        "WHERE DATE(dx.ngay_dat) = CURDATE()";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal result = rs.getBigDecimal(1);
                if (result != null) {
                    revenue = result;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return revenue;
    }
    
    // ==================== QUẢN LÝ CHUYẾN XE ====================
    
    public List<ChuyenXe> getAllChuyenXe() throws Exception {
        List<ChuyenXe> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            
            String sql = 
                "SELECT cx.id, cx.tu_noi, cx.den_noi, cx.gio_khoi_hanh, cx.gia, " +
                "cx.so_cho, cx.bien_so_xe, cx.nhaxe_id, " +
                "dd1.ten_tinh as ten_diem_di, " +
                "dd2.ten_tinh as ten_diem_den, " +
                "nx.ten_nhaxe as ten_nha_xe " +
                "FROM chuyenxe cx " +
                "LEFT JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                "LEFT JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                "LEFT JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                "ORDER BY cx.gio_khoi_hanh DESC";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ChuyenXe chuyenXe = new ChuyenXe();
                chuyenXe.setId(rs.getInt("id"));
                chuyenXe.setTuNoi(rs.getInt("tu_noi"));
                chuyenXe.setDenNoi(rs.getInt("den_noi"));
                chuyenXe.setGioKhoiHanh(rs.getTimestamp("gio_khoi_hanh").toLocalDateTime());
                chuyenXe.setGia(rs.getBigDecimal("gia"));
                chuyenXe.setSoCho(rs.getInt("so_cho"));
                chuyenXe.setBienSoXe(rs.getString("bien_so_xe"));
                chuyenXe.setNhaXeId(rs.getInt("nhaxe_id"));
                chuyenXe.setTenDiemDi(rs.getString("ten_diem_di"));
                chuyenXe.setTenDiemDen(rs.getString("ten_diem_den"));
                chuyenXe.setTenNhaXe(rs.getString("ten_nha_xe"));
                list.add(chuyenXe);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    /**
     * Thêm chuyến xe mới
     */
    public boolean addChuyenXe(ChuyenXe chuyenXe) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "INSERT INTO chuyenxe (tu_noi, den_noi, gio_khoi_hanh, gia, so_cho, bien_so_xe, nhaxe_id) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, chuyenXe.getTuNoi());
            ps.setInt(2, chuyenXe.getDenNoi());
            ps.setTimestamp(3, Timestamp.valueOf(chuyenXe.getGioKhoiHanh()));
            ps.setBigDecimal(4, chuyenXe.getGia());
            ps.setInt(5, chuyenXe.getSoCho());
            ps.setString(6, chuyenXe.getBienSoXe());
            ps.setInt(7, chuyenXe.getNhaXeId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Cập nhật chuyến xe
     */
    public boolean updateChuyenXe(ChuyenXe chuyenXe) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "UPDATE chuyenxe SET tu_noi = ?, den_noi = ?, gio_khoi_hanh = ?, " +
                        "gia = ?, so_cho = ?, bien_so_xe = ?, nhaxe_id = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, chuyenXe.getTuNoi());
            ps.setInt(2, chuyenXe.getDenNoi());
            ps.setTimestamp(3, Timestamp.valueOf(chuyenXe.getGioKhoiHanh()));
            ps.setBigDecimal(4, chuyenXe.getGia());
            ps.setInt(5, chuyenXe.getSoCho());
            ps.setString(6, chuyenXe.getBienSoXe());
            ps.setInt(7, chuyenXe.getNhaXeId());
            ps.setInt(8, chuyenXe.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Xóa chuyến xe
     */
    public boolean deleteChuyenXe(int id) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            
            // Kiểm tra xem có đặt vé nào chưa
            String checkSql = "SELECT COUNT(*) FROM datxe WHERE chuyenxe_id = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                rs.close();
                ps.close();
                throw new Exception("Không thể xóa chuyến xe đã có người đặt vé!");
            }
            rs.close();
            ps.close();
            
            // Xóa chuyến xe
            String sql = "DELETE FROM chuyenxe WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    // ==================== QUẢN LÝ NHÀ XE ====================
    
    /**
     * Lấy tất cả nhà xe
     */
    public List<NhaXe> getAllNhaXe() throws Exception {
        List<NhaXe> nhaXes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM nhaxe";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                NhaXe nhaXe = new NhaXe();
                nhaXe.setId(rs.getInt("id"));
                nhaXe.setTenNhaXe(rs.getString("ten_nhaxe"));
                nhaXe.setDiaChi(rs.getString("dia_chi"));
                nhaXe.setSoDienThoai(rs.getString("sdt"));
                nhaXes.add(nhaXe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return nhaXes;
    }
    
    /**
     * Thêm nhà xe mới
     */
    public boolean addNhaXe(NhaXe nhaXe) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "INSERT INTO nhaxe (ten_nhaxe, dia_chi, sdt) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nhaXe.getTenNhaXe());
            ps.setString(2, nhaXe.getDiaChi());
            ps.setString(3, nhaXe.getSoDienThoai());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Cập nhật nhà xe
     */
    public boolean updateNhaXe(NhaXe nhaXe) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "UPDATE nhaxe SET ten_nhaxe = ?, dia_chi = ?, sdt = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nhaXe.getTenNhaXe());
            ps.setString(2, nhaXe.getDiaChi());
            ps.setString(3, nhaXe.getSoDienThoai());
            ps.setInt(4, nhaXe.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Xóa nhà xe
     */
    public boolean deleteNhaXe(int id) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            
            // Kiểm tra xem có chuyến xe nào không
            String checkSql = "SELECT COUNT(*) FROM chuyenxe WHERE nhaxe_id = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                rs.close();
                ps.close();
                throw new Exception("Không thể xóa nhà xe đang có chuyến xe!");
            }
            rs.close();
            ps.close();
            
            // Xóa nhà xe
            String sql = "DELETE FROM nhaxe WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    // ==================== QUẢN LÝ USER ====================
    
    /**
     * Lấy tất cả user (không bao gồm admin)
     */
    public List<User> getAllUsers() throws Exception {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM user WHERE role = 1"; // Chỉ lấy user, không lấy admin
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getInt("role"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return users;
    }
    
    /**
     * Thêm user mới
     */
    public boolean addUser(User user) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            
            // Kiểm tra email đã tồn tại chưa
            String checkSql = "SELECT COUNT(*) FROM user WHERE email = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, user.getEmail());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                rs.close();
                ps.close();
                throw new Exception("Email đã tồn tại!");
            }
            rs.close();
            ps.close();
            
            // Thêm user mới
            String sql = "INSERT INTO user (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, "123456"); // Mật khẩu mặc định
            ps.setString(4, user.getPhone());
            ps.setInt(5, 1); // Role = 1 (User)
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Cập nhật user
     */
    public boolean updateUser(User user) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "UPDATE user SET name = ?, email = ?, phone = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Xóa user (không cho phép xóa admin)
     */
    public boolean deleteUser(int id) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            
            // Kiểm tra xem có phải admin không
            String checkRoleSql = "SELECT role FROM user WHERE id = ?";
            ps = conn.prepareStatement(checkRoleSql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt("role") == 2) {
                rs.close();
                ps.close();
                throw new Exception("Không thể xóa tài khoản admin!");
            }
            rs.close();
            ps.close();
            
            // Xóa user
            String sql = "DELETE FROM user WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Lấy lịch sử đặt vé của user
     */
    public List<DatXe> getUserHistory(int userId) throws Exception {
        List<DatXe> history = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT dx.*, cx.gia, cx.bien_so_xe, cx.gio_khoi_hanh, " +
                        "dd1.ten_tinh as ten_diem_di, dd2.ten_tinh as ten_diem_den, " +
                        "nx.ten_nhaxe " +
                        "FROM datxe dx " +
                        "JOIN chuyenxe cx ON dx.chuyenxe_id = cx.id " +
                        "JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                        "JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                        "JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                        "WHERE dx.user_id = ? " +
                        "ORDER BY dx.ngay_dat DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DatXe datXe = new DatXe();
                datXe.setId(rs.getInt("dx.id"));
                datXe.setUserId(rs.getInt("dx.user_id"));
                datXe.setChuyenXeId(rs.getInt("dx.chuyenxe_id"));
                datXe.setSoLuong(rs.getInt("dx.so_luong"));
                datXe.setNgayDat(rs.getTimestamp("dx.ngay_dat").toLocalDateTime());
                
                // Thông tin mở rộng
                datXe.setGiaVe(rs.getBigDecimal("gia"));
                datXe.setBienSoXe(rs.getString("bien_so_xe"));
                datXe.setGioKhoiHanh(rs.getTimestamp("gio_khoi_hanh").toLocalDateTime());
                datXe.setTenDiemDi(rs.getString("ten_diem_di"));
                datXe.setTenDiemDen(rs.getString("ten_diem_den"));
                datXe.setTenNhaXe(rs.getString("ten_nhaxe"));
                
                history.add(datXe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return history;
    }
    
    /**
     * Lấy tất cả vé đã đặt
     */
    public List<DatXe> getAllBookings() throws Exception {
        List<DatXe> bookings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT dx.*, u.name as user_name, u.email, u.phone, " +
                        "cx.gia, cx.bien_so_xe, cx.gio_khoi_hanh, " +
                        "dd1.ten_tinh as ten_diem_di, dd2.ten_tinh as ten_diem_den, " +
                        "nx.ten_nhaxe " +
                        "FROM datxe dx " +
                        "JOIN user u ON dx.user_id = u.id " +
                        "JOIN chuyenxe cx ON dx.chuyenxe_id = cx.id " +
                        "JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                        "JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                        "JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                        "ORDER BY dx.ngay_dat DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DatXe datXe = new DatXe();
                datXe.setId(rs.getInt("dx.id"));
                datXe.setUserId(rs.getInt("dx.user_id"));
                datXe.setChuyenXeId(rs.getInt("dx.chuyenxe_id"));
                datXe.setSoLuong(rs.getInt("dx.so_luong"));
                datXe.setNgayDat(rs.getTimestamp("dx.ngay_dat").toLocalDateTime());
                
                // Thông tin mở rộng
                datXe.setGiaVe(rs.getBigDecimal("gia"));
                datXe.setBienSoXe(rs.getString("bien_so_xe"));
                datXe.setGioKhoiHanh(rs.getTimestamp("gio_khoi_hanh").toLocalDateTime());
                datXe.setTenDiemDi(rs.getString("ten_diem_di"));
                datXe.setTenDiemDen(rs.getString("ten_diem_den"));
                datXe.setTenNhaXe(rs.getString("ten_nhaxe"));
                
                // Thêm thông tin user (có thể tạo field riêng nếu cần)
                
                bookings.add(datXe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return bookings;
    }
    
    // ==================== UTILITY METHODS ====================
    
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}