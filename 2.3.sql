DELIMITER $$

/* 
   2.3: VIẾT 2 THỦ TỤC HIỂN THỊ DỮ LIỆU
*/

/* 
    TT 1: Tìm kiếm sản phẩm nâng cao
*/
DROP PROCEDURE IF EXISTS `sp_search_product_advanced`$$
CREATE PROCEDURE `sp_search_product_advanced`(
    IN p_keyword VARCHAR(255),
    IN p_min_price DECIMAL(12,2),
    IN p_max_price DECIMAL(12,2)
)
BEGIN
    DECLARE v_keyword VARCHAR(255) DEFAULT IFNULL(p_keyword, '');
    DECLARE v_min DECIMAL(12,2) DEFAULT IFNULL(p_min_price, 0);
    DECLARE v_max DECIMAL(12,2) DEFAULT IFNULL(p_max_price, 9999999999);

    SELECT 
        p.product_id,
        p.product_name,
        p.price,
        p.quantity AS stock_remaining,
        s.description AS shop_name, 
        CONCAT(u.lname, ' ', u.fname) AS seller_fullname,
        p.status
    FROM 
        `product` p
    JOIN 
        `seller` s ON p.seller_id = s.user_id
    JOIN 
        `users` u ON s.user_id = u.id
    WHERE 
        p.product_name LIKE CONCAT('%', v_keyword, '%')
        AND p.price BETWEEN v_min AND v_max
        AND p.status = 'active'
    ORDER BY 
        p.price ASC;
END$$


/* 
    TT 2: Báo cáo sản phẩm bán chạy theo tháng
*/
DROP PROCEDURE IF EXISTS `sp_report_top_selling_products`$$
CREATE PROCEDURE `sp_report_top_selling_products`(
    IN p_min_sold_quantity INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    SELECT 
        p.product_id,
        p.product_name,
        p.price AS current_price,
        COUNT(od.order_id) AS total_orders_count, 
        SUM(od.quantity) AS total_quantity_sold,  
        SUM(od.quantity * od.unit_price) AS total_revenue 
    FROM 
        `product` p
    JOIN 
        `order_detail` od ON p.product_id = od.product_id
    JOIN 
        `orders` o ON od.order_id = o.order_id
    WHERE 
        o.status = 'delivered'             
        AND MONTH(o.order_date) = p_month  
        AND YEAR(o.order_date) = p_year    
    GROUP BY 
        p.product_id, p.product_name, p.price
    HAVING 
        SUM(od.quantity) >= p_min_sold_quantity 
    ORDER BY 
        total_quantity_sold DESC;          
END$$

DELIMITER ;