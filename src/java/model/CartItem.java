package com.greenmart.model;

import java.math.BigDecimal;

public class CartItem {

    private int cartId;
    private int userId;
    private int productId;
    private String productName;
    private String productImage;
    private String unit;
    private BigDecimal price;
    private int quantity;

    public CartItem() {
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int id) {
        this.cartId = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int id) {
        this.userId = id;
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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String u) {
        this.unit = u;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal p) {
        this.price = p;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int q) {
        this.quantity = q;
    }

    public BigDecimal getSubtotal() {
        if (price == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    public String getFormattedPrice() {
        if (price == null) {
            return "0đ";
        }
        return String.format("%,.0f", price).replace(",", ".") + "đ";
    }

    public String getFormattedSubtotal() {
        return String.format("%,.0f", getSubtotal()).replace(",", ".") + "đ";
    }
}
