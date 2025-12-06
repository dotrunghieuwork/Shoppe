/* THỦ TỤC THÊM SẢN PHẨM (INSERT)*/
DROP PROCEDURE IF EXISTS `sp_product_insert`;
CREATE PROCEDURE `sp_product_insert`(
    IN p_product_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(12,2),
    IN p_quantity INT,
    IN p_seller_id INT
)
BEGIN
    -- Tên sản phẩm không được để trống
    IF p_product_name IS NULL OR TRIM(p_product_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Product name cannot be empty.';
    END IF;

    -- Giá phải lớn hơn 0
    IF p_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Price must be greater than 0.';
    END IF;

    -- Số lượng không được âm
    IF p_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Quantity cannot be negative.';
    END IF;

    -- Người bán phải tồn tại và đang hoạt động (active)
    IF NOT EXISTS (SELECT 1 FROM `seller` WHERE `user_id` = p_seller_id AND `status` = 'active') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Seller does not exist or is not active.';
    END IF;

    -- Thực hiện INSERT
    INSERT INTO `product` (product_name, description, price, quantity, status, seller_id, created_date)
    VALUES (p_product_name, p_description, p_price, p_quantity, 'active', p_seller_id, NOW());

    -- Trả về thông báo thành công (tùy chọn)
    SELECT CONCAT('Product "', p_product_name, '" inserted successfully with ID: ', LAST_INSERT_ID()) AS message;
END;


/* THỦ TỤC CẬP NHẬT SẢN PHẨM (UPDATE)*/
DROP PROCEDURE IF EXISTS `sp_product_update`;
CREATE PROCEDURE `sp_product_update`(
    IN p_product_id INT,
    IN p_product_name VARCHAR(255),
    IN p_price DECIMAL(12,2),
    IN p_quantity INT,
    IN p_status ENUM('active','inactive','deleted')
)
BEGIN
    -- Kiểm tra sản phẩm có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM `product` WHERE `product_id` = p_product_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Product ID does not exist.';
    END IF;

    -- Giá
    IF p_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Price must be greater than 0.';
    END IF;

    -- Số lượng
    IF p_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Quantity cannot be negative.';
    END IF;

    -- Thực hiện UPDATE
    UPDATE `product`
    SET `product_name` = p_product_name,
        `price` = p_price,
        `quantity` = p_quantity,
        `status` = p_status
    WHERE `product_id` = p_product_id;

    SELECT CONCAT('Product ID ', p_product_id, ' updated successfully.') AS message;
END;


/* THỦ TỤC XÓA SẢN PHẨM (DELETE)*/
DROP PROCEDURE IF EXISTS `sp_product_delete`;
CREATE PROCEDURE `sp_product_delete`(
    IN p_product_id INT
)
BEGIN
    DECLARE v_order_count INT;

    -- Kiểm tra sản phẩm có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM `product` WHERE `product_id` = p_product_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Product ID not found.';
    END IF;

    -- Kiểm tra xem sản phẩm đã có trong đơn hàng nào chưa
    SELECT COUNT(*) INTO v_order_count 
    FROM `order_detail` 
    WHERE `product_id` = p_product_id;

    IF v_order_count > 0 THEN
        -- Đã có đơn hàng -> Không xóa cứng, chỉ update status (Soft Delete)
        UPDATE `product` 
        SET `status` = 'deleted' 
        WHERE `product_id` = p_product_id;
        
        SELECT 'Product has associated orders. Performed SOFT DELETE (status set to deleted).' AS message;
    ELSE
        -- Chưa có đơn hàng -> Xóa cứng (Hard Delete)
        DELETE FROM `product_category` WHERE `product_id` = p_product_id; -- Xóa bảng phụ trước
        DELETE FROM `product` WHERE `product_id` = p_product_id;
        
        SELECT 'Product has no orders. Performed HARD DELETE.' AS message;
    END IF;
END;