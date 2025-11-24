package model.bean;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class DatXe {
    private int id;
    private int userId;
    private int chuyenXeId;
    private int soLuong;
    private LocalDateTime ngayDat;
    
    // Thông tin mở rộng để hiển thị lịch sử
    private BigDecimal giaVe;
    private String bienSoXe;
    private LocalDateTime gioKhoiHanh;
    private String tenDiemDi;
    private String tenDiemDen;
    private String tenNhaXe;

    // Getters and setters cũ
    public int getId() {
        return id;
    }
    public int getUserId() {
        return userId;
    }
    public int getChuyenXeId() {
        return chuyenXeId;
    }
    public int getSoLuong() {
        return soLuong;
    }
    public LocalDateTime getNgayDat() {
        return ngayDat;
    }
    public void setId(int id) {
        this.id = id;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public void setChuyenXeId(int chuyenXeId) {
        this.chuyenXeId = chuyenXeId;
    }
    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }
    public void setNgayDat(LocalDateTime ngayDat) {
        this.ngayDat = ngayDat;
    }
    
    // Getters and setters mới
    public BigDecimal getGiaVe() {
        return giaVe;
    }
    public void setGiaVe(BigDecimal giaVe) {
        this.giaVe = giaVe;
    }
    public String getBienSoXe() {
        return bienSoXe;
    }
    public void setBienSoXe(String bienSoXe) {
        this.bienSoXe = bienSoXe;
    }
    public LocalDateTime getGioKhoiHanh() {
        return gioKhoiHanh;
    }
    public void setGioKhoiHanh(LocalDateTime gioKhoiHanh) {
        this.gioKhoiHanh = gioKhoiHanh;
    }
    public String getTenDiemDi() {
        return tenDiemDi;
    }
    public void setTenDiemDi(String tenDiemDi) {
        this.tenDiemDi = tenDiemDi;
    }
    public String getTenDiemDen() {
        return tenDiemDen;
    }
    public void setTenDiemDen(String tenDiemDen) {
        this.tenDiemDen = tenDiemDen;
    }
    public String getTenNhaXe() {
        return tenNhaXe;
    }
    public void setTenNhaXe(String tenNhaXe) {
        this.tenNhaXe = tenNhaXe;
    }
    
    // Tính tổng tiền
    public BigDecimal getTongTien() {
        if (giaVe != null) {
            return giaVe.multiply(new BigDecimal(soLuong));
        }
        return BigDecimal.ZERO;
    }
}