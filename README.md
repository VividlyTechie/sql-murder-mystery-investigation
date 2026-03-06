# SQL Murder Mystery – Data Investigation

## Project Overview
This project recreates a **forensic data investigation** using SQL to solve a fictional murder that occurred on **January 15, 2018 in SQL City**. Acting as a data analyst, I queried a relational database to identify the suspect by analyzing crime reports, witness statements, gym membership records, driver's licenses, and event attendance data.

The investigation demonstrates how SQL can be used to **extract insights from multiple related datasets and reconstruct real-world scenarios through structured querying.**

---

## Skills Demonstrated

- SQL Querying
- Multi-table Joins
- Pattern Matching (`ILIKE`, wildcards)
- Aggregation (`GROUP BY`, `HAVING`)
- Common Table Expressions (**CTEs**)
- Set Operations (`UNION`)
- Relational Data Exploration

---

## Investigation Summary

### 1. Crime Scene Analysis
Queried the `crime_scene_report` table to identify witness leads related to the January 15 incident.

### 2. Witness Investigation
Retrieved interview transcripts from **Morty Schapiro** and **Annabel Miller**, which revealed clues about the suspect's gym membership and vehicle.

### 3. Identifying the Suspect
Cross-referenced **Get Fit Now Gym memberships, check-ins, and driver's license records** to identify **Jeremy Bowers** as the hitman.

### 4. Identifying the Mastermind
Using testimony from the suspect, I filtered the database by physical description, vehicle type, and event attendance to uncover **Miranda Priestly** as the mastermind.

---

## Key Result

The investigation concluded that **Jeremy Bowers** committed the murder, while **Miranda Priestly** orchestrated the crime.

---

## Repository Structure
sql-murder-mystery-investigation
│
├── README.md
├── ERD.png
│
└── sql
    ├── table_creation
    │
    │
    ├── inserting_data
    │   
    │
    ├── detective_query
    │   
    │
    └── inserting_table
    │   
    │
    └── investigation log.pdf
        
