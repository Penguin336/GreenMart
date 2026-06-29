package com.greenmart.model;

import com.greenmart.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    private Review map(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setProductId(rs.getInt("product_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setStars(rs.getInt("stars"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        try { r.setUserFullName(rs.getString("full_name")); } catch (SQLException ignored) {}
        return r;
    }

    /** Lấy tất cả đánh giá của một sản phẩm, mới nhất trước. */
    public List<Review> getByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name "
                   + "FROM Review r JOIN Users u ON r.user_id = u.user_id "
                   + "WHERE r.product_id = ? "
                   + "ORDER BY r.created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Kiểm tra user đã đánh giá sản phẩm này chưa. */
    public boolean hasReviewed(int productId, int userId) {
        String sql = "SELECT 1 FROM Review WHERE product_id=? AND user_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Thêm đánh giá mới. Trả về true nếu thành công. */
    public boolean insert(Review r) {
        String sql = "INSERT INTO Review (product_id, user_id, stars, comment) VALUES (?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getProductId());
            ps.setInt(2, r.getUserId());
            ps.setInt(3, r.getStars());
            ps.setNString(4, r.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Thống kê: số đánh giá và điểm trung bình của một sản phẩm. */
    public int[] getStats(int productId) {
        // Trả về [reviewCount, avgStars*10] để tránh float
        String sql = "SELECT COUNT(*), ISNULL(AVG(CAST(stars AS FLOAT)),0) "
                   + "FROM Review WHERE product_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new int[]{ rs.getInt(1), (int) Math.round(rs.getDouble(2) * 10) };
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new int[]{0, 0};
    }
}
