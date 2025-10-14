# 🏫 Government College of Engineering, Erode

## College Information

**Name (Tamil):** அரசினர் பொறியியல் கல்லூரி, ஈரோடு  
**Name (English):** Government College of Engineering, Erode  
**Affiliation:** Approved by AICTE, New Delhi and Affiliated to Anna University, Chennai

---

## 📚 Departments & Programs

### 1. Civil Engineering
- **Degree:** B.E. Civil Engineering
- **HOD:** Dr. P. Saravanakumar
- **Qualification:** M.E., Ph.D.

### 2. Automobile Engineering
- **Degree:** B.E. Automobile Engineering
- **HOD:** Dr. R. Senthilraja (i/c Additional Charge)
- **Qualification:** M.E., Ph.D.

### 3. Mechanical Engineering
- **Degree:** B.E. Mechanical Engineering
- **HOD:** Dr. K. Balamurugan
- **Qualification:** M.E., Ph.D.

### 4. Electrical & Electronics Engineering (EEE)
- **Degree:** B.E. Electrical & Electronics Engineering
- **HOD:** Dr. M. Mohammadha Hussaini
- **Qualification:** M.E., Ph.D.

### 5. Electronics & Communication Engineering (ECE)
- **Degree:** B.E. Electronics & Communication Engineering
- **HOD:** Mr. M. Raja
- **Qualification:** M.E.

### 6. Computer Science & Engineering (CSE)
- **Degree:** B.E. Computer Science & Engineering
- **HOD:** Dr. A. Saradha
- **Qualification:** M.E., Ph.D.

### 7. Computer Science & Engineering (Data Science)
- **Degree:** B.E. Computer Science & Engineering (Data Science)
- **HOD:** Dr. A. Saradha
- **Qualification:** M.E., Ph.D.

### 8. Information Technology (IT)
- **Degree:** B.Tech Information Technology
- **HOD:** Dr. I. Bhuvaneshwarri (Incharge)
- **Qualification:** M.E., Ph.D.

---

## 📍 Contact Information

**Address:** Perundurai Road, Erode - 638 316, Tamil Nadu, India  
**Phone:** +91-4294-226602  
**Email:** principal@gceerode.ac.in  
**Website:** https://www.gceerode.ac.in

---

## 🎨 College Branding

The Smart Attendance System features:

- **Dual Logos:** GCEE emblem (left) and Tamil Nadu Government emblem (right)
- **Bilingual Header:** Tamil and English college names
- **Gold-Black-Silver Theme:** Matching college colors
- **Department Integration:** All 8 departments included in the system

---

## 📊 Database Integration

The `college_data.json` file contains:

```json
{
  "college": { ... },
  "departments": [ ... ],
  "logos": { ... },
  "contact": { ... }
}
```

### Usage in Flask:

```python
import json

# Load college data
with open('college_data.json') as f:
    college_data = json.load(f)

# Access departments
departments = college_data['departments']

# Get HOD info
cse_hod = next(d['hod'] for d in departments if d['id'] == 'CSE')
```

---

## 🔄 Updated Database Schema

The `users` table now includes:

- `department` (VARCHAR): Department name (CE, AUTO, MECH, EEE, ECE, CSE, CSE_DS, IT)
- `year` (INTEGER): Year of study (1-4) for students

This allows filtering attendance by department and year.

---

## ✅ Implementation Checklist

- [x] College data JSON created
- [x] Dual logos added to navbar
- [x] Tamil font support (Noto Sans Tamil)
- [x] Bilingual college name display
- [x] Department field added to database
- [x] Year field added for students
- [x] Demo data updated with department info
- [x] CSS styling for logos and branding

---

## 🚀 Next Steps

1. **Run Updated SQL Script:**
   - Use `quick_setup.sql` which now includes department and year fields
   - This will create tables with the new schema

2. **Test the Application:**
   - Check navbar displays both logos
   - Verify Tamil text renders correctly
   - Test login with department-enabled users

3. **Future Enhancements:**
   - Department-wise attendance reports
   - Year-wise filtering
   - HOD dashboard for department-specific data
   - Department-specific OTP generation

---

**The Smart Attendance System is now fully branded for Government College of Engineering, Erode! 🎓**
