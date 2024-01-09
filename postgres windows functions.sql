-- Window functions

SELECT first_name, department, 
	COUNT(*) OVER(PARTITION BY department) 
FROM employees;

SELECT ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC), first_name, salary, department
FROM employees
WHERE 1=1
AND department =  'Sports';

SELECT first_name, department, hire_date, salary,
	SUM(salary) OVER(ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS suming
FROM employees;
-- OR:
SELECT first_name, department, hire_date, salary,
	SUM(salary) OVER(ORDER BY hire_date) AS suming
FROM employees;

-- INCREASING:
SELECT ROW_NUMBER () OVER(PARTITION BY department ORDER BY hire_date), 
	first_name, department, hire_date, salary,
	SUM(salary) OVER(PARTITION BY department ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS suming
FROM employees;

-- ANOTHER WAY:
SELECT first_name, department, hire_date, salary,
	SUM(salary) OVER(ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS suming
FROM employees;

-- Working with RANK(), NTILE(), FIRST_VALUE(), NTH_VALUE()
SELECT first_name, department, salary,
	RANK() OVER(PARTITION BY department ORDER BY salary DESC) rank_dpt_salary,
	NTILE(5) OVER(PARTITION BY department ORDER BY salary DESC) braket_dpt_salary,
	FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) f_value,
	NTH_VALUE(salary, 3) OVER(PARTITION BY department ORDER BY salary DESC) nth_value
FROM employees;

-- Working with LEAD() and LAG()
SELECT first_name, department, 
	LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) last_salary,
	salary,
	LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC) next_salary
FROM employees