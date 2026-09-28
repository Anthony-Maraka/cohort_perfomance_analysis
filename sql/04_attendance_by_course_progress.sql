-- Attendance by course progress
-- ------------------------------------------------------------------
-- Question: At what point in the course does attendance start to fall?
-- ------------------------------------------------------------------
-- Courses have different lengths so we divide each course into 10 parts and compare attendance across those parts
-- ------------------------------------------------------------------
-- 0 = beginning, 5 = middle, 9 = end 

WITH course_dates AS (
	-- Find the first and the last day of the course
	SELECT
		e.cohort_id,
        e.course_id,
        MIN(a.session_date) AS first_date,
        MAX(session_date) AS last_date
	FROM enrolments e
    JOIN attendance a ON e.enrolment_id = a.enrolment_id
    GROUP BY e.cohort_id, e.course_id
),
course_progress AS (
	-- Find where each class falls within the course
    SELECT 
		a.status,
        10 * DATEDIFF(a.session_date, c.first_date)
        /DATEDIFF(c.last_date, c.first_date) AS decile
	FROM attendance a
    JOIN enrolments e ON a.enrolment_id = e.enrolment_id
    JOIN course_dates c ON e.course_id = c.course_id
		AND e.cohort_id = c.cohort_id
	WHERE a.status <> 'Not Recorded'
)