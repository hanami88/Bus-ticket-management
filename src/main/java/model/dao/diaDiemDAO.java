package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.bean.DiaDiem;
import model.utils.DBConnect;

public class diaDiemDAO {
    public List<DiaDiem> getAllDiaDiem() throws Exception {
        try {
            Connection conn = DBConnect.getConnection();
            String sql = "SELECT * FROM diadiem";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<DiaDiem> list = new ArrayList<>();
            while (rs.next()) {
                DiaDiem diaDiem = new DiaDiem();
                diaDiem.setId(rs.getInt("id"));
                diaDiem.setTenTinh(rs.getString("ten_tinh"));
                list.add(diaDiem);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
