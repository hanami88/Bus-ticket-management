package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.bean.ChuyenXe;
import model.utils.DBConnect;

public class chuyenXeDAO {
    
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
                "WHERE cx.gio_khoi_hanh > NOW() AND cx.so_cho > 0 " +
                "ORDER BY cx.gio_khoi_hanh ASC";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ChuyenXe chuyenXe = mapResultSetToChuyenXe(rs);
                list.add(chuyenXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return list;
    }
    
    public List<ChuyenXe> timKiemChuyenXe(Integer tuNoi, Integer denNoi, String ngayDi) throws Exception {
        List<ChuyenXe> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            
            StringBuilder sql = new StringBuilder(
                "SELECT cx.id, cx.tu_noi, cx.den_noi, cx.gio_khoi_hanh, cx.gia, " +
                "cx.so_cho, cx.bien_so_xe, cx.nhaxe_id, " +
                "dd1.ten_tinh as ten_diem_di, " +
                "dd2.ten_tinh as ten_diem_den, " +
                "nx.ten_nhaxe as ten_nha_xe " +
                "FROM chuyenxe cx " +
                "LEFT JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                "LEFT JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                "LEFT JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                "WHERE cx.gio_khoi_hanh > NOW() AND cx.so_cho > 0 "
            );
            
            // Thêm điều kiện tìm kiếm
            if (tuNoi != null && tuNoi > 0) {
                sql.append(" AND cx.tu_noi = ?");
            }
            if (denNoi != null && denNoi > 0) {
                sql.append(" AND cx.den_noi = ?");
            }
            if (ngayDi != null && !ngayDi.trim().isEmpty()) {
                sql.append(" AND DATE(cx.gio_khoi_hanh) = ?");
            }
            
            sql.append(" ORDER BY cx.gio_khoi_hanh ASC");
            
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (tuNoi != null && tuNoi > 0) {
                ps.setInt(paramIndex++, tuNoi);
            }
            if (denNoi != null && denNoi > 0) {
                ps.setInt(paramIndex++, denNoi);
            }
            if (ngayDi != null && !ngayDi.trim().isEmpty()) {
                ps.setString(paramIndex++, ngayDi);
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ChuyenXe chuyenXe = mapResultSetToChuyenXe(rs);
                list.add(chuyenXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return list;
    }

    public ChuyenXe getChuyenXeById(int id) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ChuyenXe chuyenXe = null;
        
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
                "WHERE cx.id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                chuyenXe = mapResultSetToChuyenXe(rs);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return chuyenXe;
    }
    
    public boolean capNhatSoCho(int chuyenXeId, int soLuongDat) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "UPDATE chuyenxe SET so_cho = so_cho - ? WHERE id = ? AND so_cho >= ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, soLuongDat);
            ps.setInt(2, chuyenXeId);
            ps.setInt(3, soLuongDat);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    public int getSoChoConLai(int chuyenXeId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int soChoConLai = 0;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT so_cho FROM chuyenxe WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, chuyenXeId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                soChoConLai = rs.getInt("so_cho");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return soChoConLai;
    }
    
    public boolean kiemTraKhaDung(int chuyenXeId, int soLuongCanDat) throws Exception {
        int soChoConLai = getSoChoConLai(chuyenXeId);
        return soChoConLai >= soLuongCanDat;
    }
    
    private ChuyenXe mapResultSetToChuyenXe(ResultSet rs) throws Exception {
        ChuyenXe chuyenXe = new ChuyenXe();
        chuyenXe.setId(rs.getInt("id"));
        chuyenXe.setTuNoi(rs.getInt("tu_noi"));
        chuyenXe.setDenNoi(rs.getInt("den_noi"));
        
        // Chuyển đổi Timestamp thành LocalDateTime
        Timestamp timestamp = rs.getTimestamp("gio_khoi_hanh");
        if (timestamp != null) {
            chuyenXe.setGioKhoiHanh(timestamp.toLocalDateTime());
        }
        
        chuyenXe.setGia(rs.getBigDecimal("gia"));
        chuyenXe.setSoCho(rs.getInt("so_cho"));
        chuyenXe.setBienSoXe(rs.getString("bien_so_xe"));
        chuyenXe.setNhaXeId(rs.getInt("nhaxe_id"));
        
        // Set tên từ JOIN
        chuyenXe.setTenDiemDi(rs.getString("ten_diem_di"));
        chuyenXe.setTenDiemDen(rs.getString("ten_diem_den"));
        chuyenXe.setTenNhaXe(rs.getString("ten_nha_xe"));
        
        return chuyenXe;
    }
    
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
       }
    
    public List<ChuyenXe> getChuyenXeHoanThanh() throws Exception {
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
                "WHERE (cx.gio_khoi_hanh <= NOW() OR cx.so_cho = 0) " +
                "ORDER BY cx.gio_khoi_hanh DESC";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ChuyenXe chuyenXe = mapResultSetToChuyenXe(rs);
                list.add(chuyenXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm chuyến xe đã hoàn thành
     */
    public List<ChuyenXe> timKiemChuyenXeHoanThanh(Integer tuNoi, Integer denNoi, String ngayDi) throws Exception {
        List<ChuyenXe> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            
            StringBuilder sql = new StringBuilder(
                "SELECT cx.id, cx.tu_noi, cx.den_noi, cx.gio_khoi_hanh, cx.gia, " +
                "cx.so_cho, cx.bien_so_xe, cx.nhaxe_id, " +
                "dd1.ten_tinh as ten_diem_di, " +
                "dd2.ten_tinh as ten_diem_den, " +
                "nx.ten_nhaxe as ten_nha_xe " +
                "FROM chuyenxe cx " +
                "LEFT JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                "LEFT JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                "LEFT JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                "WHERE (cx.gio_khoi_hanh <= NOW() OR cx.so_cho = 0)"
            );
            
            if (tuNoi != null && tuNoi > 0) {
                sql.append(" AND cx.tu_noi = ?");
            }
            if (denNoi != null && denNoi > 0) {
                sql.append(" AND cx.den_noi = ?");
            }
            if (ngayDi != null && !ngayDi.isEmpty()) {
                sql.append(" AND DATE(cx.gio_khoi_hanh) = ?");
            }
            
            sql.append(" ORDER BY cx.gio_khoi_hanh DESC");
            
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (tuNoi != null && tuNoi > 0) {
                ps.setInt(paramIndex++, tuNoi);
            }
            if (denNoi != null && denNoi > 0) {
                ps.setInt(paramIndex++, denNoi);
            }
            if (ngayDi != null && !ngayDi.isEmpty()) {
                ps.setString(paramIndex++, ngayDi);
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ChuyenXe chuyenXe = mapResultSetToChuyenXe(rs);
                list.add(chuyenXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return list;
    }
}