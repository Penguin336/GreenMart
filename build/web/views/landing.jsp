<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>GreenMart – Tạp hóa online tươi ngon mỗi ngày</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="landing-body">

<%@ include file="header.jsp" %>

<!-- ══════════════════════════════════════
     HERO SECTION
══════════════════════════════════════ -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="container hero-inner">
        <div class="hero-text">
            <span class="hero-badge">🌿 Tươi ngon mỗi ngày</span>
            <h1 class="hero-title">
                Siêu thị online<br>
                <span>xanh – sạch – tiện</span>
            </h1>
            <p class="hero-desc">
                Hàng trăm sản phẩm tươi ngon, giao tận nhà trong vòng 2 giờ.
                Cam kết chất lượng, giá cả minh bạch.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/home" class="hero-btn-primary">
                    🛒 Mua sắm ngay
                </a>
                <a href="#features" class="hero-btn-secondary">
                    Tìm hiểu thêm ↓
                </a>
            </div>
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-num">500+</span>
                    <span class="hero-stat-label">Sản phẩm</span>
                </div>
                <div class="hero-stat-divider"></div>
                <div class="hero-stat">
                    <span class="hero-stat-num">10K+</span>
                    <span class="hero-stat-label">Khách hàng</span>
                </div>
                <div class="hero-stat-divider"></div>
                <div class="hero-stat">
                    <span class="hero-stat-num">2h</span>
                    <span class="hero-stat-label">Giao hàng</span>
                </div>
            </div>
        </div>
        <div class="hero-visual">
            <div class="hero-card-float hero-card-1">🥦 Rau củ sạch</div>
            <div class="hero-card-float hero-card-2">🍎 Trái cây tươi</div>
            <div class="hero-card-float hero-card-3">🥛 Sữa & Trứng</div>
            <div class="hero-emoji-big">🛒</div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     FEATURES SECTION
══════════════════════════════════════ -->
<section class="lp-section features-section" id="features">
    <div class="container">
        <div class="section-header">
            <h2>Tại sao chọn GreenMart?</h2>
            <p>Chúng tôi cam kết mang lại trải nghiệm mua sắm tốt nhất</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🚚</div>
                <h3>Giao hàng nhanh</h3>
                <p>Nhận hàng trong 2 giờ với đơn hàng nội thành. Miễn phí vận chuyển cho đơn từ 300.000đ.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">✅</div>
                <h3>Chất lượng đảm bảo</h3>
                <p>100% sản phẩm được kiểm định chất lượng. Đổi trả dễ dàng trong 24h nếu không hài lòng.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💰</div>
                <h3>Giá cả minh bạch</h3>
                <p>Không phụ phí ẩn. Giá niêm yết rõ ràng, thường xuyên có khuyến mãi hấp dẫn.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Thanh toán an toàn</h3>
                <p>Hỗ trợ nhiều hình thức thanh toán. Bảo mật thông tin tuyệt đối.</p>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     CATEGORIES SECTION
══════════════════════════════════════ -->
<section class="lp-section categories-section">
    <div class="container">
        <div class="section-header">
            <h2>Danh mục nổi bật</h2>
            <p>Đa dạng sản phẩm từ rau củ, thịt cá đến hàng gia dụng</p>
        </div>
        <div class="categories-grid">
            <a href="${pageContext.request.contextPath}/home?category=1" class="cat-card">
                <div class="cat-icon">🍬</div>
                <span>Bánh kẹo</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=2" class="cat-card">
                <div class="cat-icon">🍜</div>
                <span>Đồ khô</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=3" class="cat-card">
                <div class="cat-icon">🥤</div>
                <span>Đồ uống</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=4" class="cat-card">
                <div class="cat-icon">🧂</div>
                <span>Gia vị</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=5" class="cat-card">
                <div class="cat-icon">🥦</div>
                <span>Rau củ quả</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=6" class="cat-card">
                <div class="cat-icon">🥛</div>
                <span>Sữa & Trứng</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=7" class="cat-card">
                <div class="cat-icon">🥩</div>
                <span>Thịt & Cá</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=8" class="cat-card">
                <div class="cat-icon">🌾</div>
                <span>Gạo & Ngũ cốc</span>
            </a>
            <a href="${pageContext.request.contextPath}/home?category=9" class="cat-card">
                <div class="cat-icon">🧴</div>
                <span>Gia dụng</span>
            </a>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     PROMO BANNER SECTION
══════════════════════════════════════ -->
<section class="lp-section promo-section">
    <div class="container">
        <div class="promo-grid">
            <div class="promo-card promo-green">
                <div class="promo-content">
                    <span class="promo-tag">Ưu đãi hôm nay</span>
                    <h3>Giảm 20%<br>cho đơn đầu tiên</h3>
                    <p>Áp dụng cho khách hàng mới đăng ký tài khoản</p>
                    <a href="${pageContext.request.contextPath}/auth/register" class="promo-btn">
                        Đăng ký ngay →
                    </a>
                </div>
                <div class="promo-emoji">🎁</div>
            </div>
            <div class="promo-card promo-orange">
                <div class="promo-content">
                    <span class="promo-tag">Miễn phí vận chuyển</span>
                    <h3>Giao hàng 0đ<br>đơn từ 300K</h3>
                    <p>Áp dụng toàn quốc, giao hàng trong ngày</p>
                    <a href="${pageContext.request.contextPath}/home" class="promo-btn promo-btn-dark">
                        Mua sắm ngay →
                    </a>
                </div>
                <div class="promo-emoji">🚚</div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     STEPS / HOW IT WORKS
══════════════════════════════════════ -->
<section class="lp-section steps-section">
    <div class="container">
        <div class="section-header">
            <h2>Đặt hàng chỉ 3 bước</h2>
            <p>Đơn giản, nhanh chóng, tiện lợi</p>
        </div>
        <div class="steps-grid">
            <div class="step-card">
                <div class="step-num">1</div>
                <div class="step-icon">🔍</div>
                <h3>Chọn sản phẩm</h3>
                <p>Duyệt qua hàng trăm sản phẩm, thêm vào giỏ hàng dễ dàng</p>
            </div>
            <div class="step-arrow">→</div>
            <div class="step-card">
                <div class="step-num">2</div>
                <div class="step-icon">📋</div>
                <h3>Đặt hàng</h3>
                <p>Điền thông tin giao hàng, xác nhận đơn hàng chỉ trong vài giây</p>
            </div>
            <div class="step-arrow">→</div>
            <div class="step-card">
                <div class="step-num">3</div>
                <div class="step-icon">📦</div>
                <h3>Nhận hàng</h3>
                <p>Hàng được giao tận tay trong vòng 2 giờ, tươi ngon đảm bảo</p>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     TESTIMONIALS
══════════════════════════════════════ -->
<section class="lp-section testimonials-section">
    <div class="container">
        <div class="section-header">
            <h2>Khách hàng nói gì?</h2>
            <p>Hàng nghìn khách hàng đã tin tưởng GreenMart</p>
        </div>
        <div class="testimonials-grid">
            <div class="testimonial-card">
                <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                <p>"Rau củ tươi hơn so với đi chợ, giao hàng nhanh, đóng gói cẩn thận. Mình đặt hàng tuần nào cũng mua ở đây!"</p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar">A</div>
                    <div>
                        <strong>Nguyễn Thị Anh</strong>
                        <span>Hà Nội</span>
                    </div>
                </div>
            </div>
            <div class="testimonial-card">
                <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                <p>"Giá cả hợp lý, nhiều sản phẩm để lựa chọn. Đặc biệt thịt cá rất tươi, không có mùi. Rất hài lòng!"</p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar">B</div>
                    <div>
                        <strong>Trần Văn Bình</strong>
                        <span>TP. Hồ Chí Minh</span>
                    </div>
                </div>
            </div>
            <div class="testimonial-card">
                <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                <p>"Ứng dụng dễ dùng, thanh toán tiện lợi. Giao hàng đúng hẹn, shipper thân thiện. 10 điểm không có gì chê!"</p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar">C</div>
                    <div>
                        <strong>Lê Thị Cẩm</strong>
                        <span>Đà Nẵng</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     CTA SECTION
══════════════════════════════════════ -->
<section class="cta-section">
    <div class="container cta-inner">
        <div class="cta-text">
            <h2>Sẵn sàng mua sắm chưa?</h2>
            <p>Đăng ký ngay hôm nay và nhận ưu đãi 20% cho đơn hàng đầu tiên</p>
        </div>
        <div class="cta-actions">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/auth/register" class="cta-btn-primary">
                        Đăng ký miễn phí
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="cta-btn-secondary">
                        Xem sản phẩm
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/home" class="cta-btn-primary">
                        🛒 Vào mua sắm ngay
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script>
    // Smooth scroll cho anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) target.scrollIntoView({ behavior: 'smooth' });
        });
    });

    // Animate on scroll (hiệu ứng fade-in khi scroll đến)
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('lp-visible');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.feature-card, .cat-card, .step-card, .testimonial-card, .promo-card')
        .forEach(el => observer.observe(el));
</script>
</body>
</html>
