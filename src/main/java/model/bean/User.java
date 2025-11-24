package model.bean;

public class User {
    private int id;
    private  String name;
    private String email;
    private String password;
    private String phone;
    private int role; // 1: User, 2: Admin
    private int soLuongVeDat;

    // getters and setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }
    public int getRole() {
        return role;
    }
    public void setRole(int role) {
        this.role = role;
    }
    public int getSoLuongVeDat() {
        return soLuongVeDat;
    }
    public void setSoLuongVeDat(int soLuongVeDat) {
        this.soLuongVeDat = soLuongVeDat;
    }
}
