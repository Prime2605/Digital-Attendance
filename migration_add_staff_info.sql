-- ===================================
-- MIGRATION: Add Staff Display Info
-- Run this if you already have tables created
-- ===================================

-- Add staff_name column to otp table
ALTER TABLE otp ADD COLUMN IF NOT EXISTS staff_name TEXT;

-- Add department column to users table (if not exists)
ALTER TABLE users ADD COLUMN IF NOT EXISTS department VARCHAR(100);

-- Add year column to users table (if not exists)
ALTER TABLE users ADD COLUMN IF NOT EXISTS year INTEGER CHECK (year >= 1 AND year <= 4);

-- ===================================
-- INSERT ALL 7 STAFF MEMBERS (HODs)
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

-- Update existing demo staff with department info (backward compatibility)
UPDATE users 
SET department = 'Computer Science & Engineering', 
    name = 'Dr. A. Saradha'
WHERE email = 'staff@example.com';

-- Update existing demo student with department and year
UPDATE users 
SET department = 'Computer Science & Engineering', 
    year = 3
WHERE email = 'student@example.com';

-- Insert additional demo students
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

-- Verify changes
SELECT 'Migration Complete!' as status;
SELECT id, name, role, email, department, year FROM users WHERE role = 'staff' ORDER BY email;
SELECT id, name, role, email, department, year FROM users WHERE role = 'student' ORDER BY email;
