# Lab 2 — Production DDL Script

## 1. Project Description

This project implements a relational database for a university management system using PostgreSQL.

The database manages students, lecturers, courses, enrollments, and payments.

## 2. Database Entities

The database contains five entities:

- **Students:** Stores student information, including names, email addresses, and dates of birth.
- **Lecturers:** Stores lecturer information.
- **Courses:** Stores course information and the lecturer responsible for each course.
- **Enrollments:** Connects students to courses and records their enrollment status.
- **Payments:** Records payments associated with student enrollments.

## 3. Relationships

- One lecturer can teach multiple courses.
- One student can have multiple enrollments.
- One course can have multiple enrollments.
- One enrollment can have multiple payments.

The enrollments table resolves the many-to-many relationship between students and courses.

## 4. Constraints and Design Decisions

The following constraints were implemented:

- PRIMARY KEY: Uniquely identifies every record.
- FOREIGN KEY: Maintains relationships between tables.
- NOT NULL: Ensures required fields are provided.
- UNIQUE: Prevents duplicate student emails, lecturer emails, and course codes.
- CHECK: Enforces valid course credits, payment amounts, enrollment statuses, and payment statuses.
- DEFAULT: Automatically generates timestamps and default statuses.

## 5. Referential Integrity

ON DELETE CASCADE was implemented on the student-enrollment and course-enrollment relationships.

Payments also cascade when their associated enrollment is deleted.

ON DELETE RESTRICT prevents deleting lecturers who still have assigned courses.

## 6. Testing

The tests.sql file contains:

- Positive tests for valid records.
- Negative tests for duplicate emails.
- Invalid course credits.
- Invalid foreign keys.
- Negative payment amounts.
- Cascade deletion verification.

## 7. Execution Instructions

Create the database:

```sql
CREATE DATABASE Lab2-DDL;
```

Execute the schema:

```bash
psql -U postgres -d Lab2-DDL -f schema.sql
```

Execute the tests:

```bash
psql -U postgres -d Lab2-DDL -f tests.sql
```

## 8. Technologies

- PostgreSQL 18
- SQL (DDL and DML)
- Git
- GitHub