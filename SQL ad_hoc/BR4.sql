WITH RankedCities AS (
    SELECT 
        dim_city.city_name,
        SUM(fact_passenger_summary.new_passengers) AS total_new_passengers,
        RANK() OVER (Order by SUM(fact_passenger_summary.new_passengers) DESC)  AS rank_highest,
        RANK() OVER (Order by SUM(fact_passenger_summary.new_passengers)) AS rank_lowest
    FROM 
        trips_db.fact_passenger_summary
    JOIN 
        trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
    GROUP BY 
        dim_city.city_name
),
CategorizedCities AS (
    SELECT 
        city_name,
        total_new_passengers,
        CASE 
            WHEN rank_highest <= 3 THEN 'Top 3'
            WHEN rank_lowest <= 3 THEN 'Bottom 3'
            ELSE NULL
        END AS city_category
    FROM 
        RankedCities
)
SELECT 
    city_name,
    total_new_passengers,
    city_category
FROM 
    CategorizedCities
WHERE 
    city_category IS NOT NULL
ORDER BY 
    city_category, total_new_passengers DESC;
