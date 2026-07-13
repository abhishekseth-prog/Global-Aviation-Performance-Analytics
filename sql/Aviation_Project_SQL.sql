# creating database
create database aviation_project;
use aviation_project;
SELECT * FROM airline_financials LIMIT 5;
SELECT * FROM passenger_traffic LIMIT 5;
SELECT * FROM route_performance LIMIT 5;
SELECT * FROM fleet_orders LIMIT 5;
SELECT * FROM aviation_incidents LIMIT 5;
SELECT COUNT(*) FROM airline_financials;
SELECT COUNT(*) FROM passenger_traffic;
SELECT COUNT(*) FROM route_performance;
SELECT COUNT(*) FROM fleet_orders;
SELECT COUNT(*) FROM aviation_incidents;
#Which airlines generated the highest total revenue between 2010 and 2026?
select airline_name, 
 sum(revenue_usd_bn) as total_revenue_bn from airline_financials
 group by airline_name
 order by total_revenue_bn desc
 limit 10;

#Which airlines have the highest average operating margin?
select airline_name, 
 sum(operating_margin_pct
) as avg_operating_margin from airline_financials
 group by airline_name
 order by avg_operating_margin  desc
 limit 10;
 
 #Which region contributes the highest airline revenue?
 select region, 
 sum(revenue_usd_bn) as total_revenue_bn from airline_financials
 group by region
 order by total_revenue_bn desc;
 
 #How does revenue vary across different business models (Legacy vs Low Cost)?
 select business_model, 
 sum(revenue_usd_bn) as total_revenue_bn from airline_financials
 group by  business_model
 order by total_revenue_bn desc;
 
 #total airline revenue changed over the years?
 SELECT
    year,
    ROUND(SUM(revenue_usd_bn), 2) AS total_revenue_bn
FROM airline_financials
GROUP BY year
ORDER BY year;
 
 #airlines have the highest average load factor?
  select airline_name, 
 avg(load_factor_pct) as avg_load_factor_bn from airline_financials
 group by  airline_name
 order by  airline_name desc
 limit 10;
 
 #passenger traffic changed year by year
 select  year, 
 round(sum(passengers_carried_m),0) as passenger_traffic from airline_financials
 group by  year
 order by  year ;
 
 #Which airlines operate the largest fleets?
 select airline_name, sum(fleet_size_est) as fleet_size from airline_financials
 group by airline_name
 order by fleet_size desc
 limit 10;
 
 # relationship between fleet size and revenue?
 SELECT
    airline_name,
    fleet_size_est,
    ROUND(SUM(revenue_usd_bn), 2) AS total_revenue_bn
FROM airline_financials
GROUP BY airline_name, fleet_size_est
ORDER BY fleet_size_est DESC; 

#How has global passenger traffic changed from 2010 to 2026, and which years experienced the highest growth or decline?
SELECT
    year,
    ROUND(SUM(rpk_billions), 2) AS total_passengers_million
FROM passenger_traffic
GROUP BY year
ORDER BY year;

#Which regions achieved the highest average passenger load factor, indicating better aircraft seat utilization?
select region , round(avg(load_factor_pct),2) as passenger_load_factor from passenger_traffic
group by region
order by passenger_load_factor desc;

#Which regions contributed the highest passenger traffic between 2010 and 2026?
select region ,   ROUND(SUM(rpk_billions), 2) AS total_passengers_million from passenger_traffic
group by region
order by total_passengers_million  desc;

#How significantly did the COVID-19 pandemic affect global passenger traffic, and which region experienced the largest decline?
SELECT
    year,
    ROUND(SUM(rpk_billions), 2) AS total_rpk
FROM passenger_traffic
WHERE year BETWEEN 2019 AND 2022
GROUP BY year
ORDER BY year;

#Which Region Experienced the Largest Decline?
SELECT
    region,
    ROUND(SUM(CASE WHEN year = 2019 THEN rpk_billions ELSE 0 END), 2) AS rpk_2019,
    ROUND(SUM(CASE WHEN year = 2020 THEN rpk_billions ELSE 0 END), 2) AS rpk_2020,
    ROUND(
        SUM(CASE WHEN year = 2019 THEN rpk_billions ELSE 0 END) -
        SUM(CASE WHEN year = 2020 THEN rpk_billions ELSE 0 END),
        2
    ) AS decline
FROM passenger_traffic
WHERE year IN (2019, 2020)
GROUP BY region
ORDER BY decline DESC;

#Route Performance Analysis

#Which flight routes carried the highest number of passengers between 2010 and 2026?
select route , round(sum(annual_passengers_m),2) as annual_passengers_million from route_performance
group by route
order by annual_passengers_million desc;

#Which routes generated the highest total revenue during the analysis period?
select route , round(sum(annual_revenue_usd_m),2) as total_revenue from route_performance
group by route
order by total_revenue desc
limit 10;

#Which routes recorded the highest average ticket fare?
SELECT
    route,
    ROUND(AVG(avg_fare_usd), 2) AS average_ticket_fare
FROM route_performance
GROUP BY route
ORDER BY average_ticket_fare DESC;

#How does route distance influence revenue and passenger demand?
SELECT
    route,
    distance_km,
    annual_revenue_usd_m,
    annual_passengers_m
FROM route_performance
ORDER BY distance_km DESC;

#Which routes consistently handled the highest passenger volumes over the years? SELECT
    route,
    ROUND(SUM(annual_passengers_m), 2) AS total_passengers_m
FROM route_performance
GROUP BY route
ORDER BY total_passengers_m DESC
LIMIT 10;

#Fleet Orders Analysis
#Which aircraft manufacturer received the highest number of aircraft orders between 2010 and 2026?
 SELECT
    manufacturer,
    SUM(orders_gross) AS total_orders
FROM fleet_orders
GROUP BY manufacturer
ORDER BY total_orders DESC;

#Which aircraft models received the highest total number of orders during the analysis period?
SELECT
    aircraft_family,
    SUM(orders_gross) AS total_orders
FROM fleet_orders
GROUP BY  aircraft_family
ORDER BY total_orders DESC;

#Which aircraft manufacturers delivered the highest number of aircraft over the years?

select manufacturer,
    SUM(deliveries) AS total_deliveries
FROM fleet_orders
GROUP BY   manufacturer
ORDER BY total_deliveries DESC;


#Which aircraft manufacturers have the largest order backlog
select manufacturer,
    SUM(backlog_end_of_year) AS total_backlog
FROM fleet_orders
GROUP BY   manufacturer
ORDER BY  total_backlog  DESC;

#What is the market share of each aircraft manufacturer based on total aircraft orders?
SELECT
    manufacturer,
    SUM(orders_gross) AS total_orders,
    ROUND(
        (SUM(orders_gross) * 100.0) /
        (SELECT SUM(orders_gross) FROM fleet_orders),
        2
    ) AS market_share_pct
FROM fleet_orders
GROUP BY manufacturer
ORDER BY market_share_pct DESC;


#Aviation Incidents 
#How many aviation incidents were recorded during the analysis period?
SELECT COUNT(*) AS total_incidents
FROM aviation_incidents;



#How many fatal aviation incidents occurred during the analysis period?
SELECT COUNT(*) AS fatal_incidents
FROM aviation_incidents
WHERE is_fatal = 1;

#Which types of aviation incidents occurred most frequently?
SELECT
    severity,
    COUNT(*) AS incident_count
FROM aviation_incidents
GROUP BY severity
ORDER BY incident_count DESC;

#Which aircraft manufacturer experienced more aviation incidents?
SELECT
    SUM(is_boeing) AS boeing_incidents,
    SUM(is_airbus) AS airbus_incidents
FROM aviation_incidents;

#How have aviation incidents changed over the years?
SELECT
    year,
    COUNT(*) AS total_incidents
FROM aviation_incidents
GROUP BY year
ORDER BY year;



#How does regional passenger demand (RPK) relate to airline revenue across different regions?
SELECT
    af.region,
    ROUND(SUM(af.revenue_usd_bn),2) AS total_revenue,
    ROUND(SUM(pt.rpk_billions),2) AS total_rpk
FROM airline_financials af
JOIN passenger_traffic pt
ON af.region = pt.region
AND af.year = pt.year
GROUP BY af.region
ORDER BY total_revenue DESC;

#Passenger Demand vs Aviation Incidents
SELECT
    pt.year,
    ROUND(SUM(pt.rpk_billions),2) AS passenger_demand,
    COUNT(ai.incident_id) AS incidents
FROM passenger_traffic pt
JOIN aviation_incidents ai
ON pt.year = ai.year
GROUP BY pt.year;

#Revenue vs Fleet Orders
SELECT
    af.year,
    ROUND(SUM(af.revenue_usd_bn),2) AS revenue,
    SUM(fo.orders_gross) AS aircraft_orders
FROM airline_financials af
JOIN fleet_orders fo
ON af.year = fo.year
GROUP BY af.year;