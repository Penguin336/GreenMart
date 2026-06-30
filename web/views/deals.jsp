<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Săn Deal Cùng GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=4">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container page-layout">

    <!-- SIDEBAR DANH MỤC -->
    <aside class="sidebar">
        <h3>📋 Danh mục</h3>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/home" class="active">
                   🛒 Khám phá tất cả
                </a>
            </li>
            <c:forEach var="cat" items="${categories}">
                <li>
                    <a href="${pageContext.request.contextPath}/home?category=${cat.categoryId}">
                       ${cat.icon} ${cat.name}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </aside>

    <main class="products-area">
        
        <!-- HEADER DEALS -->
        <div class="deals-header" style="background: linear-gradient(120deg, #bf360c 0%, #e64a19 40%, #ff7043 100%); border-radius: 16px; padding: 30px; margin-bottom: 30px; color: white; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 20px rgba(230,74,25,.3);">
            <div>
                <h1 style="margin: 0; font-size: 2.2rem; font-weight: 900; letter-spacing: 1px;">🔥 ĐẠI TIỆC SALE HÔM NAY</h1>
                <p style="margin: 8px 0 0; opacity: .9; font-size: 1.1rem;">Nhanh tay chốt đơn kẻo lỡ! Giá giảm sâu nhất tuần.</p>
            </div>
            <div class="dd-countdown" style="background: rgba(0,0,0,.2); padding: 15px 25px; border-radius: 12px;">
                <div style="font-size: .8rem; font-weight: bold; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px;">Kết thúc sau</div>
                <div style="display: flex; gap: 8px; align-items: center;">
                    <div class="dd-time-block"><span id="ddH">00</span><small>Giờ</small></div>
                    <div class="dd-sep">:</div>
                    <div class="dd-time-block"><span id="ddM">00</span><small>Phút</small></div>
                    <div class="dd-sep">:</div>
                    <div class="dd-time-block"><span id="ddS">00</span><small>Giây</small></div>
                </div>
            </div>
        </div>

        <h2 class="section-title">⚡ Danh sách Deal Hot</h2>

        <c:choose>
            <c:when test="${empty dailyDeals}">
                <p style="color:#888;margin-top:20px;">Hôm nay chưa có deal nào. Hãy quay lại sau nhé!</p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${dailyDeals}">
                        <div class="product-card" style="border: 2px solid #ffccbc;">
                            <div style="position:absolute; top: 10px; right: 10px; background: #e64a19; color: white; font-weight: bold; font-size: 0.8rem; padding: 4px 10px; border-radius: 20px; z-index: 2; box-shadow: 0 2px 8px rgba(230,74,25,.4);">Giảm Sốc</div>
                            <a href="${pageContext.request.contextPath}/product/detail/${p.productId}">
                                <div class="card-img">
                                    <c:set var="imgSrc" value="${p.imageUrl}"/>
                                    <c:if test="${not empty imgSrc and not fn:startsWith(imgSrc,'http')}">
                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imgSrc}"/>
                                    </c:if>
                                    <img src="${imgSrc}" alt="${p.name}"
                                         onerror="this.src='https://placehold.co/160x120/ffccbc/e64a19?text=Deal'">
                                </div>
                            </a>
                            <div class="card-body">
                                <span class="card-category">${p.categoryName}</span>
                                <a href="${pageContext.request.contextPath}/product/detail/${p.productId}">
                                    <p class="card-name">${p.name}</p>
                                </a>
                                <p class="card-price" style="color: #d84315;">${p.formattedPrice}
                                    <span class="card-unit" style="color: #888;">/ ${p.unit}</span>
                                </p>
                                <div class="card-meta">
                                    <c:if test="${p.reviewCount > 0}">
                                        <span class="card-rating">⭐ ${p.avgRating} <span class="card-review-count">(${p.reviewCount})</span></span>
                                    </c:if>
                                    <c:if test="${p.soldCount > 0}">
                                        <span class="card-sold">Đã bán ${p.soldCount}</span>
                                    </c:if>
                                </div>
                                <a href="${pageContext.request.contextPath}/product/detail/${p.productId}" class="btn" style="width: 100%; margin-top: 15px; display: block; text-align: center; background: #e64a19; color: white;">🛒 Mua Ngay</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>

<!-- SCRIPTS CHUNG -->
<script>
    // Countdown logic cho Deals page
    (function () {
        const hEl = document.getElementById('ddH');
        const mEl = document.getElementById('ddM');
        const sEl = document.getElementById('ddS');
        if (!hEl) return;

        function updateTimer() {
            const now = new Date();
            const tomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
            const diff = tomorrow - now;
            if (diff <= 0) {
                hEl.textContent = '00'; mEl.textContent = '00'; sEl.textContent = '00';
                return;
            }
            const h = Math.floor(diff / (1000 * 60 * 60));
            const m = Math.floor((diff / (1000 * 60)) % 60);
            const s = Math.floor((diff / 1000) % 60);

            hEl.textContent = h.toString().padStart(2, '0');
            mEl.textContent = m.toString().padStart(2, '0');
            sEl.textContent = s.toString().padStart(2, '0');
        }
        setInterval(updateTimer, 1000);
        updateTimer();
    })();
</script>

</body>
</html>
