-- ----------------------------------------------------------------------------------------------------------
-- 07_instructor_handoff_impact
-- -----------------------------------------------------------------------------------------------------------
-- Purpose: for the course/cohort pairing with more than one instructor assignments, means a handoff happened 
-- -----------------------------------------------------------------------------------------------------------
WITH multiple_instructors AS (
	SELECT
		course_id,
        cohort_id,
        COUNT(*) AS assignments
	FROM instructor_assignments
    GROUP BY course_id, cohort_id
    HAVING COUNT(*) > 1
) 
-- step 2: Attendance rate per instructor before and after the handoff
SELECT
	i.course_id,
    i.cohort_id,
    ROUND(SUM(a.status IN('Present', 'Late')) / COUNT(a.status) * 100, 1) attendance_rate,
    COUNT(*) sessions
    FROM instructor_assignments i
    JOIN enrolments e ON i.course_id = e.course_id AND i.cohort_id = e.cohort_id
    JOIN attendance a ON e.enrolment_id = a.enrolment_id
		AND a.session_date BETWEEN i.start_date AND i.end_date
    WHERE (i.course_id, i.cohort_id) IN (SELECT course_id, cohort_id FROM multiple_instructors)
    GROUP BY i.course_id, i.cohort_id, i.instructor_id;