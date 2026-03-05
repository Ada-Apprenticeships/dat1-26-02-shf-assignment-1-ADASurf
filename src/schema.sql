.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;
-- see comment on the insertion.sql about this

DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;
-- DROP TABLE exists to reset the db when schema is re read/remove duplicated tables

CREATE TABLE locations(
    location_id INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    opening_hours VARCHAR(20) NOT NULL
);

CREATE TABLE members(
    member_id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_number VARCHAR(12) NOT NULL,
    date_of_birth DATE NOT NULL,
    join_date DATE NOT NULL,
    emergency_contact_name VARCHAR(50) NOT NULL,
    emergency_contact_phone VARCHAR(12) NOT NULL
);

CREATE TABLE staff(
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_number VARCHAR(12) NOT NULL,
    position VARCHAR(20) NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment(
    equipment_id INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes(
    class_id INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200),
    capacity INT NOT NULL CHECK (capacity > 0),
    duration INT NOT NULL CHECK (duration > 0),
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule(
    schedule_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    staff_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    CHECK (end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships(
    membership_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    type VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    CHECK (end_date > start_date),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance(
    attendance_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    location_id INT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance(
    class_attendance_id INT PRIMARY KEY,
    schedule_id INT NOT NULL,
    member_id INT NOT NULL,
    attendance_status VARCHAR(15) NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE payments(
    payment_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    -- added cash as a payment method due to inconsistency with the Read Me and csv
    payment_type VARCHAR(30) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions(
    session_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    staff_id INT NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes VARCHAR(200),
    CHECK (end_time > start_time),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics(
    metric_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    measurement_date DATE NOT NULL,
    weight DECIMAL(5,2) CHECK (weight > 0),
    body_fat_percentage DECIMAL(5,2) CHECK (body_fat_percentage BETWEEN 0 AND 100),
    muscle_mass DECIMAL(5,2) CHECK (muscle_mass > 0),
    bmi DECIMAL(5,2) CHECK (bmi > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
    -- decimal allows is like varchar for eg here 5 characters but then allows 2 decimal points 
);

CREATE TABLE equipment_maintenance_log(
    log_id INT PRIMARY KEY,
    equipment_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description VARCHAR(200),
    staff_id INT NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);