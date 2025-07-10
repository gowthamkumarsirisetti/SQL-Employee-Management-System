# 🧾 Employee Management System – SQL Project

This project is a comprehensive **SQL-based Employee Management System** designed to simulate a real-world HR database. It manages everything from employee records, job departments, payroll, qualifications, and leave history to insightful queries for business analytics.

---

## 📂 Project Structure

| Table | Description |
|-------|-------------|
| `JobDepartment` | Stores department and job role metadata |
| `SalaryBonus` | Holds salary, bonus, and annual compensation info |
| `Employee` | Main employee master table |
| `Qualification` | Tracks employee positions and skill upgrades |
| `Leaves` | Records employee leave data |
| `Payroll` | Stores payment reports, salaries, and deductions |

---

## 🧠 Key Features & Queries

- 🧮 **Total employees, departments, salary distributions**
- 📊 **Department-wise payroll analysis**
- 🏆 **Top-paid employees**
- 📅 **Yearly leave patterns**
- 🧾 **Monthly payroll reports**
- 🔍 **Qualification & promotion insights**

---

## 📌 Sample SQL Insights

-- Top 5 highest paid employees
SELECT concat(firstname,' ',lastname) AS Employee_Name, amount
FROM Employee E JOIN SalaryBonus SB ON E.Job_ID = SB.Job_ID
ORDER BY amount DESC LIMIT 5;

-- Average salary per department
SELECT jobdept, AVG(amount) AS avg_salary
FROM JobDepartment JD JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
GROUP BY jobdept;

## 🛠 How to Use
1. Open any SQL IDE like MySQL Workbench, DBeaver, or SQL Server
2. Run the provided .sql file
3. Execute individual query blocks for insights and testing

<img width="949" height="660" alt="image" src="https://github.com/user-attachments/assets/3ba74608-1bd8-4cc2-8506-fae8b952ddd2" />

## 🪪 License
This project is open-sourced under the MIT License — feel free to explore, modify, and reuse.

## 🙌 Author
Gowtham
SQL Developer & Data Enthusiast
📧 gowthamsirisetti@gmail.com
