-- Migration: Add 10 Student Accounts
-- Government College of Engineering, Erode
-- Created: 2025-10-14

-- Insert 10 student accounts with different departments and years
INSERT INTO users (name, email, password, role, department, year, created_at) VALUES
-- CSE Students
('Rajesh Kumar', 'student1@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', '3rd Year', NOW()),
('Priya Sharma', 'student2@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', '2nd Year', NOW()),

-- ECE Students
('Arun Prakash', 'student3@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', '3rd Year', NOW()),
('Divya Lakshmi', 'student4@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', '2nd Year', NOW()),

-- EEE Students
('Karthik Raj', 'student5@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', '3rd Year', NOW()),
('Sneha Reddy', 'student6@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', '2nd Year', NOW()),

-- Mechanical Students
('Vijay Kumar', 'student7@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', '3rd Year', NOW()),
('Anjali Menon', 'student8@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', '2nd Year', NOW()),

-- Civil Students
('Suresh Babu', 'student9@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', '3rd Year', NOW()),
('Kavitha Devi', 'student10@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', '2nd Year', NOW())

ON CONFLICT (email) DO NOTHING;

-- Verify the inserted students
SELECT id, name, email, role, department, year 
FROM users 
WHERE role = 'student' 
ORDER BY created_at DESC 
LIMIT 10;

-- Count total students
SELECT COUNT(*) as total_students 
FROM users 
WHERE role = 'student';

-- Students by department
SELECT department, COUNT(*) as student_count 
FROM users 
WHERE role = 'student' 
GROUP BY department 
ORDER BY student_count DESC;
