# Database Schema Reference

## Tables and Columns

### Patients
| Column | Type | Constraints |
|---|---|---|
| patient_Id | INT | PK, NOT NULL |
| FName | VARCHAR(100) | NOT NULL |
| LName | VARCHAR(100) | NOT NULL |
| Gender | CHAR(1) | M/F, nullable |
| Date_Of_Birth | DATE | No future dates |
| contact_No | VARCHAR(15) | Nullable |
| pt_Address | VARCHAR(255) | Nullable |

### Doctor
| Column | Type | Constraints |
|---|---|---|
| doct_Id | INT | PK, NOT NULL |
| dept_Id | INT | FK -> Department |
| FName | VARCHAR(100) | NOT NULL |
| LName | VARCHAR(100) | NOT NULL |
| Gender | CHAR(1) | M/F, nullable |
| contact_No | VARCHAR(15) | Nullable |
| surgeon_Type | VARCHAR(100) | Null if not surgeon |
| office_No | VARCHAR(20) | Nullable |

### Appointment
| Column | Type | Constraints |
|---|---|---|
| appointment_Id | INT | PK, NOT NULL |
| patient_Id | INT | FK -> Patients |
| doct_Id | INT | FK -> Doctor |
| reason | VARCHAR(255) | Nullable |
| appointment_Date | DATE | NOT NULL |
| payment_amount | INT | Min 0, no negatives |
| mode_of_payment | VARCHAR(50) | cash/card/insurance/digital wallet |
| mode_of_appointment | VARCHAR(50) | Nullable |
| appointment_status | VARCHAR(20) | scheduled/completed/canceled |

### MedicalRecord
| Column | Type | Constraints |
|---|---|---|
| record_Id | INT | PK, NOT NULL |
| doct_Id | INT | FK -> Doctor |
| patient_Id | INT | FK -> Patients |
| visit_Date | DATE | NOT NULL |
| curr_Weight | DECIMAL | Min > 0, nullable |
| curr_Height | DECIMAL | Min > 0, nullable |
| curr_Blood_Pressure | VARCHAR(20) | Nullable |
| curr_Temp_F | DECIMAL | Nullable |
| diagnosis | VARCHAR(255) | Nullable |
| treatment | VARCHAR(255) | Nullable |
| next_Visit | DATE | Nullable |

### SurgeryRecord (post-3NF conversion)
| Column | Type | Constraints |
|---|---|---|
| surgery_Id | INT | PK, NOT NULL |
| patient_Id | INT | FK -> Patients |
| surgeon_Id | INT | FK -> Doctor (also FK -> Surgeon) |
| surgery_Date | DATE | NOT NULL |
| start_Time | TIME | Nullable |
| end_Time | TIME | Nullable |
| room_No | INT | FK -> Room |
| notes | TEXT | Nullable |
| nurse_Id | INT | FK -> Nurse, nullable |
| helper_Id | INT | FK -> Helpers, nullable |

### Surgeon (new table from 3NF fix)
| Column | Type | Constraints |
|---|---|---|
| surgeon_Id | INT | PK, FK -> Doctor |
| surgery_Type | VARCHAR(100) | NOT NULL |

### RoomRecords
| Column | Type | Constraints |
|---|---|---|
| admission_ID | INT | PK, NOT NULL |
| room_No | INT | FK -> Room |
| patient_Id | INT | FK -> Patients |
| nurse_Id | INT | FK -> Nurse, nullable |
| helper_Id | INT | FK -> Helpers, nullable |
| admission_Date | DATE | NOT NULL |
| discharge_Date | DATE | Must be after admission, nullable if still admitted |
| amount | INT | Min 0 |
| mode_of_payment | VARCHAR(50) | Nullable |

### BedRecords
| Column | Type | Constraints |
|---|---|---|
| admission_Id | INT | PK, NOT NULL |
| bed_No | INT | FK -> Bed |
| patient_Id | INT | FK -> Patients |
| nurse_Id | INT | FK -> Nurse, nullable |
| helper_Id | INT | FK -> Helpers, nullable |
| admission_Date | DATE | NOT NULL |
| discharge_Date | DATE | Nullable if still admitted |
| amount | INT | Min 0 |
| mode_of_payment | VARCHAR(50) | Nullable |

### Department
| Column | Type | Constraints |
|---|---|---|
| dept_Id | INT | PK, NOT NULL |
| dept_Name | VARCHAR(100) | NOT NULL |

### Ward
| Column | Type | Constraints |
|---|---|---|
| ward_No | INT | PK, NOT NULL |
| ward_Name | VARCHAR(100) | NOT NULL |
| dept_Id | INT | FK -> Department |

### Bed
| Column | Type | Constraints |
|---|---|---|
| bed_No | INT | PK, NOT NULL |
| ward_No | INT | FK -> Ward |

### Room
| Column | Type | Constraints |
|---|---|---|
| room_No | INT | PK, NOT NULL |
| dept_Id | INT | FK -> Department |
| room_Type | VARCHAR(50) | Nullable |

### Nurse
| Column | Type | Constraints |
|---|---|---|
| nurse_Id | INT | PK, NOT NULL |
| dept_Id | INT | FK -> Department |
| FName | VARCHAR(100) | NOT NULL |
| LName | VARCHAR(100) | NOT NULL |
| Gender | CHAR(1) | Nullable |
| contact_No | VARCHAR(15) | Nullable |

### Helpers
| Column | Type | Constraints |
|---|---|---|
| helper_Id | INT | PK, NOT NULL |
| dept_Id | INT | FK -> Department |
| FName | VARCHAR(100) | NOT NULL |
| LName | VARCHAR(100) | NOT NULL |
| Gender | CHAR(1) | Nullable |
| contact_No | VARCHAR(15) | Nullable |

### StaffShift
| Column | Type | Constraints |
|---|---|---|
| shift_Id | INT | PK, NOT NULL |
| doct_Id | INT | FK -> Doctor, nullable |
| nurse_Id | INT | FK -> Nurse, nullable |
| helper_Id | INT | FK -> Helpers, nullable |
| shift_Date | DATE | NOT NULL |
| shift_Start | TIME | NOT NULL |
| shift_End | TIME | NOT NULL |
