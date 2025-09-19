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

- Q1: List all patients name and ages
SELECT name, age FROM patients;

-- Q2: List all doctors specializing in 'Cardiology'
SELECT * FROM doctors WHERE specialization = 'Cardiology';

-- Q3: Find all patients that are older than 80
SELECT * FROM patients WHERE age > 80;

-- Q4: List all the patients ordered by their age (youngest first)
SELECT * FROM patients ORDER BY age ASC;

-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) as doctor_count 
FROM doctors 
GROUP BY specialization;

-- Q6: List patients and their doctors' names
SELECT p.name as patient_name, d.name as doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: Show treatments along with patient names and doctor names
SELECT t.treatment_type, p.name as patient_name, d.name as doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

-- Q8: Count how many patients each doctor supervises
SELECT d.name as doctor_name, COUNT(p.patient_id) as patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;

-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) as average_age FROM patients;

-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type, COUNT(*) as count
FROM treatments
GROUP BY treatment_type
ORDER BY count DESC
LIMIT 1;

-- Q11: List patients who are older than the average age of all patients
SELECT name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: List all the doctors who have more than 5 patients
SELECT d.name, COUNT(p.patient_id) as patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 5;

-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well.
SELECT t.treatment_type, p.name as patient_name, n.name as nurse_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'Morning';

-- Q14: Find the latest treatment for each patient
SELECT p.name as patient_name, t.treatment_type, t.treatment_date
FROM patients p
JOIN treatments t ON p.patient_id = t.patient_id
WHERE t.treatment_date = (
    SELECT MAX(treatment_date) 
    FROM treatments 
    WHERE patient_id = p.patient_id
);

-- Q15: List all the doctors and average age of their patients
SELECT d.name as doctor_name, AVG(p.age) as average_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;

-- Q16: List the names of the doctors who supervise more than 3 patients
SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 3;

-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)
SELECT name
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);

-- Q18: List all the medicines whose stock (quantity) is less than the average stock
SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

-- Q19: For each doctor, rank their patients by age
SELECT d.name as doctor_name, p.name as patient_name, p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age DESC) as age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id;

-- Q20: For each specialization, find the doctor with the oldest patient
WITH DoctorPatientAges AS (
    SELECT d.specialization, d.name as doctor_name, p.name as patient_name, p.age,
           RANK() OVER (PARTITION BY d.specialization ORDER BY p.age DESC) as rank_by_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
)
SELECT specialization, doctor_name, patient_name, age
FROM DoctorPatientAges
WHERE rank_by_age = 1;