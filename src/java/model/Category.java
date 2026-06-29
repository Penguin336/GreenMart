package com.greenmart.model;

// ==============================
//  Category.java
// ==============================
public class Category {

    private int categoryId;
    private String name;
    private String icon;
    private boolean isActive;

    public Category() {
    }

    public Category(int categoryId, String name, String icon) {
        this.categoryId = categoryId;
        this.name = name;
        this.icon = icon;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int id) {
        this.categoryId = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String n) {
        this.name = n;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String i) {
        this.icon = i;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean a) {
        this.isActive = a;
    }
}
