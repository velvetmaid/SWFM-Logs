CREATE TABLE IF NOT EXISTS wfm_schema.tx_attendance (
    tx_attendance_id VARCHAR(15) UNIQUE,
    attendance_date DATE,
    user_id INT,
    clock_in TIMESTAMP WITHOUT TIME ZONE,
    clock_out TIMESTAMP WITHOUT TIME ZONE,
    working_hour INTERVAL,
    username VARCHAR(150),
    employee_name VARCHAR(150),
    phone_number VARCHAR(15),
    area_id VARCHAR(5),
    area_name VARCHAR(25),
    regional_id VARCHAR(5),
    regional_name VARCHAR(25),
    cluster_id VARCHAR(5),
    cluster_name VARCHAR(50)
)