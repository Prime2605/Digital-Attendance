# 🗄️ Database Setup Guide

## ⚠️ IMPORTANT: Run These Migrations First!

If you're getting "Invalid email or password" errors, it means the accounts haven't been created in the database yet.

---

## 🚀 Quick Setup (3 Steps)

### Step 1: Open Supabase Dashboard
1. Go to: https://supabase.com/dashboard
2. Login to your account
3. Select your project: **avepxrzlkzpzoallhllw**

### Step 2: Open SQL Editor
1. Click **"SQL Editor"** in the left sidebar
2. Click **"New Query"** button

### Step 3: Run Migrations (In Order)

---

## 📋 Migration 1: Add Staff Accounts

**File:** `migration_add_staff_info.sql`

```sql
-- Copy and paste this entire block into SQL Editor

-- Add staff accounts
INSERT INTO users (name, email, password, role, department, created_at) VALUES
('Dr. P. Saravanakumar', 'staff1@gceerode.ac.in', 'staff123', 'staff', 'Civil Engineering', NOW()),
('Dr. R. Senthilraja', 'staff2@gceerode.ac.in', 'staff123', 'staff', 'Automobile Engineering', NOW()),
('Dr. K. Balamurugan', 'staff3@gceerode.ac.in', 'staff123', 'staff', 'Mechanical Engineering', NOW()),
('Dr. M. Mohammadha Hussaini', 'staff4@gceerode.ac.in', 'staff123', 'staff', 'Electrical and Electronics Engineering', NOW()),
('Mr. M. Raja', 'staff5@gceerode.ac.in', 'staff123', 'staff', 'Electronics and Communication Engineering', NOW()),
('Dr. A. Saradha', 'staff6@gceerode.ac.in', 'staff123', 'staff', 'Computer Science and Engineering', NOW()),
('Dr. I. Bhuvaneshwarri', 'staff7@gceerode.ac.in', 'staff123', 'staff', 'Information Technology', NOW())
ON CONFLICT (email) DO NOTHING;
```

**Click "Run" or press Ctrl+Enter**

---

## 📋 Migration 2: Add Student Accounts

**File:** `migration_add_students.sql`

```sql
-- Copy and paste this entire block into SQL Editor

-- Add 10 student accounts
INSERT INTO users (name, email, password, role, department, year, created_at) VALUES
('Rajesh Kumar', 'student1@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', '3rd Year', NOW()),
('Priya Sharma', 'student2@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', '2nd Year', NOW()),
('Arun Prakash', 'student3@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', '3rd Year', NOW()),
('Divya Lakshmi', 'student4@gceerode.ac.in', 'student123', 'student', 'Electronics and Communication Engineering', '2nd Year', NOW()),
('Karthik Raj', 'student5@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', '3rd Year', NOW()),
('Sneha Reddy', 'student6@gceerode.ac.in', 'student123', 'student', 'Electrical and Electronics Engineering', '2nd Year', NOW()),
('Vijay Kumar', 'student7@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', '3rd Year', NOW()),
('Anjali Menon', 'student8@gceerode.ac.in', 'student123', 'student', 'Mechanical Engineering', '2nd Year', NOW()),
('Suresh Babu', 'student9@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', '3rd Year', NOW()),
('Kavitha Devi', 'student10@gceerode.ac.in', 'student123', 'student', 'Civil Engineering', '2nd Year', NOW())
ON CONFLICT (email) DO NOTHING;
```

**Click "Run" or press Ctrl+Enter**

---

## 📋 Migration 3: Add Staff Name Column

**File:** `migration_add_staff_name.sql`

```sql
-- Copy and paste this entire block into SQL Editor

-- Add staff_name column to attendance table
ALTER TABLE attendance 
ADD COLUMN IF NOT EXISTS staff_name TEXT;

-- Update existing records
UPDATE attendance 
SET staff_name = 'Unknown Staff'
WHERE staff_name IS NULL;
```

**Click "Run" or press Ctrl+Enter**

---

## ✅ Verify Setup

After running all migrations, verify with this query:

```sql
-- Check all users
SELECT id, name, email, role, department 
FROM users 
ORDER BY role, name;
```

**Expected Result:**
- 7 staff accounts
- 10 student accounts
- Total: 17 users

---

## 🧪 Test Login

### Test Staff Login
```
Email: staff1@gceerode.ac.in
Password: staff123
```

**Should redirect to:** Staff Dashboard

### Test Student Login
```
Email: student1@gceerode.ac.in
Password: student123
```

**Should redirect to:** Student Dashboard

---

## 🔍 Troubleshooting

### Issue: "Invalid email or password"

**Cause:** Accounts not created in database

**Solution:**
1. Run Migration 1 (Staff accounts)
2. Run Migration 2 (Student accounts)
3. Try login again

### Issue: "User already exists"

**Cause:** Accounts already created

**Solution:**
- This is normal if you ran migrations before
- Just try logging in with existing credentials

### Issue: "Column 'staff_name' does not exist"

**Cause:** Migration 3 not run

**Solution:**
1. Run Migration 3 (Add staff_name column)
2. Refresh the page

---

## 📊 All Login Credentials

### Staff Accounts (Password: staff123)

| Email | Name | Department |
|-------|------|------------|
| staff1@gceerode.ac.in | Dr. P. Saravanakumar | Civil |
| staff2@gceerode.ac.in | Dr. R. Senthilraja | Automobile |
| staff3@gceerode.ac.in | Dr. K. Balamurugan | Mechanical |
| staff4@gceerode.ac.in | Dr. M. Mohammadha Hussaini | EEE |
| staff5@gceerode.ac.in | Mr. M. Raja | ECE |
| staff6@gceerode.ac.in | Dr. A. Saradha | CSE |
| staff7@gceerode.ac.in | Dr. I. Bhuvaneshwarri | IT |

### Student Accounts (Password: student123)

| Email | Name | Department | Year |
|-------|------|------------|------|
| student1@gceerode.ac.in | Rajesh Kumar | CSE | 3rd |
| student2@gceerode.ac.in | Priya Sharma | CSE | 2nd |
| student3@gceerode.ac.in | Arun Prakash | ECE | 3rd |
| student4@gceerode.ac.in | Divya Lakshmi | ECE | 2nd |
| student5@gceerode.ac.in | Karthik Raj | EEE | 3rd |
| student6@gceerode.ac.in | Sneha Reddy | EEE | 2nd |
| student7@gceerode.ac.in | Vijay Kumar | Mechanical | 3rd |
| student8@gceerode.ac.in | Anjali Menon | Mechanical | 2nd |
| student9@gceerode.ac.in | Suresh Babu | Civil | 3rd |
| student10@gceerode.ac.in | Kavitha Devi | Civil | 2nd |

---

## 🎯 Complete Setup Checklist

- [ ] Open Supabase Dashboard
- [ ] Open SQL Editor
- [ ] Run Migration 1 (Staff accounts)
- [ ] Run Migration 2 (Student accounts)
- [ ] Run Migration 3 (Add staff_name column)
- [ ] Verify users created
- [ ] Test staff login
- [ ] Test student login
- [ ] Generate OTP as staff
- [ ] Mark attendance as student
- [ ] Check attendance history

---

## 🔗 Quick Links

- **Supabase Dashboard:** https://supabase.com/dashboard
- **Your Project:** https://avepxrzlkzpzoallhllw.supabase.co
- **Local App:** http://localhost:5000
- **Vercel App:** (Your deployed URL)

---

## 💡 Pro Tips

1. **Copy Entire SQL Block:** Don't copy line by line
2. **Run All at Once:** Each migration can be run as one query
3. **Check Output:** Look for "Success" message
4. **Refresh Page:** After running migrations, refresh your app
5. **Clear Cache:** If still issues, clear browser cache (Ctrl+Shift+R)

---

## 🆘 Still Having Issues?

### Check Database Connection
```sql
SELECT NOW();
```
**Should return:** Current timestamp

### Check Users Table
```sql
SELECT COUNT(*) FROM users;
```
**Should return:** 17 (or more if you added others)

### Check Specific User
```sql
SELECT * FROM users WHERE email = 'staff1@gceerode.ac.in';
```
**Should return:** Staff details

### Reset Password (If Needed)
```sql
UPDATE users 
SET password = 'staff123' 
WHERE email = 'staff1@gceerode.ac.in';
```

---

**After running these migrations, all login issues should be resolved!** ✅
