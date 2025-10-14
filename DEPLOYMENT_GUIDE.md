# 🚀 Deployment Guide - Smart Attendance System

## 📋 Prerequisites

Before deploying, ensure you have:
- ✅ Vercel account (free)
- ✅ GitHub account (free)
- ✅ Supabase account (already set up)
- ✅ Git installed on your computer

---

## 🔧 Step 1: Install Git (If Not Installed)

### Windows
1. Download Git from: https://git-scm.com/download/win
2. Run installer with default settings
3. Restart your terminal/IDE

### Verify Installation
```bash
git --version
# Should show: git version 2.x.x
```

---

## 📦 Step 2: Initialize Git Repository

Open terminal in project folder and run:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Commit changes
git commit -m "Fix cross-server OTP and timezone issues"
```

---

## 🌐 Step 3: Create GitHub Repository

### Option A: GitHub Website
1. Go to: https://github.com/new
2. Repository name: `smart-attendance-gcee`
3. Description: `Smart Attendance System for GCEE`
4. Visibility: **Private** (recommended)
5. Click "Create repository"

### Option B: GitHub Desktop
1. Download: https://desktop.github.com/
2. Install and login
3. File → Add Local Repository
4. Select your project folder
5. Publish to GitHub

---

## 🔗 Step 4: Push to GitHub

```bash
# Add GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/smart-attendance-gcee.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Enter your GitHub credentials when prompted**

---

## ☁️ Step 5: Deploy to Vercel

### Method 1: Vercel Website (Recommended)

1. **Go to Vercel:**
   - Visit: https://vercel.com/
   - Click "Sign Up" or "Login"
   - Choose "Continue with GitHub"

2. **Import Project:**
   - Click "Add New..." → "Project"
   - Select "Import Git Repository"
   - Find `smart-attendance-gcee`
   - Click "Import"

3. **Configure Project:**
   - Framework Preset: **Other**
   - Root Directory: `./`
   - Build Command: (leave empty)
   - Output Directory: (leave empty)
   - Install Command: `pip install -r requirements.txt`

4. **Environment Variables:**
   Click "Environment Variables" and add:
   
   ```
   SUPABASE_URL = https://avepxrzlkzpzoallhllw.supabase.co
   SUPABASE_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2ZXB4cnpsa3pwem9hbGxobGx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNTk4NzQsImV4cCI6MjA3NTkzNTg3NH0.ulppHDWgfh7E96X0COAcwFTyxq9W292TDVJctPVS6QU
   SECRET_KEY = a4c1b2f3a89d0e4fbcfe1234ab56cd78
   ```

5. **Deploy:**
   - Click "Deploy"
   - Wait 2-3 minutes
   - You'll get a URL like: `https://smart-attendance-gcee.vercel.app`

### Method 2: Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy
vercel

# Follow prompts:
# - Set up and deploy? Y
# - Which scope? (select your account)
# - Link to existing project? N
# - Project name? smart-attendance-gcee
# - Directory? ./
# - Override settings? N

# Deploy to production
vercel --prod
```

---

## 🗄️ Step 6: Run Database Migration

### Supabase Dashboard

1. **Open Supabase:**
   - Go to: https://supabase.com/dashboard
   - Select your project

2. **SQL Editor:**
   - Click "SQL Editor" in left sidebar
   - Click "New Query"

3. **Run Migration:**
   - Open `migration_add_staff_info.sql` from your project
   - Copy all contents
   - Paste into Supabase SQL Editor
   - Click "Run" or press `Ctrl + Enter`

4. **Verify:**
   ```sql
   -- Check if staff accounts were created
   SELECT * FROM users WHERE email LIKE '%@gceerode.ac.in';
   
   -- Should show 7 staff accounts
   ```

---

## ✅ Step 7: Test Deployment

### Test 1: Access Website
1. Open your Vercel URL: `https://your-app.vercel.app`
2. Should see login page ✅

### Test 2: Staff Login
1. Email: `staff1@gceerode.ac.in`
2. Password: `staff123`
3. Should login successfully ✅

### Test 3: Student Login
1. Email: `student@example.com`
2. Password: `student123`
3. Should login successfully ✅

### Test 4: Cross-Server OTP
1. **On your laptop:**
   - Login as staff
   - Generate OTP
   - Note the 6-digit code

2. **On mobile (Vercel URL):**
   - Login as student
   - Enter the OTP
   - Should mark attendance ✅

---

## 🔄 Step 8: Future Updates

Whenever you make changes:

```bash
# Save changes
git add .
git commit -m "Description of changes"
git push origin main

# Vercel auto-deploys in 2-3 minutes!
```

---

## 🐛 Troubleshooting

### Issue: "Application Error" on Vercel

**Solution:**
1. Check Vercel logs:
   - Go to Vercel dashboard
   - Click your project
   - Click "Deployments"
   - Click latest deployment
   - Check "Build Logs" and "Function Logs"

2. Common fixes:
   - Ensure `requirements.txt` is correct
   - Check environment variables are set
   - Verify `vercel.json` is present

---

### Issue: OTP Still Not Working

**Check:**
1. Database migration ran successfully
2. Both servers use same Supabase URL
3. Clear browser cache (Ctrl + Shift + R)

**Test Database:**
```sql
-- In Supabase SQL Editor
SELECT * FROM otp ORDER BY created_at DESC LIMIT 5;
-- Should show recent OTPs
```

---

### Issue: Staff Login Fails

**Solution:**
```sql
-- In Supabase SQL Editor
-- Check if staff exists
SELECT * FROM users WHERE email = 'staff1@gceerode.ac.in';

-- If empty, run migration again
-- Copy paste migration_add_staff_info.sql
```

---

### Issue: "Period is over" Error

**Current Setup:**
- Testing mode is enabled
- Works anytime (not just class hours)

**To Enable Strict Mode:**
1. Open `app.py`
2. Find line 275-282
3. Comment out: `current_period = 1`
4. Uncomment the return statement
5. Commit and push

---

## 📊 Monitoring

### Vercel Dashboard
- **Analytics:** View traffic and performance
- **Logs:** Check errors and requests
- **Deployments:** See deployment history

### Supabase Dashboard
- **Table Editor:** View attendance records
- **Database:** Monitor storage
- **Auth:** (if you add authentication later)

---

## 🔒 Security Best Practices

### ✅ Already Implemented
- Environment variables (not in code)
- HTTPS only (Vercel default)
- Supabase RLS (Row Level Security)

### 🔐 Recommended Additions

1. **Password Hashing:**
   ```python
   # Install: pip install bcrypt
   import bcrypt
   
   # Hash password
   hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
   
   # Verify password
   bcrypt.checkpw(password.encode(), hashed)
   ```

2. **Rate Limiting:**
   ```python
   # Install: pip install flask-limiter
   from flask_limiter import Limiter
   
   limiter = Limiter(app, default_limits=["100 per hour"])
   ```

3. **CSRF Protection:**
   ```python
   # Install: pip install flask-wtf
   from flask_wtf.csrf import CSRFProtect
   
   csrf = CSRFProtect(app)
   ```

---

## 📱 Custom Domain (Optional)

### Add Custom Domain to Vercel

1. **Buy Domain:**
   - Namecheap, GoDaddy, etc.
   - Example: `attendance.gceerode.edu.in`

2. **Add to Vercel:**
   - Vercel Dashboard → Settings → Domains
   - Add your domain
   - Follow DNS instructions

3. **Update DNS:**
   - Add CNAME record
   - Point to Vercel

---

## 🎯 Production Checklist

Before going live:

- [ ] Run database migration
- [ ] Test all staff accounts
- [ ] Test OTP cross-server
- [ ] Test during actual class hours
- [ ] Enable strict period checking
- [ ] Add password hashing
- [ ] Set up monitoring
- [ ] Train staff on usage
- [ ] Create user manual
- [ ] Set up backup system

---

## 📞 Support

### Common Commands

```bash
# Check git status
git status

# View commit history
git log --oneline

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Force push (careful!)
git push -f origin main

# Pull latest changes
git pull origin main

# View Vercel logs
vercel logs

# Redeploy
vercel --prod
```

### Useful Links

- **Vercel Docs:** https://vercel.com/docs
- **Supabase Docs:** https://supabase.com/docs
- **Flask Docs:** https://flask.palletsprojects.com/
- **Git Docs:** https://git-scm.com/doc

---

## 🎓 Next Steps

After successful deployment:

1. **User Training:**
   - Train staff on OTP generation
   - Train students on attendance marking
   - Create quick reference guides

2. **Monitoring:**
   - Check daily attendance
   - Monitor system performance
   - Review error logs

3. **Enhancements:**
   - Add email notifications
   - Generate monthly reports
   - Add admin dashboard
   - Mobile app (React Native)

---

## ✅ Deployment Complete!

Your Smart Attendance System is now live at:
- **Vercel URL:** `https://your-app.vercel.app`
- **Local URL:** `http://localhost:5000`

**Both servers now share the same database and OTP system!** 🎉

---

## 📝 Quick Reference

### Staff Accounts
All use password: `staff123`

| Email | Department |
|-------|------------|
| staff1@gceerode.ac.in | Civil Engineering |
| staff2@gceerode.ac.in | Automobile Engineering |
| staff3@gceerode.ac.in | Mechanical Engineering |
| staff4@gceerode.ac.in | Electrical & Electronics |
| staff5@gceerode.ac.in | Electronics & Communication |
| staff6@gceerode.ac.in | Computer Science |
| staff7@gceerode.ac.in | Information Technology |

### Student Accounts
| Email | Password |
|-------|----------|
| student@example.com | student123 |
| student1@gceerode.ac.in | student123 |

### OTP Settings
- **Expiry:** 30 seconds
- **Length:** 6 digits
- **Storage:** Supabase database
- **Validation:** Server-side only

---

**Happy Deploying! 🚀**
