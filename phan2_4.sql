USE shopbtl;
SELECT DATABASE();




DELIMITER $$

CREATE FUNCTION total_quantity_by_seller(p_seller_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE qty INT;
    DECLARE total_qty INT DEFAULT 0;
    
    DECLARE cur CURSOR FOR 
        SELECT quantity FROM product WHERE seller_id = p_seller_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    -- Kiểm tra seller 
    IF NOT EXISTS (SELECT 1 FROM seller WHERE user_id = p_seller_id) THEN
        RETURN -1;  
    END IF;
    --
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO qty;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET total_qty = total_qty + qty;
    END LOOP;
    CLOSE cur;
    
    RETURN total_qty;
END$$

DELIMITER ;

-- thực thi

SELECT total_quantity_by_seller(1) AS total_qty;
SELECT total_quantity_by_seller(99) AS total_qty; 
--------------





DELIMITER $$

CREATE FUNCTION count_weak_review(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE r INT;
    DECLARE weak_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT rating FROM review WHERE product_id = p_product_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    IF NOT EXISTS (SELECT 1 FROM product WHERE product_id = p_product_id) THEN
        RETURN -1;
    END IF;

    OPEN cur;
    review_loop: LOOP
        FETCH cur INTO r;
        IF done THEN
            LEAVE review_loop;
        END IF;
        IF r <= 2 THEN
            SET weak_count = weak_count + 1;
        END IF;
    END LOOP;
    CLOSE cur;

    RETURN weak_count;
END$$

DELIMITER ;

-- thực thi
SELECT count_weak_review(1) AS weak_reviews;
SELECT count_weak_review(99) AS weak_reviews; 
-- 