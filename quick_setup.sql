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
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create otp table
CREATE TABLE IF NOT EXISTS otp (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    otp_code VARCHAR(6) NOT NULL,
    generated_by UUID REFERENCES users(id) ON DELETE CASCADE,
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

-- Insert demo staff user
INSERT INTO users (id, name, role, email, password) 
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'Staff User',
    'staff',
    'staff@example.com',
    'staff123'
) ON CONFLICT (email) DO NOTHING;

-- Insert demo student user
INSERT INTO users (id, name, role, email, password) 
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'Student User',
    'student',
    'student@example.com',
    'student123'
) ON CONFLICT (email) DO NOTHING;

-- Verify setup
SELECT 'Setup Complete!' as message;
SELECT COUNT(*) as total_users FROM users;
