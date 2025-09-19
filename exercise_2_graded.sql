CREATE TABLE medication_stock (
    medication_id INT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO medication_stock (medication_id, medication_name, quantity) VALUES
(1, 'Aspirin', 100),
(2, 'Metformin', 75),
(3, 'Lisinopril', 50),
(4, 'Atorvastatin', 120),
(5, 'Metoprolol', 80),
(6, 'Warfarin', 40),
(7, 'Insulin', 60),
(8, 'Levothyroxine', 90);

SELECT name, age FROM patients;


SELECT * FROM doctors WHERE specialization = 'Cardiology';


SELECT * FROM patients WHERE age > 80;


SELECT * FROM patients ORDER BY age ASC;
SELECT specialization, COUNT(*) as doctor_count 
FROM doctors 

SELECT p.name as patient_name, d.name as doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

SELECT t.treatment_type, p.name as patient_name, d.name as doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

SELECT d.name as doctor_name, COUNT(p.patient_id) as patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;

SELECT AVG(age) as average_age FROM patients;

SELECT treatment_type, COUNT(*) as count
FROM treatments
GROUP BY treatment_type
ORDER BY count DESC
LIMIT 1;

SELECT name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

SELECT d.name, COUNT(p.patient_id) as patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 5;

SELECT t.treatment_type, p.name as patient_name, n.name as nurse_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'Morning';

SELECT p.name as patient_name, t.treatment_type, t.treatment_date
FROM patients p
JOIN treatments t ON p.patient_id = t.patient_id
WHERE t.treatment_date = (
    SELECT MAX(treatment_date) 
    FROM treatments 
    WHERE patient_id = p.patient_id
);

SELECT d.name as doctor_name, AVG(p.age) as average_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;

SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 3;
SELECT name
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);

SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

SELECT d.name as doctor_name, p.name as patient_name, p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age DESC) as age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id;

WITH DoctorPatientAges AS (
    SELECT d.specialization, d.name as doctor_name, p.name as patient_name, p.age,
           RANK() OVER (PARTITION BY d.specialization ORDER BY p.age DESC) as rank_by_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
)
SELECT specialization, doctor_name, patient_name, age
FROM DoctorPatientAges
WHERE rank_by_age = 1;