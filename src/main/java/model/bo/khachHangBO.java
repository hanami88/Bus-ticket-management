package model.bo;

import java.util.List;

import model.bean.User;
import model.dao.khachHangDAO;

public class khachHangBO {
    private final khachHangDAO khachHangDAO = new khachHangDAO();

    public List<User> getKhachHangByChuyenXeId(int chuyenXeId) throws Exception {
        return khachHangDAO.getKhachHangByChuyenXeId(chuyenXeId);
    }
}
