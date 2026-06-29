package com.greenmart.controller;

import com.greenmart.model.CartDAO;
import com.greenmart.model.UserDAO;
import com.greenmart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        if ("/register".equals(path)) {
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();

        if ("/login".equals(path))         handleLogin(req, resp);
        else if ("/register".equals(path)) handleRegister(req, resp);
        else                               resp.sendRedirect(req.getContextPath() + "/home");
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userDAO.login(email, password);
        if (user == null) {
            req.setAttribute("error", "Email hoac mat khau khong dung!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60);
        session.setAttribute("cartCount", new CartDAO().countByUser(user.getUserId()));

        if (user.isAdmin()) resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        else                resp.sendRedirect(req.getContextPath() + "/home");
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");

        if (userDAO.emailExists(email)) {
            req.setAttribute("error", "Email da duoc dang ky!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);
        userDAO.register(u);

        resp.sendRedirect(req.getContextPath() + "/auth/login?success=1");
    }
}
