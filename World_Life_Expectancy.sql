# World Life Expectancy Project (Data Cleaning)

SELECT *
FROM World_Life_Expectancy;

#Identifying and Removing Duplicates 

SELECT country,
year,
CONCAT(Country, year),
COUNT(CONCAT(Country, year))
FROM World_Life_Expectancy
GROUP BY country,year, CONCAT(Country, year)
HAVING COUNT(CONCAT(Country, year)) > 1;


SELECT *
FROM 
(
SELECT Row_ID,
CONCAT(Country, year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, year) ORDER BY CONCAT(Country, year)) as Row_Num
FROM World_Life_Expectancy
) as Row_table
where ROW_Num >1;

DELETE FROM World_Life_Expectancy
WHERE Row_ID IN (SELECT Row_ID
FROM 
(
SELECT Row_ID,
CONCAT(Country, year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, year) ORDER BY CONCAT(Country, year)) as Row_Num
FROM World_Life_Expectancy
) as Row_table
where ROW_Num >1);


#Finding Blanks and filling them in 

SELECT *
FROM World_Life_Expectancy
Where Status = '';


SELECT DISTINCT(Status)
FROM World_Life_Expectancy
Where Status <> '';

SELECT DISTINCT(Country)
FROM World_Life_Expectancy
Where Status = 'Developing';

UPDATE World_Life_Expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
FROM World_Life_Expectancy
Where Status = 'Developing');

UPDATE World_Life_Expectancy t1
JOIN World_Life_Expectancy t2
	ON t1.Country = t2.Country
SET t1. Status = 'Developing'
where t1.status =''
AND t2.status <> ''
AND t2.Status = 'Developing'
;


UPDATE World_Life_Expectancy t1
JOIN World_Life_Expectancy t2
	ON t1.Country = t2.Country
SET t1. Status = 'Developed'
where t1.status =''
AND t2.status <> ''
AND t2.Status = 'Developed'
;

SELECT *
FROM World_Life_Expectancy
Where Status IS NULL;


SELECT *
FROM World_Life_Expectancy
WHERE `Lifeexpectancy` = '';


SELECT t1.Country,
t1.year,
t1.`Lifeexpectancy`,
t2.Country,
t2.year,
t2.`Lifeexpectancy`,
t3.Country,
t3.year,
t3.`Lifeexpectancy`,
ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
FROM World_Life_Expectancy t1
JOIN World_Life_Expectancy t2
	ON t1.Country = t2.Country
    AND t1.year = t2.year -1 
JOIN World_Life_Expectancy t3
	ON t1.Country = t3.Country
    AND t1.year = t3.year + 1
WHERE t1.`Lifeexpectancy` = '';


UPDATE World_Life_Expectancy t1
JOIN World_Life_Expectancy t2
	ON t1.Country = t2.Country
    AND t1.year = t2.year -1 
JOIN World_Life_Expectancy t3
	ON t1.Country = t3.Country
    AND t1.year = t3.year + 1
SET t1.`Lifeexpectancy` = ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
WHERE t1.`Lifeexpectancy` = '';


# Performing Exploratory Analysis 

SELECT * 
FROM World_Life_Expectancy;

# Life Expecgtancy Over the years 

SELECT Country,
MIN(`Lifeexpectancy`),
MAX(`Lifeexpectancy`),
ROUND(MAX(`Lifeexpectancy`) - MIN(`Lifeexpectancy`)) AS 15_Year_Diff
FROM World_Life_Expectancy
GROUP BY Country
HAVING MIN(`Lifeexpectancy`) <> 0
AND MAX(`Lifeexpectancy`) <> 0
ORDER BY 15_Year_Diff DESC;


#AVG Life Expectancy Per Year

SELECT Year,
ROUND(AVG(`Lifeexpectancy`),2)
FROM World_Life_Expectancy
WHERE `Lifeexpectancy` <> 0
AND `Lifeexpectancy` <> 0
GROUP BY Year
ORDER BY Year;


#Correlation Between GDP and Life Expectancy 

SELECT Country,
ROUND(AVG(`Lifeexpectancy`),1) AS Life_Exp,
ROUND(AVG(GDP),1) AS GDP
FROM World_Life_Expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC;



SELECT 
ROUND(SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END)) High_GDP_Count,
ROUND(AVG (CASE WHEN GDP >= 1500 THEN `Lifeexpectancy` ELSE NULL END)) High_GDP_Life_Exp,
ROUND(SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END)) Low_GDP_Count,
ROUND(AVG (CASE WHEN GDP <= 1500 THEN `Lifeexpectancy` ELSE NULL END)) Low_GDP_Life_Exp
FROM World_Life_Expectancy;


# Correlation between Status and Life Expectancy

SELECT Status,
ROUND(AVG(`Lifeexpectancy`),1)
FROM World_Life_Expectancy
GROUP BY Status;


SELECT Status,
Count(DISTINCT Country),
ROUND(AVG(`Lifeexpectancy`),1)
FROM World_Life_Expectancy
GROUP BY Status;


# BMI and LIfe Expectancy

SELECT Country,
ROUND(AVG(`Lifeexpectancy`),1) AS Life_Exp,
ROUND(AVG(BMI),1) AS BMI
FROM World_Life_Expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC;


#Looking at Adult Mortality

SELECT Country,
Year,
`Lifeexpectancy`,
`Adultmortality`,
SUM(`Adultmortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM World_Life_Expectancy
WHERE Country LIKE '%UNITED%';


