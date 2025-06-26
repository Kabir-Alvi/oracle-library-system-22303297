2.


-- 📊 Analyze member borrowing behavior by showing their last borrow date using LAG
SELECT 
    member_id,
    transaction_id,
    issue_date,
    LAG(issue_date) OVER (
        PARTITION BY member_id 
        ORDER BY issue_date
    ) AS previous_issue_date
FROM TRANSACTIONS
ORDER BY member_id, issue_date;




-- 📦 Procedure: Issue a book after checking availability and generating transaction
DELIMITER $$

CREATE PROCEDURE issue_book_to_member (
    IN in_member_id INT,
    IN in_book_id INT
)
label_proc: BEGIN
    DECLARE available_now INT DEFAULT 0;
    DECLARE next_txn_id INT DEFAULT 0;

    -- 🚨 Exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT '❌ Error issuing book!' AS message;
    END;

    START TRANSACTION;

    -- 📘 Step 1: Check availability
    SELECT available_copies 
    INTO available_now
    FROM BOOKS
    WHERE book_id = in_book_id
    FOR UPDATE;

    IF available_now IS NULL THEN
        ROLLBACK;
        SELECT '🚫 Book not found.' AS message;
        LEAVE label_proc;
    END IF;

    IF available_now <= 0 THEN
        ROLLBACK;
        SELECT '📕 Book currently unavailable.' AS message;
        LEAVE label_proc;
    END IF;

    -- 🆔 Step 2: Generate new transaction ID
    SELECT IFNULL(MAX(transaction_id), 0)
    INTO next_txn_id
    FROM TRANSACTIONS;

    -- 💾 Step 3: Insert transaction
    INSERT INTO TRANSACTIONS (
        transaction_id, member_id, book_id, issue_date, due_date, return_date, fine_amount, status
    ) VALUES (
        next_txn_id + 1,
        in_member_id,
        in_book_id,
        CURDATE(),
        DATE_ADD(CURDATE(), INTERVAL 14 DAY),
        NULL,
        0.00,
        'Pending'
    );

    -- 🔄 Step 4: Update book stock
    UPDATE BOOKS
    SET available_copies = available_copies - 1
    WHERE book_id = in_book_id;

    COMMIT;

    SELECT CONCAT('✅ Book issued. Transaction ID: ', next_txn_id + 1) AS message;
END label_proc $$

DELIMITER ;




-- 💸 Function: Calculates overdue fine for a transaction (₹5 per day)
DELIMITER $$

CREATE FUNCTION get_fine_amount(txn_id INT)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    DECLARE due_dt DATE;
    DECLARE ret_dt DATE;
    DECLARE today DATE;
    DECLARE days_late INT DEFAULT 0;
    DECLARE fine_amt DECIMAL(6,2) DEFAULT 0.00;

    SET today = CURDATE();

    SELECT due_date, return_date
    INTO due_dt, ret_dt
    FROM TRANSACTIONS
    WHERE transaction_id = txn_id;

    IF ret_dt IS NOT NULL THEN
        SET days_late = DATEDIFF(ret_dt, due_dt);
    ELSE
        SET days_late = DATEDIFF(today, due_dt);
    END IF;

    IF days_late > 0 THEN
        SET fine_amt = days_late * 5;
    END IF;

    RETURN fine_amt;
END $$

DELIMITER ;

-- 🔍 Usage Example
SELECT get_fine_amount(1) AS fine_for_txn_1;





-- 🔄 Trigger: When book status changes to 'Returned', update available_copies
DELIMITER $$

CREATE TRIGGER trg_update_stock_after_return
AFTER UPDATE ON TRANSACTIONS
FOR EACH ROW
BEGIN
    IF OLD.status <> 'Returned' AND NEW.status = 'Returned' THEN
        UPDATE BOOKS
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END $$

DELIMITER ;




-- 👤 Create system users
CREATE USER 'librarian'@'localhost' IDENTIFIED BY 'lib_password123';
CREATE USER 'student_user'@'localhost' IDENTIFIED BY 'student_password123';

-- 🛡️ Assign roles and permissions
GRANT ALL PRIVILEGES ON Library_Management_System.* TO 'librarian'@'localhost';
GRANT SELECT ON Library_Management_System.BOOKS TO 'student_user'@'localhost';

-- ✅ Apply the permission changes
FLUSH PRIVILEGES;

-- 🗑️ Optional cleanup if needed:
-- DROP USER 'librarian'@'localhost';
-- DROP USER 'student_user'@'localhost';












