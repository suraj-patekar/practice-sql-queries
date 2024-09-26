with cte as (select *,
row_number() over(partition by customer_id order by event_date desc) as rn
from subscription_history where event_date < '2020-12-31')
select * from cte where rn = 1 and event != 'C' 
and date(event_date, '+'|| subscription_period || ' months') >= '2020-12-31';