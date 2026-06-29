<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="form-card">
    <h2>🌿 Đăng nhập</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${param.success == '1'}">
        <div class="alert alert-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/auth/login">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" class="form-control"
                   placeholder="email@example.com" required autofocus>
        </div>
        <div class="form-group">
            <label>Mật khẩu</label>
            <input type="password" name="password" class="form-control"
                   placeholder="••••••••" required>
        </div>
        <button type="submit" class="form-submit">Đăng nhập</button>
    </form>
    <p style="text-align:center;margin-top:16px;font-size:.9rem">
        Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/auth/register" style="color:#388e3c;font-weight:600">Đăng ký ngay</a>
    </p>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
