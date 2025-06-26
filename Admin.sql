1.

-- 🌟 Optimization Task: Creating Helpful Indexes for Faster Search Operations

-- 🎯 Index on the 'author' column to accelerate author-based book searches
CREATE INDEX ix_author_lookup ON BOOKS(author);

-- 🎯 Index on the 'title' column to speed up title-based search filters
CREATE INDEX ix_title_lookup ON BOOKS(title);

-- 👥 Index on 'member_id' in TRANSACTIONS for quick member-wise transaction lookups
CREATE INDEX ix_member_transaction ON TRANSACTIONS(member_id);

-- 📚 Index on 'book_id' in TRANSACTIONS for book-based transaction filtering
CREATE INDEX ix_book_transaction ON TRANSACTIONS(book_id);



-- 🔍 Query Analyzer: Check Execution Strategy for Author-based Book Retrieval

-- 🛠️ This shows the internal execution plan MySQL uses to find books by specific author
EXPLAIN 
SELECT * 
FROM BOOKS 
WHERE author = 'John Smith';





