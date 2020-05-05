/*
Show all Project information for projects located in New York or New Jersey.
*/

SELECT * FROM project
WHERE project_location IN ("NJ", "NY");



/*
Show all Project information for projects managed by a department located in New York 
*/

SELECT * FROM project
WHERE departmentid IN(
SELECT  departmentid
FROM department
WHERE department_location = "NY");



/*
Show all employees whose first name contains the letters ‘ar’
*/
SELECT *
FROM employee
WHERE first_name LIKE "*ar*";



/*
Show all employees whose name contains the letter 'a' and the letter 'r' in that order
*/

SELECT *
FROM employee
WHERE first_name LIKE "*a*r*";



/*
Show all employees whose name contains the letter 'a' and the letter 'r' in any order
*/

SELECT *
FROM employee
WHERE first_name LIKE "*a*r*" or first_name LIKE "*r*a*";



/*
Show total of salary paid and department_name in each department but only show those with total salary greater than 50000
*/

SELECT d.department_name, SUM(salary)
FROM employee e, department d
WHERE e.departmentid= d.departmentid 
GROUP BY d.department_name
HAVING SUM(salary) > 50000;



/*
Show total of salaries paid by each department but only if the total is greater than the average paid by each department
*/

SELECT d.department_name, SUM(salary)
FROM employee e, department d
WHERE e.departmentid = d.departmentid
GROUP BY d.department_name
HAVING SUM(salary) > AVG(salary);


/* Recursive Queries */

/*
Provide a listing of each student and the name of their tutor
*/

SELECT s.name AS student, t.name AS Tutor
FROM students s, students t
WHERE s.student_Tutorid = t.studentid;



/*
We don’t see who is tutoring Bill Smith, how do we solve this issue
*/

/* No value as Bill’s tutor. */
SELECT s.name AS Student, t.name AS Tutor
FROM students s LEFT JOIN students t
ON s.student_Tutorid = t.studentid;

/* Show “NO Tutor” */
SELECT s.name AS Student,NZ( t.name, "NO Tutor") AS Tutor
FROM students s LEFT JOIN students t
ON s.student_Tutorid = t.studentid;



/*
Finding students who do not tutor anyone?
*/

SELECT s.name AS Student, t.name AS Tutor
FROM students s RIGHT JOIN students t
ON s.student_Tutorid = t.studentid;



/*
How many students does each tutor work with ?
*/

SELECT  t.name, COUNT(s.student_Tutorid) AS num_tutored
FROM students s, students t
WHERE s.student_Tutorid = t.studentid
GROUP BY t.name;



/*
What is the largest number of students one person tutors?
*/

SELECT MAX(a.num_tutored)
FROM (
SELECT t.name, COUNT(s.student_tutorid) AS num_tutored
FROM students s, students t
WHERE s.student_tutorid = t.studentid
GROUP BY t.name) AS a;
