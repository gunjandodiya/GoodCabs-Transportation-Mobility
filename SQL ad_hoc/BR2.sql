-- Actual_trips
 SELECT 
            dim_city.city_id,
            dim_city.city_name,
            DATE_FORMAT(fact_trips.date, '%M') AS month_name, -- Extracting month name from fact_trips.date
            COUNT(fact_trips.trip_id) AS actual_trips
        FROM 
            trips_db.fact_trips
        JOIN 
            trips_db.dim_city ON fact_trips.city_id = dim_city.city_id
        GROUP BY 
            dim_city.city_id, dim_city.city_name, DATE_FORMAT(fact_trips.date, '%M');
        
-- Target_trips
SELECT 
            monthly_target_trips.city_id,
            DATE_FORMAT(monthly_target_trips.month, '%M') AS month_name, -- Assuming target_date is the date for targets
            SUM(monthly_target_trips.total_target_trips) AS target_trips
        FROM 
            targets_db.monthly_target_trips
        GROUP BY 
            monthly_target_trips.city_id, DATE_FORMAT(monthly_target_trips.month, '%M');
            
-- Performace status & Percentage difference
	SELECT 
    Actual.city_name,
    Actual.month_name,
    Actual.actual_trips,
    Target.target_trips,
    
    CASE 
        WHEN Actual.actual_trips > Target.target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    ROUND(((Actual.actual_trips - Target.target_trips) * 100.0 / Target.target_trips), 2) AS percentage_difference
FROM 
    -- Subquery for Actual Trips aggregated at the city and month level
    (
        SELECT 
            dim_city.city_id,
            dim_city.city_name,
            DATE_FORMAT(fact_trips.date, '%M') AS month_name, -- Extracting month name from fact_trips.date
            COUNT(fact_trips.trip_id) AS actual_trips
        FROM 
            trips_db.fact_trips
        JOIN 
            trips_db.dim_city ON fact_trips.city_id = dim_city.city_id
        GROUP BY 
            dim_city.city_id, dim_city.city_name, DATE_FORMAT(fact_trips.date, '%M')
    ) AS Actual
JOIN 
    -- Subquery for Target Trips aggregated at the city and month level
    (
        SELECT 
            monthly_target_trips.city_id,
            DATE_FORMAT(monthly_target_trips.month, '%M') AS month_name, -- Assuming target_date is the date for targets
            SUM(monthly_target_trips.total_target_trips) AS target_trips
        FROM 
            targets_db.monthly_target_trips
        GROUP BY 
            monthly_target_trips.city_id, DATE_FORMAT(monthly_target_trips.month, '%M')
    ) AS Target
ON 
    Actual.city_id = Target.city_id
    AND Actual.month_name = Target.month_name;



