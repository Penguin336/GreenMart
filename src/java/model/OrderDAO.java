package com.greenmart.model;

import com.greenmart.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(Order order, List<CartItem> items) {
        String insOrder  = "INSERT INTO Orders (user_id,full_name,phone,address,total_amount,note) "
                         + "VALUES (?,?,?,?,?,?)";
        String insDetail = "INSERT INTO OrderDetail (order_id,product_id,quantity,unit_price) VALUES (?,?,?,?)";

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = conn.prepareStatement(insOrder, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, order.getUserId());
                    ps.setNString(2, order.getFullName());
                    ps.setString(3, order.getPhone());
                    ps.setNString(4, order.getAddress());
                    ps.setBigDecimal(5, order.getTotalAmount());
                    ps.setNString(6, order.getNote());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Khong lay duoc orderId");
                        orderId = keys.getInt(1);
                    }
                }

                ProductDAO productDAO = new ProductDAO();
                try (PreparedStatement ps = conn.prepareStatement(insDetail)) {
                    for (CartItem item : items) {
                        if (!productDAO.decreaseStock(conn, item.getProductId(), item.getQuantity())) {
                            throw new SQLException("San pham '" + item.getProductName() + "' khong du so luong!");
                        }
                        // Tăng sold_count tương ứng với số lượng đặt
                        productDAO.increaseSoldCount(conn, item.getProductId(), item.getQuantity());
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getProductId());
                        ps.setInt(3, item.getQuantity());
                        ps.setBigDecimal(4, item.getPrice());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                new CartDAO().clearByUser(conn, order.getUserId());
                conn.commit();
                return orderId;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Order getById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE order_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setDetails(getDetails(orderId));
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Đếm tổng số đơn hàng (dùng cho phân trang). */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Lấy một trang đơn hàng. offset tính từ 0. */
    public List<Order> getPage(int offset, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public long countPending() {
        String sql = "SELECT COUNT(*) FROM Orders WHERE status='pending'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Kiểm tra user đã mua (đơn hàng đã giao) sản phẩm này chưa.
     * Chỉ đơn có status = 'delivered' mới được tính.
     */
    public boolean hasPurchased(int productId, int userId) {
        String sql = "SELECT 1 FROM Orders o "
                   + "JOIN OrderDetail od ON o.order_id = od.order_id "
                   + "WHERE o.user_id = ? AND od.product_id = ? AND o.status = 'delivered'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status=? WHERE order_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setFullName(rs.getString("full_name"));
        o.setPhone(rs.getString("phone"));
        o.setAddress(rs.getString("address"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setNote(rs.getString("note"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }

    private List<OrderDetail> getDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.name AS product_name, p.image_url "
                + "FROM OrderDetail od JOIN Product p ON od.product_id = p.product_id "
                + "WHERE od.order_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setDetailId(rs.getInt("detail_id"));
                    d.setOrderId(orderId);
                    d.setProductId(rs.getInt("product_id"));
                    d.setProductName(rs.getString("product_name"));
                    d.setProductImage(rs.getString("image_url"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setUnitPrice(rs.getBigDecimal("unit_price"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
