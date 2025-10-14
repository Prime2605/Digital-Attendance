# ⚡ Quick Start Guide

## 🚀 Deploy in 5 Minutes

### Option 1: Automated Script (Windows)

1. **Double-click:** `deploy.bat`
2. **Follow prompts**
3. **Done!**

---

### Option 2: Manual Steps

#### Step 1: Install Git
- Download: https://git-scm.com/download/win
- Install with defaults
- Restart terminal

#### Step 2: Push to GitHub
```bash
# Open terminal in project folder
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/smart-attendance.git
git branch -M main
git push -u origin main
```

#### Step 3: Deploy to Vercel
1. Go to: https://vercel.com/
2. Sign in with GitHub
3. Click "Add New..." → "Project"
4. Select your repository
5. Add environment variables:
   ```
   SUPABASE_URL = https://avepxrzlkzpzoallhllw.supabase.co
   SUPABASE_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2ZXB4cnpsa3pwem9hbGxobGx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNTk4NzQsImV4cCI6MjA3NTkzNTg3NH0.ulppHDWgfh7E96X0COAcwFTyxq9W292TDVJctPVS6QU
   SECRET_KEY = a4c1b2f3a89d0e4fbcfe1234ab56cd78
   ```
6. Click "Deploy"
7. Wait 2 minutes

#### Step 4: Setup Database
1. Go to: https://supabase.com/dashboard
2. Click "SQL Editor"
3. Open `migration_add_staff_info.sql`
4. Copy all contents
5. Paste in SQL Editor
6. Click "Run"

---

## ✅ Test It

### Test 1: Login
- URL: `https://your-app.vercel.app`
- Email: `staff1@gceerode.ac.in`
- Password: `staff123`

### Test 2: Cross-Server OTP
1. **Laptop:** Generate OTP
2. **Mobile:** Enter OTP
3. **Should work!** ✅

---

## 🎯 All Staff Accounts

Password: `staff123` for all

| Email | Name |
|-------|------|
| staff1@gceerode.ac.in | Dr. P. Saravanakumar |
| staff2@gceerode.ac.in | Dr. R. Senthilraja |
| staff3@gceerode.ac.in | Dr. K. Balamurugan |
| staff4@gceerode.ac.in | Dr. M. Mohammadha Hussaini |
| staff5@gceerode.ac.in | Mr. M. Raja |
| staff6@gceerode.ac.in | Dr. A. Saradha |
| staff7@gceerode.ac.in | Dr. I. Bhuvaneshwarri |

---

## 🔄 Update After Changes

```bash
git add .
git commit -m "Your changes"
git push origin main

# Vercel auto-deploys!
```

---

## 📚 Full Documentation

- **Deployment:** See `DEPLOYMENT_GUIDE.md`
- **Cross-Server Fix:** See `CROSS_SERVER_FIX.md`
- **3D Background:** See `3D_BACKGROUND.md`
- **Features:** See `ESSENTIAL_FEATURES.md`

---

**That's it! Your system is live!** 🎉
