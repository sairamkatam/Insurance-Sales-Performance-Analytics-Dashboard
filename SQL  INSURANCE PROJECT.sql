create database insurance56;
use insurance56;
select * from invoice11;
select * from meeting11;
select * from opportunity;
select* from fees;
select * from brokerage;
select * from budgets;

-- NO OF INVOICES BY ACCOUNT EXCEUTIVE
select * from invoice11;
select Acc_exec , count(invoice_number) as no_of_invoice_by_acc_exec from invoice11 group by Acc_exec order by count(invoice_number) desc;

-- NO OF MEETINGS BY ACCOUNT EXEX
select * from meeting11;
select acc_exec , count(meeting_date) as meeting_count from meeting11 group by acc_exec;

-- STAGE FUNNEL BY REVENUE
select * from opportunity11;
select stage , sum(revenue_amount) as total_revenue from opportunity11 group by stage order by total_revenue desc;

-- OPEN OPPERTUNITIES TOP 5
select * from opportunity;
select opportunity_name , revenue_amount from opportunity order by revenue_amount desc limit 5;

-- TOP 4 OPPERTUNITY BY REVENUE
select * from opportunity11;
select opportunity_name , revenue_amount from opportunity11 order by revenue_amount desc limit 4;

-- OPPORTUNITY BY PRODUCT_GROUP
select * from opportunity11;
select product_group , count(opportunity_id) as total_opportunities , sum(revenue_amount) as total_revenue
 from opportunity11 group by product_group order by total_revenue desc;

-- COUNT OF MEETING DATE
select year(meeting_date) as meeting_year , count(meeting_date) as total_meetings
from meeting11 group by year(meeting_date) order by meeting_year;

select meeting_year , count(*) meeting_count
from ( select year(str_to_date(meeting_date, '%d-%m-%y')) meeting_year
       from meeting11) t 
group by meeting_year
order by meeting_year;       

----------- cross sell
select sum(`Cross sell bugdet`) as cross_sell_target from budgets;

select 
sum(amount)as achieved_cross_sell
from(
select amount from brokerage where income_class ='cross sell'
UNION ALL
select amount from fees where income_class = 'cross sell'
) as combinedData;
select sum(amount)as invoice_cross_sell from invoice11
where income_class='cross sell'; 

--- new
select sum(`New Budget`)as new_target from budgets;
select
sum(amount) as achieved_new
from(
select amount from brokerage where income_class = 'new'
union all
select amount from fees where income_class = 'new'
) as combinedData;
select sum(amount)as invoice_new from invoice11
where income_class= 'new';


----- renewal
select sum(`Renewal Budget`)as renewal_target from budgets;
select
sum(amount) as achieved_renewal
from (
select amount from brokerage where income_class ='renewal'
union all
select amount from fees where income_class = ' renewal'
) As combinedData;
select sum(amount) as invoice_renewal from invoice11
where income_class='renewal';


    