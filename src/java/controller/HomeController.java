package com.greenmart.controller;

import com.greenmart.model.CategoryDAO;
import com.greenmart.model.ProductDAO;
import com.greenmart.model.Category;
import com.greenmart.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String  keyword    = req.getParameter("keyword");
        String  catParam   = req.getParameter("category");
        String  sortBy     = req.getParameter("sort");
        String  minPStr    = req.getParameter("minPrice");
        String  maxPStr    = req.getParameter("maxPrice");

        Integer categoryId = null;
        if (catParam != null && !catParam.isBlank()) {
            try { categoryId = Integer.parseInt(catParam); } catch (NumberFormatException ignored) {}
        }
        Long minPrice = null, maxPrice = null;
        try { if (minPStr != null && !minPStr.isBlank()) minPrice = Long.parseLong(minPStr); } catch (NumberFormatException ignored) {}
        try { if (maxPStr != null && !maxPStr.isBlank()) maxPrice = Long.parseLong(maxPStr); } catch (NumberFormatException ignored) {}

        // Phân trang
        int totalItems = productDAO.countAll(categoryId, keyword, minPrice, maxPrice);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }
        if (currentPage < 1)          currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * PAGE_SIZE;
        List<Product>  products   = productDAO.getPage(categoryId, keyword, minPrice, maxPrice, sortBy, offset, PAGE_SIZE);
        List<Category> categories = categoryDAO.getAllActive();
        Product        dailyDeal  = productDAO.getDailyDeal();

        req.setAttribute("products",     products);
        req.setAttribute("categories",   categories);
        req.setAttribute("dailyDeal",    dailyDeal);
        req.setAttribute("keyword",      keyword);
        req.setAttribute("categoryId",   categoryId);
        req.setAttribute("sortBy",       sortBy);
        req.setAttribute("minPrice",     minPStr);
        req.setAttribute("maxPrice",     maxPStr);
        req.setAttribute("currentPage",  currentPage);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("totalItems",   totalItems);

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
