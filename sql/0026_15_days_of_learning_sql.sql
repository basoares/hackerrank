/*

Julia conducted a 15 days of learning SQL contest. The start date of the
contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least 1 
submission each day (starting on the first day of the contest), and find the
hacker_id and name of the hacker who made maximum number of submissions each
day. If more than one such hacker has a maximum number of submissions, print
the lowest hacker_id. The query should print this information for each day of
the contest, sorted by the date.

NB:
The description of the problem should be as follow: Write a query to print
total number of unique hackers who made at least submission each day
(starting on the first day of the contest) until that day and find the
hacker_id and name of the hacker who made maximum number of submissions each
day (without considering if they made submissions the days before or after)
If more than one such hacker has a maximum number of submissions, print the
lowest hacker_id. The query should print this information for each day of
the contest, sorted by the date.

*/
WITH RUNNING_SUBS AS
(
  SELECT SUBMISSION_DATE, HACKER_ID
    FROM
    (
      SELECT S.*,
             DENSE_RANK() OVER (ORDER BY S.SUBMISSION_DATE) DS,
             DENSE_RANK() OVER (PARTITION BY S.HACKER_ID ORDER BY S.SUBMISSION_DATE) DS2
        FROM SUBMISSIONS S
    ) X
   WHERE DS = DS2
)
SELECT S.SUBMISSION_DATE,
       COUNT(DISTINCT S.HACKER_ID),
       H.HACKER_ID,
       H.NAME
  FROM RUNNING_SUBS S
 CROSS APPLY
 (
    SELECT TOP 1 iSUB.HACKER_ID, iH.NAME, COUNT(DISTINCT iSUB.SUBMISSION_ID) SUBS_DAY
      FROM SUBMISSIONS iSUB
     INNER JOIN HACKERS iH
        ON iH.HACKER_ID = iSUB.HACKER_ID
     WHERE iSUB.SUBMISSION_DATE = S.SUBMISSION_DATE
     GROUP BY iSUB.HACKER_ID, iH.NAME
     ORDER BY 3 DESC, 1
 ) H
GROUP BY S.SUBMISSION_DATE, H.HACKER_ID, H.NAME
ORDER BY S.SUBMISSION_DATE;

/*

different interpretation of the problem


WITH SUBS AS
(
    SELECT SUBMISSION_DATE, HACKER_ID, COUNT(DISTINCT SUBMISSION_ID) SUBS_DAY
      FROM
      (
        SELECT *,
               DENSE_RANK() OVER (ORDER BY SUBMISSION_DATE) DS,
               MIN(SUBMISSION_DATE) OVER (PARTITION BY HACKER_ID) FIRST_SUB
          FROM SUBMISSIONS
      ) X
     WHERE DS = DATEDIFF(DAY, FIRST_SUB, SUBMISSION_DATE) + 1
    GROUP BY SUBMISSION_DATE, HACKER_ID
), RANK_SUBS_DAY AS
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SUBMISSION_DATE ORDER BY SUBS_DAY DESC, HACKER_ID) RN
      FROM SUBS
)
SELECT S1.SUBMISSION_DATE,
       COUNT(DISTINCT S1.HACKER_ID),
       MAX(CASE WHEN RN = 1 THEN S1.HACKER_ID END),
       MAX(CASE WHEN RN = 1 THEN H.NAME END)
  FROM RANK_SUBS_DAY S1
  LEFT JOIN HACKERS H
    ON H.HACKER_ID = S1.HACKER_ID
   AND S1.RN = 1
GROUP BY S1.SUBMISSION_DATE
ORDER BY S1.SUBMISSION_DATE;


WITH SUBS AS
(
    SELECT SUBMISSION_DATE, HACKER_ID, NAME, COUNT(DISTINCT SUBMISSION_ID) SUBS_DAY
      FROM
      (
        SELECT S.*,
               DENSE_RANK() OVER (ORDER BY S.SUBMISSION_DATE) DS,
               DENSE_RANK() OVER (PARTITION BY S.HACKER_ID ORDER BY S.SUBMISSION_DATE) DS2,
               H.NAME
          FROM SUBMISSIONS S
         INNER JOIN HACKERS H
            ON H.HACKER_ID = S.HACKER_ID
      ) X
     WHERE DS = DS2
    GROUP BY SUBMISSION_DATE, HACKER_ID, NAME
), RANK_SUBS_DAY AS
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SUBMISSION_DATE ORDER BY SUBS_DAY DESC, HACKER_ID) RN
      FROM SUBS
)
SELECT S.SUBMISSION_DATE,
       COUNT(DISTINCT S.HACKER_ID),
       MIN(CASE WHEN S.RN = 1 THEN S.HACKER_ID END),
       MIN(CASE WHEN S.RN = 1 THEN S.NAME END)
  FROM RANK_SUBS_DAY S
GROUP BY S.SUBMISSION_DATE
ORDER BY S.SUBMISSION_DATE;

*/
