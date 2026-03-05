.open fittrackpro.db
.mode box

-- 6.1 
INSERT INTO attendance (attendance_id, member_id, location_id, check_in_time)
VALUES (4, 7, 1, '2025-02-14 16:30:00');

-- 6.2 
SELECT date(check_in_time) AS visit_date,
       check_in_time,
       check_out_time
FROM attendance
WHERE member_id = 5;

-- 6.3 
SELECT strftime('%W', check_in_time) AS day_of_week,
       COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC;
-- %W gives the number of the week about the whole year
-- by that I mean the index of the number for the week (from total weeks in year)

-- 6.4 
SELECT l.name AS location_name,
       ROUND(COUNT(a.attendance_id) * 1.0 / 
       (julianday(MAX(a.check_in_time)) - julianday(MIN(a.check_in_time)) + 1), 2) AS avg_daily_attendance
FROM locations l
LEFT JOIN attendance a ON l.location_id = a.location_id
GROUP BY l.location_id;
-- MAX takes the latest value, MIN takes earliest value, 
-- add 1 to account for the first day
-- again LEFT JOIN takes left table values unconditionally
