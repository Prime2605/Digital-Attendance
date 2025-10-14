-- Quick Setup for Smart Attendance System
-- Copy and paste this ENTIRE script into Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('staff', 'student')),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100),
    year INTEGER CHECK (year >= 1 AND year <= 4),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create otp table
CREATE TABLE IF NOT EXISTS otp (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    otp_code VARCHAR(6) NOT NULL,
    generated_by UUID REFERENCES users(id) ON DELETE CASCADE,
    staff_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Create attendance table with period column
CREATE TABLE IF NOT EXISTS attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    period INTEGER NOT NULL CHECK (period >= 1 AND period <= 8),
    time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'present' CHECK (status IN ('present', 'absent', 'late')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_otp_code ON otp(otp_code);
CREATE INDEX IF NOT EXISTS idx_attendance_student ON attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date);

-- Unique constraint: one attendance per student per period per day
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_attendance_per_period 
ON attendance(student_id, date, period);

-- ===================================
-- INSERT ALL STAFF MEMBERS (7 HODs)
-- ===================================
-- All staff use password: staff123

-- Staff 1: Civil Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'Dr. P. Saravanakumar',
    'staff',
    'staff1@gceerode.ac.in',
    'staff123',
    'Civil Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 2: Automobile Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'Dr. R. Senthilraja',
    'staff',
    'staff2@gceerode.ac.in',
    'staff123',
    'Automobile Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 3: Mechanical Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '33333333-3333-3333-3333-333333333333',
    'Dr. K. Balamurugan',
    'staff',
    'staff3@gceerode.ac.in',
    'staff123',
    'Mechanical Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 4: Electrical & Electronics Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '44444444-4444-4444-4444-444444444444',
    'Dr. M. Mohammadha Hussaini',
    'staff',
    'staff4@gceerode.ac.in',
    'staff123',
    'Electrical & Electronics Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 5: Electronics & Communication Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '55555555-5555-5555-5555-555555555555',
    'Mr. M. Raja',
    'staff',
    'staff5@gceerode.ac.in',
    'staff123',
    'Electronics & Communication Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 6: Computer Science & Engineering
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '66666666-6666-6666-6666-666666666666',
    'Dr. A. Saradha',
    'staff',
    'staff6@gceerode.ac.in',
    'staff123',
    'Computer Science & Engineering'
) ON CONFLICT (email) DO NOTHING;

-- Staff 7: Information Technology
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    '77777777-7777-7777-7777-777777777777',
    'Dr. I. Bhuvaneshwarri',
    'staff',
    'staff7@gceerode.ac.in',
    'staff123',
    'Information Technology'
) ON CONFLICT (email) DO NOTHING;

-- Legacy staff account (for backward compatibility)
INSERT INTO users (id, name, role, email, password, department) 
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'Dr. A. Saradha',
    'staff',
    'staff@example.com',
    'staff123',
    'Computer Science & Engineering'
) ON CONFLICT (email) DO NOTHING;

-- ===================================
-- INSERT DEMO STUDENTS
-- ===================================

-- Student 1: CSE Department
INSERT INTO users (id, name, role, email, password, department, year) 
VALUES (
    '88888888-8888-8888-8888-888888888888',
    'Rajesh Kumar',
    'student',
    'student1@gceerode.ac.in',
    'student123',
    'Computer Science & Engineering',
    3
) ON CONFLICT (email) DO NOTHING;

-- Student 2: ECE Department
INSERT INTO users (id, name, role, email, password, department, year) 
VALUES (
    '99999999-9999-9999-9999-999999999999',
    'Priya Sharma',
    'student',
    'student2@gceerode.ac.in',
    'student123',
    'Electronics & Communication Engineering',
    2
) ON CONFLICT (email) DO NOTHING;

-- Legacy student account (for backward compatibility)
INSERT INTO users (id, name, role, email, password, department, year) 
VALUES (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'Student User',
    'student',
    'student@example.com',
    'student123',
    'Computer Science & Engineering',
    3
) ON CONFLICT (email) DO NOTHING;

-- Verify setup
SELECT 'Setup Complete!' as message;
SELECT COUNT(*) as total_users FROM users;
