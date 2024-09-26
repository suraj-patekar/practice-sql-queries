/*CREATE TABLE employees  (employee_id int,employee_name varchar(15), email_id varchar(15) );

delete from employees;

INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('101','Liam Alton', 'li.al@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('102','Josh Day', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('103','Sean Mann', 'se.ma@abc.com'); 
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('104','Evan Blake', 'ev.bl@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('105','Toby Scott', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('106','Anjali Chouhan', 'JO.DA@ABC.COM');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('107','Ankit Bansal', 'AN.BA@ABC.COM');*/

--from the duplicate email ids return email id with lower case only 
with cte as (select *, rank() over(partition by lower(email_id) order by ASCII(email_id) desc) rn
from employees)
select employee_id, employee_name, email_id from cte where rn=1 order by employee_id;

