package com.greenmart.controller;

import com.greenmart.model.CategoryDAO;
import com.greenmart.model.OrderDAO;
import com.greenmart.model.ProductDAO;
import com.greenmart.model.ReviewDAO;
import com.greenmart.model.Review;
import com.greenmart.model.Category;
import com.greenmart.model.Product;
import com.greenmart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/product/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB – buffer trước khi ghi disk
    maxFileSize       = 5 * 1024 * 1024,  // tối đa 5 MB / ảnh
    maxRequestSize    = 10 * 1024 * 1024  // tối đa 10 MB / request
)
public class ProductController extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO   reviewDAO   = new ReviewDAO();
    private final OrderDAO    orderDAO    = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/detail/")) {
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                Product p = productDAO.getById(id);
                if (p == null) { resp.sendError(404); return; }

                List<Review> reviews = reviewDAO.getByProduct(id);
                boolean hasReviewed   = false;
                boolean hasPurchased  = false;
                HttpSession sess = req.getSession(false);
                if (sess != null && sess.getAttribute("user") != null) {
                    int uid = ((User) sess.getAttribute("user")).getUserId();
                    hasReviewed  = reviewDAO.hasReviewed(id, uid);
                    hasPurchased = orderDAO.hasPurchased(id, uid);
                }

                req.setAttribute("product",      p);
                req.setAttribute("reviews",      reviews);
                req.setAttribute("hasReviewed",  hasReviewed);
                req.setAttribute("hasPurchased", hasPurchased);
                req.getRequestDispatcher("/views/product-detail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(400);
            }
            return;
        }

        // ── Autocomplete JSON endpoint ─────────────────────────────────────
        if ("/autocomplete".equals(pathInfo)) {
            String q = req.getParameter("q");
            List<String> names = productDAO.autocomplete(q);
            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("[");
            for (int i = 0; i < names.size(); i++) {
                if (i > 0) out.print(",");
                // Escape quotes safely
                out.print("\"" + names.get(i).replace("\\", "\\\\").replace("\"", "\\\"") + "\"");
            }
            out.print("]");
            return;
        }
        if (pathInfo != null && pathInfo.startsWith("/admin")) {
            requireAdmin(req, resp);
            if (resp.isCommitted()) return;

            final int PAGE_SIZE = 10;
            String keyword = req.getParameter("keyword");

            int totalItems = productDAO.countAllAdmin(keyword);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

            int currentPage = 1;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) {
                try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
            }
            if (currentPage < 1)          currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            int offset = (currentPage - 1) * PAGE_SIZE;

            req.setAttribute("products",    productDAO.getPageAdmin(keyword, offset, PAGE_SIZE));
            req.setAttribute("categories",  categoryDAO.getAllActive());
            req.setAttribute("keyword",     keyword);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages",  totalPages);
            req.setAttribute("totalItems",  totalItems);
            req.getRequestDispatcher("/views/admin/product-manage.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // ── Xử lý đánh giá sản phẩm (không yêu cầu admin) ─────────────────
        if ("review".equals(action)) {
            HttpSession sess = req.getSession(false);
            if (sess == null || sess.getAttribute("user") == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }
            User user = (User) sess.getAttribute("user");
            int productId = Integer.parseInt(req.getParameter("productId"));

            // Chỉ cho phép nếu đã mua sản phẩm này (đơn delivered)
            if (!orderDAO.hasPurchased(productId, user.getUserId())) {
                resp.sendRedirect(req.getContextPath() + "/product/detail/" + productId + "#reviews");
                return;
            }

            // Chưa đánh giá thì mới cho thêm
            if (!reviewDAO.hasReviewed(productId, user.getUserId())) {
                int stars = Integer.parseInt(req.getParameter("stars"));
                String comment = req.getParameter("comment");
                Review r = new Review();
                r.setProductId(productId);
                r.setUserId(user.getUserId());
                r.setStars(Math.max(1, Math.min(5, stars)));
                r.setComment(comment);
                reviewDAO.insert(r);
            }
            resp.sendRedirect(req.getContextPath() + "/product/detail/" + productId + "#reviews");
            return;
        }

        // Các action còn lại (add, edit, delete) chỉ dành cho admin
        requireAdmin(req, resp);
        if (resp.isCommitted()) return;

        if ("add".equals(action) || "edit".equals(action)) {            Product p = new Product();
            String idParam = req.getParameter("productId");
            if (idParam != null && !idParam.isBlank())
                p.setProductId(Integer.parseInt(idParam));
            p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            p.setName(req.getParameter("name"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(new BigDecimal(req.getParameter("price")));
            p.setUnit(req.getParameter("unit"));
            p.setStock(Integer.parseInt(req.getParameter("stock")));

            // ── Xử lý upload ảnh ──────────────────────────────────────────
            String imageUrl = req.getParameter("imageUrlCurrent"); // ảnh hiện tại (khi edit)
            Part filePart = req.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String ext = originalName.contains(".")
                        ? originalName.substring(originalName.lastIndexOf('.'))
                        : ".jpg";
                // Tên file unique để tránh trùng
                String savedName = UUID.randomUUID().toString() + ext;

                // Thư mục lưu: <webroot>/images/products/
                String uploadDir = getServletContext().getRealPath("/images/products");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                try (InputStream in = filePart.getInputStream()) {
                    Files.copy(in, new File(dir, savedName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                imageUrl = "images/products/" + savedName;
            }
            p.setImageUrl(imageUrl != null ? imageUrl : "");

            if ("add".equals(action)) productDAO.insert(p);
            else                      productDAO.update(p);

        } else if ("delete".equals(action)) {
            productDAO.delete(Integer.parseInt(req.getParameter("productId")));
        }

        // Giữ lại trang và keyword sau khi thêm/sửa/xóa
        String page    = req.getParameter("currentPage");
        String keyword = req.getParameter("keyword");
        StringBuilder redirect = new StringBuilder(req.getContextPath() + "/product/admin/list");
        boolean hasParam = false;
        if (page != null && !page.isBlank() && !"1".equals(page)) {
            redirect.append("?page=").append(page);
            hasParam = true;
        }
        if (keyword != null && !keyword.isBlank()) {
            redirect.append(hasParam ? "&" : "?")
                    .append("keyword=")
                    .append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        resp.sendRedirect(redirect.toString());
    }

    private void requireAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        User u = (User) session.getAttribute("user");
        if (!u.isAdmin()) resp.sendRedirect(req.getContextPath() + "/home");
    }
}
