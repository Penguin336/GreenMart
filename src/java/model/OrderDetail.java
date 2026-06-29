package com.greenmart.model;

import java.math.BigDecimal;

public class OrderDetail {

    private int detailId;
    private int orderId;
    private int productId;
    private String productName;
    private String productImage;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderDetail() {
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int id) {
        this.detailId = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int id) {
        this.orderId = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int id) {
        this.productId = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String n) {
        this.productName = n;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String u) {
        this.productImage = u;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int q) {
        this.quantity = q;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal p) {
        this.unitPrice = p;
    }

    public BigDecimal getSubtotal() {
        if (unitPrice == null) {
            return BigDecimal.ZERO;
        }
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public String getFormattedPrice() {
        if (unitPrice == null) {
            return "0đ";
        }
        return String.format("%,.0f", unitPrice).replace(",", ".") + "đ";
    }

    public String getFormattedSubtotal() {
        return String.format("%,.0f", getSubtotal()).replace(",", ".") + "đ";
    }
}
