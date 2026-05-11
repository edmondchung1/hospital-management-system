<img width="770" height="622" alt="image" src="https://github.com/user-attachments/assets/7eca67d9-14b7-47f5-a5fd-bb639b69ff05" /># Hospital Management System Database

A relational database project designed to support hospital operations including patient management, appointments, medical records, surgeries, room/bed tracking, and staff scheduling.

Built using MySQL with a Kaggle dataset containing real-world hospital data.
**Tools:** MySQL · SQL · ERD Design · Database Normalization


**Dataset:** [Hospital Management System on Kaggle](https://www.kaggle.com/datasets/mshamoonbutt/hospital-management-system/data)

---

## Table of Contents

- [Project Overview](#project-overview)
- [Database Schema](#database-schema)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Normalization](#normalization)
- [SQL Queries](#sql-queries)
- [Key Findings](#key-findings)
- [Future Scope](#future-scope)
- [How to Run](#how-to-run)

---

## Project Overview

This database was designed to address the data management needs of large healthcare organizations dealing with high patient volumes and complex operational workflows. The system centralizes data across departments, enabling better resource allocation, patient tracking, and financial reporting.

**Who benefits from this system:**
- Hospitals and large healthcare networks
- Facilities managing complex multi-department operations
- Organizations looking to improve efficiency in patient care and resource planning

**Competitive advantages of this design:**
- Integrated Appointment, MedicalRecord, and Patient tables for full visit history
- BedRecords and RoomRecords linked to Ward for real-time capacity tracking
- SurgeryRecord tied to both patient and surgeon with timestamps and room assignment
- Department-level data enabling cross-functional analytics

---

## Database Schema

The database contains **14 tables** spanning patients, clinical staff, facilities, and transactions.

| Table | Description |
|---|---|
| `Patients` | Patient demographics and contact info |
| `Doctor` | Doctor profiles and department assignments |
| `Nurse` | Nurse profiles and department assignments |
| `Helpers` | Support staff profiles |
| `Department` | Hospital departments |
| `Appointment` | Scheduled visits between patients and doctors |
| `MedicalRecord` | Diagnosis, vitals, and treatment per visit |
| `SurgeryRecord` | Surgery details including surgeon, room, and timing |
| `Room` | Room inventory by department and type |
| `Ward` | Ward details linked to departments |
| `Bed` | Individual beds linked to wards |
| `RoomRecords` | Patient room admission and discharge history |
| `BedRecords` | Patient bed admission and discharge history |
| `StaffShift` | Shift scheduling for doctors, nurses, and helpers |

### Key Entity Attributes

**Patients**
- `patient_Id` (PK) - Integer, unique, not null
- `FName`, `LName` - Alphanumeric, max 100 chars, not null
- `Gender` - M/F, null handled as unknown
- `Date_Of_Birth` - Date, no future dates allowed
- `contact_No`, `pt_Address` - Optional, may be null

**Doctor**
- `doct_Id` (PK) - Integer, unique, not null
- `dept_Id` (FK) - Links to Department, range 101-131
- `surgeon_Type` - Null if doctor is not a surgeon

**Appointment**
- `appointment_Id` (PK) - Integer, unique, not null
- `patient_Id`, `doct_Id` (FK) - Both required, not null
- `appointment_status` - Enum: scheduled, completed, canceled

**MedicalRecord**
- `record_Id` (PK), `patient_Id` (FK), `doct_Id` (FK)
- Vitals: `curr_Weight`, `curr_Height`, `curr_Blood_Pressure`, `curr_Temp_F`
- Clinical: `diagnosis`, `treatment`, `next_Visit`

---

## Entity Relationship Diagram

![ERD](diagrams/erd_diagram.png)

### Relationships

**Patient relationships:**
- One patient can have many appointments (each appointment belongs to one patient)
- One patient can have many medical records (each record belongs to one patient)
- One patient can have multiple room and bed admissions over time

**Doctor relationships:**
- One doctor can have many appointments, medical records, shifts, and surgeries
- Each doctor belongs to one department

**Department relationships:**
- One department can have many doctors, nurses, helpers, rooms, and wards

**Facility relationships:**
- One ward contains many beds
- One room can be used for many surgeries and room records
- One nurse or helper can be assigned to multiple room records, bed records, and surgeries

---

## Normalization

All 14 tables were analyzed for 3rd Normal Form (3NF) compliance.

| # | Table | 3NF Status |
|---|---|---|
| 1 | Patients | Already 3NF |
| 2 | Appointment | Already 3NF |
| 3 | Bed | Already 3NF |
| 4 | BedRecords | Already 3NF |
| 5 | Department | Already 3NF |
| 6 | Doctor | Already 3NF |
| 7 | Helpers | Already 3NF |
| 8 | MedicalRecord | Already 3NF |
| 9 | Nurse | Already 3NF |
| 10 | Room | Already 3NF |
| 11 | RoomRecords | Already 3NF |
| 12 | StaffShift | Already 3NF |
| 13 | **SurgeryRecord** | **Transitive dependency found, converted to 3NF** |
| 14 | Wards | Already 3NF |

### 3NF Conversion: SurgeryRecord

**Issue found:** `surgeon_id → surgery_type` created a transitive dependency since each surgeon always performs the same surgery type.

**Fix:** Extracted a separate `Surgeon` table containing `surgeon_id` and `surgery_type`, removing the transitive dependency from `SurgeryRecord`.

```
Before:
SurgeryRecord(surgery_id, patient_id, surgeon_id, surgery_type, ...)
                                           ^______________|
                                           transitive dependency

After:
SurgeryRecord(surgery_id, patient_id, surgeon_id, surgery_date, ...)
Surgeon(surgeon_id, surgery_type)
```

---

## SQL Queries

All queries are in [`sql/queries.sql`](sql/queries.sql).

### Query Overview

| # | Query | Type |
|---|---|---|
| 1 | Patient appointments with assigned doctors | JOIN |
| 2 | Number of doctors per department | GROUP BY |
| 3 | Total revenue and appointments per department | JOIN + AGG |
| 4 | Payment mode distribution | GROUP BY + PERCENT |
| 5 | Surgeries with surgeon info | JOIN |
| 6 | Bed count per ward with department | JOIN |
| 7 | Patient demographics by age group and gender | CASE + GROUP BY |
| 8 | Top diagnoses with patient count and avg temp | JOIN + AGG |
| 9 | Patients who have never booked an appointment | Subquery |
| 10 | Doctors with above-average appointment load | Subquery + HAVING |

---

## Key Findings

**Staffing:** General Medicine has the most doctors (52), followed by Critical Care (51) and Emergency Medicine (47). Specialty departments like Cardiology and Neurology are comparatively understaffed relative to their appointment volume.

**Revenue:** General Medicine generated the most revenue (830,436 total across 505 appointments) with an average payment of ~1,644 per visit. Neurology had the highest average payment at 1,714.

**Payments:** Payment methods are nearly evenly distributed: Digital Wallet (26.2%), Cash (24.7%), Card (24.6%), Insurance (24.5%), suggesting the system needs to support all four methods equally.

**Patient Demographics:** The over-60 age group is the largest patient segment (320F, 272M), which should inform resource planning for geriatric and chronic disease departments.

**Top Diagnoses:** General Checkup accounts for the most cases (1,799), followed by Migraine Headache and Essential Hypertension (both 137). Viral Fever stands out with an elevated average temperature of 101.4F compared to 98.0F for most other diagnoses.

**Workload:** Dr. Raza Hasnain has a significantly above-average appointment load at 505 total appointments, the only doctor exceeding the average threshold, which may indicate a need for workload redistribution.

**Unengaged Patients:** A number of registered patients have never booked an appointment, representing an outreach and engagement opportunity for the hospital.

---

## Future Scope

Given more time and resources, the natural next steps for this system would be:

- **Predictive analytics** to forecast patient demand and hospital capacity by department and season
- **Real-time operational dashboard** using Tableau or Power BI connected to the live database
- **Billing and insurance integration** for full end-to-end financial management
- **Patient risk scoring** based on vitals, diagnosis history, and visit frequency to support early intervention
- **Cross-hospital data integration** to enable analytics across healthcare networks

---

## How to Run

### Requirements
- MySQL 8.0+
- Any SQL client (MySQL Workbench, DBeaver, etc.)

### Setup
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/mshamoonbutt/hospital-management-system/data)
2. Import the CSV files into your MySQL instance
3. Run the queries in [`sql/queries.sql`](sql/queries.sql)

### File Structure
```
hospital-management-system/
├── README.md
├── sql/
│   └── queries.sql
├── diagrams/
│   └── erd_diagram.png
└── docs/
    └── presentation.pdf
```

---

## Team

Built as a group project for Business Data Management at UCI Paul Merage School of Business.

Dataset source: [Kaggle - Hospital Management System](https://www.kaggle.com/datasets/mshamoonbutt/hospital-management-system/data)
