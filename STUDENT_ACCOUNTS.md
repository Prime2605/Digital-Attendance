# 👨‍🎓 Student Accounts

## 📋 All Student Accounts

### Password for All Students: `student123`

---

## 🎓 Computer Science and Engineering (CSE)

### 1. Rajesh Kumar
- **Email:** `student1@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Computer Science and Engineering
- **Year:** 3rd Year
- **Role:** Student

### 2. Priya Sharma
- **Email:** `student2@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Computer Science and Engineering
- **Year:** 2nd Year
- **Role:** Student

---

## 📡 Electronics and Communication Engineering (ECE)

### 3. Arun Prakash
- **Email:** `student3@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Electronics and Communication Engineering
- **Year:** 3rd Year
- **Role:** Student

### 4. Divya Lakshmi
- **Email:** `student4@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Electronics and Communication Engineering
- **Year:** 2nd Year
- **Role:** Student

---

## ⚡ Electrical and Electronics Engineering (EEE)

### 5. Karthik Raj
- **Email:** `student5@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Electrical and Electronics Engineering
- **Year:** 3rd Year
- **Role:** Student

### 6. Sneha Reddy
- **Email:** `student6@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Electrical and Electronics Engineering
- **Year:** 2nd Year
- **Role:** Student

---

## ⚙️ Mechanical Engineering

### 7. Vijay Kumar
- **Email:** `student7@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Mechanical Engineering
- **Year:** 3rd Year
- **Role:** Student

### 8. Anjali Menon
- **Email:** `student8@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Mechanical Engineering
- **Year:** 2nd Year
- **Role:** Student

---

## 🏗️ Civil Engineering

### 9. Suresh Babu
- **Email:** `student9@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Civil Engineering
- **Year:** 3rd Year
- **Role:** Student

### 10. Kavitha Devi
- **Email:** `student10@gceerode.ac.in`
- **Password:** `student123`
- **Department:** Civil Engineering
- **Year:** 2nd Year
- **Role:** Student

---

## 📊 Summary

### Total Students: 10

| Department | Count | Years |
|------------|-------|-------|
| Computer Science and Engineering | 2 | 2nd, 3rd |
| Electronics and Communication Engineering | 2 | 2nd, 3rd |
| Electrical and Electronics Engineering | 2 | 2nd, 3rd |
| Mechanical Engineering | 2 | 2nd, 3rd |
| Civil Engineering | 2 | 2nd, 3rd |

---

## 🔐 Login Credentials

### Quick Reference Table

| # | Name | Email | Password | Department | Year |
|---|------|-------|----------|------------|------|
| 1 | Rajesh Kumar | student1@gceerode.ac.in | student123 | CSE | 3rd |
| 2 | Priya Sharma | student2@gceerode.ac.in | student123 | CSE | 2nd |
| 3 | Arun Prakash | student3@gceerode.ac.in | student123 | ECE | 3rd |
| 4 | Divya Lakshmi | student4@gceerode.ac.in | student123 | ECE | 2nd |
| 5 | Karthik Raj | student5@gceerode.ac.in | student123 | EEE | 3rd |
| 6 | Sneha Reddy | student6@gceerode.ac.in | student123 | EEE | 2nd |
| 7 | Vijay Kumar | student7@gceerode.ac.in | student123 | Mechanical | 3rd |
| 8 | Anjali Menon | student8@gceerode.ac.in | student123 | Mechanical | 2nd |
| 9 | Suresh Babu | student9@gceerode.ac.in | student123 | Civil | 3rd |
| 10 | Kavitha Devi | student10@gceerode.ac.in | student123 | Civil | 2nd |

---

## 🚀 How to Add These Accounts

### Option 1: Supabase Dashboard (Recommended)

1. **Go to Supabase:**
   - Visit: https://supabase.com/dashboard
   - Select your project

2. **Open SQL Editor:**
   - Click "SQL Editor" in left sidebar
   - Click "New Query"

3. **Run Migration:**
   - Open `migration_add_students.sql`
   - Copy all contents
   - Paste into SQL Editor
   - Click "Run" or press `Ctrl + Enter`

4. **Verify:**
   ```sql
   SELECT name, email, department, year 
   FROM users 
   WHERE role = 'student' 
   ORDER BY name;
   ```

### Option 2: Manual Insert

If you prefer to add one by one:

```sql
INSERT INTO users (name, email, password, role, department, year, created_at) 
VALUES 
('Rajesh Kumar', 'student1@gceerode.ac.in', 'student123', 'student', 'Computer Science and Engineering', '3rd Year', NOW());
```

---

## 🧪 Testing

### Test Login for Each Student

1. **Go to:** http://localhost:5000 (or your Vercel URL)
2. **Login with:**
   - Email: `student1@gceerode.ac.in`
   - Password: `student123`
3. **Should see:** Student Dashboard
4. **Repeat for all 10 students**

### Test Attendance Marking

1. **Staff generates OTP**
2. **Student logs in**
3. **Enters OTP**
4. **Attendance marked successfully**
5. **Check history shows:**
   - Period number
   - Staff name
   - Exact time

---

## 📱 Use Cases

### Scenario 1: CSE Class
- **Staff:** Dr. A. Saradha (CSE)
- **Students:** Rajesh Kumar, Priya Sharma
- **Period:** 3
- **All CSE students mark attendance**

### Scenario 2: ECE Class
- **Staff:** Mr. M. Raja (ECE)
- **Students:** Arun Prakash, Divya Lakshmi
- **Period:** 5
- **All ECE students mark attendance**

### Scenario 3: Mixed Class
- **Staff:** Any staff member
- **Students:** From different departments
- **Period:** Any
- **Test cross-department attendance**

---

## 🔍 Verification Queries

### Check All Students
```sql
SELECT * FROM users WHERE role = 'student' ORDER BY name;
```

### Students by Department
```sql
SELECT department, COUNT(*) as count 
FROM users 
WHERE role = 'student' 
GROUP BY department;
```

### Students by Year
```sql
SELECT year, COUNT(*) as count 
FROM users 
WHERE role = 'student' 
GROUP BY year;
```

### Recent Attendance
```sql
SELECT u.name, a.date, a.period, a.time, a.staff_name
FROM attendance a
JOIN users u ON a.student_id = u.id
WHERE u.role = 'student'
ORDER BY a.created_at DESC
LIMIT 20;
```

---

## 📊 Department Distribution

```
CSE:        ██████████ (2 students)
ECE:        ██████████ (2 students)
EEE:        ██████████ (2 students)
Mechanical: ██████████ (2 students)
Civil:      ██████████ (2 students)
```

### Year Distribution

```
2nd Year: █████████████████████ (5 students)
3rd Year: █████████████████████ (5 students)
```

---

## 🎯 Features to Test

### With Multiple Students

1. **Bulk Attendance:**
   - Generate one OTP
   - Multiple students enter same OTP
   - All get marked present

2. **Department Filtering:**
   - Filter attendance by department
   - See only CSE students
   - See only ECE students

3. **Statistics:**
   - Total attendance count
   - Department-wise breakdown
   - Period-wise analysis

4. **Reports:**
   - Export CSV with all students
   - Filter by date range
   - Department-wise reports

---

## 🔐 Security Notes

### Password Policy
- **Current:** Simple password for testing
- **Production:** Should use strong passwords
- **Recommendation:** Implement password hashing

### Email Format
- **Pattern:** `studentN@gceerode.ac.in`
- **Domain:** Official college domain
- **Unique:** Each student has unique email

---

## 📝 Additional Students (If Needed)

### Template for More Students
```sql
INSERT INTO users (name, email, password, role, department, year, created_at) 
VALUES 
('Student Name', 'student11@gceerode.ac.in', 'student123', 'student', 'Department Name', 'Year', NOW());
```

### Departments Available
- Computer Science and Engineering
- Electronics and Communication Engineering
- Electrical and Electronics Engineering
- Mechanical Engineering
- Civil Engineering
- Information Technology
- Automobile Engineering

---

## ✅ Post-Migration Checklist

- [ ] Run `migration_add_students.sql` in Supabase
- [ ] Verify 10 students created
- [ ] Test login for each student
- [ ] Check department distribution
- [ ] Test attendance marking
- [ ] Verify attendance history shows correctly
- [ ] Test attendance rate calculations
- [ ] Check CSV export includes all students

---

## 🎓 Student Information

### Naming Convention
- **First Name + Last Name**
- **Mix of male and female names**
- **Common Indian names**
- **Professional format**

### Email Convention
- **Format:** `studentN@gceerode.ac.in`
- **N:** Sequential number (1-10)
- **Domain:** Official college domain
- **Lowercase:** All lowercase letters

### Department Assignment
- **Balanced:** 2 students per department
- **Realistic:** Actual GCEE departments
- **Diverse:** Different engineering branches

### Year Assignment
- **2nd Year:** 5 students
- **3rd Year:** 5 students
- **Balanced:** Equal distribution
- **Realistic:** Active students

---

**10 student accounts are ready to be created!** 👨‍🎓✨

Run `migration_add_students.sql` in Supabase to add them all at once.
