-- ===================================================
-- E-Commerce Database System
-- Author: Haifa Khalid Aldhwayan
-- Engine: SQLite
-- ===================================================

-- ---------------------------------------------------
-- Part 1: Create Database Tables (Schema)
-- ---------------------------------------------------

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(50) NOT NULL
);

-- 3. Products Table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 5. OrderItems Table (Junction Table for Many-to-Many)
CREATE TABLE OrderItems (
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- ---------------------------------------------------
-- Part 2: Insert Sample Data
-- ---------------------------------------------------

INSERT INTO Categories (category_name) VALUES 
('Electronics'), 
('Accessories'), 
('Office Supplies');

INSERT INTO Products (product_name, price, stock_quantity, category_id) VALUES 
('Ergonomic Chair', 250.00, 15, 3),
('Mechanical Keyboard', 120.00, 8, 1),
('Wireless Mouse', 45.00, 50, 1),
('Monitor Stand', 65.00, 5, 2);

INSERT INTO Customers (first_name, last_name, email) VALUES 
('Haifa', 'Khalid', 'haifa.khalid@example.com'),
('Sara', 'Ahmed', 'sara.ahmed@example.com');

INSERT INTO Orders (customer_id, total_amount) VALUES 
(1, 370.00), 
(2, 45.00);

INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 250.00),
(1, 2, 1, 120.00),
(2, 3, 1, 45.00);

-- ---------------------------------------------------
-- Part 3: Business Analytical Queries
-- ---------------------------------------------------

-- Report A: Total spending per customer
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Report B: Low stock warning (Items under 10 units)
SELECT product_name, stock_quantity 
FROM Products 
WHERE stock_quantity < 10;
