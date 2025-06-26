# oracle-library-system-22303297

📚 University Library Management System
Final Project – Database (Oracle) Course

📝 Overview
This project represents the final assignment for the Database course. It showcases the design and implementation of a complete University Library Management System using Oracle Database technologies, covering everything from schema design to security and performance optimization.

🎯 Assignment Objectives
This assignment demonstrates the ability to:

✅ Design and implement a complete relational database system

✅ Apply ER modeling and normalization principles

✅ Develop complex SQL queries and PL/SQL programs

✅ Implement security, performance tuning, and user access control

🎓 Learning Outcomes Achieved
Learning Area	Description
Database Design	Applied ER modeling and normalization techniques
SQL Mastery	Performed DML, DDL, DCL, TCL operations
PL/SQL Programming	Developed stored procedures, functions, and triggers
Database Administration	Implemented user management and indexing strategies

📦 Assignment Deliverables
✅ Part 1: Database Design & Setup (15 Marks)
Created core tables: BOOKS, MEMBERS, and TRANSACTIONS

Applied primary/foreign key constraints and integrity rules

Inserted 20 books, 15 members, and 25 transactions as sample data

✅ Part 2: Basic SQL Operations (20 Marks)
Retrieved available books, overdue members, and most borrowed titles

Performed data manipulation: adding new members, updating fines, archiving transactions

✅ Part 3: Advanced SQL Queries (25 Marks)
Implemented various JOIN operations (INNER, LEFT, SELF, CROSS)

Used subqueries for member fines, usage stats, borrowing patterns

Applied aggregate and window functions for analytical reports

✅ Part 4: PL/SQL Programming (25 Marks)
Developed ISSUE_BOOK procedure for book issuance logic

Created CALCULATE_FINE function for overdue fines

Wrote UPDATE_AVAILABLE_COPIES trigger to manage book inventory in real-time

✅ Part 5: Database Administration (15 Marks)
Configured user roles (librarian, student_user) and privileges

Applied indexing strategies and execution plan analysis for performance

🛠️ Technologies Used
Component	Technology
Database	Oracle
SQL	DML, DDL, DCL, TCL
Procedural Language	PL/SQL
Tools	Oracle SQL Developer / SQL*Plus

⭐ Key Features
📖 Book Management
Track complete book metadata: Title, Author, ISBN, Category, etc.

Monitor total and available copies

Categorize books for efficient filtering

👤 Member Management
Store detailed member profiles (students, faculty, staff)

Track membership status, type, and contact information

🔁 Transaction Management
Maintain full lending/return history

Capture issue, return, and due dates

Automate fine calculation and payment status

📊 Advanced Queries & Reporting
Identify overdue books and frequent borrowers

Retrieve underutilized resources (least borrowed books)

Generate ranked lists using RANK(), LAG(), NTILE()

🧠 PL/SQL Logic
ISSUE_BOOK Procedure: Validates availability, creates transaction, updates stock

CALCULATE_FINE Function: Calculates overdue fine at ₹5 per day

Trigger on Return: Auto-updates available copies in BOOKS

🔐 User Access & Security
librarian: Full CRUD access on all entities

student_user: Read-only access to BOOKS table

Role-based privileges and data security enforcement

🚀 Performance Optimization
Indexing applied on frequently searched fields (e.g., member_id, book_id)

Execution plans reviewed to identify slow queries

Optimized joins and subqueries for large data volumes

📂 Project Folder Structure
pgsql
Copy
Edit
oracle-library-system-[student-id]/
│
├── README.md             # Documentation (this file)
└── sql/
    ├── setup.sql         # Tables, constraints, and sample data
    ├── queries.sql       # SQL queries for Part 2 & 3
    ├── plsql.sql         # PL/SQL procedures, functions, triggers
    └── admin.sql         # User creation, privileges, indexing
📁 File Details
setup.sql
DDL for BOOKS, MEMBERS, TRANSACTIONS

Constraints: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE

Sample data insertions

queries.sql
Data retrieval: available books, overdue returns, top borrowers

Data updates: fines, new members, archived transactions

Subqueries, joins, and analytical reports

plsql.sql
ISSUE_BOOK procedure

CALCULATE_FINE function

Trigger for updating available_copies

admin.sql
Role and user creation

Privilege assignments

Indexing and optimization commands

🚦 How to Execute
Connect to Oracle Database

bash
Copy
Edit
sqlplus username/password@DB
Run files sequentially:

sql
Copy
Edit
@sql/setup.sql     -- Schema & data
@sql/queries.sql   -- Queries
@sql/plsql.sql     -- Procedures & triggers
@sql/admin.sql     -- Roles & tuning
🧬 Database Schema Overview
BOOKS
book_id, title, author, publisher, isbn, category, total_copies, available_copies, price

MEMBERS
member_id, first_name, last_name, email, phone, address, membership_date, membership_type

TRANSACTIONS
transaction_id, member_id, book_id, issue_date, due_date, return_date, fine_amount, status

✅ Requirement Summary
Category	Covered
Sample Data (20 books, 15 members, 25 transactions)	✅ Yes
Queries: Availability, Fines, Rankings, Trends	✅ Yes
PL/SQL: Procedure, Function, Trigger	✅ Yes
User Management: Roles & Access	✅ Yes
Optimization: Indexing, Plans	✅ Yes
