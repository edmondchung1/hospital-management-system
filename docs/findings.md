# Query Findings and Analysis

A summary of what each query revealed from the Hospital Management System dataset.

---

## Q1 - Patient Appointments with Assigned Doctors

Basic operational query joining patients to their scheduled appointments and assigned doctors. Confirms referential integrity across the three core tables and surfaces appointment status tracking (scheduled, completed, canceled) at a patient level.

---

## Q2 - Doctor Distribution by Department

General Medicine (52 doctors) and Critical Care (51) are the most staffed departments. Specialty departments like Cardiology (7), Oncology (6), and Neurology (5) have significantly fewer doctors despite high appointment demand seen in Q3. This imbalance is worth flagging for hospital administrators.

---

## Q3 - Revenue and Appointments by Department

General Medicine dominates in both volume (505 appointments) and total revenue (830,436). However, Neurology has the highest average payment per visit at 1,714, suggesting specialty care commands a price premium even with lower appointment counts. Endocrinology rounds out the top 5 despite having only 3 doctors from Q2.

---

## Q4 - Payment Mode Distribution

Payment methods are nearly evenly split across all four modes:
- Digital Wallet: 26.2%
- Cash: 24.7%
- Card: 24.6%
- Insurance: 24.5%

No single method dominates, which means the hospital's billing and payment infrastructure needs to support all four equally. Insurance being the lowest at 24.5% is worth monitoring given the industry shift toward insurance-based reimbursement.

---

## Q5 - Surgeries with Surgeon Information

Returns the most recent surgical cases with full surgeon and department context. All top 10 results fall under the Surgery department as expected. Notes like "Need special care" and "Transfer to ICU" appear across multiple cases, suggesting post-surgical escalation is common and should be tracked more systematically.

---

## Q6 - Bed Count by Ward and Department

General Medicine Ward has the most beds (38), followed by Surgical Ward (36) and ICU under Critical Care (30). Interestingly, ICU appears twice across two different departments (Critical Care and Cardiology), suggesting shared ICU infrastructure across specialties. Oncology Ward has 24 beds despite Oncology having only 6 doctors from Q2.

---

## Q7 - Patient Demographics by Age and Gender

The over-60 group is the largest patient segment (320 female, 272 male), totaling 592 patients. This is nearly double the next largest group (18-40 female at 179). The data strongly suggests this hospital primarily serves an older population and should prioritize geriatric care, chronic disease management, and longer average stays in its capacity planning.

---

## Q8 - Top Diagnoses with Avg Temperature

General Checkup is by far the most common record type (1,799 cases vs. 137 for the next closest diagnoses), which may indicate a large preventive or wellness care segment. Viral Fever stands out with an average temperature of 101.4F compared to 98.0F for nearly every other diagnosis, providing a potential signal for automated triage flagging.

---

## Q9 - Patients with No Appointment History

Multiple registered patients have never booked an appointment. These could represent:
- Patients registered during emergencies who never followed up
- Incomplete data from system migration
- Outreach targets for preventive care programs

This list feeds directly into a patient engagement strategy.

---

## Q10 - Above-Average Appointment Workload

Only one doctor, Dr. Raza Hasnain (ID 1027), exceeds the average appointment threshold with 505 total appointments. Given that General Medicine has 52 doctors and 505 total appointments from Q3, this suggests Dr. Hasnain may be handling a disproportionate share. If this is accurate, it is a clear workload distribution issue worth addressing at the department level.
