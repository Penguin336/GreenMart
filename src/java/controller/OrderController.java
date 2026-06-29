package com.greenmart.controller;

import com.greenmart.model.CartDAO;
import com.greenmart.model.OrderDAO;
import com.greenmart.model.CartItem;
import com.greenmart.model.Order;
import com.greenmart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/order/*")
public class OrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO  cartDAO  = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = getLoginUser(req, resp);
        if (user == null) return;

        String path = req.getPathInfo();

        if ("/checkout".equals(path)) {
            List<CartItem> items = cartDAO.getByUser(user.getUserId());
            if (items.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/cart"); return; }
            BigDecimal total = items.stream().map(CartItem::getSubtotal)
                                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            req.setAttribute("cartItems",    items);
            req.setAttribute("cartTotal",    total);
            req.setAttribute("cartTotalFmt", String.format("%,.0f", total).replace(",", ".") + "d");
            req.getRequestDispatcher("/views/checkout.jsp").forward(req, resp);
            return;
        }
        if ("/history".equals(path)) {
            req.setAttribute("orders", orderDAO.getByUser(user.getUserId()));
            req.getRequestDispatcher("/views/order-history.jsp").forward(req, resp);
            return;
        }
        if (path != null && path.startsWith("/detail/")) {
            int orderId = Integer.parseInt(path.substring(8));
            req.setAttribute("order", orderDAO.getById(orderId));
            req.getRequestDispatcher("/views/order-detail.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = getLoginUser(req, resp);
        if (user == null) return;
        req.setCharacterEncoding("UTF-8");

        if ("/place".equals(req.getPathInfo())) {
            List<CartItem> items = cartDAO.getByUser(user.getUserId());
            if (items.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/cart"); return; }

            BigDecimal total = items.stream().map(CartItem::getSubtotal)
                                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setFullName(req.getParameter("fullName"));
            order.setPhone(req.getParameter("phone"));
            order.setAddress(req.getParameter("address"));
            order.setNote(req.getParameter("note"));
            order.setTotalAmount(total);

            int orderId = orderDAO.placeOrder(order, items);
            if (orderId > 0) resp.sendRedirect(req.getContextPath() + "/order/detail/" + orderId + "?success=1");
            else             resp.sendRedirect(req.getContextPath() + "/order/checkout?error=1");
        }
    }

    private User getLoginUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }
}
