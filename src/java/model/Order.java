package com.greenmart.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {

    private int orderId;
    private int userId;
    private String fullName;
    private String phone;
    private String address;
    private BigDecimal totalAmount;
    private String status;   // pending|confirmed|shipping|delivered|cancelled
    private String note;
    private Date createdAt;
    private List<OrderDetail> details;

    public Order() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int id) {
        this.orderId = id;
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

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal t) {
        this.totalAmount = t;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String s) {
        this.status = s;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String n) {
        this.note = n;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date d) {
        this.createdAt = d;
    }

    public List<OrderDetail> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail> d) {
        this.details = d;
    }

    public String getStatusLabel() {
        return switch (status) {
            case "pending" ->
                "Chờ xác nhận";
            case "confirmed" ->
                "Đã xác nhận";
            case "shipping" ->
                "Đang giao";
            case "delivered" ->
                "Đã giao";
            case "cancelled" ->
                "Đã hủy";
            default ->
                status;
        };
    }

    public String getFormattedTotal() {
        if (totalAmount == null) {
            return "0đ";
        }
        return String.format("%,.0f", totalAmount).replace(",", ".") + "đ";
    }
}
