<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<nav class="navbar">
    <div class="container navbar-inner">

        <!-- ── TRÁI: Logo + Brand ── -->
        <a class="brand" href="${pageContext.request.contextPath}/landing">
            <span class="brand-logo">🌿</span>
            <span class="brand-text">
                <span class="brand-name"><span>Green</span> Mart</span>
                <span class="brand-tagline">Tạp hóa online</span>
            </span>
        </a>

        <!-- ── GIỮA: Search bar + Autocomplete ── -->
        <form class="search-form" action="${pageContext.request.contextPath}/home" method="get"
              style="position:relative">
            <div class="search-wrap">
                <input type="text" name="keyword" id="searchKeyword" class="search-input"
                       placeholder="Tìm kiếm sản phẩm..."
                       value="${keyword}" autocomplete="off"/>
                <button type="submit" class="btn-search" title="Tìm kiếm">🔍</button>
            </div>
            <div class="autocomplete-list" id="acList"></div>
        </form>

        <!-- ── PHẢI: Nav links ── -->
        <div class="nav-actions">

            <a href="${pageContext.request.contextPath}/home">
                <span class="nav-icon">🏠</span> Trang chủ
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="nav-user-wrap">
                        <span class="nav-link">
                            <span class="nav-avatar">
                                ${fn:substring(sessionScope.user.fullName, 0, 1)}
                            </span>
                            <span class="nav-user-name">${sessionScope.user.fullName}</span>
                            <span class="nav-chevron">▼</span>
                        </span>
                        <div class="nav-dropdown">
                            <div class="nav-dropdown-header">
                                <div class="dd-name">${sessionScope.user.fullName}</div>
                                <div class="dd-role">
                                    ${sessionScope.user.admin ? '⭐ Quản trị viên' : '🛒 Khách hàng'}
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/profile">
                                <span class="nav-icon">👤</span> Trang cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/order/history">
                                <span class="nav-icon">📦</span> Đơn hàng của tôi
                            </a>
                            <c:if test="${sessionScope.user.admin}">
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/admin/dashboard">
                                    <span class="nav-icon">⚙️</span> Quản trị hệ thống
                                </a>
                            </c:if>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/auth/logout" class="dropdown-logout">
                                <span class="nav-icon">🚪</span> Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn-login">
                        Đăng nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn-register">
                        Đăng ký
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/cart" class="cart-btn" id="cartBtn">
                <span class="cart-icon">🛒</span>
                <c:if test="${not empty sessionScope.cartCount and sessionScope.cartCount > 0}">
                    <span id="cartCount">${sessionScope.cartCount}</span>
                </c:if>
                <c:if test="${empty sessionScope.cartCount or sessionScope.cartCount == 0}">
                    <span id="cartCount" style="display:none">0</span>
                </c:if>
            </a>

        </div>
    </div>
</nav>

<script>
(function () {
    const input   = document.getElementById('searchKeyword');
    const list    = document.getElementById('acList');
    if (!input || !list) return;

    const ctx     = '${pageContext.request.contextPath}';
    let debounce  = null;
    let focused   = -1;
    let items     = [];

    function render(names) {
        items = names;
        focused = -1;
        if (!names.length) { close(); return; }
        list.innerHTML = names
            .map((n, i) => `<div class="ac-item" data-i="${i}">${n}</div>`)
            .join('');
        list.classList.add('open');

        list.querySelectorAll('.ac-item').forEach(el => {
            el.addEventListener('mousedown', e => {
                e.preventDefault();
                input.value = el.textContent;
                input.closest('form').submit();
            });
        });
    }

    function close() {
        list.classList.remove('open');
        list.innerHTML = '';
        focused = -1;
    }

    function moveFocus(dir) {
        const els = list.querySelectorAll('.ac-item');
        if (!els.length) return;
        if (focused >= 0) els[focused].classList.remove('focused');
        focused = (focused + dir + els.length) % els.length;
        els[focused].classList.add('focused');
        input.value = els[focused].textContent;
    }

    input.addEventListener('input', function () {
        clearTimeout(debounce);
        const q = this.value.trim();
        if (q.length < 1) { close(); return; }
        debounce = setTimeout(() => {
            fetch(ctx + '/product/autocomplete?q=' + encodeURIComponent(q))
                .then(r => r.json())
                .then(render)
                .catch(() => close());
        }, 200);
    });

    input.addEventListener('keydown', function (e) {
        if (e.key === 'ArrowDown')  { e.preventDefault(); moveFocus(1); }
        else if (e.key === 'ArrowUp')   { e.preventDefault(); moveFocus(-1); }
        else if (e.key === 'Escape')    { close(); }
        else if (e.key === 'Enter' && focused >= 0) {
            e.preventDefault();
            input.value = items[focused];
            close();
            input.closest('form').submit();
        }
    });

    document.addEventListener('click', function (e) {
        if (!input.contains(e.target) && !list.contains(e.target)) close();
    });
})();
</script>
