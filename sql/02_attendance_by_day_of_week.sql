-- 02_attendance_by_day_of_week
-- Purpose: find which day of the week has the weakest attendance across every course and cohort
SELECT 
	DAYNAME(session_date) day_of_week,
    100 * SUM(status IN ('Present', 'Late')) / COUNT(*) attendance_rate
FROM attendance
WHERE status != 'Not Recorded'
GROUP BY DAYNAME(session_date)
ORDER BY SUM(status IN ('Present', 'Late')) / COUNT(*); -- Friday weakest at 53% while monday is the strongest at 63%

-- Attendance by day of the week in each cohort
WITH cohort_attendance AS (
SELECT
	DAYNAME(a.session_date) day_of_week,
    c.cohort_label,
    100 * SUM(a.status IN ('Present', 'Late')) / COUNT(*) attendance_rate
FROM attendance a
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id
WHERE a.status != 'Not Recorded'
GROUP BY DAYNAME(a.session_date), c.cohort_label
)
SELECT 
	cohort_label, 
    day_of_week,
    attendance_rate,
    RANK() OVER(PARTITION BY cohort_label ORDER BY attendance_rate) AS rank_
FROM cohort_attendance; -- Friday is the weakest in terms of daily attendance while Monday consistently records the highest attendance for all the cohorts
