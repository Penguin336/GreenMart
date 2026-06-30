<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>GreenMart – Tạp hóa online</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container page-layout">

    <!-- SIDEBAR DANH MỤC -->
    <aside class="sidebar">
        <h3>📋 Danh mục</h3>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/home"
                   class="${empty param.category ? 'active' : ''}">
                   🛒 Tất cả sản phẩm
                </a>
            </li>
            <c:forEach var="cat" items="${categories}">
                <li>
                    <a href="${pageContext.request.contextPath}/home?category=${cat.categoryId}"
                       class="${param.category == cat.categoryId ? 'active' : ''}">
                       ${cat.icon} ${cat.name}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </aside>

    <!-- SẢN PHẨM -->
    <main class="products-area">

        <h2 class="section-title">
            🌿 Tất cả sản phẩm
            <c:if test="${not empty keyword}">
                <small style="font-size:.85rem;color:#607d5e;">"${keyword}"</small>
            </c:if>
        </h2>

        <!-- ── BỘ LỌC NÂNG CAO ── -->
        <form method="get" action="${pageContext.request.contextPath}/home" class="filter-bar" id="filterForm">
            <c:if test="${not empty keyword}">
                <input type="hidden" name="keyword" value="${keyword}">
            </c:if>
            <c:if test="${not empty categoryId and categoryId > 0}">
                <input type="hidden" name="category" value="${categoryId}">
            </c:if>

            <div class="filter-group">
                <label class="filter-label">💰 Khoảng giá</label>
                <div class="filter-prices">
                    <button type="button" class="price-chip ${empty minPrice and empty maxPrice ? 'active' : ''}"
                            onclick="setPrice('','')">Tất cả</button>
                    <button type="button" class="price-chip ${minPrice=='0' and maxPrice=='50000' ? 'active' : ''}"
                            onclick="setPrice(0,50000)">Dưới 50k</button>
                    <button type="button" class="price-chip ${minPrice=='50000' and maxPrice=='100000' ? 'active' : ''}"
                            onclick="setPrice(50000,100000)">50k–100k</button>
                    <button type="button" class="price-chip ${minPrice=='100000' and maxPrice=='200000' ? 'active' : ''}"
                            onclick="setPrice(100000,200000)">100k–200k</button>
                    <button type="button" class="price-chip ${minPrice=='200000' and empty maxPrice ? 'active' : ''}"
                            onclick="setPrice(200000,'')">Trên 200k</button>
                </div>
                <input type="hidden" name="minPrice" id="minPrice" value="${not empty minPrice ? minPrice : ''}">
                <input type="hidden" name="maxPrice" id="maxPrice" value="${not empty maxPrice ? maxPrice : ''}">
            </div>

            <div class="filter-group">
                <label class="filter-label">🔀 Sắp xếp</label>
                <div class="filter-sorts">
                    <button type="button" class="sort-chip ${empty sortBy or sortBy=='newest' ? 'active' : ''}"
                            onclick="setSort('newest')">Mới nhất</button>
                    <button type="button" class="sort-chip ${sortBy=='best_seller' ? 'active' : ''}"
                            onclick="setSort('best_seller')">🔥 Bán chạy</button>
                    <button type="button" class="sort-chip ${sortBy=='price_asc' ? 'active' : ''}"
                            onclick="setSort('price_asc')">Giá ↑</button>
                    <button type="button" class="sort-chip ${sortBy=='price_desc' ? 'active' : ''}"
                            onclick="setSort('price_desc')">Giá ↓</button>
                </div>
                <input type="hidden" name="sort" id="sortBy" value="${not empty sortBy ? sortBy : 'newest'}">
            </div>
        </form>

        <%-- ── DEAL HÔM NAY ── --%>
        <c:if test="${not empty dailyDeal}">
        <div class="daily-deal-banner" id="dailyDealBanner">
            <div class="dd-left">
                <div class="dd-badge">🔥 DEAL HÔM NAY</div>
                <div class="dd-countdown-label">Kết thúc sau:</div>
                <div class="dd-countdown" id="ddCountdown">
                    <div class="dd-time-block"><span id="ddH">00</span><small>Giờ</small></div>
                    <div class="dd-sep">:</div>
                    <div class="dd-time-block"><span id="ddM">00</span><small>Phút</small></div>
                    <div class="dd-sep">:</div>
                    <div class="dd-time-block"><span id="ddS">00</span><small>Giây</small></div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/product/detail/${dailyDeal.productId}" class="dd-product">
                <div class="dd-img-wrap">
                    <c:set var="ddImg" value="${dailyDeal.imageUrl}"/>
                    <c:if test="${not empty ddImg and not fn:startsWith(ddImg,'http')}">
                        <c:set var="ddImg" value="${pageContext.request.contextPath}/${ddImg}"/>
                    </c:if>
                    <img src="${ddImg}" alt="${dailyDeal.name}"
                         onerror="this.src='https://placehold.co/120x120/e8f5e9/2e7d32?text=🛒'">
                </div>
                <div class="dd-info">
                    <span class="dd-cat">${dailyDeal.categoryName}</span>
                    <p class="dd-name">${dailyDeal.name}</p>
                    <div class="dd-price-row">
                        <span class="dd-original-price">${dailyDeal.formattedOriginalPrice}</span>
                        <span class="dd-discount-badge">-23%</span>
                    </div>
                    <p class="dd-price">${dailyDeal.formattedPrice}<span class="dd-unit"> / ${dailyDeal.unit}</span></p>
                    <c:if test="${dailyDeal.reviewCount > 0}">
                        <span class="dd-rating">⭐ ${dailyDeal.avgRating} (${dailyDeal.reviewCount} đánh giá)</span>
                    </c:if>
                    <span class="dd-cta">Xem ngay →</span>
                </div>
            </a>
            <div class="dd-deco">🔥</div>
        </div>
        </c:if>

        <c:choose>
            <c:when test="${empty products}">
                <p style="color:#888;margin-top:20px;">Không tìm thấy sản phẩm nào.</p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
                        <div class="product-card">
                            <a href="${pageContext.request.contextPath}/product/detail/${p.productId}">
                                <div class="card-img">
                                    <c:set var="imgSrc" value="${p.imageUrl}"/>
                                    <c:if test="${not empty imgSrc and not fn:startsWith(imgSrc,'http')}">
                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imgSrc}"/>
                                    </c:if>
                                    <img src="${imgSrc}" alt="${p.name}"
                                         onerror="this.src='https://placehold.co/160x120/e8f5e9/2e7d32?text=No+Image'">
                                </div>
                            </a>
                            <div class="card-body">
                                <span class="card-category">${p.categoryName}</span>
                                <a href="${pageContext.request.contextPath}/product/detail/${p.productId}">
                                    <p class="card-name">${p.name}</p>
                                </a>
                                <p class="card-price">${p.formattedPrice}
                                    <span class="card-unit">/ ${p.unit}</span>
                                </p>
                                <div class="card-meta">
                                    <c:if test="${p.reviewCount > 0}">
                                        <span class="card-rating">⭐ ${p.avgRating} <span class="card-review-count">(${p.reviewCount})</span></span>
                                    </c:if>
                                    <c:if test="${p.soldCount > 0}">
                                        <span class="card-sold">Đã bán ${p.soldCount}</span>
                                    </c:if>
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form method="post" action="${pageContext.request.contextPath}/cart">
                                        <input type="hidden" name="action"    value="add">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <input type="hidden" name="quantity"  value="1">
                                        <button type="submit" class="btn-add-cart">🛒 Thêm vào giỏ</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/auth/login"
                                       class="btn-add-cart" style="text-align:center;display:block;padding:9px">
                                       🛒 Thêm vào giỏ
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>

                <%-- Pagination --%>
                <c:if test="${totalPages > 1}">
                    <c:set var="baseUrl" value="${pageContext.request.contextPath}/home?"/>
                    <c:if test="${not empty keyword}"><c:set var="baseUrl" value="${baseUrl}keyword=${keyword}&amp;"/></c:if>
                    <c:if test="${not empty categoryId and categoryId > 0}"><c:set var="baseUrl" value="${baseUrl}category=${categoryId}&amp;"/></c:if>
                    <c:if test="${not empty sortBy}"><c:set var="baseUrl" value="${baseUrl}sort=${sortBy}&amp;"/></c:if>
                    <c:if test="${not empty minPrice}"><c:set var="baseUrl" value="${baseUrl}minPrice=${minPrice}&amp;"/></c:if>
                    <c:if test="${not empty maxPrice}"><c:set var="baseUrl" value="${baseUrl}maxPrice=${maxPrice}&amp;"/></c:if>

                    <nav class="pagination" aria-label="Phân trang">
                        <c:choose>
                            <c:when test="${currentPage <= 1}">
                                <span class="page-btn disabled">&#8592; Trước</span>
                            </c:when>
                            <c:otherwise>
                                <a class="page-btn" href="${baseUrl}page=${currentPage - 1}">&#8592; Trước</a>
                            </c:otherwise>
                        </c:choose>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-btn active">${i}</span>
                                </c:when>
                                <c:when test="${i == 1 or i == totalPages or (i >= currentPage - 2 and i <= currentPage + 2)}">
                                    <a class="page-btn" href="${baseUrl}page=${i}">${i}</a>
                                </c:when>
                                <c:when test="${i == currentPage - 3 or i == currentPage + 3}">
                                    <span class="page-btn disabled">…</span>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">
                                <span class="page-btn disabled">Sau &#8594;</span>
                            </c:when>
                            <c:otherwise>
                                <a class="page-btn" href="${baseUrl}page=${currentPage + 1}">Sau &#8594;</a>
                            </c:otherwise>
                        </c:choose>
                    </nav>
                    <p class="page-info">Trang ${currentPage} / ${totalPages} &nbsp;·&nbsp; ${totalItems} sản phẩm</p>
                </c:if>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<%@ include file="footer.jsp" %>

<script>
const ctxPath = '${pageContext.request.contextPath}';

function setPrice(min, max) {
    document.getElementById('minPrice').value = min;
    document.getElementById('maxPrice').value = max;
    document.getElementById('filterForm').submit();
}
function setSort(val) {
    document.getElementById('sortBy').value = val;
    document.getElementById('filterForm').submit();
}

// ── Đồng hồ đếm ngược Deal hôm nay ──────────────────────────────────────────
(function () {
    const hEl = document.getElementById('ddH');
    const mEl = document.getElementById('ddM');
    const sEl = document.getElementById('ddS');
    if (!hEl) return;

    function tick() {
        const now  = new Date();
        const midnight = new Date(now);
        midnight.setHours(24, 0, 0, 0);
        let diff = Math.max(0, Math.floor((midnight - now) / 1000));

        const h = Math.floor(diff / 3600);
        diff -= h * 3600;
        const m = Math.floor(diff / 60);
        const s = diff - m * 60;

        hEl.textContent = String(h).padStart(2, '0');
        mEl.textContent = String(m).padStart(2, '0');
        sEl.textContent = String(s).padStart(2, '0');
    }
    tick();
    setInterval(tick, 1000);
})();
</script>
</body>
</html>
