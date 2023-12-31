-- unit 7 subquery
use university;

select title 
from course 
where title in (select title  from course where credits = 3) and dept_name = 'Comp. Sci.';

select distinct student.id
from student join advisor 
on student.id = advisor.s_id join instructor
on advisor.i_id = instructor.ID
where instructor.name in (select name from instructor where name = 'Einstein') ;


select salary
from instructor
where salary in(select max(salary) from instructor);

select *
from takes
where semester = 'Fall' and year = 2009  ;

SELECT course_id, COUNT(course_id) AS course_count
FROM takes
GROUP BY course_id
ORDER BY course_count DESC
LIMIT 1;

-- unit 8 index
use sakila;

ALTER TABLE rental
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customer (customer_id)
ON DELETE RESTRICT;

create index idx_pa on payment (payment_date, amount);



 -- unit 9 view
 create view v_cumail as
select * ,
	case 
		when length(email) > 0 then "*****" 
        else email
	end as cus_email
from customer;

select * from v_cuallmail;
-- drop view v_cumail;



CREATE VIEW MonthlySalesReport AS
SELECT
    DATE_FORMAT(r.rental_date, '%Y-%m-01') AS month,
    c.name AS category,
    SUM(p.amount) AS total_sales
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY DATE_FORMAT(r.rental_date, '%Y-%m-01'), c.name
ORDER BY DATE_FORMAT(r.rental_date, '%Y-%m-01'), c.name;
-- 3)
CREATE VIEW MonthlyFilmReport AS
SELECT
    f.film_id,
    f.title AS film_title,
    c.name AS film_category,
    COUNT(DISTINCT fa.actor_id) AS num_actors,
    COUNT(DISTINCT i.inventory_id) AS num_copies_in_inventory,
    COUNT(r.rental_id) AS num_rentals
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY f.film_id, f.title, c.name
ORDER BY f.film_id;


-- unit 10
use sakila;

-- 1
select name ,
	case 
		when name in ("English","Italian","French","German") then "latin1"
        when name in ("Japanese","Mandarin") then "utf8"
        else "Unknow"
	end character_set
from language;
    
-- 2
select sum(
	case
		when rating = "G" then 1
        else 0
	end
) G_Count ,
sum(
	case
		when rating = "PG" then 1
        else 0
	end
) PG_Count ,
sum(
	case
		when rating = "PG-13" then 1
        else 0
	end
) PG13_Count , 
sum(
	case
		when rating = "R" then 1
        else 0
	end
) R_Count ,
sum(
	case
		when rating = "NC-17" then 1
        else 0
	end
) NC17_Count
from film;

-- 3
select table_name , index_name 
from information_schema.statistics
where index_schema = "sakila" 
order by table_name;

-- 4
select 
    concat(
        'ALTER TABLE ', 
        table_name, 
        ' ADD INDEX ', 
        index_name, 
        ' (', 
        group_concat(DISTINCT COLUMN_NAME ORDER BY SEQ_IN_INDEX), 
        ');'
    ) as CREATE_INDEX_QUERY
from
    INFORMATION_SCHEMA.STATISTICS
where 
    index_schema = 'sakila' and
    table_name = 'customer'
group by
	table_name , index_name ; 








