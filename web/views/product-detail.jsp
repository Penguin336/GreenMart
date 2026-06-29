<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.name} – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container">
    <!-- Breadcrumb -->
    <p style="padding:16px 0;font-size:.88rem;color:#888">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a> ›
        <a href="${pageContext.request.contextPath}/home?category=${product.categoryId}">${product.categoryName}</a> ›
        ${product.name}
    </p>

    <!-- ── THÔNG TIN SẢN PHẨM ── -->
    <div class="detail-wrap">
        <div class="detail-img">
            <c:set var="imgSrc" value="${product.imageUrl}"/>
            <c:if test="${not empty imgSrc and not fn:startsWith(imgSrc,'http')}">
                <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imgSrc}"/>
            </c:if>
            <img src="${imgSrc}" alt="${product.name}"
                 onerror="this.src='https://placehold.co/260x260/e8f5e9/2e7d32?text=No+Image'">
        </div>
        <div class="detail-info">
            <p class="detail-cat">${product.categoryName}</p>
            <h1>${product.name}</h1>

            <!-- Rating tóm tắt -->
            <div class="detail-rating-row">
                <c:choose>
                    <c:when test="${product.reviewCount > 0}">
                        <span class="detail-stars">
                            <c:forEach begin="1" end="5" var="s">
                                <c:choose>
                                    <c:when test="${s <= product.avgRating}">⭐</c:when>
                                    <c:otherwise><span style="opacity:.3">⭐</span></c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <span class="detail-avg">${product.avgRating}</span>
                        <span class="detail-review-cnt">(${product.reviewCount} đánh giá)</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color:#aaa;font-size:.88rem">Chưa có đánh giá</span>
                    </c:otherwise>
                </c:choose>
                <c:if test="${product.soldCount > 0}">
                    <span class="detail-sold">· Đã bán <strong>${product.soldCount}</strong></span>
                </c:if>
            </div>

            <div class="detail-price">${product.formattedPrice}</div>
            <div class="detail-unit">/ ${product.unit}</div>
            <p class="detail-stock">
                <c:choose>
                    <c:when test="${product.stock > 0}">✅ Còn hàng (${product.stock} ${product.unit})</c:when>
                    <c:otherwise>❌ Hết hàng</c:otherwise>
                </c:choose>
            </p>
            <p class="detail-desc">${product.description}</p>

            <c:choose>
                <c:when test="${not empty sessionScope.user and product.stock > 0}">
                    <form method="post" action="${pageContext.request.contextPath}/cart">
                        <input type="hidden" name="action"    value="add">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <div class="qty-row">
                            <label style="font-weight:600">Số lượng:</label>
                            <input type="number" name="quantity" value="1" min="1" max="${product.stock}">
                        </div>
                        <button type="submit" class="btn-big">🛒 Thêm vào giỏ hàng</button>
                    </form>
                </c:when>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn-big"
                       style="display:inline-block;text-align:center">
                       🔑 Đăng nhập để mua hàng
                    </a>
                </c:when>
                <c:otherwise>
                    <button class="btn-big" disabled style="background:#ccc;cursor:not-allowed">Hết hàng</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ── SECTION ĐÁNH GIÁ ── -->
    <section class="review-section" id="reviews">
        <h2 class="review-section-title">⭐ Đánh giá sản phẩm</h2>

        <!-- Form gửi đánh giá -->
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <div class="review-login-prompt">
                    <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a> để gửi đánh giá.
                </div>
            </c:when>
            <c:when test="${hasReviewed}">
                <div class="review-already">✅ Bạn đã đánh giá sản phẩm này.</div>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/product/detail/${product.productId}"
                      class="review-form">
                    <input type="hidden" name="action"    value="review">
                    <input type="hidden" name="productId" value="${product.productId}">

                    <div class="review-form-label">Chọn số sao:</div>
                    <div class="star-picker" id="starPicker">
                        <c:forEach begin="1" end="5" var="s">
                            <span class="star-pick" data-val="${s}">☆</span>
                        </c:forEach>
                    </div>
                    <input type="hidden" name="stars" id="starsInput" value="5">

                    <textarea name="comment" class="review-textarea" rows="3"
                              placeholder="Nhận xét của bạn về sản phẩm này..."></textarea>
                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                </form>
            </c:otherwise>
        </c:choose>

        <!-- Danh sách đánh giá -->
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="review-empty">Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
            </c:when>
            <c:otherwise>
                <div class="review-list">
                    <c:forEach var="rv" items="${reviews}">
                        <div class="review-card">
                            <div class="review-header">
                                <div class="review-avatar">${fn:substring(rv.userFullName,0,1)}</div>
                                <div>
                                    <div class="review-user">${rv.userFullName}</div>
                                    <div class="review-date">
                                        <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <div class="review-stars-display">${rv.starDisplay}</div>
                            </div>
                            <c:if test="${not empty rv.comment}">
                                <p class="review-comment">${rv.comment}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<%@ include file="footer.jsp" %>

<style>
    .detail-wrap { display:flex; gap:36px; background:#fff; border-radius:12px;
                   box-shadow:0 2px 10px rgba(0,0,0,.09); padding:32px; max-width:900px;
                   margin:0 auto 32px; flex-wrap:wrap; }
    .detail-img  { width:280px; height:280px; display:flex; align-items:center;
                   justify-content:center; background:var(--green-pale); border-radius:10px; flex-shrink:0; }
    .detail-img img { max-height:260px; object-fit:contain; }
    .detail-info { flex:1; min-width:240px; }
    .detail-info h1 { font-size:1.5rem; color:var(--text-main); margin-bottom:8px; }
    .detail-cat  { font-size:.82rem; color:var(--text-muted); margin-bottom:10px; }
    .detail-price{ font-size:2rem; font-weight:800; color:var(--price); margin-bottom:4px; }
    .detail-unit { font-size:.9rem; color:var(--text-muted); margin-bottom:16px; }
    .detail-desc { font-size:.92rem; color:#555; line-height:1.7; margin-bottom:20px; }
    .detail-stock{ font-size:.88rem; color:#388e3c; margin-bottom:16px; }
    .qty-row     { display:flex; align-items:center; gap:12px; margin-bottom:20px; }
    .qty-row input{ width:70px; padding:8px; border:1.5px solid #ccc; border-radius:8px;
                    text-align:center; font-size:1rem; }
    .btn-big     { padding:12px 32px; font-size:1rem; border-radius:10px;
                   background:var(--green-mid); color:#fff; border:none; cursor:pointer;
                   font-weight:700; transition:background .2s; }
    .btn-big:hover { background:var(--green-dark); }

    .detail-rating-row { display:flex; align-items:center; gap:10px; margin-bottom:14px; flex-wrap:wrap; }
    .detail-avg        { font-weight:700; color:#f57f17; font-size:1.05rem; }
    .detail-review-cnt { font-size:.83rem; color:var(--text-muted); }
    .detail-sold       { font-size:.84rem; color:var(--text-muted); }
</style>

<script>
// ── Star picker ──────────────────────────────────────────────────────────────
(function() {
    const picker = document.getElementById('starPicker');
    if (!picker) return;
    const stars  = picker.querySelectorAll('.star-pick');
    let selected = 5;

    function paint(n) {
        stars.forEach((s, i) => { s.textContent = i < n ? '⭐' : '☆'; });
    }
    paint(selected);

    stars.forEach((s, i) => {
        s.addEventListener('mouseover', () => paint(i + 1));
        s.addEventListener('mouseout',  () => paint(selected));
        s.addEventListener('click', () => {
            selected = i + 1;
            document.getElementById('starsInput').value = selected;
            paint(selected);
        });
    });
})();
</script>
</body>
</html>
