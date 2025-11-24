package model.bo;

import java.util.List;

import model.bean.DiaDiem;
import model.dao.diaDiemDAO;

public class diaDiemBO {
    private final diaDiemDAO diaDiemDAO = new diaDiemDAO();

    public List<DiaDiem> getAllDiaDiem() throws Exception {
        return diaDiemDAO.getAllDiaDiem();
    }
}
