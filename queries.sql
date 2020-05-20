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



/*
Who has the highest salary at the company?
*/

SELECT first_name, Last_name, Salary
FROM employee
WHERE salary = 
(select MAX(salary) FROM employee);



/*
Who has the highest paid salary in New York ?
*/

SELECT top 1 e.first_name, e.last_name, d.department_location, salary
FROM employee e
INNER JOIN department d 
ON e.departmentid = d.departmentid
WHERE d.department_location = "NY"
ORDER BY salary DESC;



/*
Which employees make more than the average salary?
*/

SELECT first_name, last_name, salary
FROM employee 
WHERE salary > (SELECT AVG(salary) FROM employee);



/*
For each project show 
Total employee working on the project
the total number of hours spent on the project per week
*/

SELECT project_number, count(employeeid),sum(hours_per_week)
FROM project_assignment
GROUP BY project_number;



/*
For each employee,
show the total number of projects
and also total numbers of hours spent on the projects
*/

SELECT employeeid, COUNT(project_number), sum(hours_per_week)
FROM project_assignment
GROUP BY employeeid;



/*
Show all of the project and department information for all projects.
*/

SELECT p.*, d.*
FROM project p, department d
WHERE p.departmentid = d.departmentid;



/*
Show all of the project and department information for all projects except where the project and department are in two different locations.
*/

SELECT p.*, d.*
FROM project p
INNER JOIN department d ON p.departmentid = d.departmentid
WHERE p.project_location <>d.department_location;



/*
Show all of the projects name and their total hours worked per week.
*/

SELECT p.project_name,  SUM(hours_per_week)
FROM project p
INNER JOIN project_assignment a ON p.project_id = a.project_number
GROUP BY p.project_name;



/*
Show the projects and the total hours worked per week only for those projects totalling more than 30 hours per week.
*/

SELECT p.project_name,  SUM(hours_per_week)
FROM project p
INNER JOIN project_assignment a ON p.project_id = a.project_number
GROUP BY p.project_name
having SUM(a.hours_per_week)>30;



/*
Show the project and the total hours worked per week only for the project with the most total hours
*/

SELECT top 1 p.project_name,  SUM(hours_per_week)
FROM project p
INNER JOIN project_assignment a ON p.project_id = a.project_number
GROUP BY p.project_name
ORDER BY sum(hours_per_week) DESC;



/*
Show each employee and project including the number of hours they work on each project.
*/

SELECT first_name, last_name, project_name, hours_per_week
FROM (employee e INNER JOIN project_assignment pa
ON e.employeeid = pa.employeeid) INNER JOIN project p
ON pa.project_number = p.project_id;



/*
Show name of the department with the largest total salary and its total salary.
*/

SELECT department_name, SUM(salary)
FROM employee e, department d
WHERE e.departmentid = d.departmentid
GROUP BY department_name
HAVING SUM(salary) 
= (
SELECT MAX(totalsalary)
FROM (SELECT department_name, SUM(salary) AS totalsalary
FROM employee e, department d
WHERE e.departmentid = d.departmentid
GROUP BY department_name)
);



/*
Show maximum number of people one person is tutoring
*/

SELECT top 1 t.name, a.num_tutored
FROM (
SELECT t.name, COUNT(s.student_tutorid) AS num_tutored
FROM students s, students t
WHERE s.student_tutorid = t.studentid
GROUP BY t.name) AS a
ORDER BY a.num_tutored DESC;



/*
Which department name has combined payroll of more than $85,000?
*/

SELECT department_name, totalsalary FROM
(SELECT department_name, sum(salary) AS totalsalary
FROM employee e, department d
WHERE e.departmentid = d.departmentid
GROUP BY department_name)
WHERE totalsalary > 85000;



/*
Show the employees name that contribute to projects that  are worked on more than 30 hours per week
*/

SELECT e.last_name, e.first_name, pw.total_hours
FROM
(SELECT project_number, SUM(hours_per_week) AS total_hours
FROM project_assignment
Group BY project_number
having sum(hours_per_week) > 30) pw,
employee e, project_assignment pa
WHERE pw.project_number = pa.project_number
AND pa.employeeid = e.employeeid;



/*
Who is the highest paid employee?
*/

/* Solution 1: using top 1 */
SELECT top 1 First_name,last_name
FROM employee
ORDER BY salary DESC;

/* Solution 2: using NOT EXISTS */
SELECT e1.First_name, e1.last_name
FROM employee e1
WHERE NOT EXISTS (
SELECT *
FROM employee e2
WHERE e1.salary < e2.salary
);


/*
Show all of the employees except the highest paid.
*/

SELECT First_name, last_name
FROM  employee
WHERE salary NOT IN
(SELECT top 1 salary
FROM employee
ORDER BY salary DESC);



/*
Which employee (names) has the highest working hours on a project?
*/

/* Solution 1: using sub-query */
SELECT e.Last_name, e.first_name
FROM employee e, project_assignment pa
WHERE e.employeeid = pa.employeeid
AND pa.hours_per_week =
(SELECT top 1 hours_per_week
FROM project_assignment
ORDER BY hours_per_week DESC);

/* solution 2: using NOT EXISTS */

SELECT e1.first_name, e1.last_name, pa.hours_per_week
FROM employee e1, project_assignment pa
WHERE e1.employeeid = pa.employeeid AND
NOT EXISTS (
SELECT employeeid, hours_per_week
FROM project_assignment pa1
WHERE pa.hours_per_week < pa1.hours_per_week)
AND pa.hours_per_week is NOT NULL;


