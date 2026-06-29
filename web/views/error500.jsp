<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>500 – GreenMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div style="text-align:center;padding:100px 20px">
    <p style="font-size:5rem">🚨</p>
    <h1 style="font-size:3rem;color:#c62828">500</h1>
    <p style="font-size:1.2rem;color:#555;margin:16px 0">Lỗi server! Vui lòng thử lại sau.</p>
    <a href="${pageContext.request.contextPath}/home"
       style="display:inline-block;padding:12px 28px;background:#2e7d32;color:#fff;
              border-radius:10px;font-weight:700;text-decoration:none">
       🏠 Về trang chủ
    </a>
</div>
</body>
</html>
