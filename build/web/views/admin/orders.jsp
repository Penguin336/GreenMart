<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đơn hàng – GreenMart Admin</title>
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
            <div class="admin-topbar-title">📦 Quản lý đơn hàng</div>
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
                <span>›</span> Đơn hàng
            </div>

            <div class="admin-card">
                <div class="admin-card-header">
                    <div class="admin-card-title">📋 Danh sách đơn hàng</div>
                    <select class="admin-select" id="statusFilter" onchange="filterStatus(this.value)">
                        <option value="">Tất cả trạng thái</option>
                        <option value="pending">⏳ Chờ xác nhận</option>
                        <option value="confirmed">✅ Đã xác nhận</option>
                        <option value="shipping">🚚 Đang giao</option>
                        <option value="delivered">✔️ Đã giao</option>
                        <option value="cancelled">❌ Đã hủy</option>
                    </select>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>SĐT</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="orderTable">
                        <c:forEach var="o" items="${orders}">
                            <tr data-status="${o.status}">
                                <td><strong>#${o.orderId}</strong></td>
                                <td>${o.fullName}</td>
                                <td style="color:var(--text-muted)">${o.phone}</td>
                                <td style="font-weight:700;color:var(--price)">${o.formattedTotal}</td>
                                <td><span class="status-badge status-${o.status}">${o.statusLabel}</span></td>
                                <td style="color:var(--text-muted);font-size:.83rem">
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/order/${o.orderId}"
                                       class="btn btn-secondary" style="padding:5px 14px;font-size:.8rem">
                                        Chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr><td colspan="7" style="text-align:center;color:var(--text-muted);padding:40px">
                                Không có đơn hàng nào
                            </td></tr>
                        </c:if>
                    </tbody>
                </table>

                <%-- Pagination admin đơn hàng --%>
                <c:if test="${totalPages > 1}">
                    <div class="admin-pagination">
                        <span class="page-info">
                            Trang ${currentPage} / ${totalPages} &nbsp;·&nbsp; ${totalItems} đơn hàng
                        </span>
                        <nav class="pagination" style="margin-top:0">
                            <c:choose>
                                <c:when test="${currentPage <= 1}">
                                    <span class="page-btn disabled">&#8592;</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-btn"
                                       href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}">&#8592;</a>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 or i == totalPages
                                                 or (i >= currentPage - 2 and i <= currentPage + 2)}">
                                        <a class="page-btn"
                                           href="${pageContext.request.contextPath}/admin/orders?page=${i}">${i}</a>
                                    </c:when>
                                    <c:when test="${i == currentPage - 3 or i == currentPage + 3}">
                                        <span class="page-btn disabled">…</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage >= totalPages}">
                                    <span class="page-btn disabled">&#8594;</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-btn"
                                       href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}">&#8594;</a>
                                </c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
function filterStatus(val) {
    document.querySelectorAll('#orderTable tr[data-status]').forEach(row => {
        row.style.display = (!val || row.dataset.status === val) ? '' : 'none';
    });
}
</script>
</body>
</html>
