package com.greenmart.model;

import java.math.BigDecimal;

public class Product {

    private int        productId;
    private int        categoryId;
    private String     categoryName;
    private String     name;
    private String     description;
    private BigDecimal price;
    private String     unit;
    private String     imageUrl;
    private int        stock;
    private boolean    isActive;
    private int        soldCount;    // tổng đã bán (từ sold_count hoặc tính từ OrderDetail)
    private double     avgRating;   // điểm trung bình đánh giá
    private int        reviewCount; // số lượt đánh giá

    public Product() {
    }

    // Getters & Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int id) {
        this.productId = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int id) {
        this.categoryId = id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String n) {
        this.categoryName = n;
    }

    public String getName() {
        return name;
    }

    public void setName(String n) {
        this.name = n;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String d) {
        this.description = d;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal p) {
        this.price = p;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String u) {
        this.unit = u;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String url) {
        this.imageUrl = url;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int s) {
        this.stock = s;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean a) {
        this.isActive = a;
    }

    public int getSoldCount()             { return soldCount; }
    public void setSoldCount(int v)       { this.soldCount = v; }

    public double getAvgRating()          { return avgRating; }
    public void setAvgRating(double v)    { this.avgRating = v; }

    public int getReviewCount()           { return reviewCount; }
    public void setReviewCount(int v)     { this.reviewCount = v; }

    /**
     * Trả về chuỗi sao ngắn gọn cho card sản phẩm.
     * Vd: avgRating=4.3, reviewCount=12 → "⭐ 4.3 (12)"
     */
    public String getRatingDisplay() {
        if (reviewCount == 0) return "";
        return String.format("⭐ %.1f (%d)", avgRating, reviewCount);
    }

    /**
     * Format giá tiền: 25000 -> "25.000đ"
     */
    public String getFormattedPrice() {
        if (price == null) {
            return "0đ";
        }
        return String.format("%,.0f", price).replace(",", ".") + "đ";
    }
}
