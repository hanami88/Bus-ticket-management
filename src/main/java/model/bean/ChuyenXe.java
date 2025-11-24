package model.bean;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ChuyenXe {
    private int id;
    private int tuNoi;
    private int denNoi;
    private LocalDateTime gioKhoiHanh;
    private BigDecimal gia;
    private int soCho;
    private String bienSoXe;
    private int nhaXeId;
    
    private String tenDiemDi;   
    private String tenDiemDen;  
    private String tenNhaXe;    

    // Constructor
    public ChuyenXe() {}

    public ChuyenXe(int id, int tuNoi, int denNoi, LocalDateTime gioKhoiHanh, 
                    BigDecimal gia, int soCho, String bienSoXe, int nhaXeId) {
        this.id = id;
        this.tuNoi = tuNoi;
        this.denNoi = denNoi;
        this.gioKhoiHanh = gioKhoiHanh;
        this.gia = gia;
        this.soCho = soCho;
        this.bienSoXe = bienSoXe;
        this.nhaXeId = nhaXeId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTuNoi() {
        return tuNoi;
    }

    public void setTuNoi(int tuNoi) {
        this.tuNoi = tuNoi;
    }

    public int getDenNoi() {
        return denNoi;
    }

    public void setDenNoi(int denNoi) {
        this.denNoi = denNoi;
    }

    public LocalDateTime getGioKhoiHanh() {
        return gioKhoiHanh;
    }

    public void setGioKhoiHanh(LocalDateTime gioKhoiHanh) {
        this.gioKhoiHanh = gioKhoiHanh;
    }

    public BigDecimal getGia() {
        return gia;
    }

    public void setGia(BigDecimal gia) {
        this.gia = gia;
    }

    public int getSoCho() {
        return soCho;
    }

    public void setSoCho(int soCho) {
        this.soCho = soCho;
    }

    public String getBienSoXe() {
        return bienSoXe;
    }

    public void setBienSoXe(String bienSoXe) {
        this.bienSoXe = bienSoXe;
    }

    public int getNhaXeId() {
        return nhaXeId;
    }

    public void setNhaXeId(int nhaXeId) {
        this.nhaXeId = nhaXeId;
    }

    // Getters và Setters cho các trường JOIN
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
}
