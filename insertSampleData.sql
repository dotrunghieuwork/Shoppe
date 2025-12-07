-- =======================
-- 14) INSERT SAMPLE DATA (FULL)
-- ======================= -- Đã sửa thành shopbtl

-- 1) USERS (10 người)
INSERT INTO users (username, email, password, bdate, lname, fname, link, temp_address, perm_address)
VALUES
('user01','van.luyen0101@gmail.com','vanluyen1','2005-01-01','Nguyen','Van Luyen',NULL,'HCM','HCM'),
('user02','ngoc2002@gmail.com','tranthingoc2','2002-02-02','Tran','Thi Ngoc',NULL,'HN','HN'),
('user03','lebach@gmail.com','levanbach3','2004-03-03','Le','Van Bach',NULL,'DN','DN'),
('user04','phamthituyet@gmail.com','phamthituyet4','2006-04-04','Pham','Thi Tuyet',NULL,'Hue','Hue'),
('user05','thuminh55@gmail.com','hominhthu5','2008-05-05','Ho','Minh Thu',NULL,'HCM','HCM'),
('user06','mai.vo1999@gmail.com','vothimai6','1999-06-06','Vo','Thi Mai',NULL,'HN','HN'),
('user07','hiep@gmail.com','ngovanhiep7','2005-07-07','Ngo','Van Hiep',NULL,'HCM','HCM'),
('user08','ngochieu@gmail.com','dangngochieu8','2000-08-08','Dang','Ngoc Hieu',NULL,'DN','DN'),
('user09','hoanghai99@gmail.com','buihoanghai9','2001-09-09','Bui','Hoang Hai',NULL,'Hue','Hue'),
('admin01','admin@gmail.com','adminpass','2000-10-10','Admin','System',NULL,'HCM','HCM');

-- 2) USER_PHONE
INSERT INTO user_phone (user_id, phone_num) VALUES
(1,'0900000001'),(1,'0987123456'),
(2,'0900000002'),(3,'0900000003'),(4,'0900000004'),
(5,'0900000005'),(6,'0900000006'),(7,'0900000007'),
(8,'0900000008'),(9,'0900000009'),(10,'0900000010');

-- 3) SELLER (5 Shop)
INSERT INTO seller (user_id, description, status, average_rating, bank_account, total_revenue, monthly_revenue)
VALUES
(1,'Shop thoi trang nam','active',4.7,'ACB-123456',35000000,5000000),
(2,'Shop phu kien dien thoai','active',4.5,'VCB-998877',42000000,7000000),
(3,'Do gia dung chat luong','active',4.6,'TPB-556677',28000000,3000000),
(4,'Shop tai nghe loa','inactive',4.3,'MB-445566',15000000,2000000),
(6,'My pham thien nhien','active',4.8,'VIB-000111',12000000,2000000);

-- 4) CUSTOMER (5 Khách)
INSERT INTO customer (user_id, default_address, loyalty_points, total_spent)
VALUES
(1,'HCM',100,1000000), (2,'HN',120,1200000), (3,'DN',90,900000),
(4,'Hue',80,800000), (5,'HCM',150,2000000);

-- 5) CATEGORY
INSERT INTO category (category_name, description) VALUES
('Thoi trang','Quan ao, ao thun, quan jean'),
('Phu kien','Op lung, cap sac'),
('Gia dung','Noi, chao, do nha bep'),
('Dien tu','Tai nghe, loa'),
('Do choi','Lego, xep hinh');

-- 6) FINANCIAL REPORT 
INSERT INTO `financialReport` (`createDate`, `endDate`, `admin_id`, `commissionRate`) 
VALUES 
('2025-07-01 00:00:00', '2025-07-31 23:59:59', 10, 0.05), -- Tháng 7
('2025-08-01 00:00:00', '2025-08-31 23:59:59', 10, 0.05), -- Tháng 8
('2025-09-01 00:00:00', '2025-09-30 23:59:59', 10, 0.05), -- Tháng 9
('2025-10-01 00:00:00', '2025-10-31 23:59:59', 10, 0.05), -- Tháng 10
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 0.05); -- Tháng 11

-- 7) financialReport_seller
INSERT INTO `financialReport_seller` (`createDate`, `endDate`, `admin_id`, `seller_id`) 
VALUES 
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 1),
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 2),
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 3),
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 4),
('2025-11-01 00:00:00', '2025-11-30 23:59:59', 10, 6);
-- 8) PRODUCT (8 Sản phẩm)
INSERT INTO product (product_name, description, price, quantity, status, seller_id) VALUES
('Ao thun basic','Cotton 100%',199000,120,'active',1),
('Quan jean slim','Den navy',399000,80,'active',1),
('Op lung iPhone 15','Nhua deo',99000,300,'active',2),
('Cap USB-C 60W','Ho tro Power Delivery',149000,200,'active',2),
('Noi chong dinh 24cm','Phu ceramic',259000,100,'active',3),
('Chao gang 26cm','Gang duc',399000,50,'active',3),
('Tai nghe Bluetooth','Bluetooth 5.3',499000,70,'active',4),
('Lego city mini','Bo xep hinh mini',129000,90,'active',1);

-- 9) PRODUCT_CATEGORY
INSERT INTO product_category (product_id, category_id) VALUES
(1,1),(2,1),(3,2),(4,2),(5,3),(6,3),(7,4),(8,5);

-- 10) PROMOTION
INSERT INTO promotion (seller_id, promotion_name, quantity, used_quantity, created_date, end_date, status) VALUES
(1,'Thu dong 2025',1000,0,'2025-10-05','2025-12-31','active'),
(2,'Phu kien sale',800,0,'2025-10-06','2025-12-15','active'),
(3,'Gia dung -40k',600,0,'2025-10-07','2025-12-20','active'),
(1,'Do choi 12.12',500,0,'2025-10-08','2025-12-31','active'),
(4,'Dien tu cuoi nam',400,0,'2025-10-10','2025-12-31','active');

-- 11) DISCOUNT
INSERT INTO discount (discount_name, discount_money, expired_day, bound_amount, promotion_id) VALUES
('VOUCHER50K',50000,'2025-12-31',200000,1),
('VOUCHER30K',30000,'2025-12-15',150000,2),
('VOUCHER40K',40000,'2025-12-20',250000,3),
('VOUCHER20K',20000,'2025-12-31',100000,1),
('VOUCHER60K',60000,'2025-12-31',300000,4),
('VOUCHER15K',15000,'2025-12-31',90000,2);

-- 12) WISHLIST
INSERT INTO wishlist (user_id, wishlist_name) VALUES
(1,'Wishlist 01'), (2,'Wishlist 02'), (3,'Wishlist 03'), (4,'Wishlist 04'), (5,'Wishlist 05');

-- 13) WISHLIST_ITEM
INSERT INTO wishlist_item (wishlist_id, product_id) VALUES
(1,1),(1,3),(2,2),(3,5),(4,7),(5,8);

-- 14) ORDERS (6 Đơn hàng)
INSERT INTO orders (order_date, expected_delivery_date, actual_delivery_date, status, total_cost, cost, customer_id, discount_id)
VALUES
('2025-11-01','2025-11-05','2025-11-04','delivered',397000,348000,1,1),
('2025-11-02','2025-11-06','2025-11-06','delivered',248000,218000,2,2),
('2025-11-03','2025-11-08','2025-11-07','delivered',399000,359000,3,3),
('2025-11-04','2025-11-09','2025-11-08','delivered',149000,129000,4,4),
('2025-11-05','2025-11-10','2025-11-09','delivered',628000,568000,5,5),
('2025-11-06','2025-11-10',NULL,'shipped',129000,129000,1,NULL);

-- 15) ORDER_DETAIL
INSERT INTO order_detail (order_id, product_id, quantity, unit_price) VALUES
(1,1,1,199000),(1,3,2,99000),
(2,4,1,149000),(2,3,1,99000),
(3,6,1,399000),
(4,4,1,149000),
(5,7,1,499000),(5,8,1,129000),
(6,8,1,129000);

-- 16) PAYMENT_METHOD 
INSERT INTO `paymentMethod` (`methodType`, `order_id`, `accountNumber`, `cardNumber`) 
VALUES 
('COD', 1, NULL, NULL),
('BANK_TRANSFER', 2, '1903654123011', NULL),
('CREDIT_CARD', 3, NULL, '4222-3333-4444-5555'),
('E-WALLET', 4, '0909123456', NULL),
('COD', 5, NULL, NULL);

-- 17) COMPLAINT
INSERT INTO complaint (customer_id, seller_id, admin_id, date_reported, reason, status) VALUES
(2,2,10,'2025-11-06','San pham bi hong khi giao','resolved'),
(5,2,10,'2025-11-07','Cap sac khong hoat dong','pending'),
(1,3,10,'2025-11-08','Chao bi moc','resolved'),
(3,4,10,'2025-11-09','Tai nghe bi loi','in_progress'),
(4,1,10,'2025-11-10','Lego thieu linh kien','resolved');

-- 18) REVIEW (8 Đánh giá)
INSERT INTO review (customer_id, product_id, comment, review_date, rating) VALUES
(1,1,'Ao thun form dep','2025-11-05',5),
(1,3,'Op lung on','2025-11-06',4),
(2,4,'Cap sac tot','2025-11-07',5),
(3,6,'Chao gang on','2025-11-08',4),
(4,4,'Giao nhanh','2025-11-09',5),
(5,7,'Am thanh on','2025-11-10',4),
(5,8,'Lego dep','2025-11-10',5),
(2,3,'Phu hop','2025-11-08',4);

-- 19) REFERRAL (Người giới thiệu)
INSERT INTO referral (invited, invited_by, referral_date) VALUES
(2, 1, '2025-10-01'), -- User 1 giới thiệu User 2
(3, 1, '2025-10-02'),
(4, 2, '2025-10-05'),
(5, 2, '2025-10-06'),
(6, 3, '2025-10-10');