package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.bean.DatXe;
import model.utils.DBConnect;

public class datXeDAO {
    
    public boolean datVe(DatXe datXe) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "INSERT INTO datxe (user_id, chuyenxe_id, so_luong, ngay_dat) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, datXe.getUserId());
            ps.setInt(2, datXe.getChuyenXeId());
            ps.setInt(3, datXe.getSoLuong());
            ps.setTimestamp(4, Timestamp.valueOf(datXe.getNgayDat()));
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
    
    public List<DatXe> getDatXeByUserId(int userId) throws Exception {
        List<DatXe> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM datxe WHERE user_id = ? ORDER BY ngay_dat DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DatXe datXe = new DatXe();
                datXe.setId(rs.getInt("id"));
                datXe.setUserId(rs.getInt("user_id"));
                datXe.setChuyenXeId(rs.getInt("chuyenxe_id"));
                datXe.setSoLuong(rs.getInt("so_luong"));
                
                Timestamp timestamp = rs.getTimestamp("ngay_dat");
                if (timestamp != null) {
                    datXe.setNgayDat(timestamp.toLocalDateTime());
                }
                
                list.add(datXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        
        return list;
    }

    public List<DatXe> getLichSuDatXeWithDetails(int userId) throws Exception {
        List<DatXe> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnect.getConnection();
            String sql = 
                "SELECT dx.id, dx.user_id, dx.chuyenxe_id, dx.so_luong, dx.ngay_dat, " +
                "cx.gia, cx.bien_so_xe, cx.gio_khoi_hanh, " +
                "dd1.ten_tinh as ten_diem_di, " +
                "dd2.ten_tinh as ten_diem_den, " +
                "nx.ten_nhaxe as ten_nha_xe " +
                "FROM datxe dx " +
                "LEFT JOIN chuyenxe cx ON dx.chuyenxe_id = cx.id " +
                "LEFT JOIN diadiem dd1 ON cx.tu_noi = dd1.id " +
                "LEFT JOIN diadiem dd2 ON cx.den_noi = dd2.id " +
                "LEFT JOIN nhaxe nx ON cx.nhaxe_id = nx.id " +
                "WHERE dx.user_id = ? " +
                "ORDER BY dx.ngay_dat DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DatXe datXe = new DatXe();
                datXe.setId(rs.getInt("id"));
                datXe.setUserId(rs.getInt("user_id"));
                datXe.setChuyenXeId(rs.getInt("chuyenxe_id"));
                datXe.setSoLuong(rs.getInt("so_luong"));
                
                Timestamp timestamp = rs.getTimestamp("ngay_dat");
                if (timestamp != null) {
                    datXe.setNgayDat(timestamp.toLocalDateTime());
                }
                
                // Thêm thông tin bổ sung vào DatXe (cần thêm fields mới vào bean)
                datXe.setGiaVe(rs.getBigDecimal("gia"));
                datXe.setBienSoXe(rs.getString("bien_so_xe"));
                
                Timestamp gioKhoiHanh = rs.getTimestamp("gio_khoi_hanh");
                if (gioKhoiHanh != null) {
                    datXe.setGioKhoiHanh(gioKhoiHanh.toLocalDateTime());
                }
                
                datXe.setTenDiemDi(rs.getString("ten_diem_di"));
                datXe.setTenDiemDen(rs.getString("ten_diem_den"));
                datXe.setTenNhaXe(rs.getString("ten_nha_xe"));
                
                list.add(datXe);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return list;
    }
    
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) throws Exception {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

}