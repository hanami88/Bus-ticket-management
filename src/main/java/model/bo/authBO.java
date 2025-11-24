package model.bo;

import model.bean.User;
import model.dao.authDAO;

public class authBO {
    private final authDAO authDAO = new authDAO();

    public User dangNhap(String email, String password) {
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            return null;
        }
        return authDAO.dangNhap(email, password);
    }

    public boolean dangKy(User user) throws Exception {
        return authDAO.dangKy(user);
    }

    public User getUserByEmail(String email) throws Exception {
        if (email == null || email.isEmpty()) {
            return null;
        }
        return authDAO.getUserByEmail(email);
    }

    public boolean updatePassword(String email, String newPassword) throws Exception {
        if (email == null || newPassword == null || email.isEmpty() || newPassword.isEmpty()) {
            return false;
        }
        return authDAO.updatePassword(email, newPassword);
    }
}
