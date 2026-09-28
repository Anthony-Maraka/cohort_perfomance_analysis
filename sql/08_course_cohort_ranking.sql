-- ---------------------------------------------------------------------------------------------------------------
-- 08_course_cohort_ranking
-- ---------------------------------------------------------------------------------------------------------------
/* Purpose: Rank every course/cohort combination that has run in the program by attendance rate
alongside its completion rate, to spot which specific offerings are underperforming and whether any course repeats
near the bottom across multiple cohorts*/
-- ----------------------------------------------------------------------------------------------------------------
WITH att AS (
	SELECT
		e.course_id,
        e.cohort_id,
        ROUND(100.0 * SUM(a.status IN ('Present', 'Late')) / 
        COUNT(*), 1) AS attendance_rate
	FROM enrolments e
    JOIN attendance a ON a.enrolment_id = e.enrolment_id
    WHERE a.status != 'Not Recorded'
    GROUP BY e.course_id, e.cohort_id
),
comp AS (
	SELECT
		course_id,
        cohort_id,
        ROUND(100.0 * SUM(status = 'Completed') / COUNT(*), 1) AS completion_rate,
        COUNT(*) AS enrolled
	FROM enrolments
    GROUP BY course_id, cohort_id
)
SELECT
	c.course_name,
    att.cohort_id,
    att.attendance_rate,
    comp.completion_rate,
    comp.enrolled
FROM att
JOIN comp
	ON att.course_id = comp.course_id
    AND att.cohort_id = comp.cohort_id
JOIN courses c ON c.course_id = att.course_id
ORDER BY att.attendance_rate ASC; /* Result:
								  Data Analysis appears twice in the weakest five(Cohort 4 and 5),
                                  This suggests a course level pattern rather than one bad cohort.
                                  Completion rates for cohorts 4, 5, 6 read low across every row, because of the
                                  Unknown status data quality issue documented in 01_data_quality_checks
                                  not because those cohorts genuinely perfomed worse.
                                  Read completion figures for those cohorts with that caveat attached */
