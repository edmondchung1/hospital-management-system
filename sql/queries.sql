-- ============================================================
-- Hospital Management System - SQL Queries
-- Business Data Management | UCI Paul Merage School of Business
-- Dataset: https://www.kaggle.com/datasets/mshamoonbutt/hospital-management-system
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Patient Appointments with Assigned Doctors
-- Shows which patients are assigned to which doctors.
-- Useful for scheduling oversight and patient-doctor relationship tracking.
-- ------------------------------------------------------------

SELECT
    P.patient_Id        AS PatientID,
    P.FName             AS PatientFirstName,
    P.LName             AS PatientLastName,
    D.doct_Id           AS DoctorID,
    D.FName             AS DoctorFirstName,
    D.LName             AS DoctorLastName,
    A.reason            AS Reason,
    A.appointment_Date  AS AppointmentDate,
    A.appointment_status AS AppointmentStatus
FROM Appointment A
JOIN Patients P ON A.patient_Id = P.patient_Id
JOIN Doctor D   ON A.doct_Id    = D.doct_Id;


-- ------------------------------------------------------------
-- Query 2: Number of Doctors in Each Department
-- Shows doctor distribution across departments.
-- Helps identify understaffed or overstaffed departments.
-- ------------------------------------------------------------

SELECT
    Dept.dept_Name      AS DepartmentName,
    COUNT(D.doct_Id)    AS TotalDoctors
FROM Department Dept
JOIN Doctor D ON Dept.dept_Id = D.dept_Id
GROUP BY Dept.dept_Name
ORDER BY TotalDoctors DESC;


-- ------------------------------------------------------------
-- Query 3: Total Revenue and Appointments Per Department
-- Compares departments by appointment volume and revenue generated.
-- Key for financial planning and resource allocation.
-- ------------------------------------------------------------

SELECT
    dept.dept_Name                          AS DepartmentName,
    COUNT(a.appointment_Id)                 AS TotalAppointments,
    SUM(a.payment_amount)                   AS TotalRevenue,
    ROUND(AVG(a.payment_amount), 2)         AS AvgPayment
FROM Appointment a
JOIN Doctor D       ON a.doct_Id    = D.doct_Id
JOIN Department dept ON D.dept_Id  = dept.dept_Id
GROUP BY dept.dept_Name
ORDER BY TotalRevenue DESC
LIMIT 8;


-- ------------------------------------------------------------
-- Query 4: Payment Mode Distribution
-- Breaks down how patients are paying for services.
-- Informs which payment methods need to be prioritized.
-- ------------------------------------------------------------

SELECT
    mode_of_payment                                                         AS ModeOfPayment,
    COUNT(*)                                                                AS Count,
    SUM(payment_amount)                                                     AS Total,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Appointment), 1)        AS Percent
FROM Appointment
GROUP BY mode_of_payment
ORDER BY Total DESC;


-- ------------------------------------------------------------
-- Query 5: Surgeries with Surgeon Information
-- Tracks recent surgeries and the doctors performing them.
-- Useful for surgical scheduling and outcome monitoring.
-- ------------------------------------------------------------

SELECT
    p.FName             AS PatientFirstName,
    p.LName             AS PatientLastName,
    d.FName             AS SurgeonFirstName,
    d.LName             AS SurgeonLastName,
    dept.dept_Name      AS Department,
    sr.surgery_Type     AS SurgeryType,
    sr.surgery_Date     AS SurgeryDate,
    sr.notes            AS Notes
FROM SurgeryRecord sr
JOIN Patients p      ON sr.patient_Id   = p.patient_Id
JOIN Doctor d        ON sr.surgeon_Id   = d.doct_Id
JOIN Department dept ON d.dept_Id       = dept.dept_Id
ORDER BY sr.surgery_Date DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 6: Bed Count Per Ward with Department
-- Shows bed availability broken down by ward and department.
-- Supports capacity planning and patient admission decisions.
-- ------------------------------------------------------------

SELECT
    w.ward_Name         AS WardName,
    dept.dept_Name      AS DepartmentName,
    COUNT(b.bed_No)     AS TotalBeds
FROM Bed b
JOIN Ward w         ON b.ward_No    = w.ward_No
JOIN Department dept ON w.dept_Id  = dept.dept_Id
GROUP BY w.ward_Name, dept.dept_Name
ORDER BY TotalBeds DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 7: Patient Demographics by Age Group and Gender
-- Segments patient population by age and gender.
-- Useful for understanding which patient groups drive the most demand.
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) < 18  THEN 'Under 18'
        WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 18 AND 40 THEN '18-40'
        WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE 'Over 60'
    END AS AgeGroup,
    Gender,
    COUNT(*) AS Count
FROM Patients
GROUP BY AgeGroup, Gender
ORDER BY AgeGroup, Gender;


-- ------------------------------------------------------------
-- Query 8: Top Diagnoses with Patient Count and Avg Temperature
-- Identifies the most common diagnoses across all patients.
-- The avg temperature by diagnosis can signal systemic health patterns.
-- ------------------------------------------------------------

SELECT
    mr.diagnosis                            AS Diagnosis,
    COUNT(*)                                AS TotalCases,
    COUNT(DISTINCT mr.patient_Id)           AS UniquePatients,
    ROUND(AVG(mr.curr_Temp_F), 1)           AS AvgTempF
FROM MedicalRecord mr
JOIN Patients p ON mr.patient_Id = p.patient_Id
GROUP BY mr.diagnosis
ORDER BY TotalCases DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 9: Patients Who Have Never Booked an Appointment
-- Finds registered patients with zero appointment history.
-- Represents a patient engagement and outreach opportunity.
-- ------------------------------------------------------------

SELECT
    patient_Id      AS PatientID,
    FName           AS PatientFirstName,
    LName           AS PatientLastName,
    Gender
FROM Patients
WHERE patient_Id NOT IN (
    SELECT patient_Id FROM Appointment
)
LIMIT 10;


-- ------------------------------------------------------------
-- Query 10: Doctors with Above-Average Appointment Load
-- Identifies doctors whose appointment count exceeds the system average.
-- Helps flag potential burnout risks and workload imbalances.
-- ------------------------------------------------------------

SELECT
    D.doct_Id           AS DoctorID,
    D.FName             AS DoctorFirstName,
    D.LName             AS DoctorLastName,
    COUNT(A.appointment_Id) AS TotalAppointments
FROM Doctor D
JOIN Appointment A ON D.doct_Id = A.doct_Id
GROUP BY D.doct_Id, D.FName, D.LName
HAVING COUNT(A.appointment_Id) > (
    SELECT AVG(doctor_appointments)
    FROM (
        SELECT COUNT(*) AS doctor_appointments
        FROM Appointment
        GROUP BY doct_Id
    ) AS avg_table
);
