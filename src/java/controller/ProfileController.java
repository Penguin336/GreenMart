package com.greenmart.controller;

import com.greenmart.model.UserDAO;
import com.greenmart.model.User;
import com.greenmart.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        req.setAttribute("profile", userDAO.getById(user.getUserId()));
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        User user     = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if ("updateInfo".equals(action))          handleUpdateInfo(req, resp, session, user);
        else if ("changePassword".equals(action)) handleChangePassword(req, resp, session, user);
        else                                      resp.sendRedirect(req.getContextPath() + "/profile");
    }

    private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp,
                                   HttpSession session, User user)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String phone    = req.getParameter("phone");
        String address  = req.getParameter("address");

        if (fullName == null || fullName.isBlank()) {
            setErrorAndForward(req, resp, user, "Ho ten khong duoc de trong!");
            return;
        }
        user.setFullName(fullName.trim());
        user.setPhone(phone    != null ? phone.trim()    : "");
        user.setAddress(address != null ? address.trim() : "");

        boolean ok = userDAO.updateProfile(user);
        if (ok) {
            User fresh = userDAO.getById(user.getUserId());
            session.setAttribute("user", fresh);
            req.setAttribute("success", "Cap nhat thong tin thanh cong!");
            req.setAttribute("profile", fresh);
        } else {
            req.setAttribute("error",   "Cap nhat that bai, vui long thu lai!");
            req.setAttribute("profile", user);
        }
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp,
                                       HttpSession session, User user)
            throws ServletException, IOException {
        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        User dbUser = userDAO.getById(user.getUserId());

        if (!PasswordUtil.verify(oldPass, dbUser.getPassword())) {
            setErrorAndForward(req, resp, dbUser, "Mat khau hien tai khong dung!"); return;
        }
        if (newPass == null || newPass.length() < 6) {
            setErrorAndForward(req, resp, dbUser, "Mat khau moi phai co it nhat 6 ky tu!"); return;
        }
        if (!newPass.equals(confirm)) {
            setErrorAndForward(req, resp, dbUser, "Xac nhan mat khau khong khop!"); return;
        }

        boolean ok = userDAO.updatePassword(user.getUserId(), PasswordUtil.hash(newPass));
        req.setAttribute(ok ? "success" : "error",
                         ok ? "Doi mat khau thanh cong!" : "Doi mat khau that bai!");
        req.setAttribute("profile", dbUser);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse resp,
                                     User profile, String msg)
            throws ServletException, IOException {
        req.setAttribute("error",   msg);
        req.setAttribute("profile", profile);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }
}
