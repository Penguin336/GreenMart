<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang cá nhân – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container" style="padding: 32px 16px;">
    <div class="profile-layout">

        <!-- ── SIDEBAR CÁ NHÂN ── -->
        <aside class="profile-sidebar">
            <div class="profile-avatar">
                <span class="avatar-icon">👤</span>
                <div>
                    <p class="avatar-name">${profile.fullName}</p>
                    <p class="avatar-email">${profile.email}</p>
                    <span class="status-badge status-delivered" style="margin-top:4px;display:inline-block">
                        ${profile.role eq 'admin' ? '⭐ Admin' : '🛒 Khách hàng'}
                    </span>
                </div>
            </div>
            <nav class="profile-nav">
                <a href="#info"     class="profile-nav-link active" onclick="switchTab('info',this)">📋 Thông tin cá nhân</a>
                <a href="#password" class="profile-nav-link"        onclick="switchTab('password',this)">🔑 Đổi mật khẩu</a>
                <a href="${pageContext.request.contextPath}/order/history" class="profile-nav-link">📦 Lịch sử đơn hàng</a>
                <a href="${pageContext.request.contextPath}/auth/logout"   class="profile-nav-link logout-link">🚪 Đăng xuất</a>
            </nav>
        </aside>

        <!-- ── NỘI DUNG CHÍNH ── -->
        <div class="profile-content">

            <!-- Alert -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">✅ ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">⚠️ ${error}</div>
            </c:if>

            <!-- TAB: THÔNG TIN CÁ NHÂN -->
            <div id="tab-info" class="profile-tab">
                <div class="profile-card">
                    <h3 class="profile-card-title">📋 Thông tin cá nhân</h3>
                    <form method="post" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="updateInfo">

                        <div class="form-group">
                            <label>Họ và tên <span style="color:red">*</span></label>
                            <input type="text" name="fullName" class="form-control"
                                   value="${profile.fullName}" required maxlength="150">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" class="form-control" value="${profile.email}"
                                   disabled style="background:#f5f5f5;color:#888;cursor:not-allowed">
                            <small style="color:#999;font-size:.78rem">Email không thể thay đổi</small>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="tel" name="phone" class="form-control"
                                   value="${profile.phone}" maxlength="20"
                                   placeholder="Nhập số điện thoại">
                        </div>
                        <div class="form-group">
                            <label>Địa chỉ giao hàng</label>
                            <textarea name="address" class="form-control" rows="3"
                                      placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành"
                                      maxlength="300">${profile.address}</textarea>
                        </div>
                        <div class="form-group" style="color:#999;font-size:.82rem">
                            <p>📅 Tham gia từ:
                                <fmt:formatDate value="${profile.createdAt}" pattern="dd/MM/yyyy"/>
                            </p>
                        </div>
                        <button type="submit" class="form-submit">💾 Lưu thay đổi</button>
                    </form>
                </div>
            </div>

            <!-- TAB: ĐỔI MẬT KHẨU -->
            <div id="tab-password" class="profile-tab" style="display:none">
                <div class="profile-card">
                    <h3 class="profile-card-title">🔑 Đổi mật khẩu</h3>
                    <form method="post" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-group">
                            <label>Mật khẩu hiện tại <span style="color:red">*</span></label>
                            <input type="password" name="oldPassword" class="form-control"
                                   required placeholder="Nhập mật khẩu hiện tại">
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu mới <span style="color:red">*</span></label>
                            <input type="password" name="newPassword" class="form-control"
                                   required minlength="6" placeholder="Ít nhất 6 ký tự">
                        </div>
                        <div class="form-group">
                            <label>Xác nhận mật khẩu mới <span style="color:red">*</span></label>
                            <input type="password" name="confirmPassword" class="form-control"
                                   required minlength="6" placeholder="Nhập lại mật khẩu mới">
                        </div>
                        <button type="submit" class="form-submit">🔒 Đổi mật khẩu</button>
                    </form>
                </div>
            </div>

        </div><!-- /profile-content -->
    </div><!-- /profile-layout -->
</div>

<%@ include file="footer.jsp" %>

<script>
    function switchTab(tab, el) {
        // Ẩn tất cả tab
        document.querySelectorAll('.profile-tab').forEach(t => t.style.display = 'none');
        // Bỏ active tất cả nav link
        document.querySelectorAll('.profile-nav-link').forEach(a => a.classList.remove('active'));
        // Hiện tab được chọn
        document.getElementById('tab-' + tab).style.display = 'block';
        el.classList.add('active');
    }

    // Nếu có lỗi đổi password thì tự mở tab password
    <c:if test="${not empty error and param.action eq 'changePassword'}">
        switchTab('password', document.querySelector('[onclick*="password"]'));
    </c:if>
</script>
</body>
</html>
