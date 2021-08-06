/*

Pivot the Occupation column in OCCUPATIONS so that each Name is sorted
alphabetically and displayed underneath its corresponding Occupation. The
output column headers should be Doctor, Professor, Singer, and Actor, 
respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

*/
SELECT PV.Doctor, PV.Professor, PV.Singer, PV.Actor/*, O.RN*/
FROM
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) RN
FROM OCCUPATIONS
) O
PIVOT
(
    MAX(NAME)
    FOR OCCUPATION IN (Doctor, Professor, Singer, Actor)
) PV
