-- Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.

SELECT name,revenue,category
 from (select category,name,revenue,rank() over (partition by category order by revenue desc)as rn
from 
   (select pizza_types.name,pizza_types.category,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    
GROUP BY pizza_types.name,pizza_types.category) as a) as b where rn<=3;


