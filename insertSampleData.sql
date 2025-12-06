-- =======================
-- 14) INSERT SAMPLE DATA
-- =======================
USE shopbtl;   -- chọn database
SELECT DATABASE();  -- sẽ trả về 'shopbtl'


-- Users
INSERT INTO users (username, email, password, bdate, lname, fname, temp_address, perm_address)
VALUES
('user01','van.luyen0101@gmail.com','vanluyen1','2005-01-01','Nguyen','Van Luyen','HCM','HCM'),
('user02','ngoc2002@gmail.com','tranthingoc2','2002-02-02','Tran','Thi Ngoc','HN','HN'),
('user03','lebach@gmail.com','levanbach3','2004-03-03','Le','Van Bach','DN','DN'),
('admin01','admin@gmail.com','adminpass','2000-10-10','Admin','System','HCM','HCM');

-- User Phone
INSERT INTO user_phone (user_id, phone_num)
VALUES
(1,'0900000001'),
(2,'0900000002'),
(3,'0900000003'),
(4,'0900000010');

-- Sellers
INSERT INTO seller (user_id, description, status, average_rating, bank_account, total_revenue, monthly_revenue)
VALUES
(1,'Shop thoi trang nam','active',4.7,'ACB-123456',35000000,5000000);

-- Customers
INSERT INTO customer (user_id, default_address, loyalty_points, total_spent)
VALUES
(2,'HN',120,1200000),
(3,'DN',90,900000),
(4,'HCM',100,1000000);

-- Category
INSERT INTO category (category_name, description)
VALUES
('Thoi trang','Quan ao, ao thun, quan jean');

-- Product
INSERT INTO product (product_name, description, price, quantity, status, seller_id)
VALUES
('Ao thun basic','Cotton 100%',199000,120,'active',1);

-- Product_Category
INSERT INTO product_category (product_id, category_id)
VALUES (1,1);

-- Promotion
INSERT INTO promotion (seller_id, promotion_name, quantity, used_quantity, status)
VALUES (1,'Thu dong 2025',1000,0,'active');

-- Discount
INSERT INTO discount (discount_name, discount_money, expired_day, bound_amount, promotion_id)
VALUES ('VOUCHER50K',50000,'2025-12-31',200000,1);

-- Orders
INSERT INTO orders (customer_id, total_cost, cost, discount_id)
VALUES (2,398000,348000,1);

-- Order_Detail
INSERT INTO order_detail (order_id, product_id, quantity, unit_price)
VALUES (1,1,1,199000);

-- Review
INSERT INTO review (customer_id, product_id, comment, rating)
VALUES (2,1,'Ao thun form dep',5);

-- Complaint
INSERT INTO complaint (customer_id, seller_id, admin_id, reason, status)
VALUES (2,1,4,'San pham bi hong khi giao','resolved');