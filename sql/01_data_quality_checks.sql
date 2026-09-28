USE arel2;
-- data quality checks.sql
-- Purpose: check the underlying records before trusting any

-- enrolment per status -- how large is the unkown
SELECT 
	status,
    COUNT(*) AS total_enrolments
FROM enrolments
-- WHERE status = 'Unknown'
GROUP BY status
ORDER BY total_enrolments;  -- 31.5% (178) of the records are unkown

-- What share of students have missing contact informaation: phone-number and email
SELECT
	SUM(email = '') missing_email,
    SUM(phone = '') missing_phone
FROM students;  -- 75% of students have missing contact details

-- How many attendance sessions have no status recorded at all
SELECT 
	status,
    COUNT(*) Unknown_attendance
FROM attendance
-- WHERE status = 'Not Recorded'
GROUP BY status
ORDER BY status DESC;  

-- Not recorded sessions as a share of the whole attendance table
SELECT 
	ROUND(100.0 * SUM(status = 'Not Recorded')/ COUNT(*), 2) AS pct_not_recorded
FROM attendance; -- 3.18% of sessions were not recorded
    