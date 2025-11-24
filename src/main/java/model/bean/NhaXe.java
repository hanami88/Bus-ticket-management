package model.bean;

public class NhaXe {
    private int id;
    private String tenNhaXe;
    private String diaChi;
    private String soDienThoai;

    // getter and setter
    public int getId() {
        return id;
    }
    public String getTenNhaXe() {
        return tenNhaXe;
    }
    public String getDiaChi() {
        return diaChi;
    }
    public String getSoDienThoai() {
        return soDienThoai;
    }
    public void setId(int id) {
        this.id = id;
    }
    public void setTenNhaXe(String tenNhaXe) {
        this.tenNhaXe = tenNhaXe;
    }
    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }
    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }
}
