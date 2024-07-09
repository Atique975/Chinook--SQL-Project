/*
Question #1:
Write a solution to find the employee_id of managers with at least 2 direct reports.


Expected column names: employee_id

*/

-- q1 solution:

SELECT employee_id
FROM employee
WHERE employee_id IN (
    SELECT reports_to
    FROM employee
    GROUP BY reports_to
    HAVING COUNT(*) >= 2
);
 -- replace this with your query


/*

Question #2: 
Calculate total revenue for MPEG-4 video files purchased in 2024.

Expected column names: total_revenue

*/

-- q2 solution:

SELECT 
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM 
    invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN media_type mt ON t.media_type_id = mt.media_type_id
    JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE 
    mt.name = 'Protected MPEG-4 video file'
    AND EXTRACT(YEAR FROM i.invoice_date) = 2024;-- replace this with your query

/*
Question #3: 
For composers appearing in classical playlists, count the number of distinct playlists they appear on and 
create a comma separated list of the corresponding (distinct) playlist names.

Expected column names: composer, distinct_playlists, list_of_playlists

*/

-- q3 solution:

select
	composer,
  count(distinct playlist.name),
  string_agg(playlist.name,',')
  
from
	track
left join
	playlist_track using(track_id)
left join
	playlist using(playlist_id)
where
	playlist.name ilike '%classical%'
and
	composer is not null
group by
	composer-- replace this with your query

/*
Question #4: 
Find customers whose yearly total spending is strictly increasing*.


*read the hints!


Expected column names: customer_id
*/

-- q4 solution:

with t0 as (
select
	extract(year from invoice_date) as yr,
  customer_id,
  coalesce(sum(total),0) as yearly_total
from
	invoice
join
	customer using(customer_id)
where
  extract(year from invoice_date) < 2025
group by
	extract(year from invoice_date),
  customer_id
order by
	customer_id,
  yr
),
t1 as (
select
	*,
  coalesce(lag(yearly_total) over (partition by customer_id order by yr) < yearly_total,true) as gt_last_year
from
	t0
)
select 
	customer_id
from
	t1
group by
	customer_id
having
	count(customer_id) = sum(gt_last_year::int)
-- replace this with your query

