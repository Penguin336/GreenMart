<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đơn #${order.orderId} – GreenMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">

    <!-- ── SIDEBAR ── -->
    <aside class="admin-sidebar">
        <div class="admin-brand">
            <div class="admin-brand-logo">🌿</div>
            <div class="admin-brand-text">
                <div class="admin-brand-name"><span>Green</span>Mart</div>
                <div class="admin-brand-sub">Admin Panel</div>
            </div>
        </div>
        <nav class="admin-nav">
            <div class="admin-nav-label">Tổng quan</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link">
                <span class="nav-icon">📊</span><span>Dashboard</span>
            </a>
            <div class="admin-nav-label">Quản lý</div>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link active">
                <span class="nav-icon">📦</span><span>Đơn hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/product/admin/list" class="admin-nav-link">
                <span class="nav-icon">🛍</span><span>Sản phẩm</span>
            </a>
        </nav>
        <div class="admin-nav-bottom">
            <a href="${pageContext.request.contextPath}/home" class="admin-nav-link">
                <span class="nav-icon">🌐</span><span>Xem shop</span>
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="admin-nav-link admin-logout">
                <span class="nav-icon">🚪</span><span>Đăng xuất</span>
            </a>
        </div>
    </aside>

    <!-- ── MAIN ── -->
    <div class="admin-content">
        <div class="admin-topbar">
            <div class="admin-topbar-title">
                📦 Đơn hàng #${order.orderId}
                <span class="status-badge status-${order.status}"
                      style="margin-left:8px">${order.statusLabel}</span>
            </div>
            <div class="admin-topbar-right">
                <div class="admin-user-chip">
                    <div class="chip-avatar">${fn:substring(sessionScope.user.fullName,0,1)}</div>
                    ${sessionScope.user.fullName}
                </div>
            </div>
        </div>

        <div class="admin-page">
            <div class="admin-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>›</span>
                <a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a>
                <span>›</span> #${order.orderId}
            </div>

            <div class="admin-info-grid">
                <!-- Thông tin giao hàng -->
                <div class="admin-card" style="margin-bottom:0">
                    <div class="admin-card-header">
                        <div class="admin-card-title">📍 Thông tin giao hàng</div>
                    </div>
                    <div class="admin-card-body">
                        <div class="admin-info-row">
                            <span class="admin-info-label">Người nhận</span>
                            <span class="admin-info-value">${order.fullName}</span>
                        </div>
                        <div class="admin-info-row">
                            <span class="admin-info-label">Điện thoại</span>
                            <span class="admin-info-value">${order.phone}</span>
                        </div>
                        <div class="admin-info-row">
                            <span class="admin-info-label">Địa chỉ</span>
                            <span class="admin-info-value">${order.address}</span>
                        </div>
                        <div class="admin-info-row">
                            <span class="admin-info-label">Ghi chú</span>
                            <span class="admin-info-value" style="font-style:italic;color:var(--text-muted)">
                                ${empty order.note ? '—' : order.note}
                            </span>
                        </div>
                        <div class="admin-info-row">
                            <span class="admin-info-label">Ngày đặt</span>
                            <span class="admin-info-value">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Cập nhật trạng thái -->
                <div class="admin-card" style="margin-bottom:0">
                    <div class="admin-card-header">
                        <div class="admin-card-title">🔄 Cập nhật trạng thái</div>
                    </div>
                    <div class="admin-card-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/updateStatus">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <div class="form-group">
                                <label>Trạng thái hiện tại</label>
                                <div style="margin-bottom:14px">
                                    <span class="status-badge status-${order.status}"
                                          style="font-size:.9rem;padding:5px 14px">
                                        ${order.statusLabel}
                                    </span>
                                </div>
                                <label>Chuyển sang</label>
                                <select name="status" class="form-control admin-select"
                                        style="width:100%">
                                    <option value="pending"   ${order.status=='pending'   ?'selected':''}>⏳ Chờ xác nhận</option>
                                    <option value="confirmed" ${order.status=='confirmed' ?'selected':''}>✅ Đã xác nhận</option>
                                    <option value="shipping"  ${order.status=='shipping'  ?'selected':''}>🚚 Đang giao</option>
                                    <option value="delivered" ${order.status=='delivered' ?'selected':''}>✔️ Đã giao</option>
                                    <option value="cancelled" ${order.status=='cancelled' ?'selected':''}>❌ Đã hủy</option>
                                </select>
                            </div>
                            <div style="display:flex;gap:10px;margin-top:8px">
                                <button type="submit" class="btn btn-primary" style="flex:1">
                                    Cập nhật
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/orders"
                                   class="btn btn-secondary">← Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Sản phẩm trong đơn -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <div class="admin-card-title">🛍 Sản phẩm trong đơn</div>
                    <span style="font-size:.85rem;color:var(--text-muted)">
                        ${order.details.size()} sản phẩm
                    </span>
                </div>
                <table class="admin-table">
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
                                    <div class="admin-product-thumb">
                                        <c:choose>
                                            <c:when test="${empty d.productImage}">
                                                <img src="https://placehold.co/44x44/e8f5e9/2e7d32?text=...">
                                            </c:when>
                                            <c:when test="${fn:startsWith(d.productImage,'http')}">
                                                <img src="${d.productImage}"
                                                     onerror="this.src='https://placehold.co/44x44/e8f5e9/2e7d32?text=...'">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${d.productImage}"
                                                     onerror="this.src='https://placehold.co/44x44/e8f5e9/2e7d32?text=...'">
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="admin-product-name">${d.productName}</span>
                                    </div>
                                </td>
                                <td>${d.formattedPrice}</td>
                                <td>
                                    <span style="background:#f0f4f0;border-radius:6px;
                                                 padding:2px 10px;font-weight:700">
                                        ${d.quantity}
                                    </span>
                                </td>
                                <td style="font-weight:700;color:var(--price)">${d.formattedSubtotal}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" style="text-align:right;font-weight:700">Tổng cộng:</td>
                            <td style="font-size:1.15rem;font-weight:800;color:var(--price)">
                                ${order.formattedTotal}
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>

        </div>
    </div>
</div>
</body>
</html>
