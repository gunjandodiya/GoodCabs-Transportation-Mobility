#City-level fare and trip summary report 

SELECT 
      dim_city.city_name, 
      COUNT(trip_id) AS total_trips, 
      ROUND((SUM(fare_amount)/SUM(distance_travelled_km)),1) AS Avg_fare_per_km,
      ROUND((SUM(fare_amount)/COUNT(trip_id)),1) AS Avg_fare_per_trip,
      ROUND(Count(trip_id)*100/(select count(trip_id) from fact_trips),1) AS total_trips_cont_percentage 
FROM fact_trips
JOIN dim_city
     ON  dim_city.city_id = fact_trips.city_id
GROUP BY fact_trips.city_id
ORDER BY total_trips_cont_percentage DESC