3.

-- 📘 Show books where some copies are currently borrowed
SELECT 
    book_id, title, total_copies, available_copies
FROM BOOKS
WHERE available_copies < total_copies;



-- ⏰ Find members who haven’t returned books before due date
SELECT 
    M.member_id, M.first_name, M.last_name, 
    T.book_id, T.due_date
FROM MEMBERS AS M
JOIN TRANSACTIONS AS T ON M.member_id = T.member_id
WHERE T.due_date < CURDATE() AND T.status = 'Overdue';



-- 🔝 Show most borrowed books based on transaction frequency
SELECT 
    B.book_id, B.title, COUNT(T.transaction_id) AS borrow_count
FROM BOOKS AS B
JOIN TRANSACTIONS AS T ON B.book_id = T.book_id
GROUP BY B.book_id, B.title
ORDER BY borrow_count DESC
LIMIT 5;


-- ⛔ Members who always returned books after due date
SELECT DISTINCT 
    M.member_id, M.first_name, M.last_name
FROM MEMBERS AS M
JOIN TRANSACTIONS AS T ON M.member_id = T.member_id
WHERE T.return_date > T.due_date;



-- 💸 Update ₹5/day fines for late returns
SET SQL_SAFE_UPDATES = 0;

UPDATE TRANSACTIONS
SET fine_amount = DATEDIFF(return_date, due_date) * 5
WHERE return_date > due_date;



-- 🧍 Add a new member only if email & phone are unique
INSERT INTO MEMBERS (
    member_id, first_name, last_name, email, phone, address, membership_date, membership_type
)
SELECT 
    16, 'Rafi', 'Hasan', 'rafi@example.com', '01234567906', 'Narsingdi, BD', CURDATE(), 'Student'
WHERE NOT EXISTS (
    SELECT 1 FROM MEMBERS 
    WHERE email = 'rafi@example.com' OR phone = '01234567906'
);



-- 🗂️ Update book category based on publication decade
UPDATE BOOKS
SET category = CASE
    WHEN YEAR(publication_year) < 2000 THEN 'Classic'
    WHEN YEAR(publication_year) BETWEEN 2000 AND 2010 THEN 'Standard'
    ELSE 'Modern'
END;



-- 🔍 Combine transaction, member, and book details for overdue books
SELECT 
    T.transaction_id,
    M.member_id, M.first_name, M.last_name,
    B.book_id, B.title, B.category,
    T.issue_date, T.due_date, T.return_date, T.status
FROM TRANSACTIONS T
JOIN MEMBERS M ON T.member_id = M.member_id
JOIN BOOKS B ON T.book_id = B.book_id
WHERE T.status = 'Overdue';



-- 📚 Count transactions for all books (even never borrowed ones)
SELECT 
    B.book_id, B.title, COUNT(T.transaction_id) AS transaction_count
FROM BOOKS B
LEFT JOIN TRANSACTIONS T ON B.book_id = T.book_id
GROUP BY B.book_id, B.title
ORDER BY transaction_count DESC;



-- 🔄 Members who borrowed from same category as others
SELECT DISTINCT 
    M1.member_id AS member1_id, M1.first_name AS member1_name,
    M2.member_id AS member2_id, M2.first_name AS member2_name,
    B1.category
FROM TRANSACTIONS T1
JOIN MEMBERS M1 ON T1.member_id = M1.member_id
JOIN BOOKS B1 ON T1.book_id = B1.book_id
JOIN TRANSACTIONS T2 ON B1.category = (
    SELECT category FROM BOOKS WHERE book_id = T2.book_id
)
JOIN MEMBERS M2 ON T2.member_id = M2.member_id
WHERE M1.member_id <> M2.member_id;



-- 📊 Books with borrow count above average
SELECT book_id, title
FROM BOOKS
WHERE book_id IN (
    SELECT book_id
    FROM TRANSACTIONS
    GROUP BY book_id
    HAVING COUNT(*) > (
        SELECT AVG(borrow_count)
        FROM (
            SELECT COUNT(*) AS borrow_count
            FROM TRANSACTIONS
            GROUP BY book_id
        ) AS stats
    )
);


-- 💰 Identify members paying more fines than average in their group
SELECT member_id, first_name, last_name, total_fine
FROM (
    SELECT M.member_id, M.first_name, M.last_name, M.membership_type,
           SUM(T.fine_amount) AS total_fine
    FROM MEMBERS M
    JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name, M.membership_type
) AS member_fines
WHERE total_fine > (
    SELECT AVG(total_fine)
    FROM (
        SELECT M.member_id, M.membership_type, SUM(T.fine_amount) AS total_fine
        FROM MEMBERS M
        JOIN TRANSACTIONS T ON M.member_id = T.member_id
        GROUP BY M.member_id, M.membership_type
    ) AS avg_fines
    WHERE avg_fines.membership_type = member_fines.membership_type
);



-- 📚 Show currently available books in most borrowed category
SELECT book_id, title, category
FROM BOOKS
WHERE available_copies > 0
AND category = (
    SELECT category
    FROM BOOKS B
    JOIN TRANSACTIONS T ON B.book_id = T.book_id
    GROUP BY category
    ORDER BY COUNT(*) DESC
    LIMIT 1
);






-- 🏆 Second most active member by borrow count
SELECT member_id, first_name, last_name, txn_count
FROM (
    SELECT M.member_id, M.first_name, M.last_name, COUNT(T.transaction_id) AS txn_count
    FROM MEMBERS M
    JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name
) AS ranked
WHERE txn_count = (
    SELECT MAX(txn_count) FROM (
        SELECT COUNT(transaction_id) AS txn_count
        FROM TRANSACTIONS
        GROUP BY member_id
        HAVING COUNT(transaction_id) < (
            SELECT MAX(inner_count) FROM (
                SELECT COUNT(transaction_id) AS inner_count
                FROM TRANSACTIONS
                GROUP BY member_id
            ) AS all_txns
        )
    ) AS second_best
);




-- 📅 Total fines by month with cumulative sum
SELECT 
    DATE_FORMAT(return_date, '%Y-%m') AS month,
    SUM(fine_amount) AS monthly_fine,
    SUM(SUM(fine_amount)) OVER (ORDER BY DATE_FORMAT(return_date, '%Y-%m')) AS running_total
FROM TRANSACTIONS
WHERE fine_amount > 0
GROUP BY month
ORDER BY month;



-- 🥇 Rank members by borrow count inside membership group
SELECT 
    member_id, first_name, last_name, membership_type, borrow_count,
    RANK() OVER (PARTITION BY membership_type ORDER BY borrow_count DESC) AS rank_within_type
FROM (
    SELECT M.member_id, M.first_name, M.last_name, M.membership_type,
           COUNT(T.transaction_id) AS borrow_count
    FROM MEMBERS M
    LEFT JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name, M.membership_type
) AS stats;




-- 📈 Show how much each category contributes to total transactions
SELECT 
    B.category,
    COUNT(T.transaction_id) AS category_transaction_count,
    ROUND(
        100 * COUNT(T.transaction_id) / (SELECT COUNT(*) FROM TRANSACTIONS), 
        2
    ) AS percentage_contribution
FROM BOOKS B
LEFT JOIN TRANSACTIONS T ON B.book_id = T.book_id
GROUP BY B.category
ORDER BY percentage_contribution DESC;










