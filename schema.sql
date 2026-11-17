CREATE TABLE lecturers (
    lecturer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email CITEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email CITEXT NOT NULL UNIQUE,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    credits INTEGER NOT NULL CHECK (credits BETWEEN 1 AND 10),
    lecturer_id INTEGER NOT NULL,

    CONSTRAINT fk_course_lecturer
        FOREIGN KEY (lecturer_id)
        REFERENCES lecturers(lecturer_id)
        ON DELETE RESTRICT
);

CREATE TABLE enrollments (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'enrolled',

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE,

    CONSTRAINT unique_student_course
        UNIQUE (student_id, course_id),

    CONSTRAINT valid_enrollment_status
        CHECK (status IN ('enrolled', 'completed', 'dropped'))
);

CREATE TABLE payments (
    payment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id INTEGER NOT NULL,
    amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',

    CONSTRAINT fk_payment_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE,

    CONSTRAINT valid_payment_status
        CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded'))
);

CREATE INDEX idx_courses_lecturer
ON courses(lecturer_id);

CREATE INDEX idx_enrollments_course
ON enrollments(course_id);

CREATE INDEX idx_payments_enrollment
ON payments(enrollment_id);