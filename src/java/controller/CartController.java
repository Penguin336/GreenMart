package com.greenmart.controller;

import com.greenmart.model.CartDAO;
import com.greenmart.model.CartItem;
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

@WebServlet(urlPatterns = {"/cart", "/cart/*"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = getLoginUser(req, resp);
        if (user == null) return;

        List<CartItem> items = cartDAO.getByUser(user.getUserId());
        BigDecimal total = items.stream()
                               .map(CartItem::getSubtotal)
                               .reduce(BigDecimal.ZERO, BigDecimal::add);

        req.setAttribute("cartItems",    items);
        req.setAttribute("cartTotal",    total);
        req.setAttribute("cartTotalFmt", String.format("%,.0f", total).replace(",", ".") + "d");
        req.getRequestDispatcher("/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = getLoginUser(req, resp);
        if (user == null) return;

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "add" -> {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int qty       = Integer.parseInt(req.getParameter("quantity"));
                cartDAO.addOrUpdate(user.getUserId(), productId, qty);
                req.getSession().setAttribute("cartCount", cartDAO.countByUser(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/home");
            }
            case "update" -> {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                int qty    = Integer.parseInt(req.getParameter("quantity"));
                cartDAO.updateQuantity(cartId, qty);
                req.getSession().setAttribute("cartCount", cartDAO.countByUser(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            case "remove" -> {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                cartDAO.remove(cartId);
                req.getSession().setAttribute("cartCount", cartDAO.countByUser(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            default -> resp.sendRedirect(req.getContextPath() + "/cart");
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
