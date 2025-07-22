-- Create tables for Bank Data Analytics project

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    City VARCHAR(50),
    JoinDate DATE
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),
    OpenDate DATE,
    CloseDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(12, 2),
    TransactionType VARCHAR(20),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Insert sample data for Customers

INSERT INTO Customers VALUES
(1, 'Alice Jensen', 34, 'Copenhagen', '2020-02-15'),
(2, 'Bo Hansen', 42, 'Aarhus', '2019-11-20'),
(3, 'Clara Madsen', 28, 'Odense', '2021-06-05'),
(4, 'David Sørensen', 50, 'Copenhagen', '2018-07-12'),
(5, 'Eva Nielsen', 37, 'Aalborg', '2022-01-10');

-- Insert sample data for Accounts

INSERT INTO Accounts VALUES
(1001, 1, 'Checking', '2020-02-16', NULL),
(1002, 1, 'Savings', '2020-03-01', NULL),
(1003, 2, 'Checking', '2019-11-21', NULL),
(1004, 3, 'Checking', '2021-06-06', NULL),
(1005, 4, 'Savings', '2018-07-15', NULL),
(1006, 5, 'Checking', '2022-01-11', NULL);

-- Insert sample data for Transactions

INSERT INTO Transactions VALUES
(5001, 1001, '2024-01-05', 1500.00, 'Deposit'),
(5002, 1001, '2024-01-15', 200.00, 'Withdrawal'),
(5003, 1002, '2024-02-01', 5000.00, 'Deposit'),
(5004, 1003, '2024-01-20', 300.00, 'Withdrawal'),
(5005, 1003, '2024-03-10', 1200.00, 'Deposit'),
(5006, 1004, '2024-02-15', 700.00, 'Deposit'),
(5007, 1004, '2024-02-20', 100.00, 'Withdrawal'),
(5008, 1005, '2024-01-05', 2000.00, 'Deposit'),
(5009, 1006, '2024-03-25', 800.00, 'Deposit'),
(5010, 1006, '2024-04-01', 400.00, 'Withdrawal'),
(5011, 1001, '2024-03-05', 300.00, 'Withdrawal'),
(5012, 1002, '2024-04-10', 1000.00, 'Withdrawal');

-- Queries with comments for Bank Data Analytics project

-- 1. Count total number of customers
SELECT COUNT(*) AS total_customers
FROM Customers;

-- 2. Count total number of accounts
SELECT COUNT(*) AS total_accounts
FROM Accounts;

-- 3. Count total number of transactions
SELECT COUNT(*) AS total_transactions
FROM Transactions;

-- 4. Average age of customers
SELECT ROUND(AVG(Age), 1) AS average_age
FROM Customers;

-- 5. Distribution of account types
SELECT AccountType, COUNT(*) AS count_accounts
FROM Accounts
GROUP BY AccountType;

-- 6. Customers with highest number of transactions in 2024
SELECT c.CustomerID, c.Name, COUNT(t.TransactionID) AS num_transactions
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
JOIN Transactions t ON a.AccountID = t.AccountID
WHERE t.TransactionDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.CustomerID, c.Name
ORDER BY num_transactions DESC
LIMIT 5;

-- 7. Total balance per customer (sum deposits - withdrawals)
SELECT 
  c.CustomerID, 
  c.Name,
  COALESCE(SUM(CASE WHEN t.TransactionType = 'Deposit' THEN t.Amount ELSE 0 END), 0) -
  COALESCE(SUM(CASE WHEN t.TransactionType = 'Withdrawal' THEN t.Amount ELSE 0 END), 0) AS total_balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY c.CustomerID, c.Name
ORDER BY total_balance DESC;

-- 8. New customers per month in 2024
SELECT 
  DATE_FORMAT(JoinDate, '%Y-%m') AS join_month,
  COUNT(*) AS new_customers
FROM Customers
WHERE JoinDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY join_month
ORDER BY join_month;

-- 9. Average transaction amount by type
SELECT TransactionType, ROUND(AVG(Amount), 2) AS avg_amount
FROM Transactions
GROUP BY TransactionType;

-- 10. Identify large transactions over 10,000
SELECT t.TransactionID, a.AccountID, c.Name, t.TransactionDate, t.Amount
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
WHERE t.Amount > 10000;

-- 11. Customers with multiple small withdrawals on same day (>2 withdrawals < 500 DKK)
SELECT 
  c.CustomerID,
  c.Name,
  t.TransactionDate,
  COUNT(*) AS small_withdrawals
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
WHERE t.TransactionType = 'Withdrawal' AND t.Amount < 500
GROUP BY c.CustomerID, c.Name, t.TransactionDate
HAVING COUNT(*) > 2
ORDER BY small_withdrawals DESC;

-- 12. Accounts inactive for 6+ months but with recent large deposits (>5000)
SELECT 
  a.AccountID,
  c.Name,
  MAX(t.TransactionDate) AS last_transaction,
  SUM(CASE WHEN t.TransactionType = 'Deposit' AND t.Amount > 5000 THEN t.Amount ELSE 0 END) AS large_deposit_sum
FROM Accounts a
JOIN Customers c ON a.CustomerID = c.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY a.AccountID, c.Name
HAVING MAX(t.TransactionDate) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
   AND large_deposit_sum > 0;
