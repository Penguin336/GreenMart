package com.greenmart.model;

import com.greenmart.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setUnit(rs.getString("unit"));
        p.setImageUrl(rs.getString("image_url"));
        p.setStock(rs.getInt("stock"));
        p.setActive(rs.getBoolean("is_active"));
        try { p.setDailyDeal(rs.getBoolean("is_daily_deal")); } catch (SQLException ignored) {}
        try { p.setCategoryName(rs.getString("category_name")); } catch (SQLException ignored) {}
        // sold_count và rating (có thể null nếu query không join)
        try { p.setSoldCount(rs.getInt("sold_count")); }       catch (SQLException ignored) {}
        try { p.setAvgRating(rs.getDouble("avg_rating")); }    catch (SQLException ignored) {}
        try { p.setReviewCount(rs.getInt("review_count")); }   catch (SQLException ignored) {}
        return p;
    }

    // ─── Phần SELECT dùng chung ─────────────────────────────────────────────
    private static final String SELECT_BASE =
            "SELECT p.*, c.name AS category_name, "
            + "  ISNULL(p.sold_count, 0) AS sold_count, "
            + "  ISNULL(r.avg_rating, 0) AS avg_rating, "
            + "  ISNULL(r.review_count, 0) AS review_count "
            + "FROM Product p "
            + "JOIN Category c ON p.category_id = c.category_id "
            + "LEFT JOIN vw_ProductRating r ON r.product_id = p.product_id "
            + "WHERE p.is_active = 1 ";

    public List<Product> getAll(Integer categoryId, String keyword) {
        return getAll(categoryId, keyword, null, null, null);
    }

    public List<Product> getAll(Integer categoryId, String keyword,
                                Long minPrice, Long maxPrice, String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE);
        appendFilters(sql, categoryId, keyword, minPrice, maxPrice);
        sql.append(buildOrderBy(sortBy));

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            setFilterParams(ps, 1, categoryId, keyword, minPrice, maxPrice);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Đếm tổng sản phẩm active theo bộ lọc (dùng cho phân trang). */
    public int countAll(Integer categoryId, String keyword) {
        return countAll(categoryId, keyword, null, null);
    }

    public int countAll(Integer categoryId, String keyword, Long minPrice, Long maxPrice) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Product p WHERE p.is_active = 1 ");
        if (categoryId != null && categoryId > 0) sql.append("AND p.category_id = ? ");
        if (keyword  != null && !keyword.isBlank()) sql.append("AND p.name LIKE ? ");
        if (minPrice != null) sql.append("AND p.price >= ? ");
        if (maxPrice != null) sql.append("AND p.price <= ? ");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (categoryId != null && categoryId > 0) ps.setInt(idx++, categoryId);
            if (keyword  != null && !keyword.isBlank()) ps.setNString(idx++, "%" + keyword + "%");
            if (minPrice != null) ps.setLong(idx++, minPrice);
            if (maxPrice != null) ps.setLong(idx++, maxPrice);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /** Lấy một trang sản phẩm active theo bộ lọc. offset tính từ 0. */
    public List<Product> getPage(Integer categoryId, String keyword, int offset, int pageSize) {
        return getPage(categoryId, keyword, null, null, null, offset, pageSize);
    }

    public List<Product> getPage(Integer categoryId, String keyword,
                                 Long minPrice, Long maxPrice, String sortBy,
                                 int offset, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE);
        appendFilters(sql, categoryId, keyword, minPrice, maxPrice);
        sql.append(buildOrderBy(sortBy));
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = setFilterParams(ps, 1, categoryId, keyword, minPrice, maxPrice);
            ps.setInt(idx++, offset);
            ps.setInt(idx,   pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── helper: append WHERE filters ────────────────────────────────────────
    private void appendFilters(StringBuilder sql, Integer categoryId, String keyword,
                                Long minPrice, Long maxPrice) {
        if (categoryId != null && categoryId > 0) sql.append("AND p.category_id = ? ");
        if (keyword    != null && !keyword.isBlank()) sql.append("AND p.name LIKE ? ");
        if (minPrice   != null) sql.append("AND p.price >= ? ");
        if (maxPrice   != null) sql.append("AND p.price <= ? ");
    }

    // ── helper: set PreparedStatement params, returns next idx ──────────────
    private int setFilterParams(PreparedStatement ps, int idx,
                                Integer categoryId, String keyword,
                                Long minPrice, Long maxPrice) throws SQLException {
        if (categoryId != null && categoryId > 0) ps.setInt(idx++, categoryId);
        if (keyword    != null && !keyword.isBlank()) ps.setNString(idx++, "%" + keyword + "%");
        if (minPrice   != null) ps.setLong(idx++, minPrice);
        if (maxPrice   != null) ps.setLong(idx++, maxPrice);
        return idx;
    }

    // ── helper: ORDER BY clause ──────────────────────────────────────────────
    private String buildOrderBy(String sortBy) {
        if (sortBy == null) sortBy = "";
        return switch (sortBy) {
            case "price_asc"  -> "ORDER BY p.price ASC ";
            case "price_desc" -> "ORDER BY p.price DESC ";
            case "best_seller"-> "ORDER BY p.sold_count DESC ";
            case "newest"     -> "ORDER BY p.created_at DESC ";
            default           -> "ORDER BY p.created_at DESC ";
        };
    }

    /** Autocomplete: trả về tối đa 8 tên sản phẩm khớp keyword. */
    public List<String> autocomplete(String keyword) {
        List<String> names = new ArrayList<>();
        if (keyword == null || keyword.isBlank()) return names;
        String sql = "SELECT TOP 8 name FROM Product "
                   + "WHERE is_active=1 AND name LIKE ? "
                   + "ORDER BY sold_count DESC, name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) names.add(rs.getString("name"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return names;
    }

    /** Tăng sold_count sau khi đặt hàng thành công. */
    public void increaseSoldCount(Connection conn, int productId, int qty) throws SQLException {
        String sql = "UPDATE Product SET sold_count = sold_count + ? WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    /** Đếm tổng sản phẩm (bao gồm cả inactive) – dùng cho admin dashboard. */
    public int countAllAdmin() {
        String sql = "SELECT COUNT(*) FROM Product WHERE is_active = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Lấy một trang sản phẩm cho admin (tất cả active). offset tính từ 0. */
    public List<Product> getPageAdmin(String keyword, int offset, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE);
        if (keyword != null && !keyword.isBlank()) sql.append("AND p.name LIKE ? ");
        sql.append("ORDER BY p.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.isBlank()) ps.setNString(idx++, "%" + keyword + "%");
            ps.setInt(idx++, offset);
            ps.setInt(idx,   pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Đếm tổng sản phẩm admin theo keyword. */
    public int countAllAdmin(String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Product p WHERE p.is_active = 1 ");
        if (keyword != null && !keyword.isBlank()) sql.append("AND p.name LIKE ? ");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (keyword != null && !keyword.isBlank()) ps.setNString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Deal hôm nay:
     * - Ưu tiên sản phẩm admin đã tick is_daily_deal = 1.
     * - Nếu không có thì dùng seed theo ngày (auto đổi mỗi ngày).
     */
    public Product getDailyDeal() {
        // 1. Kiểm tra xem admin có chọn sản phẩm deal không
        String flagSql = SELECT_BASE + "AND p.is_daily_deal = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(flagSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return map(rs);  // trả về sản phẩm admin chọn
        } catch (SQLException e) { e.printStackTrace(); }

        // 2. Fallback: seed theo ngày
        String countSql = "SELECT COUNT(*) FROM Product WHERE is_active = 1";
        int total = 0;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        if (total == 0) return null;

        long daysSinceEpoch = java.time.LocalDate.now().toEpochDay();
        int offset = (int) (daysSinceEpoch % total);
        String sql = SELECT_BASE + "ORDER BY p.product_id ASC OFFSET ? ROWS FETCH NEXT 1 ROWS ONLY";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Admin đặt sản phẩm làm Deal hôm nay (bỏ chọn tất cả các sản phẩm khác trước). */
    public void setDailyDeal(int productId) {
        String clear  = "UPDATE Product SET is_daily_deal = 0 WHERE is_daily_deal = 1";
        String setDeal = "UPDATE Product SET is_daily_deal = 1 WHERE product_id = ?";
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(clear)) {
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(setDeal)) {
                ps2.setInt(1, productId);
                ps2.executeUpdate();
            }
            conn.commit();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /** Admin bỏ chọn deal thủ công → quay về chế độ tự động theo ngày. */
    public void clearDailyDeal() {
        String sql = "UPDATE Product SET is_daily_deal = 0 WHERE is_daily_deal = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public Product getById(int id) {
        String sql = SELECT_BASE + "AND p.product_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Product p) {
        String sql = "INSERT INTO Product (category_id,name,description,price,unit,image_url,stock) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getName());
            ps.setNString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setNString(5, p.getUnit());
            ps.setString(6, p.getImageUrl());
            ps.setInt(7, p.getStock());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Product p) {
        String sql = "UPDATE Product SET category_id=?,name=?,description=?,price=?,unit=?,"
                + "image_url=?,stock=? WHERE product_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getName());
            ps.setNString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setNString(5, p.getUnit());
            ps.setString(6, p.getImageUrl());
            ps.setInt(7, p.getStock());
            ps.setInt(8, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE Product SET is_active=0 WHERE product_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean decreaseStock(Connection conn, int productId, int qty) throws SQLException {
        String sql = "UPDATE Product SET stock = stock - ? WHERE product_id = ? AND stock >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, productId);
            ps.setInt(3, qty);
            return ps.executeUpdate() > 0;
        }
    }
}
