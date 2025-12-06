-- Tạo database
CREATE DATABASE IF NOT EXISTS `shopbtl`;
USE `shopbtl`;

DELIMITER $$

/* Bảng người dùng */
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `bdate` DATE,
  `lname` VARCHAR(100),
  `fname` VARCHAR(100),
  `link` VARCHAR(255),
  `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `temp_address` VARCHAR(255),
  `perm_address` VARCHAR(255),
  CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
) ENGINE=InnoDB$$

/* Số điện thoại người dùng (weak entity) */
CREATE TABLE IF NOT EXISTS `user_phone` (
  `user_id` INT NOT NULL,
  `phone_num` VARCHAR(30),
  PRIMARY KEY(`phone_num`, `user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB$$

/* Bảng referral */
CREATE TABLE IF NOT EXISTS `referral` (
  `invited` INT NOT NULL,
  `invited_by` INT NOT NULL,
  `referral_date` DATE,
  PRIMARY KEY (`invited`, `invited_by`),
  FOREIGN KEY (`invited`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`invited_by`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB$$

/* Seller */
CREATE TABLE IF NOT EXISTS `seller` (
  `user_id` INT PRIMARY KEY,
  `description` TEXT,
  `status` VARCHAR(50),
  `average_rating` DECIMAL(3,2) DEFAULT 0,
  `bank_account` VARCHAR(200),
  `total_revenue` DECIMAL(14,2) DEFAULT 0,
  `monthly_revenue` DECIMAL(14,2) DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Customer */
CREATE TABLE IF NOT EXISTS `customer` (
  `user_id` INT PRIMARY KEY,
  `default_address` VARCHAR(255),
  `loyalty_points` INT DEFAULT 0,
  `total_spent` DECIMAL(14,2) DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Danh mục sản phẩm */
CREATE TABLE IF NOT EXISTS `category` (
  `category_id` INT AUTO_INCREMENT PRIMARY KEY,
  `category_name` VARCHAR(150) NOT NULL UNIQUE,
  `description` TEXT
) ENGINE=InnoDB$$

/* Sản phẩm */
CREATE TABLE IF NOT EXISTS `product` (
  `product_id` INT AUTO_INCREMENT PRIMARY KEY,
  `product_name` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `quantity` INT NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('active','inactive','deleted') DEFAULT 'active',
  `seller_id` INT NOT NULL,
  FOREIGN KEY (`seller_id`) REFERENCES `seller`(`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Bảng nối product <-> category */
CREATE TABLE IF NOT EXISTS `product_category` (
  `product_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`, `category_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB$$

/* Promotion */
CREATE TABLE IF NOT EXISTS `promotion` (
  `promotion_id` INT AUTO_INCREMENT PRIMARY KEY,
  `seller_id` INT NOT NULL,
  `promotion_name` VARCHAR(255),
  `quantity` INT DEFAULT 0,
  `used_quantity` INT DEFAULT 0,
  `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` DATETIME DEFAULT CURRENT_TIMESTAMP ,
  `status` ENUM('active','inactive') DEFAULT 'inactive',
  FOREIGN KEY (`seller_id`) REFERENCES `seller`(`user_id`) ON DELETE RESTRICT,
  CHECK (`used_quantity` <= `quantity`)
) ENGINE=InnoDB$$

/* Discount */
CREATE TABLE IF NOT EXISTS `discount` (
  `discount_id` INT AUTO_INCREMENT PRIMARY KEY,
  `discount_name` VARCHAR(255),
  `discount_money` DECIMAL(12,2) DEFAULT 0,
  `expired_day` DATE,
  `bound_amount` DECIMAL(14,2) DEFAULT 0,
  `promotion_id` INT,
  FOREIGN KEY (`promotion_id`) REFERENCES `promotion`(`promotion_id`) ON DELETE SET NULL
) ENGINE=InnoDB$$

/* Orders */
CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `expected_delivery_date` DATE DEFAULT (CURRENT_DATE + INTERVAL 7 DAY),
  `actual_delivery_date` DATE,
  `status` ENUM('pending','shipped','delivered','cancelled') DEFAULT 'pending',
  `total_cost` DECIMAL(14,2) NOT NULL DEFAULT 0,
  `cost` DECIMAL(14,2) NOT NULL DEFAULT 0,
  `customer_id` INT NOT NULL,
  `discount_id` INT UNIQUE,
  FOREIGN KEY (`customer_id`) REFERENCES `customer`(`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`discount_id`) REFERENCES `discount`(`discount_id`) ON DELETE SET NULL,
  CHECK (
    `actual_delivery_date` IS NULL OR
    (
      `actual_delivery_date` >= `order_date`
      AND (`expected_delivery_date` IS NULL OR `actual_delivery_date` <= `expected_delivery_date`)
    )
  )
) ENGINE=InnoDB$$

/* Order detail */
CREATE TABLE IF NOT EXISTS `order_detail` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(14,2) NOT NULL,
  PRIMARY KEY (`order_id`, `product_id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Review */
CREATE TABLE IF NOT EXISTS `review` (
  `customer_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `comment` TEXT,
  `review_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rating` INT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  PRIMARY KEY (`customer_id`, `product_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer`(`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Wishlist */
CREATE TABLE IF NOT EXISTS `wishlist` (
  `wishlist_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `wishlist_name` VARCHAR(255),
  `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `customer`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB$$

/* Wishlist item */
CREATE TABLE IF NOT EXISTS `wishlist_item` (
  `wishlist_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`wishlist_id`, `product_id`),
  FOREIGN KEY (`wishlist_id`) REFERENCES `wishlist`(`wishlist_id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE RESTRICT
) ENGINE=InnoDB$$

/* Complaint */
CREATE TABLE IF NOT EXISTS `complaint` (
  `date_reported` DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` TEXT,
  `status` VARCHAR(50),
  `customer_id` INT NOT NULL,
  `seller_id` INT NOT NULL,
  `admin_id` INT ,
  PRIMARY KEY(`customer_id`, `seller_id`,`date_reported`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer`(`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`seller_id`) REFERENCES `seller`(`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`admin_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB$$

DELIMITER ;
