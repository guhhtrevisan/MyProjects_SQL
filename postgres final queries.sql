-- 1) Write a query that finds students who do not take CS180.

SELECT *
FROM students s
LEFT JOIN student_enrollment se
ON s.student_no = se.student_no
WHERE 1=1
AND student_name NOT IN (SELECT student_name
						FROM students s
						JOIN student_enrollment se
						ON s.student_no = se.student_no 
						WHERE course_no IN ('CS180'));


-- 2)Write a query to find students who take CS110 or CS107 but not both.

(SELECT student_name, course_no
FROM students s
JOIN student_enrollment se
ON s.student_no = se.student_no
WHERE 1=1
AND student_name IN (SELECT student_name 
					FROM students s
					JOIN student_enrollment se
					ON s.student_no = se.student_no
					WHERE course_no IN ('CS110'))
EXCEPT
SELECT student_name, course_no
FROM students s
JOIN student_enrollment se
ON s.student_no = se.student_no
WHERE 1=1
AND student_name IN (SELECT student_name 
					FROM students s
					JOIN student_enrollment se
					ON s.student_no = se.student_no
					WHERE course_no IN ('CS210')) )
UNION ALL
(SELECT student_name, course_no
FROM students s
JOIN student_enrollment se
ON s.student_no = se.student_no
WHERE 1=1
AND student_name IN (SELECT student_name 
					FROM students s
					JOIN student_enrollment se
					ON s.student_no = se.student_no
					WHERE course_no IN ('CS210'))
EXCEPT
SELECT student_name, course_no
FROM students s
JOIN student_enrollment se
ON s.student_no = se.student_no
WHERE 1=1
AND student_name IN (SELECT student_name 
					FROM students s
					JOIN student_enrollment se
					ON s.student_no = se.student_no
					WHERE course_no IN ('CS110')) );

						  
-- Answer B:
SELECT s.student_no, s.student_name, s.age
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
GROUP BY s.student_no, s.student_name, s.age
HAVING SUM(CASE WHEN se.course_no IN ('CS110', 'CS107') THEN 1 ELSE 0 END ) = 1;
 

-- 3) Write a query to find students who take CS220 and no other courses.

SELECT *
FROM (
	SELECT  student_name, age, course_no, 
			COUNT(course_no) OVER(PARTITION BY student_name) total
	FROM students s
	LEFT JOIN student_enrollment se
	ON s.student_no = se.student_no )tb
WHERE 1=1
AND total < 2
AND (course_no = 'CS220' OR course_no IS NULL)
ORDER BY total DESC;

 
 -- Answer B:
SELECT s.*
FROM students s, student_enrollment se1,
     (SELECT student_no FROM student_enrollment
      GROUP BY student_no
      HAVING count(*) = 1) se2
WHERE s.student_no = se1.student_no
AND se1.student_no = se2.student_no
AND se1.course_no = 'CS220';


/* 4) Write a query that finds those students who take at most 2 courses. 
Your query should exclude students that don't take any courses as well as those that take more than 2 course */

SELECT *
FROM (
	SELECT  student_name, age, course_no, 
			COUNT(course_no) OVER(PARTITION BY student_name) total
	FROM students s
	JOIN student_enrollment se
	ON s.student_no = se.student_no )tb
WHERE 1=1
AND total > 0 AND total < 3
ORDER BY total DESC;


-- 5) Write a query to find students who are older than two other students.

SELECT student_no, student_name, age
FROM students
WHERE 1=1
AND age > (SELECT MIN(age)
		FROM students s
		WHERE age > (SELECT MIN(age) FROM students) )
ORDER BY age DESC;