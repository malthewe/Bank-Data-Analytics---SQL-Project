# Bank-Data-Analytics---SQL-Project
This project demonstrates how to analyze bank-related data using SQL queries.   It focuses on exploring customer behavior, transaction patterns, and basic fraud indicators using a simplified banking dataset.

The dataset contains three tables:  
- **Customers:** Information about bank customers  
- **Accounts:** Customer accounts with types and dates  
- **Transactions:** Deposits and withdrawals linked to accounts  

The goal is to extract insights from the data to support business decisions such as identifying active customers, monitoring transaction trends, and detecting potential suspicious activity.

## Data Model

| Table       | Columns                                   | Description                         |
|-------------|-------------------------------------------|-----------------------------------|
| Customers   | CustomerID (PK), Name, Age, City, JoinDate | Bank customers' personal info     |
| Accounts    | AccountID (PK), CustomerID (FK), AccountType, OpenDate, CloseDate | Customer accounts                |
| Transactions| TransactionID (PK), AccountID (FK), TransactionDate, Amount, TransactionType | Money movements on accounts       |

## Potential Extensions

- Connect this dataset to Power BI or Tableau to build dashboards and storytelling reports.  
- Extend the schema with more granular data like loan details or credit scores.  
- Implement more advanced analytics or fraud detection querie
