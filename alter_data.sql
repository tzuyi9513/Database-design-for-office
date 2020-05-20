/* 
Make Ed Jones's salary $40,000 
*/

UPDATE employee
SET salary = 40000
WHERE employeeid = 'E103’; 



/*
Give everyone in department 1 a 2% raise.
*/

UPDATE employee
SET salary =salary * 1.02
WHERE departmentid = 1;



/*
All employees who work on the Web Site Design project get a 5% raise.
*/

Update employee
set salary = salary*1.05
WHERE employeeid in
(select employeeid 
from project_assignment pa inner join project p
on pa.project_number = p.project_id
where project_name = "WebSiteDesign"
)



/*
Remove Ed from the Inventory project
*/

DELETE FROM project_assignment
WHERE employeeid = 'E103' 
AND project_number = 20
; 



/*
Remove Ed from the employee table
*/
/* Find relationship between project_assignment and employee, and delete records in project_assignment first*/
DELECT project_assignment
WHERE employee = ‘E103’ AND project IN (1,2);
/* Delete data in employee table after deleting in project_assignment table*/
DELETE FROM employee
WHERE employeeid = ‘E103’;



/*
Show all project information (using union)
*/

SELECT * FROM project
UNION
SELECT * FROM additional_projects;
