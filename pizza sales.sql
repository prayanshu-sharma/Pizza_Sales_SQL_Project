-- Q1-RETREIVE THE TOTAL NUMBER OF ORDER PLACED

SELECT count(order_id) AS total_orders FROM ORDERS;


-- Q2-CALCULATE TOTAL REVENUE GENERATED FROM PIZZA SALES
select ROUND(SUM(order_details.quantity*pizzas.price),2) as total_sales from order_details join pizzas on pizzas.pizz_id=order_details.pizza_id;


-- Q3-IDENTIFY HIGHEST PRICED PIZZA

select pizza_types.name,pizzas.price from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id order by pizzas.price desc limit 1;



-- Q4-IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED

select pizzas.size,count(order_details.order_details_id) as order_count from pizzas join order_details on pizzas.pizza_id=order_details.pizza_id group by pizzas.size order by order_count desc;


-- Q5-LIST THE TOP 5 MOST ORDERED PIZZA TYPES ALONG WITH THEIR QUANTITIES

select pizza_types.name,SUM(order_details.quantity) as quantity from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_details on 
order_details.pizza_id=pizzas.pizzas.pizza_id group by pizza_types.name order by quantity desc limit 5;


-- Q6-join necessary table to find toal quantity of each pizza category ordered

select pizza_types.category ,sum(order_details.quantity) as quantity from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_details 
on order_details.pizza_id=pizzas.pizza_id group by pizza_types.category order by quantity desc;


-- Q7-DETERMINE THE DISTRIBUTION OF ORDERS BY HOUR OF THE DAY

select hour(order_time),count(order_id) as order_count from orders group by hour(order_time);


-- Q8-JOIN TABLE TO FIND THE CATEGORY WISE DISTRIBUTION OF PIZZAS.

select category,count(name) from pizza_types group by category;


-- Q9-GROUP ORDERS BY DATE AND CALCULATE AVG NUMBER OF PIZZAS ORDERD PER DAY

select round(avg(quantity),0) as avg_pizza_orderperday from (select orders.order_date,sum(order_details.quantity) as quantity from orders join order_details on orders.order_id=order_details.order_id
 group by orders.order_date) as order_quantity;
 
 
 
 -- Q10-DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE
 
 select pizza_types.name, SUM(order_details.quantity*pizzas.price) as revenue from pizza_types join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id join order_details 
 on order_details.pizza_id=pizzas.pizza_id group by pizza_types.name order by revenue desc limit 3;
 
 
 -- Q11-CALCULATE % CONTRIBUTION OF EACH PIZZA TYPE TO TOTAL REVENUE.
 
 select pizza_types.category, round(SUM(order_details.quantity*pizzas.price)/(select ROUND(SUM(order_details.quantity*pizzas.price),2) as 
 total_sales from order_details join pizzas on pizzas.pizza_id=order_details.pizza_id)*100,2) as revenue
 from pizza_types join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id join order_details 
 on order_details.pizza_id=pizzas.pizza_id group by pizza_types.category order by revenue desc;
 
 
 
 -- Q12-ANALYZE CUMULATIVE REVENUE GENERATED OVER TIME
 
 select order_date ,sum(revenue) over (order by order_date ) as cummulative_revenue from 
 (select orders.order_date,sum(order_details.quantity*pizzas.price) as revenue from order_details join 
 pizzas on order_details.pizza_id=pizzas.pizza_id 
 join orders on orders.order_id=order_details.order_id group by orders.order_date) as sales;
 
 
 
 -- Q13-DETERMINE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE FOR EACH PIZZA CATEGORY
 
 select name,revenue from 
 (select category,name,revenue,rank() over(partition by category order by revenue desc)as rn from
 (select pizza_types.category,pizza_types.name,sum((order_details.quantity)*pizzas.price) as revenue from pizza_types join pizzas 
 on pizzas.pizza_type_id=pizza_types.pizza_type_id join order_details on order_details.pizza_id=pizzas.pizza_id
 group by pizza_types.category,pizza_types.name) as r) as b where rn<=3;