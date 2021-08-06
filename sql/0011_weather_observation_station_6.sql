/*

Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) 
from STATION. Your result cannot contain duplicates.

*/
SELECT DISTINCT CITY FROM STATION WHERE LOWER(LEFT(CITY, 1)) IN ('a', 'e', 'i', 'o', 'u') ORDER BY CITY;
