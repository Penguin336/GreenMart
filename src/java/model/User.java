package com.greenmart.model;

import java.util.Date;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role;
    private boolean isActive;
    private Date createdAt;

    public User() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int id) {
        this.userId = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String n) {
        this.fullName = n;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String e) {
        this.email = e;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String p) {
        this.password = p;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String p) {
        this.phone = p;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String a) {
        this.address = a;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String r) {
        this.role = r;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean a) {
        this.isActive = a;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date d) {
        this.createdAt = d;
    }

    public boolean isAdmin() {
        return "admin".equals(role);
    }
}
