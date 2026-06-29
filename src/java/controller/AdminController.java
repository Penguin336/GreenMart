package com.greenmart.controller;

import com.greenmart.model.OrderDAO;
import com.greenmart.model.ProductDAO;
import com.greenmart.model.UserDAO;
import com.greenmart.model.Order;
import com.greenmart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private final OrderDAO   orderDAO   = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final UserDAO    userDAO    = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String path = req.getPathInfo();

        if ("/dashboard".equals(path)) {
            List<Order> recentOrders = orderDAO.getAll();
            req.setAttribute("totalOrders",   orderDAO.countAll());
            req.setAttribute("totalProducts", productDAO.countAllAdmin(null));
            req.setAttribute("totalUsers",    userDAO.getAll().size());
            req.setAttribute("pendingOrders", orderDAO.countPending());
            req.setAttribute("recentOrders",  recentOrders.stream().limit(5).toList());
            req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
            return;
        }
        if ("/orders".equals(path)) {
            final int PAGE_SIZE = 15;
            int totalItems = orderDAO.countAll();
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

            int currentPage = 1;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) {
                try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
            }
            if (currentPage < 1)          currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            int offset = (currentPage - 1) * PAGE_SIZE;
            req.setAttribute("orders",       orderDAO.getPage(offset, PAGE_SIZE));
            req.setAttribute("currentPage",  currentPage);
            req.setAttribute("totalPages",   totalPages);
            req.setAttribute("totalItems",   totalItems);
            req.getRequestDispatcher("/views/admin/orders.jsp").forward(req, resp);
            return;
        }
        if (path != null && path.startsWith("/order/")) {
            int orderId = Integer.parseInt(path.substring(7));
            req.setAttribute("order", orderDAO.getById(orderId));
            req.getRequestDispatcher("/views/admin/order-detail.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        if ("/updateStatus".equals(req.getPathInfo())) {
            int    orderId = Integer.parseInt(req.getParameter("orderId"));
            String status  = req.getParameter("status");
            orderDAO.updateStatus(orderId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/order/" + orderId);
        }
    }

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return false;
        }
        User u = (User) session.getAttribute("user");
        if (!u.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return false;
        }
        return true;
    }
}
