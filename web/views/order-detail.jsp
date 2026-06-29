<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng #${order.orderId} – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container" style="max-width:760px;margin:32px auto">
    <c:if test="${param.success == '1'}">
        <div class="alert alert-success" style="font-size:1rem;padding:16px">
            🎉 Đặt hàng thành công! Chúng tôi sẽ liên hệ xác nhận sớm nhất.
        </div>
    </c:if>

    <div style="background:#fff;border-radius:12px;box-shadow:0 2px 8px rgba(0,0,0,.09);padding:28px">
        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:24px">
            <h2 style="color:var(--green-dark)">📦 Đơn hàng #${order.orderId}</h2>
            <span class="status-badge status-${order.status}">${order.statusLabel}</span>
        </div>

        <!-- Thông tin giao hàng -->
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:24px;flex-wrap:wrap">
            <div style="background:var(--green-pale);border-radius:8px;padding:16px">
                <h4 style="color:var(--green-dark);margin-bottom:10px">📍 Địa chỉ giao hàng</h4>
                <p><strong>${order.fullName}</strong></p>
                <p>📞 ${order.phone}</p>
                <p>🏠 ${order.address}</p>
                <c:if test="${not empty order.note}">
                    <p style="margin-top:8px;color:#666;font-style:italic">📝 ${order.note}</p>
                </c:if>
            </div>
            <div style="background:#f3f3f3;border-radius:8px;padding:16px">
                <h4 style="color:var(--green-dark);margin-bottom:10px">🧾 Thông tin đơn</h4>
                <p>Mã đơn: <strong>#${order.orderId}</strong></p>
                <p>Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                <p>Thanh toán: <strong>COD</strong></p>
                <p>Trạng thái: <span class="status-badge status-${order.status}">${order.statusLabel}</span></p>
            </div>
        </div>

        <!-- Danh sách sản phẩm -->
        <h3 style="color:var(--green-dark);margin-bottom:14px">🛍 Sản phẩm đã đặt</h3>
        <table>
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${order.details}">
                    <tr>
                        <td>
                            <div style="display:flex;align-items:center;gap:10px">
                                <img src="${d.productImage}" style="width:48px;height:48px;object-fit:contain;
                                     border-radius:6px;background:#f1f8e9"
                                     onerror="this.style.display='none'">
                                ${d.productName}
                            </div>
                        </td>
                        <td>${d.formattedPrice}</td>
                        <td>${d.quantity}</td>
                        <td style="font-weight:700;color:var(--price)">${d.formattedSubtotal}</td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" style="text-align:right;font-weight:700;font-size:1rem">Tổng cộng:</td>
                    <td style="font-size:1.15rem;font-weight:800;color:var(--price)">${order.formattedTotal}</td>
                </tr>
            </tfoot>
        </table>

        <div style="display:flex;gap:12px;margin-top:24px;flex-wrap:wrap">
            <a href="${pageContext.request.contextPath}/order/history" class="btn btn-secondary">← Lịch sử đơn hàng</a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">🛒 Tiếp tục mua sắm</a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
