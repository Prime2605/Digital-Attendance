-- ============================================
-- COMPLETE DATABASE SETUP
-- Smart Attendance System - GCEE
-- Run this entire file in Supabase SQL Editor
-- ============================================

-- Step 1: Add staff_name column to attendance table
ALTER TABLE attendance 
ADD COLUMN IF NOT EXISTS staff_name TEXT;

-- Update existing records
UPDATE attendance 
SET staff_name = 'Unknown Staff'
WHERE staff_name IS NULL;

-- Step 2: Insert Staff Accounts (7 staff members)
INSERT INTO users (name, email, password, role, department, created_at) VALUES
('Dr. P. Saravanakumar', 'staff1@gceerode.ac.in', 'staff123', 'staff', 'Civil Engineering', NOW()),
('Dr. R. Senthilraja', 'staff2@gceerode.ac.in', 'staff123', 'staff', 'Automobile Engineering', NOW()),
('Dr. K. Balamurugan', 'staff3@gceerode.ac.in', 'staff123', 'staff', 'Mechanical Engineering', NOW()),
('Dr. M. Mohammadha Hussaini', 'staff4@gceerode.ac.in', 'staff123', 'staff', 'Electrical and Electronics Engineering', NOW()),
('Mr. M. Raja', 'staff5@gceerode.ac.in', 'staff123', 'staff', 'Electronics and Communication Engineering', NOW()),
('Dr. A. Saradha', 'staff6@gceerode.ac.in', 'staff123', 'staff', 'Computer Science and Engineering', NOW()),
('Dr. I. Bhuvaneshwarri', 'staff7@gceerode.ac.in', 'staff123', 'staff', 'Information Technology', NOW())
ON CONFLICT (email) DO NOTHING;

-- Step 3: Insert Student Accounts (10 students)
INSERT INTO users (name, email, password, role, department, year, created_at) VALUES
('Rajesh Kumar', 'student1@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', 3, NOW()),
('Priya Sharma', 'student2@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', 2, NOW()),
('Arun Prakash', 'student3@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', 3, NOW()),
('Divya Lakshmi', 'student4@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', 2, NOW()),
('Karthik Raj', 'student5@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', 3, NOW()),
('Sneha Reddy', 'student6@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', 2, NOW()),
('Vijay Kumar', 'student7@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', 3, NOW()),
('Anjali Menon', 'student8@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', 2, NOW()),
('Suresh Babu', 'student9@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', 3, NOW()),
('Kavitha Devi', 'student10@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', 2, NOW())
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check all users
SELECT '=== ALL USERS ===' as info;
SELECT id, name, email, role, department, year 
FROM users 
ORDER BY role DESC, name;

-- Count by role
SELECT '=== USER COUNT BY ROLE ===' as info;
SELECT role, COUNT(*) as count 
FROM users 
GROUP BY role;

-- Staff list
SELECT '=== STAFF MEMBERS ===' as info;
SELECT name, email, department 
FROM users 
WHERE role = 'staff' 
ORDER BY name;

-- Student list
SELECT '=== STUDENTS ===' as info;
SELECT name, email, department, year 
FROM users 
WHERE role = 'student' 
ORDER BY department, name;

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- 
-- LOGIN CREDENTIALS:
-- 
-- STAFF (Password: staff123)
-- - staff1@gceerode.ac.in to staff7@gceerode.ac.in
-- 
-- STUDENTS (Password: student123)
-- - student1@gceerode.ac.in to student10@gceerode.ac.in
-- 
-- ============================================
