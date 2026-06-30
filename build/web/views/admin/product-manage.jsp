<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sản phẩm – GreenMart Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link">
                <span class="nav-icon">📦</span><span>Đơn hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/product/admin/list" class="admin-nav-link active">
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
            <div class="admin-topbar-title">🛍 Quản lý sản phẩm</div>
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
                <span>›</span> Sản phẩm
            </div>

            <div class="admin-card">
                <div class="admin-card-header">
                    <div class="admin-card-title">📋 Danh sách sản phẩm</div>
                    <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap">
                        <form method="get" action="${pageContext.request.contextPath}/product/admin/list"
                              style="display:flex;gap:8px;align-items:center">
                            <input type="text" name="keyword" id="searchInput"
                                   class="admin-search-input"
                                   placeholder="🔍 Tìm sản phẩm..."
                                   value="${not empty keyword ? keyword : ''}">
                            <button type="submit" class="btn btn-secondary"
                                    style="padding:7px 14px;font-size:.85rem">Tìm</button>
                            <c:if test="${not empty keyword}">
                                <a href="${pageContext.request.contextPath}/product/admin/list"
                                   class="btn btn-secondary"
                                   style="padding:7px 14px;font-size:.85rem">✕ Xóa lọc</a>
                            </c:if>
                        </form>
                        <button class="btn btn-primary" onclick="openAddModal()">
                            + Thêm sản phẩm
                        </button>
                    </div>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Deal 🔥</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="productTable">
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <c:set var="imgSrc" value="${p.imageUrl}"/>
                                    <c:if test="${not empty imgSrc and not fn:startsWith(imgSrc,'http')}">
                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imgSrc}"/>
                                    </c:if>
                                    <img src="${imgSrc}" alt="${p.name}"
                                         style="width:48px;height:48px;object-fit:contain;
                                                border-radius:8px;background:#f1f8e9"
                                         onerror="this.src='https://placehold.co/48x48/e8f5e9/2e7d32?text=...'">
                                </td>
                                <td>
                                    <span style="font-weight:600">${p.name}</span>
                                    <div style="font-size:.75rem;color:var(--text-muted);margin-top:2px">
                                        ${p.description}
                                    </div>
                                </td>
                                <td>
                                    <span style="background:#f0f7f0;color:var(--green-dark);
                                                 border-radius:6px;padding:2px 9px;font-size:.78rem;font-weight:600">
                                        ${p.categoryName}
                                    </span>
                                </td>
                                <td style="font-weight:700;color:var(--price)">
                                    ${p.formattedPrice}
                                    <span style="font-size:.75rem;color:var(--text-muted);font-weight:400">
                                        /${p.unit}
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight:700;
                                        color:${p.stock > 10 ? '#2e7d32' : p.stock > 0 ? '#f57f17' : '#c62828'}">
                                        ${p.stock}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.dailyDeal}">
                                            <%-- Đang là deal: nút bỏ chọn --%>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/product/admin/list"
                                                  style="display:inline">
                                                <input type="hidden" name="action"    value="clearDeal">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" title="Đang là deal hôm nay. Bấm để bỏ."
                                                        style="border:none;background:none;cursor:pointer;font-size:1.3rem">🔥</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Chưa là deal: nút đặt làm deal --%>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/product/admin/list"
                                                  style="display:inline">
                                                <input type="hidden" name="action"    value="setDeal">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" title="Đặt làm Deal hôm nay"
                                                        style="border:none;background:none;cursor:pointer;font-size:1.3rem;opacity:.25">🔥</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="display:flex;gap:6px">
                                        <button class="btn btn-secondary"
                                                style="padding:5px 12px;font-size:.8rem"
                                                onclick="openEditModal(${p.productId},'${p.name.replace("'","\\'")}',
                                                         ${p.categoryId},'${p.description}',${p.price},
                                                         '${p.unit}','${p.imageUrl}',${p.stock})">
                                            ✏️ Sửa
                                        </button>
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/product/admin/list"
                                              style="display:inline">
                                            <input type="hidden" name="action"      value="delete">
                                            <input type="hidden" name="productId"   value="${p.productId}">
                                            <input type="hidden" name="currentPage" value="${currentPage}">
                                            <input type="hidden" name="keyword"     value="${keyword}">
                                            <button type="submit" class="btn btn-danger"
                                                    style="padding:5px 12px;font-size:.8rem"
                                                    onclick="return confirm('Xóa sản phẩm này?')">
                                                🗑 Xóa
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty products}">
                            <tr><td colspan="6" style="text-align:center;color:var(--text-muted);padding:40px">
                                Chưa có sản phẩm nào
                            </td></tr>
                        </c:if>
                    </tbody>
                </table>

                <%-- Pagination admin sản phẩm --%>
                <c:if test="${totalPages > 1}">
                    <c:set var="baseUrl" value="${pageContext.request.contextPath}/product/admin/list?"/>
                    <c:if test="${not empty keyword}"><c:set var="baseUrl" value="${baseUrl}keyword=${keyword}&amp;"/></c:if>
                    <div class="admin-pagination">
                        <span class="page-info">
                            Trang ${currentPage} / ${totalPages} &nbsp;·&nbsp; ${totalItems} sản phẩm
                        </span>
                        <nav class="pagination" style="margin-top:0">
                            <c:choose>
                                <c:when test="${currentPage <= 1}">
                                    <span class="page-btn disabled">&#8592;</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-btn" href="${baseUrl}page=${currentPage - 1}">&#8592;</a>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 or i == totalPages
                                                 or (i >= currentPage - 2 and i <= currentPage + 2)}">
                                        <a class="page-btn" href="${baseUrl}page=${i}">${i}</a>
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
                                    <a class="page-btn" href="${baseUrl}page=${currentPage + 1}">&#8594;</a>
                                </c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- ── MODAL THÊM / SỬA ── -->
<div class="admin-modal-overlay" id="productModal">
    <div class="admin-modal">
        <div class="admin-modal-header">
            <h3 id="modalTitle">➕ Thêm sản phẩm mới</h3>
            <button class="admin-modal-close" onclick="closeModal()">✕</button>
        </div>
        <div class="admin-modal-body">
            <form method="post" action="${pageContext.request.contextPath}/product/admin/list"
                  id="productForm" enctype="multipart/form-data">
                <input type="hidden" name="action"          id="formAction"       value="add">
                <input type="hidden" name="productId"       id="formProductId"    value="">
                <input type="hidden" name="imageUrlCurrent" id="formImageCurrent" value="">
                <input type="hidden" name="currentPage"     id="formCurrentPage"  value="${currentPage}">
                <input type="hidden" name="keyword"         id="formKeyword"      value="${keyword}">

                <div class="form-group">
                    <label>Tên sản phẩm *</label>
                    <input type="text" name="name" id="formName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Danh mục *</label>
                    <select name="categoryId" id="formCategory" class="form-control" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}">${cat.icon} ${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
                    <div class="form-group">
                        <label>Giá (đồng) *</label>
                        <input type="number" name="price" id="formPrice"
                               class="form-control" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn vị *</label>
                        <input type="text" name="unit" id="formUnit"
                               class="form-control" placeholder="kg / gói / hộp..." required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Tồn kho</label>
                    <input type="number" name="stock" id="formStock"
                           class="form-control" min="0" value="0">
                </div>

                <div class="form-group">
                    <label>Ảnh sản phẩm</label>
                    <%-- Preview ảnh hiện tại --%>
                    <div id="imgPreviewWrap" style="margin-bottom:8px;display:none">
                        <img id="imgPreview" src="" alt="preview"
                             style="max-height:110px;max-width:100%;border-radius:8px;
                                    border:1.5px solid #dce8dc;object-fit:contain;
                                    background:#f1f8e9;padding:4px">
                    </div>
                    <input type="file" name="imageFile" id="formImageFile"
                           class="form-control" accept="image/*"
                           style="padding:6px"
                           onchange="previewImage(this)">
                    <div style="font-size:.75rem;color:var(--text-muted);margin-top:4px">
                        Chọn ảnh từ máy (JPG/PNG/WEBP, tối đa 5 MB).
                        Nếu không chọn ảnh mới, ảnh cũ sẽ được giữ nguyên.
                    </div>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" id="formDesc"
                              class="form-control" rows="3"
                              style="resize:vertical"></textarea>
                </div>

                <div class="admin-modal-footer" style="padding:0;margin-top:16px">
                    <button type="submit" class="btn btn-primary" style="flex:1">
                        💾 Lưu sản phẩm
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
const contextPath = '${pageContext.request.contextPath}';

function previewImage(input) {
    const wrap = document.getElementById('imgPreviewWrap');
    const img  = document.getElementById('imgPreview');
    if (input.files && input.files[0]) {
        img.src = URL.createObjectURL(input.files[0]);
        wrap.style.display = 'block';
    }
}

function openAddModal() {
    document.getElementById('modalTitle').textContent        = '➕ Thêm sản phẩm mới';
    document.getElementById('formAction').value              = 'add';
    document.getElementById('formProductId').value           = '';
    document.getElementById('formImageCurrent').value        = '';
    document.getElementById('imgPreviewWrap').style.display  = 'none';
    document.getElementById('imgPreview').src                = '';
    document.getElementById('productForm').reset();
    document.getElementById('productModal').classList.add('open');
}

function openEditModal(id, name, catId, desc, price, unit, img, stock) {
    document.getElementById('modalTitle').textContent = '✏️ Sửa sản phẩm';
    document.getElementById('formAction').value       = 'edit';
    document.getElementById('formProductId').value    = id;
    document.getElementById('formImageCurrent').value = img;
    document.getElementById('formName').value         = name;
    document.getElementById('formCategory').value     = catId;
    document.getElementById('formDesc').value         = desc;
    document.getElementById('formPrice').value        = price;
    document.getElementById('formUnit').value         = unit;
    document.getElementById('formStock').value        = stock;
    // Reset file input và hiện ảnh cũ
    document.getElementById('formImageFile').value    = '';
    const wrap = document.getElementById('imgPreviewWrap');
    const prev = document.getElementById('imgPreview');
    if (img) {
        prev.src = img.startsWith('http') ? img : (contextPath + '/' + img);
        wrap.style.display = 'block';
    } else {
        wrap.style.display = 'none';
    }
    document.getElementById('productModal').classList.add('open');
}

function closeModal() {
    document.getElementById('productModal').classList.remove('open');
}

document.getElementById('productModal').addEventListener('click', function (e) {
    if (e.target === this) closeModal();
});
</script>
</body>
</html>
