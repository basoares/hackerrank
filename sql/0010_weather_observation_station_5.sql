/*

Query the two cities in STATION with the shortest and longest CITY 
names, as well as their respective lengths (i.e.: number of characters 
in the name). If there is more than one smallest or largest city, choose 
the one that comes first when ordered alphabetically. 


*/
;WITH CITY_LENGTHS AS
(
SELECT CITY,
    LEN(CITY) NAME_SIZE,
    ROW_NUMBER() OVER (ORDER BY LEN(CITY), CITY) A,
    ROW_NUMBER() OVER (ORDER BY LEN(CITY) DESC, CITY) B
FROM STATION
)
SELECT CITY, NAME_SIZE
FROM CITY_LENGTHS
WHERE A = 1
OR B = 1;

/*
SELECT CITY, LEN(CITY) FROM STATION ORDER BY LEN(CITY), CITY
SELECT CITY, LEN(CITY) FROM STATION ORDER BY LEN(CITY) DESC, CITY
