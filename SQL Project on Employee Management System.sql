CREATE DATABASE EMPLOYEE_MANAGEMENT_SYSTEM;
USE EMPLOYEE_MANAGEMENT_SYSTEM;

-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
SELECT * FROM JOBDEPARTMENT;


-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
SELECT * FROM SALARYBONUS;


-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
SELECT * FROM EMPLOYEE;


-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
SELECT * FROM QUALIFICATION;


-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
SELECT * FROM LEAVES;


-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);
SELECT * FROM Payroll;

						-- EMPLOYEE INSIGHTS --

-- 1.How many unique employees are currently in the system?
SELECT count(distinct emp_ID) as Total_Employees FROM EMPLOYEE;

-- 2.Which departments have the highest number of employees? 
SELECT JD.jobdept as Job_Department, COUNT(E.emp_ID) AS Employees_per_Department
FROM JobDepartment JD
JOIN Employee E ON JD.Job_ID = E.Job_ID
GROUP BY Job_Department
ORDER BY Employees_per_Department DESC;

-- 3.What is the average salary per department?
SELECT JD.jobdept as Job_Department, AVG(SB.amount) AS Average_Salary
FROM JobDepartment JD
JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
GROUP BY Job_Department;


-- 4.Who are the top 5 highest-paid employees?
SELECT concat(E.firstname,' ',E.lastname) as Employee_Name, SB.amount
FROM Employee E
JOIN SalaryBonus SB ON E.Job_ID = SB.Job_ID
ORDER BY SB.amount DESC
LIMIT 5;

-- 5.What is the total salary expenditure across the company?
SELECT SUM(SB.annual + SB.bonus) AS Total_Salary_Expenditure
FROM SalaryBonus SB;


					--  JOB ROLE AND DEPARTMENT ANALYSIS  --

-- 6.How many different job roles exist in each department? 
SELECT jobdept as Job_Department, COUNT(DISTINCT name) AS Total_Roles
FROM JobDepartment
GROUP BY Job_Department;

-- 7.What is the average salary range per department?
SELECT jd.jobdept,
AVG(sb.amount) AS avg_salary
FROM JobDepartment jd
JOIN SalaryBonus sb ON jd.Job_ID = sb.Job_ID
GROUP BY jd.jobdept;

-- 8.Which job roles offer the highest salary?
SELECT JD.name as Job_Role, JD.jobdept as Job_Department, SB.amount
FROM JobDepartment JD
JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
ORDER BY SB.amount DESC
LIMIT 5;


-- 9.Which departments have the highest total salary allocation? 
SELECT JD.jobdept as Job_Department, SUM(SB.annual + SB.bonus) AS Total_Salary_Allocation
FROM JobDepartment JD
JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
GROUP BY Job_Department
ORDER BY Total_Salary_Allocation DESC;



					--  QUALIFICATION AND SKILLS ANALYSIS --

-- 10.How many employees have at least one qualification listed? 
SELECT COUNT(DISTINCT Emp_ID) AS qualified_employees
FROM Qualification;


-- 11.Which positions require the most qualifications? 
SELECT Position, COUNT(*) AS No_Of_Qualifications
FROM Qualification
GROUP BY Position
ORDER BY No_Of_Qualifications DESC;


-- 12.What is the average number of qualifications per department? 
SELECT JD.jobdept as Job_Department, AVG(K.qual_count) AS Avg_Qualifications
FROM
    (SELECT E.Job_ID, COUNT(Q.QualID) AS qual_count
    FROM Employee E
    LEFT JOIN Qualification Q ON E.emp_ID = Q.Emp_ID
    GROUP BY E.emp_ID , E.Job_ID) AS K
JOIN JobDepartment JD ON JD.Job_ID = K.Job_ID
GROUP BY Job_Department;



					-- LEAVE AND ABSENCE PATTERNS  --

-- 13.Which year had the most employees taking leaves? 
SELECT YEAR(date) AS Year, COUNT(DISTINCT emp_ID) AS Total_Leaves
FROM Leaves
GROUP BY YEAR(date)
ORDER BY Total_Leaves DESC
LIMIT 1;


-- 14.What is the average number of leave days taken by its employees per department? 
SELECT JD.jobdept as Job_Department, AVG(L.leave_days) AS Avg_Leave_Days
FROM (SELECT E.emp_ID, E.Job_ID, COUNT(L.leave_ID) AS leave_days
    FROM Employee E
    JOIN Leaves L ON E.emp_ID = L.emp_ID
    GROUP BY E.emp_ID, E.Job_ID) L
JOIN JobDepartment JD ON JD.Job_ID = L.Job_ID
GROUP BY Job_Department;


-- 15.Which employees have taken the most leaves? 
SELECT concat(E.firstname,' ',E.lastname) as Employee_Name, COUNT(L.leave_ID) AS Total_Leaves
FROM Employee E
JOIN Leaves L ON E.emp_ID = L.emp_ID
GROUP BY E.emp_ID
ORDER BY Total_Leaves DESC
LIMIT 5;


-- 16.What is the total number of leave days taken company-wide?

SELECT COUNT(*) AS Total_Leave_Days
FROM Leaves;


-- 17.How do leave days correlate with payroll amounts? 
SELECT E.emp_ID, COUNT(L.leave_ID) AS Total_Leaves, SUM(P.total_amount) AS Total_Payment
FROM Employee E
LEFT JOIN Leaves L ON E.emp_ID = L.emp_ID
LEFT JOIN Payroll P ON E.emp_ID = P.emp_ID
GROUP BY E.emp_ID;



					-- PAYROLL AND COMPENSATION ANALYSIS --
                    
-- 18.What is the total monthly payroll processed?
SELECT DATE_FORMAT(date, '%Y-%m') AS Payroll_Month, SUM(total_amount) AS Total_Monthly_Payroll
FROM Payroll
GROUP BY Payroll_Month
ORDER BY Payroll_Month DESC;


-- 19.What is the average bonus given per department?
SELECT JD.jobdept as Job_Department, AVG(SB.bonus) AS Avg_Bonus
FROM JobDepartment JD
JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
GROUP BY Job_Department;


-- 20.Which department receives the highest total bonuses?
SELECT JD.jobdept as Job_Department, SUM(SB.bonus) AS Total_Bonus
FROM JobDepartment JD
JOIN SalaryBonus SB ON JD.Job_ID = SB.Job_ID
GROUP BY Job_Department
ORDER BY Total_Bonus DESC
LIMIT 1;


-- 21.What is the average net salary after all deductions? 
SELECT AVG(total_amount) AS Avg_Net_Salary
FROM Payroll;



					-- EMPLOYEE PERFORMANCE AND GROWTH --

-- 22.Which year had the highest number of employee promotions?
SELECT YEAR(Date_In) AS Year, COUNT(*) AS Promotions
FROM Qualification
GROUP BY YEAR(Date_In)
ORDER BY promotions DESC
LIMIT 1;
