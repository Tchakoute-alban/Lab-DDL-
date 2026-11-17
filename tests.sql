-- =====================================
-- POSITIVE TESTS
-- =====================================

-- Insert a lecturer
INSERT INTO lecturers (full_name, email)
VALUES ('John Smith', 'john.smith@university.com');

-- Insert a student
INSERT INTO students (full_name, email, date_of_birth)
VALUES ('Alice Johnson', 'alice@gmail.com', '2004-05-15');

-- Insert a course
INSERT INTO courses (course_code, course_name, credits, lecturer_id)
VALUES (
    'CSE209',
    'Linux Fundamentals',
    3,
    (SELECT lecturer_id
     FROM lecturers
     WHERE email = 'john.smith@university.com')
);

-- Enroll the student in the course
INSERT INTO enrollments (student_id, course_id)
VALUES (
    (SELECT student_id
     FROM students
     WHERE email = 'alice@gmail.com'),

    (SELECT course_id
     FROM courses
     WHERE course_code = 'CSE209')
);

-- Make a payment
INSERT INTO payments (enrollment_id, amount, payment_status)
VALUES (
    (SELECT enrollment_id
     FROM enrollments
     WHERE student_id = (
         SELECT student_id
         FROM students
         WHERE email = 'alice@gmail.com'
     )),
     15000.00,
     'paid'
);


-- =====================================
-- NEGATIVE TESTS
-- =====================================

-- TEST 1: Duplicate student email
DO $$
BEGIN
    INSERT INTO students (full_name, email)
    VALUES ('Another Student', 'alice@gmail.com');

    RAISE EXCEPTION 'FAIL: Duplicate email was accepted';

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'PASS: Duplicate email rejected';
END $$;


-- TEST 2: Invalid course credits
DO $$
BEGIN
    INSERT INTO courses (
        course_code,
        course_name,
        credits,
        lecturer_id
    )
    VALUES (
        'CSE999',
        'Invalid Course',
        15,
        (SELECT lecturer_id
         FROM lecturers
         WHERE email = 'john.smith@university.com')
    );

    RAISE EXCEPTION 'FAIL: Invalid credits were accepted';

EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'PASS: Invalid credits rejected';
END $$;


-- TEST 3: Invalid foreign key
DO $$
BEGIN
    INSERT INTO enrollments (student_id, course_id)
    VALUES (
        -1,
        (SELECT course_id
         FROM courses
         WHERE course_code = 'CSE209')
    );

    RAISE EXCEPTION 'FAIL: Invalid student ID was accepted';

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'PASS: Invalid student ID rejected';
END $$;


-- TEST 4: Negative payment amount
DO $$
BEGIN
    INSERT INTO payments (enrollment_id, amount)
    VALUES (
        (SELECT enrollment_id
         FROM enrollments
         WHERE student_id = (
             SELECT student_id
             FROM students
             WHERE email = 'alice@gmail.com'
         )),
        -500
    );

    RAISE EXCEPTION 'FAIL: Negative payment was accepted';

EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'PASS: Negative payment rejected';
END $$;