<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard – GreenMart Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link active">
                <span class="nav-icon">📊</span><span>Dashboard</span>
            </a>

            <div class="admin-nav-label">Quản lý</div>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link">
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

        <!-- Topbar -->
        <div class="admin-topbar">
            <div class="admin-topbar-title">📊 Dashboard</div>
            <div class="admin-topbar-right">
                <div class="admin-user-chip">
                    <div class="chip-avatar">
                        ${fn:substring(sessionScope.user.fullName,0,1)}
                    </div>
                    ${sessionScope.user.fullName}
                </div>
            </div>
        </div>

        <div class="admin-page">

            <!-- Stat cards -->
            <div class="admin-stats">
                <div class="admin-stat-card green">
                    <div class="admin-stat-icon">📦</div>
                    <div class="admin-stat-info">
                        <div class="admin-stat-num">${totalOrders}</div>
                        <div class="admin-stat-label">Tổng đơn hàng</div>
                    </div>
                </div>
                <div class="admin-stat-card blue">
                    <div class="admin-stat-icon">🛍</div>
                    <div class="admin-stat-info">
                        <div class="admin-stat-num">${totalProducts}</div>
                        <div class="admin-stat-label">Sản phẩm</div>
                    </div>
                </div>
                <div class="admin-stat-card orange">
                    <div class="admin-stat-icon">👥</div>
                    <div class="admin-stat-info">
                        <div class="admin-stat-num">${totalUsers}</div>
                        <div class="admin-stat-label">Khách hàng</div>
                    </div>
                </div>
                <div class="admin-stat-card red">
                    <div class="admin-stat-icon">⏳</div>
                    <div class="admin-stat-info">
                        <div class="admin-stat-num">${pendingOrders}</div>
                        <div class="admin-stat-label">Chờ xác nhận</div>
                    </div>
                </div>
            </div>

            <!-- Recent orders -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <div class="admin-card-title">📋 Đơn hàng gần đây</div>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary"
                       style="font-size:.82rem;padding:7px 16px">Xem tất cả →</a>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${recentOrders}">
                            <tr>
                                <td><strong>#${o.orderId}</strong></td>
                                <td>${o.fullName}</td>
                                <td style="font-weight:700;color:var(--price)">${o.formattedTotal}</td>
                                <td><span class="status-badge status-${o.status}">${o.statusLabel}</span></td>
                                <td style="color:var(--text-muted)">
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/order/${o.orderId}"
                                       class="btn btn-secondary" style="padding:5px 12px;font-size:.8rem">Xem</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <tr><td colspan="6" style="text-align:center;color:var(--text-muted);padding:32px">
                                Chưa có đơn hàng nào
                            </td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>
</body>
</html>
