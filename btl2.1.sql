USE shopbtl;

DELIMITER $$

-- =======================================================
-- 1. THỦ TỤC THÊM SẢN PHẨM (INSERT)
-- =======================================================
DROP PROCEDURE IF EXISTS `sp_product_insert`$$
CREATE PROCEDURE `sp_product_insert`(
    IN p_product_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(12,2),
    IN p_quantity INT,
    IN p_seller_id INT
)
BEGIN
    -- Validate dữ liệu
    IF p_product_name IS NULL OR TRIM(p_product_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Product name cannot be empty.';
    END IF;
    IF p_price <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Price must be greater than 0.';
    END IF;
    IF p_quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Quantity cannot be negative.';
    END IF;

    -- Insert
    INSERT INTO `product` (product_name, description, price, quantity, status, seller_id, created_date)
    VALUES (p_product_name, p_description, p_price, p_quantity, 'active', p_seller_id, NOW());

    -- Trả về sản phẩm vừa tạo để Python hiển thị
    SELECT * FROM product WHERE product_id = LAST_INSERT_ID();
END$$


-- =======================================================
-- 2. THỦ TỤC CẬP NHẬT SẢN PHẨM (UPDATE)
-- =======================================================
DROP PROCEDURE IF EXISTS `sp_product_update`$$
CREATE PROCEDURE `sp_product_update`(
    IN p_product_id INT,
    IN p_product_name VARCHAR(255),
    IN p_price DECIMAL(12,2),
    IN p_quantity INT,
    IN p_status ENUM('active','inactive','deleted')
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `product` WHERE `product_id` = p_product_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Product ID does not exist.';
    END IF;

    UPDATE `product`
    SET `product_name` = p_product_name,
        `price` = p_price,
        `quantity` = p_quantity,
        `status` = p_status
    WHERE `product_id` = p_product_id;

    SELECT * FROM product WHERE product_id = p_product_id;
END$$


-- =======================================================
-- 3. THỦ TỤC XÓA SẢN PHẨM (DELETE)
-- =======================================================
DROP PROCEDURE IF EXISTS `sp_product_delete`$$
CREATE PROCEDURE `sp_product_delete`(IN p_product_id INT)
BEGIN
    DECLARE v_order_count INT;

    -- Kiểm tra xem sản phẩm đã có ai mua chưa
    SELECT COUNT(*) INTO v_order_count FROM `order_detail` WHERE `product_id` = p_product_id;

    IF v_order_count > 0 THEN
        -- Đã có người mua -> Xóa mềm (Đổi status thành deleted)
        UPDATE `product` SET `status` = 'deleted' WHERE `product_id` = p_product_id;
        SELECT 'Product has associated orders. Performed SOFT DELETE.' AS message;
    ELSE
        -- Chưa ai mua -> Xóa cứng (Bay màu luôn)
        DELETE FROM `product_category` WHERE `product_id` = p_product_id;
        DELETE FROM `product` WHERE `product_id` = p_product_id;
        SELECT 'Product has no orders. Performed HARD DELETE.' AS message;
    END IF;
END$$


-- =======================================================
-- 4. THỦ TỤC TÌM KIẾM NÂNG CAO (SEARCH) - Python cần cái này
-- =======================================================
DROP PROCEDURE IF EXISTS `sp_search_product_advanced`$$
CREATE PROCEDURE `sp_search_product_advanced`(
    IN p_keyword VARCHAR(100),
    IN p_min_price DECIMAL(12,2),
    IN p_max_price DECIMAL(12,2)
)
BEGIN
    SELECT * FROM product 
    WHERE (p_keyword IS NULL OR product_name LIKE CONCAT('%', p_keyword, '%') OR description LIKE CONCAT('%', p_keyword, '%'))
      AND (p_min_price IS NULL OR price >= p_min_price)
      AND (p_max_price IS NULL OR price <= p_max_price)
      AND status != 'deleted';
END$$


-- =======================================================
-- 5. THỦ TỤC BÁO CÁO DOANH THU (REPORT) - Python cần cái này
-- =======================================================
DROP PROCEDURE IF EXISTS `sp_report_top_selling_products`$$
CREATE PROCEDURE `sp_report_top_selling_products`(
    IN p_min_sold INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    SELECT 
        p.product_id,
        p.product_name, 
        SUM(od.quantity) as total_sold, 
        SUM(od.quantity * od.unit_price) as revenue
    FROM order_detail od
    JOIN orders o ON od.order_id = o.order_id
    JOIN product p ON od.product_id = p.product_id
    WHERE MONTH(o.order_date) = p_month 
      AND YEAR(o.order_date) = p_year 
      AND o.status = 'delivered'
    GROUP BY p.product_id, p.product_name
    HAVING total_sold >= p_min_sold
    ORDER BY total_sold DESC;
END$$

DELIMITER ;