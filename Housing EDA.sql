SELECT *
FROM housing_data2;

-- Houses Sold Per City.
SELECT SplitPropertyCity, COUNT(SplitPropertyCity) AS HOUSES
FROM housing_data2
WHERE SplitPropertyCity != ''
GROUP BY SplitPropertyCity
ORDER BY 2 DESC; 
-- A blank City has been spotted. Lets try to go back to data cleaning and see whether we can get it fixed. 
-- They are important for another set of analysis.

SELECT LandUse, SaleDate, SalePrice, TotalValue
FROM housing_data2
WHERE SplitPropertyCity = 'NASHVILLE' -- Most Selling City.
ORDER BY 2 ASC;


SELECT LandUse, SaleDate, SalePrice, TotalValue
FROM housing_data2
WHERE SplitPropertyCity = 'MOUNT JULIET' -- Worst Selling City. 
ORDER BY 2 ASC;


SELECT SplitPropertyCity, AVG(SalePrice)
FROM housing_data2
WHERE SplitPropertyCity != ''
GROUP BY SplitPropertyCity
ORDER BY 2 DESC;
-- Its noted that Nashville and mount juliet have among the highest average saleprice. Meaning houses bought has nothing to do with price.

SELECT SplitPropertyCity, AVG(Acreage)
FROM housing_data2
WHERE SplitPropertyCity != ''
GROUP BY SplitPropertyCity
ORDER BY 2 DESC; -- Mount Juliet houses were the biggest and Antioch were the smallest. 


SELECT LandUse, COUNT(LandUse)
FROM housing_data2
GROUP BY LandUse
ORDER BY 2 DESC; -- Houses were mostly sold to single families by a huge margin. 

SELECT LandUse, AVG(Acreage)
FROM housing_data2
GROUP BY LandUse
ORDER BY 2 DESC; -- This shows the average acreage used for different land uses. 

SELECT SUBSTRING(SaleDate, 1, 4) AS `YEAR`, COUNT(SplitPropertyAddress) AS 'Houses Sold'
FROM housing_data2
GROUP BY SUBSTRING(SaleDate, 1, 4)
ORDER BY 2 DESC; -- 2015 was the most selling year. 2019 was the worst. 

SELECT SplitPropertyCity, SUM(SalePrice) AS Total_Amount
FROM housing_data2
WHERE SplitPropertyCity != ''
GROUP BY SplitPropertyCity
ORDER BY 2 DESC; -- money made from selling houses per city.

SELECT SoldAsVacant, SUM(SalePrice) AS Amount
From housing_data2
GROUP BY SoldAsVacant
ORDER BY 2 DESC; -- People bought houses that were already initially occupied the most.

SELECT OwnerName, COUNT(SplitPropertyAddress)
FROM housing_data2
GROUP BY OwnerName
ORDER BY 2 DESC; -- highest seller name is unknown. so we take the second

SELECT Bedrooms, COUNT(SplitPropertyAddress)
FROM housing_data2
GROUP BY Bedrooms
ORDER BY 2 DESC; -- Includes 0 bedrooms, but those could be factories, manufacturing houses. 

select *
from housing_data2;