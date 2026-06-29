-- ============================================
--  GreenMart Database Script (SQL Server)
--  Tạo database, bảng, dữ liệu mẫu
-- ============================================

CREATE DATABASE GreenMart;
GO

USE GreenMart;
GO

-- =====================
-- BẢNG DANH MỤC
-- =====================
CREATE TABLE Category (
    category_id   INT IDENTITY(1,1) PRIMARY KEY,
    name          NVARCHAR(100)  NOT NULL,
    icon          NVARCHAR(50)   DEFAULT '🛒',
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE()
);

-- =====================
-- BẢNG SẢN PHẨM
-- =====================
CREATE TABLE Product (
    product_id    INT IDENTITY(1,1) PRIMARY KEY,
    category_id   INT            NOT NULL REFERENCES Category(category_id),
    name          NVARCHAR(200)  NOT NULL,
    description   NVARCHAR(MAX),
    price         DECIMAL(12,0)  NOT NULL,
    unit          NVARCHAR(30)   DEFAULT N'cái',
    image_url     NVARCHAR(500),
    stock         INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE()
);

-- =====================
-- BẢNG NGƯỜI DÙNG
-- =====================
CREATE TABLE Users (
    user_id       INT IDENTITY(1,1) PRIMARY KEY,
    full_name     NVARCHAR(150)  NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    password      VARCHAR(255)   NOT NULL,   -- SHA-256 hashed
    phone         VARCHAR(20),
    address       NVARCHAR(300),
    role          VARCHAR(10)    DEFAULT 'customer' CHECK(role IN ('customer','admin')),
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE()
);

-- =====================
-- BẢNG ĐƠN HÀNG
-- =====================
CREATE TABLE Orders (
    order_id        INT IDENTITY(1,1) PRIMARY KEY,
    user_id         INT            NOT NULL REFERENCES Users(user_id),
    full_name       NVARCHAR(150)  NOT NULL,
    phone           VARCHAR(20)    NOT NULL,
    address         NVARCHAR(300)  NOT NULL,
    total_amount    DECIMAL(14,0)  NOT NULL,
    status          VARCHAR(20)    DEFAULT 'pending'
                    CHECK(status IN ('pending','confirmed','shipping','delivered','cancelled')),
    note            NVARCHAR(500),
    created_at      DATETIME       DEFAULT GETDATE()
);

-- =====================
-- BẢNG CHI TIẾT ĐƠN HÀNG
-- =====================
CREATE TABLE OrderDetail (
    detail_id     INT IDENTITY(1,1) PRIMARY KEY,
    order_id      INT            NOT NULL REFERENCES Orders(order_id),
    product_id    INT            NOT NULL REFERENCES Product(product_id),
    quantity      INT            NOT NULL,
    unit_price    DECIMAL(12,0)  NOT NULL
);

-- =====================
-- BẢNG GIỎ HÀNG
-- =====================
CREATE TABLE Cart (
    cart_id       INT IDENTITY(1,1) PRIMARY KEY,
    user_id       INT            NOT NULL REFERENCES Users(user_id),
    product_id    INT            NOT NULL REFERENCES Product(product_id),
    quantity      INT            NOT NULL DEFAULT 1,
    UNIQUE(user_id, product_id)
);

-- ============================================
-- DỮ LIỆU MẪU
-- ============================================

-- Danh mục
INSERT INTO Category (name, icon) VALUES
(N'Bánh kẹo',           N'🍫'),
(N'Đồ khô',             N'🍜'),
(N'Đồ uống',            N'🥤'),
(N'Gia vị',             N'🧂'),
(N'Rau củ quả',         N'🥦'),
(N'Sữa - Trứng',        N'🥛'),
(N'Thịt - Cá',          N'🥩'),
(N'Gạo & Ngũ cốc',      N'🌾'),
(N'Sản phẩm gia dụng',  N'🧴');

-- Sản phẩm
INSERT INTO Product (category_id, name, description, price, unit, image_url, stock) VALUES
-- Bánh kẹo
(1, N'Bánh quy Oreo',       N'Bánh quy Oreo kem vani hộp 137g', 25000,  N'hộp', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=Oreo',       100),
-- Đồ khô
(2, N'Mì Hảo Hảo',          N'Mì tôm chua cay Hảo Hảo 75g',    5000,   N'gói', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=HaoHao',    500),
(2, N'Bột giặt',             N'Bột giặt OMO 800g',               17000,  N'gói', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=BotGiat',   200),
-- Đồ uống
(3, N'Coca-Cola',            N'Coca-Cola lon 330ml',              17000,  N'lon', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=Coca',      300),
-- Gia vị
(4, N'Nước mắm Nam Ngư',    N'Nước mắm Nam Ngư 500ml',           32000,  N'chai','https://placehold.co/200x200/e8f5e9/2e7d32?text=NuocMam',  150),
-- Rau củ quả
(5, N'Cà chua Đà Lạt',      N'Cà chua tươi Đà Lạt 1kg',         15000,  N'kg',  'https://placehold.co/200x200/e8f5e9/2e7d32?text=CaChua',   100),
(5, N'Dầu ăn',               N'Dầu ăn Neptune 1 lít',             32000,  N'chai','https://placehold.co/200x200/e8f5e9/2e7d32?text=DauAn',    80),
(5, N'Hành tỏi',             N'Hành tỏi tươi 500g',               15000,  N'kg',  'https://placehold.co/200x200/e8f5e9/2e7d32?text=HanhToi', 200),
(5, N'Bánh tráng',           N'Bánh tráng mè Tây Ninh',           25000,  N'gói', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=BanhTrang',120),
-- Sữa - Trứng
(6, N'Sữa tươi Vinamilk',   N'Sữa tươi tiệt trùng Vinamilk 1L', 18000,  N'hộp', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=Vinamilk', 200),
(6, N'Trứng gà',             N'Trứng gà tươi vỉ 10 quả',          19000,  N'vỉ',  'https://placehold.co/200x200/e8f5e9/2e7d32?text=TrungGa', 150),
-- Thịt - Cá
(7, N'Thịt bò Úc',           N'Thịt bò Úc nhập khẩu 500g',      280000, N'kg',  'https://placehold.co/200x200/e8f5e9/2e7d32?text=ThitBo',   50),
-- Gạo
(8, N'Gạo ST25',             N'Gạo ST25 thơm ngon 5kg',           25000,  N'gói', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=GaoST25', 100),
-- Gia dụng
(9, N'Xà phòng Omo',         N'Xà phòng Omo 800g',                22000,  N'gói', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=OMO',     120),
-- Kem đánh răng
(9, N'Kem đánh răng Colgate',N'Kem đánh răng Colgate 230g',       18000,  N'hộp', 'https://placehold.co/200x200/e8f5e9/2e7d32?text=Colgate', 200);

-- Admin account (password: Admin@123 -> sha-256)
INSERT INTO Users (full_name, email, password, phone, role) VALUES
(N'Admin GreenMart', 'admin@greenmart.vn',
 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',
 '0901234567', 'admin');

-- Customer mẫu (password: 123456)
INSERT INTO Users (full_name, email, password, phone, address) VALUES
(N'Nguyễn Văn A', 'user@greenmart.vn',
 '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
 '0987654321', N'123 Nguyễn Trãi, Hà Nội');
GO

-- =====================
-- STORED PROCEDURES
-- =====================

-- Tìm kiếm sản phẩm
CREATE PROCEDURE sp_SearchProducts
    @keyword NVARCHAR(200) = NULL,
    @category_id INT = NULL
AS
BEGIN
    SELECT p.*, c.name AS category_name
    FROM Product p
    JOIN Category c ON p.category_id = c.category_id
    WHERE p.is_active = 1
      AND (@keyword IS NULL OR p.name LIKE N'%' + @keyword + N'%')
      AND (@category_id IS NULL OR p.category_id = @category_id)
    ORDER BY p.created_at DESC;
END;
GO

-- =====================
-- BẢNG ĐÁNH GIÁ SẢN PHẨM
-- =====================
CREATE TABLE Review (
    review_id   INT IDENTITY(1,1) PRIMARY KEY,
    product_id  INT           NOT NULL REFERENCES Product(product_id),
    user_id     INT           NOT NULL REFERENCES Users(user_id),
    stars       TINYINT       NOT NULL CHECK(stars BETWEEN 1 AND 5),
    comment     NVARCHAR(1000),
    created_at  DATETIME      DEFAULT GETDATE(),
    UNIQUE(product_id, user_id)   -- mỗi user chỉ đánh giá 1 lần / sản phẩm
);
GO

-- Cột sold_count trên Product (cập nhật mỗi lần đặt hàng thành công)
ALTER TABLE Product ADD sold_count INT NOT NULL DEFAULT 0;
GO

-- View tiện lợi: thống kê rating theo sản phẩm
CREATE VIEW vw_ProductRating AS
SELECT product_id,
       COUNT(*)            AS review_count,
       AVG(CAST(stars AS FLOAT)) AS avg_rating
FROM Review
GROUP BY product_id;
GO
