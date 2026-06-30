package controller;

import model.CategoryDAO;
import model.Product;
import model.ProductDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/deals")
public class DailyDealController extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> dailyDeals = productDAO.getDailyDeals();
        req.setAttribute("dailyDeals", dailyDeals);
        
        req.setAttribute("categories", categoryDAO.getAllActive());

        req.getRequestDispatcher("/views/deals.jsp").forward(req, resp);
    }
}
