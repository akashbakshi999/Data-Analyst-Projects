create database zomato_analytics;
use zomato_analytics;
#-----------------------------------EMP, DEPT CASE STUDY-----------------------------------------------------------

#Question 1

CREATE TABLE employee (
	emp_no int primary key,
	ename varchar(30),
	job varchar(30) default "Clerk",
	mgr int,
	hiredate date,
	salary float CHECK (salary>0),
	comm float,
	`dept_no` int);
desc employee;

INSERT INTO employee VALUES
(7369,"SMITH","CLERK",7902,'1890-12-17',800.00, Null, 20),
(7499,"ALLEN","SALESMAN",7698,'1981-02-20',1600.00,300.00,30),
(7521,'WARD','SALESMAN',7698,'1981-02-22',1250.00,500.00,30),
(7566,'JONES','MANAGER',7839,'1981-04-02',2975.00,Null,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250.00,1400.00,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850.00, Null,30),
(7782,'CLARK','MANAGER',7839,'1981-06-09',2450.00,Null,10),
(7788,'SCOTT','ANALYST',7566,'1987-04-19',3000.00, Null,20),
(7839,'KING','PRESIDENT',Null,'1981-11-17',5000.00,Null,10),
(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500.00,0.00,30),
(7876,'ADAMS','CLERK',7788,'1987-05-23',1100.00,Null,20),
(7900,'JAMES','CLERK',7698,'1981-12-03',950.00,Null,30),
(7902,'FORD','ANALYST',7566,'1981-12-03',3000.00,Null,20),
(7934,'MILLER','CLERK',7782,'1982-01-23',1300.00,Null,10);

select * from employee;

#Question 2

CREATE TABLE Department (deptid int primary key, dname varchar(30),loc varchar(30));
desc Department;

INSERT INTO Department VALUES
(10,'OPERATIONS','BOSTON'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'ACCOUNTING','NEW YORK');

SELECT * from Department;		

ALTER TABLE employee
ADD FOREIGN KEY (`dept_no`)
references Department(deptid);


#Question 3

# List the Names and salary of the employee whose salary is greater than 1000

SELECT 
	ename,
    salary 
FROM employee
WHERE salary>1000;


#Question 4

# 	List the details of the employees who have joined before end of September 81.

SELECT 
	emp_no,
    ename as employee,
    hiredate
FROM employee
WHERE hiredate<'1981-09-30';


#Question 5

# List Employee Names having I as second character.

SELECT
ename 
FROM employee
WHERE ename LIKE '_I%';


#Question 6

# List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns

SELECT 
	ename as employee_name, 
    salary, 
	(0.4*salary) as allowances,
	(0.1*salary) as `P.F.`
FROM employee;


#Question 7

# List Employee Names with designations who does not report to anybody?

SELECT DISTINCT employee_name,designation 
FROM
(SELECT
a.ename AS employee_name,
a.job AS designation 
FROM
employee AS a JOIN employee as b
ON a.emp_no=b.mgr
WHERE a.mgr IS NULL) AS `emp_donot_report`;

# Question 8

# List Empno, Ename and Salary in the ascending order of salary?

SELECT 
	emp_no,
    ename,
    salary
FROM employee
ORDER BY salary ASC;

#Question 9

# How many jobs are available in the Organization ?

SELECT 
	COUNT(distinct (job)) AS `Number of Jobs`
FROM employee;


#Question 10

# Determine total payable salary of salesman category?

SELECT
	job, 
    SUM(salary) AS `salesmen_salary`
FROM employee
WHERE job="SALESMAN"
GROUP BY job;



#Question 11

# List average monthly salary for each job within each department?   

SELECT
	employee.job, 
	department.dname as department, 
	AVG(employee.salary) as `Avg_salary`
FROM 
employee INNER JOIN department
ON employee.`dept_no`=department.deptid
GROUP BY job,department;


#Question 12

#Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working?


SELECT
	employee.ename AS emp_name,
    department.dname as emp_department,
    employee.salary AS emp_salary
FROM 
employee INNER join department
ON 
employee.`dept_no`=department.deptid;


#Question 13

# Create the Table Job Grades?

CREATE TABLE `Job Grades` 
(Grade varchar(5), 
`lowest_Sal` float,
`highest_sal` float);

INSERT INTO `Job Grades` VALUES
('A',0,999),
('B',1000,1999),
('C',2000,2999),
('D',3000,3999),
('E',4000,5000);

select * from `Job Grades`;
select * from employee;

#Question 14

# Display the last name, salary and  Corresponding Grade?

SELECT
	emp_details.ename as employee_name,
    emp_details.salary as employee_salary,
    `Job Grades`.grade as employee_grade
FROM
(SELECT
	*,
    if(salary<1000,999,if(salary<2000,1999,
		if(salary<3000,2999,if(salary<4000,3999,5000)))) as high_salary
FROM employee) as emp_details 
INNER JOIN 
`Job Grades`
ON emp_details.high_salary=`Job Grades`.highest_sal;


# other method

SELECT
	ename,
    salary,
    IF(salary<1000,"A",IF(salary<2000,"B",
		IF(salary<3000,"C",IF(Salary<4000,"D","E")))) as Grade
FROM employee;


#Question 15

# Display the Emp name and the Manager name under whom the Employee works in the below format?

select * from employee;

SELECT 
	b.ename AS Emp, 
    a.ename AS Manager 
FROM
employee AS a JOIN employee AS b
ON
a.emp_no=b.mgr
ORDER BY Manager;


#Question 16

# Display Empname and Total sal where Total Sal (sal + Comm)?


SELECT
	ename AS Empname, 
    IF(comm IS NULL,salary, salary+comm) AS `Total Sal`
FROM
employee;


#Question 17

#	Display Empname and Sal whose empno is a odd number?

SELECT 
	emp_no,
    ename AS emp_name, 
    salary AS emp_salary
FROM 
employee
WHERE emp_no % 2 <> 0;

#Question 18

# Display Empname , Rank of sal in Organisation , Rank of Sal in their department?

SELECT 
	emp_details.ename AS emp_name,
    emp_details.dname AS emp_department, 
    dense_rank() over(partition by dname order by salary desc) AS rank_sal_dept,
	dense_rank() over(order by salary desc) as rank_sal_org 
FROM
(SELECT 
	employee.ename, 
    department.dname,
    employee.salary
 FROM 
 employee INNER JOIN department
 ON 
 employee.`dept_no`=department.deptid) AS emp_details
ORDER BY emp_department;

#Question 19

#	Display Top 3 Empnames based on their Salary?

SELECT
 ename,
 salary
FROM employee
ORDER BY salary DESC
LIMIT 3;

#Question 20

# Display Empname who has highest Salary in Each Department?

SELECT
	salary_wise_rank.emp,
    salary_wise_rank.Department, 
    salary_wise_rank.rank_sal_dept, 
    salary_wise_rank.rank_sal_org 
FROM
(SELECT
	a.ename AS emp,
    a.dname AS Department, 
    dense_rank() over(partition by dname order by salary desc) AS rank_sal_dept,
	dense_rank() over(order by salary desc) AS rank_sal_org 
FROM
(SELECT * 
 FROM 
 employee INNER JOIN department
 ON
 employee.`dept_no`=department.deptid) AS a
 ORDER BY department) AS salary_wise_rank
 WHERE salary_wise_rank.rank_sal_dept=1;
 
 






