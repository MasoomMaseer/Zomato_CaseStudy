create database sql_case_zomato;
use sql_case_zomato;
/*Business Questions: 
1) Help Zomato in identifying the cities with poor Restaurant ratings
2) Mr.roy is looking for a restaurant in kolkata which provides online 
delivery. Help him choose the best restaurant
3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.
4)Enlist most affordable and highly rated restaurants city wise.
5)Help Zomato in identifying the restaurants with poor offline services
6)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
  In case there are two cities with the same result, sort them in alphabetical order.
7) What are the top 5 countries with most restaurants linked with Zomato?
8) What is the average cost for two across all Zomato listed restaurants? 
9) Group the restaurants basis the average cost for two into: 
Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average. 
Then, find the number of restaurants in each category. 
10) List the two top 5 restaurants with highest rating with maximum votes. 
*/

-- 1 
select avg(rating)
from zomato;
-- Avg rating of all restaurants is 2.9.
-- therefore finding restaurants below the avg rating
select RestaurantID, Res_identify, City, Rating
from zomato
where rating < 2.9
order by city;

-- 2 
select RestaurantID, Res_identify, city, Has_Online_delivery, rating
from zomato
where Has_Online_delivery = "Yes" and rating >= 4.5 and city = "Kolkata";

-- 3
select RestaurantID, Res_identify, cuisines, city,rating
from zomato
where Cuisines like "Pizza" and city = "New Delhi" and rating >= 4;

-- 4 
select RestaurantID, Res_identify, City, Average_Cost_for_two, Rating
from zomato
order by city, Rating desc, Average_Cost_for_two asc;

-- 5 
select RestaurantID, Res_identify, City, Has_Table_booking, Rating
from zomato
where  Has_Table_booking = "Yes" and rating < 2.9;

-- 6
SELECT city, COUNT(restaurantid) AS restaurant_count
FROM zomato
WHERE rating >= 4.9
GROUP BY city
HAVING COUNT(restaurantid) >= 3
ORDER BY city ASC;

-- 7 
select countrycode, count(RestaurantID) as TotalNoRestaurants
from zomato
group by countrycode
order by totalnorestaurants desc limit 5;

-- 8 
select avg(Average_Cost_for_two) as AvgCost
from zomato;

-- 9 
-- restaurants must be grouped in 6 categories with reference to avgcostoftwo
-- Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average
select restaurantid, Average_Cost_for_two, case
                                           when Average_Cost_for_two <= 100 then "Average"
                                           when Average_Cost_for_two between 101 and 250 then "Medium High"
                                           when Average_Cost_for_two between 251 and 500 then "High"
                                           when Average_Cost_for_two between 501 and 1000 then "Expensive"
                                           when Average_Cost_for_two between 1001 and 2000 then "Very Expensive"
                                           Else "Luxurious Expensive"
                                           end as Category,
                                           count(restaurantid) as TotalNoRestaurants
from zomato
group by Category
order by category;


SELECT 
    CASE
        WHEN Average_Cost_for_two <= 100 THEN 'Average'
        WHEN Average_Cost_for_two BETWEEN 101 AND 250 THEN 'Medium High'
        WHEN Average_Cost_for_two BETWEEN 251 AND 500 THEN 'High'
        WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN 'Expensive'
        WHEN Average_Cost_for_two BETWEEN 1001 AND 2000 THEN 'Very Expensive'
        ELSE 'Luxurious Expensive'
    END AS Category,
    COUNT(restaurantid) AS Number_of_Restaurants
FROM zomato
GROUP BY Category
ORDER BY Category;

-- 10 
select RestaurantID, Res_identify, city, Votes, Rating
from zomato
order by votes desc, rating desc
limit 5;