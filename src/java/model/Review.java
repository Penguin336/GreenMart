package com.greenmart.model;

import java.util.Date;

public class Review {

    private int    reviewId;
    private int    productId;
    private int    userId;
    private String userFullName;   // JOIN từ Users
    private int    stars;          // 1-5
    private String comment;
    private Date   createdAt;      // dùng java.util.Date để fmt:formatDate hoạt động

    public Review() {}

    public int getReviewId()            { return reviewId; }
    public void setReviewId(int v)      { this.reviewId = v; }

    public int getProductId()           { return productId; }
    public void setProductId(int v)     { this.productId = v; }

    public int getUserId()              { return userId; }
    public void setUserId(int v)        { this.userId = v; }

    public String getUserFullName()            { return userFullName; }
    public void setUserFullName(String v)      { this.userFullName = v; }

    public int getStars()               { return stars; }
    public void setStars(int v)         { this.stars = v; }

    public String getComment()          { return comment; }
    public void setComment(String v)    { this.comment = v; }

    public Date getCreatedAt()          { return createdAt; }
    public void setCreatedAt(Date v)    { this.createdAt = v; }

    /** Trả về chuỗi sao, vd: "⭐⭐⭐⭐☆" */
    public String getStarDisplay() {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 5; i++) sb.append(i <= stars ? "⭐" : "☆");
        return sb.toString();
    }
}
