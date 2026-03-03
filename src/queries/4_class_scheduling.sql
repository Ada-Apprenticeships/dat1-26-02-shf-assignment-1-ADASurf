.open fittrackpro.db
.mode column

-- 4.1 
SELECT c.class_id,
       c.name AS class_name,
       s.first_name || ' ' || s.last_name AS instructor_name 
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN staff s ON cs.staff_id = s.staff_id;

-- 4.2 
SELECT c.class_id,
       c.name,
       cs.start_time,
       cs.end_time,
       c.capacity - COUNT(ca.class_attendance_id) AS available_spots
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE date(cs.start_time) = '2025-02-01'
GROUP BY cs.schedule_id;

-- 4.3 
INSERT INTO class_attendance (class_attendance_id, schedule_id, member_id, attendance_status)
VALUES (16, 1, 11, 'Registered');

-- 4.4 
DELETE FROM class_attendance
WHERE member_id = 3 AND schedule_id = 7;

-- 4.5 
SELECT c.class_id,
       c.name AS class_name,
       COUNT(*) AS registration_count
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id
ORDER BY registration_count DESC
LIMIT 1;

-- 4.6 
SELECT ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT member_id), 2) AS avg_classes_per_member
FROM class_attendance
WHERE attendance_status IN ('Registered', 'Attended');
