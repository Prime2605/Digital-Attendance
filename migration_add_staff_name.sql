-- Migration: Add staff_name column to attendance table
-- This stores which staff member's OTP was used for attendance

-- Add staff_name column to attendance table
ALTER TABLE attendance 
ADD COLUMN IF NOT EXISTS staff_name TEXT;

-- Add comment to explain the column
COMMENT ON COLUMN attendance.staff_name IS 'Name of staff member who generated the OTP used for this attendance';

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_attendance_staff_name ON attendance(staff_name);

-- Update existing records (optional - set to 'Unknown' for old records)
UPDATE attendance 
SET staff_name = 'Unknown Staff'
WHERE staff_name IS NULL;

-- Verify the changes
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'attendance' AND column_name = 'staff_name';

-- Show sample data
SELECT id, student_id, date, period, time, staff_name, status
FROM attendance
ORDER BY created_at DESC
LIMIT 5;
