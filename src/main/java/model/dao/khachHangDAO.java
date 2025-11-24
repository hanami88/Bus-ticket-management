package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.bean.User;
import model.utils.DBConnect;

public class khachHangDAO {
    public List<User> getKhachHangByChuyenXeId(int chuyenXeId) throws Exception {
        try {
            Connection conn = DBConnect.getConnection();
            String sql = "SELECT user.id, user.email, user.name, user.phone, datxe.so_luong FROM user INNER JOIN datxe ON user.id = datxe.user_id WHERE datxe.chuyenxe_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, chuyenXeId);
            ResultSet rs = ps.executeQuery();
            List<User> listKhachHang = new ArrayList<>();
            while (rs.next()) {
                User user = new User();
                user.setEmail(rs.getString("email"));
                user.setName(rs.getString("name"));
                user.setPhone(rs.getString("phone"));
                // lấy số lượng vé đã đặt
                int soLuongDat = rs.getInt("so_luong");
                user.setSoLuongVeDat(soLuongDat);
                listKhachHang.add(user);
            }
            rs.close();
            ps.close();
            conn.close();
            return listKhachHang;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
