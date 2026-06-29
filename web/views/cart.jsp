<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container cart-page">
    <h2>🛒 Giỏ hàng của bạn</h2>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div style="text-align:center;padding:60px 0;color:#888">
                <p style="font-size:3rem">🛒</p>
                <p style="font-size:1.1rem;margin:16px 0">Giỏ hàng trống</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Tiếp tục mua sắm</a>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Xóa</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <div style="display:flex;align-items:center;gap:12px">
                                    <img src="${item.productImage}" alt="${item.productName}"
                                         style="width:60px;height:60px;object-fit:contain;border-radius:6px;background:#f1f8e9"
                                         onerror="this.src='https://placehold.co/60x60/e8f5e9/2e7d32?text=...'">
                                    <span style="font-weight:600">${item.productName}</span>
                                </div>
                            </td>
                            <td style="color:var(--price);font-weight:700">${item.formattedPrice}/${item.unit}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/cart"
                                      style="display:inline">
                                    <input type="hidden" name="action"  value="update">
                                    <input type="hidden" name="cartId"  value="${item.cartId}">
                                    <input type="number" name="quantity" value="${item.quantity}"
                                           min="1" class="qty-input"
                                           onchange="this.form.submit()">
                                </form>
                            </td>
                            <td style="font-weight:700">${item.formattedSubtotal}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/cart">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                    <button type="submit" class="btn btn-danger"
                                            style="padding:5px 12px;font-size:.82rem"
                                            onclick="return confirm('Xóa sản phẩm này?')">🗑</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="cart-summary">
                <p class="cart-total">Tổng cộng: ${cartTotalFmt}</p>
                <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:16px">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">← Tiếp tục mua</a>
                    <a href="${pageContext.request.contextPath}/order/checkout" class="btn btn-primary">Đặt hàng →</a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
