<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="form-card" style="max-width:500px">
    <h2>🌿 Đăng ký tài khoản</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/auth/register">
        <div class="form-group">
            <label>Họ và tên</label>
            <input type="text" name="fullName" class="form-control"
                   placeholder="Nguyễn Văn A" required autofocus>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" class="form-control"
                   placeholder="email@example.com" required>
        </div>
        <div class="form-group">
            <label>Mật khẩu</label>
            <input type="password" name="password" id="pw" class="form-control"
                   placeholder="Tối thiểu 6 ký tự" minlength="6" required>
        </div>
        <div class="form-group">
            <label>Xác nhận mật khẩu</label>
            <input type="password" id="pw2" class="form-control"
                   placeholder="Nhập lại mật khẩu" required>
            <small id="pwErr" style="color:#c62828;display:none">Mật khẩu không khớp!</small>
        </div>
        <div class="form-group">
            <label>Số điện thoại</label>
            <input type="tel" name="phone" class="form-control" placeholder="09xxxxxxxx">
        </div>
        <button type="submit" class="form-submit">Đăng ký</button>
    </form>
    <p style="text-align:center;margin-top:16px;font-size:.9rem">
        Đã có tài khoản?
        <a href="${pageContext.request.contextPath}/auth/login" style="color:#388e3c;font-weight:600">Đăng nhập</a>
    </p>
</div>

<%@ include file="footer.jsp" %>

<script>
    document.querySelector('form').addEventListener('submit', function(e) {
        const pw  = document.getElementById('pw').value;
        const pw2 = document.getElementById('pw2').value;
        if (pw !== pw2) {
            e.preventDefault();
            document.getElementById('pwErr').style.display = 'block';
        }
    });
</script>
</body>
</html>
