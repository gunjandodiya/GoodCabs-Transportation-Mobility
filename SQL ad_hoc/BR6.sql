-- Repeat Passenger Rate Analysis
WITH monthly_repeat AS ( 
    SELECT 
        city_name, 
        DATE_FORMAT(fact_passenger_summary.month, '%M') AS month_name,
        fact_passenger_summary.month, 
        SUM(fact_passenger_summary.repeat_passengers) AS repeat_passengers,  
        SUM(fact_passenger_summary.total_passengers) AS total_passengers,  
        CONCAT(ROUND((SUM(fact_passenger_summary.repeat_passengers) * 100 / SUM(fact_passenger_summary.total_passengers)), 2), '%') AS monthly_repeat_passenger_rate
    FROM 
        trips_db.fact_passenger_summary
    JOIN 
        trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
    GROUP BY 
        city_name, fact_passenger_summary.month
),

city_repeat AS (
    SELECT 
        dim_city.city_name, 
        SUM(fact_passenger_summary.total_passengers) AS total_passengers, 
        SUM(fact_passenger_summary.repeat_passengers) AS repeat_passengers,
        CONCAT(ROUND((SUM(fact_passenger_summary.repeat_passengers) * 100 / SUM(fact_passenger_summary.total_passengers)), 2), '%') AS repeat_passenger_rate
    FROM 
        trips_db.fact_passenger_summary
    JOIN 
        trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
    GROUP BY
        dim_city.city_name
)

SELECT 
    monthly_repeat.city_name, 
    monthly_repeat.total_passengers, 
    monthly_repeat.repeat_passengers, 
    monthly_repeat.monthly_repeat_passenger_rate, 
    city_repeat.repeat_passenger_rate 
FROM 
    monthly_repeat 
JOIN 
    city_repeat  
    ON monthly_repeat.city_name = city_repeat.city_name
ORDER BY 
    monthly_repeat.city_name;





