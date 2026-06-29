<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-grid { display:grid; grid-template-columns:1fr 380px; gap:28px; flex-wrap:wrap; }
        .checkout-left { background:#fff; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.09); padding:28px; }
        .checkout-right{ background:#fff; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.09);
                         padding:24px; align-self:start; }
        .checkout-right h3 { color:var(--green-dark); margin-bottom:16px; }
        .order-summary-item { display:flex; justify-content:space-between; padding:8px 0;
                               border-bottom:1px solid #f0f0f0; font-size:.9rem; }
        .order-total { display:flex; justify-content:space-between; padding-top:12px;
                       font-weight:800; font-size:1.1rem; color:var(--price); }
        @media(max-width:768px){ .checkout-grid{ grid-template-columns:1fr; } }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container checkout-page">
    <h2>📦 Thông tin đặt hàng</h2>
    <c:if test="${param.error == '1'}">
        <div class="alert alert-danger">Có lỗi khi đặt hàng. Vui lòng kiểm tra lại số lượng tồn kho.</div>
    </c:if>

    <div class="checkout-grid">
        <!-- Form thông tin giao hàng -->
        <div class="checkout-left">
            <h3 style="color:var(--green-dark);margin-bottom:20px">📍 Địa chỉ giao hàng</h3>
            <form method="post" action="${pageContext.request.contextPath}/order/place" id="checkoutForm">
                <div class="form-group">
                    <label>Họ và tên người nhận</label>
                    <input type="text" name="fullName" class="form-control"
                           value="${sessionScope.user.fullName}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="tel" name="phone" class="form-control"
                           value="${sessionScope.user.phone}" required>
                </div>
                <div class="form-group">
                    <label>Địa chỉ nhận hàng</label>
                    <input type="text" name="address" class="form-control"
                           value="${sessionScope.user.address}"
                           placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành" required>
                </div>
                <div class="form-group">
                    <label>Ghi chú đơn hàng (tùy chọn)</label>
                    <textarea name="note" class="form-control" rows="3"
                              placeholder="Ví dụ: Giao buổi sáng, gọi trước khi giao..."></textarea>
                </div>
                <div style="background:var(--green-pale);border-radius:8px;padding:14px;margin-bottom:20px">
                    <p style="font-size:.88rem;color:var(--green-dark);font-weight:600">
                        💳 Phương thức thanh toán
                    </p>
                    <label style="display:flex;align-items:center;gap:8px;margin-top:8px;font-size:.9rem">
                        <input type="radio" name="payment" value="cod" checked>
                        Thanh toán khi nhận hàng (COD)
                    </label>
                </div>
                <button type="submit" class="btn btn-primary"
                        style="width:100%;padding:13px;font-size:1.05rem;border-radius:10px">
                    ✅ Xác nhận đặt hàng
                </button>
            </form>
        </div>

        <!-- Tóm tắt đơn hàng -->
        <div class="checkout-right">
            <h3>🧾 Đơn hàng của bạn</h3>
            <c:forEach var="item" items="${cartItems}">
                <div class="order-summary-item">
                    <span>
                        <img src="${item.productImage}" style="width:32px;height:32px;object-fit:contain;vertical-align:middle;margin-right:6px"
                             onerror="this.style.display='none'">
                        ${item.productName}
                        <span style="color:#888"> x${item.quantity}</span>
                    </span>
                    <span style="font-weight:600;white-space:nowrap">${item.formattedSubtotal}</span>
                </div>
            </c:forEach>
            <div class="order-summary-item" style="border:none">
                <span>Phí giao hàng</span>
                <span style="color:#388e3c;font-weight:600">Miễn phí</span>
            </div>
            <div class="order-total">
                <span>Tổng thanh toán</span>
                <span>${cartTotalFmt}</span>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
