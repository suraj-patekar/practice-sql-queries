/*CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');*/

--remove the duplicate routes and keep the first valuecity_distance
with cte as (select * ,
ROW_NUMBER() over(order by (select NULL)) as rn
from city_distance)
select c1.* from cte c1 left join cte c2
on c1.source=c2.destination and c1.destination=c2.source
where c1.rn < c2.rn or c2.distance is null or c1.distance != c2.distance