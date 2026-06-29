package com.greenmart.model;

import com.greenmart.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.cart_id, c.user_id, c.product_id, c.quantity, "
                + "p.name AS product_name, p.image_url, p.price, p.unit "
                + "FROM Cart c JOIN Product p ON c.product_id = p.product_id "
                + "WHERE c.user_id = ? AND p.is_active = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImage(rs.getString("image_url"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setUnit(rs.getString("unit"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addOrUpdate(int userId, int productId, int qty) {
        String checkSql = "SELECT cart_id, quantity FROM Cart WHERE user_id=? AND product_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement check = conn.prepareStatement(checkSql)) {
            check.setInt(1, userId);
            check.setInt(2, productId);
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) {
                    int newQty = rs.getInt("quantity") + qty;
                    String upd = "UPDATE Cart SET quantity=? WHERE cart_id=?";
                    try (PreparedStatement ps2 = conn.prepareStatement(upd)) {
                        ps2.setInt(1, newQty);
                        ps2.setInt(2, rs.getInt("cart_id"));
                        return ps2.executeUpdate() > 0;
                    }
                } else {
                    String ins = "INSERT INTO Cart (user_id,product_id,quantity) VALUES (?,?,?)";
                    try (PreparedStatement ps2 = conn.prepareStatement(ins)) {
                        ps2.setInt(1, userId);
                        ps2.setInt(2, productId);
                        ps2.setInt(3, qty);
                        return ps2.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateQuantity(int cartId, int qty) {
        if (qty <= 0) return remove(cartId);
        String sql = "UPDATE Cart SET quantity=? WHERE cart_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean remove(int cartId) {
        String sql = "DELETE FROM Cart WHERE cart_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearByUser(Connection conn, int userId) throws SQLException {
        String sql = "DELETE FROM Cart WHERE user_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        }
    }

    public int countByUser(int userId) {
        String sql = "SELECT ISNULL(SUM(quantity),0) FROM Cart WHERE user_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
