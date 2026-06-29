<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container order-list">
    <h2 style="color:var(--green-dark)">📋 Lịch sử đơn hàng</h2>

    <c:choose>
        <c:when test="${empty orders}">
            <div style="text-align:center;padding:60px;color:#888;background:#fff;border-radius:12px">
                <p style="font-size:2.5rem">📦</p>
                <p style="margin:12px 0 20px">Bạn chưa có đơn hàng nào</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Mua sắm ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orders}">
                <div class="order-card">
                    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px">
                        <div>
                            <h4>Đơn hàng #${order.orderId}</h4>
                            <p style="font-size:.85rem;color:#888;margin-top:4px">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </p>
                        </div>
                        <div style="text-align:right">
                            <span class="status-badge status-${order.status}">${order.statusLabel}</span>
                            <p style="font-weight:800;color:var(--price);font-size:1.05rem;margin-top:6px">
                                ${order.formattedTotal}
                            </p>
                        </div>
                    </div>
                    <div style="margin-top:14px;display:flex;justify-content:flex-end">
                        <a href="${pageContext.request.contextPath}/order/detail/${order.orderId}"
                           class="btn btn-secondary" style="font-size:.88rem;padding:7px 16px">
                           Xem chi tiết →
                        </a>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
