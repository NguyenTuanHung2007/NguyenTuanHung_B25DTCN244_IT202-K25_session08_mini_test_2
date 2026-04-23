DROP DATABASE IF EXISTS BookStoreDB;
CREATE DATABASE BookStoreDB;
USE BookStoreDB;

CREATE TABLE Category (
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Book (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT (1),
    publish_date DATE,
    price DECIMAL(18,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category (category_id)
);

CREATE TABLE Book_Order (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    FOREIGN KEY (book_id) REFERENCES Book (book_id),
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE
);

ALTER TABLE Book
ADD author_name VARCHAR(100) NOT NULL;

ALTER TABLE Book_Order
MODIFY COLUMN customer_name VARCHAR(200);


INSERT INTO Category VALUES
(1, 'IT & Tech', 'Sách lập trình'),
(2, 'Business', 'Sách kinh doanh'),
(3, 'Novel', 'Tiểu thuyết');

INSERT INTO Book VALUES
(1, 'Clean code', 1, '2020-05-10', 500000, 1, 'Robert C. Martin'),
(2, 'Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
(3, 'JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
(4, 'Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

INSERT INTO Book_Order VALUES
(101, 'Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
(102, 'Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
(103, 'Le Hoang Yen', 4, '2025-03-12', NULL);

UPDATE BOOK
SET price = price + 50000
WHERE category_id = 1;

DELETE FROM Book_Order
WHERE order_date < '2025-02-01';

-- CASE & AS: Hiển thị title, author_name và cột status_name (Nếu status = 1 là 'Còn hàng', 0 là 'Hết hàng'). 
SELECT title, author_name,
	CASE
		WHEN status = 1 THEN 'Còn hàng'
        ELSE 'Hết hàng'
        END AS status_name
    FROM Book;
    
-- Hàm hệ thống: Lấy danh sách sách: title viết hoa toàn bộ và một cột tính số năm xuất bản (từ publish_date đến hiện tại). 
SELECT UPPER(title), (YEAR(NOW()) - YEAR(publish_date)) AS book_age 
FROM Book;

-- INNER JOIN: Hiển thị title, price và category_name của từng cuốn sách.  
SELECT b.title, c.category_name, b.price 
FROM Book AS b
INNER JOIN Category AS c
ON b.category_id = c.category_id;

-- ORDER BY & LIMIT: Lấy thông tin 2 cuốn sách có giá (price) cao nhất, sắp xếp giảm dần. 
SELECT * 
FROM Book AS b
INNER JOIN Category AS c
ON b.category_id = c.category_id
ORDER BY b.price DESC
LIMIT 2;

-- GROUP BY & HAVING: Thống kê số lượng sách theo từng thể loại, chỉ hiển thị thể loại có từ 2 cuốn sách trở lên. 
SELECT c.category_name, COUNT(b.title) AS count
FROM Book AS b
INNER JOIN Category AS c
ON b.category_id = c.category_id
GROUP BY c.category_name
HAVING count >= 2;

-- Scalar Subquery: Tìm những cuốn sách có giá cao hơn mức giá trung bình của toàn bộ cửa hàng.
SELECT * FROM Book
WHERE price > (SELECT AVG(price) FROM Book);

-- IN Operator Subquery: Liệt kê thông tin các cuốn sách đã từng được đặt hàng ít nhất một lần.
SELECT * FROM Book_order
WHERE order_id IN (SELECT order_id FROM Book_order);

-- Correlated Subquery: Tìm những cuốn sách có mức giá cao nhất trong chính thể loại của chúng.
SELECT title, price
FROM Book AS b
WHERE price = (
	SELECT MAX(b2.price)
	FROM Book AS b2
    WHERE b2.category_id = b.category_id
);


