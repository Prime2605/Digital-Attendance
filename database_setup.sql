-- ===================================
-- SMART ATTENDANCE SYSTEM
-- Supabase Database Setup Script
-- ===================================

-- Enable UUID extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===================================
-- DROP EXISTING TABLES (if needed)
-- ===================================
-- Uncomment the following lines if you want to reset the database
-- DROP TABLE IF EXISTS attendance CASCADE;
-- DROP TABLE IF EXISTS otp CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;

-- ===================================
-- CREATE USERS TABLE
-- ===================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('staff', 'student')),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comment to users table
COMMENT ON TABLE users IS 'Stores user information for staff and students';
COMMENT ON COLUMN users.role IS 'User role: staff or student';
COMMENT ON COLUMN users.email IS 'Unique email address for login';

-- ===================================
-- CREATE OTP TABLE
-- ===================================
CREATE TABLE IF NOT EXISTS otp (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    otp_code VARCHAR(6) NOT NULL,
    generated_by UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Add comment to otp table
-- CREATE ATTENDANCE TABLE
-- ===================================

-- Create attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    period INTEGER NOT NULL CHECK (period >= 1 AND period <= 8),
    time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'present' CHECK (status IN ('present', 'absent', 'late')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comment to attendance table
COMMENT ON TABLE attendance IS 'Stores student attendance records';
COMMENT ON COLUMN attendance.status IS 'Attendance status: present, absent, or late';

-- ===================================
-- CREATE INDEXES FOR PERFORMANCE
-- ===================================

-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- OTP table indexes
CREATE INDEX IF NOT EXISTS idx_otp_code ON otp(otp_code);
CREATE INDEX IF NOT EXISTS idx_otp_generated_by ON otp(generated_by);
CREATE INDEX IF NOT EXISTS idx_otp_expires_at ON otp(expires_at);

-- Attendance table indexes
CREATE INDEX IF NOT EXISTS idx_attendance_student ON attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_attendance_created_at ON attendance(created_at);
CREATE INDEX IF NOT EXISTS idx_attendance_student_date ON attendance(student_id, date);

-- ===================================
-- CREATE CONSTRAINTS
-- ===================================

-- Ensure one attendance record per student per period per day
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_attendance_per_period 
ON attendance(student_id, date, period);

-- ===================================
-- INSERT DEMO DATA
-- ===================================

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

-- Insert additional demo students
INSERT INTO users (name, role, email, password) VALUES
('Alice Johnson', 'student', 'alice@example.com', 'alice123'),
('Bob Smith', 'student', 'bob@example.com', 'bob123'),
('Charlie Brown', 'student', 'charlie@example.com', 'charlie123'),
('Diana Prince', 'student', 'diana@example.com', 'diana123'),
('Eve Wilson', 'student', 'eve@example.com', 'eve123')
ON CONFLICT (email) DO NOTHING;

-- Insert additional demo staff
INSERT INTO users (name, role, email, password) VALUES
('Prof. John Doe', 'staff', 'john.doe@example.com', 'john123'),
('Dr. Jane Smith', 'staff', 'jane.smith@example.com', 'jane123')
ON CONFLICT (email) DO NOTHING;

-- ===================================
-- CREATE VIEWS FOR REPORTING
-- ===================================

-- View: Daily attendance summary
CREATE OR REPLACE VIEW daily_attendance_summary AS
SELECT 
    a.date,
    COUNT(DISTINCT a.student_id) as total_present,
    COUNT(DISTINCT u.id) FILTER (WHERE u.role = 'student') as total_students,
    ROUND(
        (COUNT(DISTINCT a.student_id)::DECIMAL / 
         NULLIF(COUNT(DISTINCT u.id) FILTER (WHERE u.role = 'student'), 0)) * 100, 
        2
    ) as attendance_percentage
FROM attendance a
CROSS JOIN users u
WHERE u.role = 'student'
GROUP BY a.date
ORDER BY a.date DESC;

-- View: Student attendance history with details
CREATE OR REPLACE VIEW student_attendance_history AS
SELECT 
    u.id as student_id,
    u.name as student_name,
    u.email as student_email,
    a.date,
    a.time,
    a.status,
    a.created_at
FROM users u
LEFT JOIN attendance a ON u.id = a.student_id
WHERE u.role = 'student'
ORDER BY a.created_at DESC;

-- ===================================
-- CREATE FUNCTIONS
-- ===================================

-- Function to clean up expired OTPs (optional, for maintenance)
CREATE OR REPLACE FUNCTION cleanup_expired_otps()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM otp WHERE expires_at < NOW();
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to get attendance statistics for a student
CREATE OR REPLACE FUNCTION get_student_attendance_stats(student_uuid UUID)
RETURNS TABLE(
    total_days INTEGER,
    present_days INTEGER,
    attendance_rate DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_days,
        COUNT(*) FILTER (WHERE status = 'present')::INTEGER as present_days,
        ROUND(
            (COUNT(*) FILTER (WHERE status = 'present')::DECIMAL / NULLIF(COUNT(*), 0)) * 100,
            2
        ) as attendance_rate
    FROM attendance
    WHERE student_id = student_uuid;
END;
$$ LANGUAGE plpgsql;

-- ===================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- ===================================
-- Uncomment if you want to enable RLS for additional security

-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE otp ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Create policies (example - customize based on your needs)
-- CREATE POLICY "Users can view their own data" ON users
--     FOR SELECT USING (auth.uid() = id);

-- CREATE POLICY "Staff can generate OTPs" ON otp
--     FOR INSERT WITH CHECK (
--         EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'staff')
--     );

-- CREATE POLICY "Students can view their attendance" ON attendance
--     FOR SELECT USING (student_id = auth.uid());

-- ===================================
-- GRANT PERMISSIONS
-- ===================================
-- Grant necessary permissions to authenticated users
-- GRANT SELECT, INSERT ON users TO authenticated;
-- GRANT SELECT, INSERT ON otp TO authenticated;
-- GRANT SELECT, INSERT ON attendance TO authenticated;

-- ===================================
-- VERIFICATION QUERIES
-- ===================================
-- Run these to verify the setup

-- Check if tables were created
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- AND table_name IN ('users', 'otp', 'attendance');

-- Check demo users
-- SELECT id, name, role, email FROM users;

-- Check indexes
-- SELECT indexname, tablename FROM pg_indexes 
-- WHERE schemaname = 'public' 
-- ORDER BY tablename, indexname;

-- ===================================
-- SETUP COMPLETE
-- ===================================
-- Your Smart Attendance System database is now ready!
-- 
-- Demo Credentials:
-- Staff: staff@example.com / staff123
-- Student: student@example.com / student123
