/*CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP timestamp NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);
*/

-- management wants to see the users that did not login in past 6 months
--CURRENT_DATE + INTERVAL '-6 months'
select user_id from (select user_id, (max(login_timestamp) < CURRENT_DATE + INTERVAL '-6 months') as active from logins
group by user_id
order by user_id) A 
where A.active='t';

 -- another method
select user_id, max(login_timestamp) as last_login from logins
group by user_id
having max(login_timestamp) < CURRENT_DATE + INTERVAL '-6 months'
order by user_id;

--another method
select distinct user_id from logins where user_id not in 
(select user_id from logins where login_timestamp > CURRENT_DATE + INTERVAL '-6 months')


-- Question2 for the quarterly analysis calculate the number of users and sessions, return first date of quarter

select date_part('quarter', login_timestamp) as quarter_number,
count(distinct user_id) as user_cnt, count(session_id) as session_cnt,
date_trunc('quarter',min(login_timestamp)) as first_login
from logins
group by date_part('quarter', login_timestamp)

-- Question 3 display user ids that logged in Jan 2024 and did not log in Nov 2023
with cte as (select distinct user_id from logins 
where login_timestamp between '2024-01-01' and '2024-01-31'
and user_id not in (select user_id from logins where login_timestamp between '2023-11-01' and '2023-11-30'))
select c.user_id, u.user_name from cte c inner join users u on c.user_id=u.user_id;

--Question 4 Add to the query number 2 the percentage change in sessions from last quarter

with cte as (select date_part('quarter', login_timestamp) as quarter_number,
count(distinct user_id) as user_cnt, count(session_id) as session_cnt,
date_trunc('quarter',min(login_timestamp)) as first_login
from logins
group by date_part('quarter', login_timestamp))
select *, (session_cnt - lag(session_cnt,1) over(order by first_login)) * 100.0/ lag(session_cnt,1) over(order by first_login) as pct_change
from cte


-- Question 5 display the user id that has highest session score for each day

with cte as (select user_id, login_timestamp::date as login_date, sum(session_score) highest_score from logins
group by user_id, login_timestamp::date)
select * from (
select *, rank() over(partition by login_date order by highest_score desc) as rn 
from cte) A
where A.rn =1


--Question 6 to identify the best users return the user ids who had a session on every single day since first login
-- consider 2024-06-28 as last day
with cte as (select user_id, min(login_timestamp::date) as first_login,
   '2024-06-28' -  min(login_timestamp::date) + 1 as no_of_logins_reqd,
    count(distinct login_timestamp::date) as no_of_logins
from logins
GROUP by user_id
order by user_id)
select * from cte where no_of_logins_reqd = no_of_logins;


-- Question 7 On what days there were no log ins at all


WITH RECURSIVE cte AS (
    -- Anchor member: Start with the minimum login date
    SELECT min(login_timestamp::date) AS first_date, '2024-06-28'::date AS last_date
    FROM logins

    UNION ALL

    -- Recursive member: Generate dates until last_date
    SELECT (first_date + INTERVAL '1 day')::date AS first_date, last_date
    FROM cte
    WHERE first_date < last_date
)
SELECT first_date
FROM cte where first_date not in (select login_timestamp::date from logins);
