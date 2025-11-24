package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.bean.User;
import model.utils.DBConnect;   

public class authDAO {
    public User dangNhap(String email, String password) {
        try {
            Connection conn = DBConnect.getConnection();
            String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            User user = null;
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getInt("role"));
            }
            
            rs.close();
            ps.close();
            conn.close();
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean dangKy(User user) throws Exception {
        try {
            Connection conn = DBConnect.getConnection();
            String checkSql = "SELECT COUNT(*) FROM user WHERE email = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, user.getEmail());
            ResultSet rs = checkPs.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            rs.close();
            checkPs.close();

            if (count > 0) {
                conn.close();
                return false; // Email already exists
            }

            // Insert new user
            String sql = "INSERT INTO user (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setInt(5, 1);
            int rowsAffected = ps.executeUpdate();
            ps.close();
            conn.close();
            return rowsAffected > 0; // Return true if insert was successful
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
    public User getUserByEmail(String email) {
        try {
            Connection conn = DBConnect.getConnection();
            String sql = "SELECT * FROM user WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            User user = null;
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getInt("role"));
            }
            rs.close();
            ps.close();
            conn.close();
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updatePassword(String email, String newPassword) {
        try {
            Connection conn = DBConnect.getConnection();
            String sql = "UPDATE user SET password = ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int rowsAffected = ps.executeUpdate();
            ps.close();
            conn.close();
            return rowsAffected > 0; 
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
