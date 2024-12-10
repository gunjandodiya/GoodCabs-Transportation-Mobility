WITH CityMonthlyRevenue AS (
    SELECT 
        dim_city.city_name,
        DATE_FORMAT(fact_trips.date, '%M') AS month_name,
        SUM(fact_trips.fare_amount) AS monthly_revenue
    FROM 
        trips_db.fact_trips
    JOIN 
        trips_db.dim_city ON fact_trips.city_id = dim_city.city_id

    GROUP BY 
        dim_city.city_name, DATE_FORMAT(fact_trips.date, '%M')
),
CityTotalRevenue AS (
    SELECT 
        city_name,
        SUM(monthly_revenue) AS total_revenue
    FROM 
        CityMonthlyRevenue
    GROUP BY 
        city_name
),
CityMaxRevenue AS (
    SELECT 
        cmr.city_name,
        cmr.month_name AS highest_revenue_month,
        cmr.monthly_revenue AS revenue,
        ctr.total_revenue,
        ROUND((cmr.monthly_revenue * 100.0 / ctr.total_revenue), 2) AS percentage_contribution
    FROM 
        CityMonthlyRevenue cmr
    JOIN 
        CityTotalRevenue ctr ON cmr.city_name = ctr.city_name
    WHERE 
        cmr.monthly_revenue = (
            SELECT 
                MAX(monthly_revenue)
            FROM 
                CityMonthlyRevenue
            WHERE 
                city_name = cmr.city_name
        )
)
SELECT 
    city_name,
    highest_revenue_month,
    revenue,
    percentage_contribution
FROM 
    CityMaxRevenue
ORDER BY 
    city_name;
