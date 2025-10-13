# 🔧 Installation Guide

Complete step-by-step installation guide for the Smart Attendance System.

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] **Python 3.8+** installed ([Download](https://www.python.org/downloads/))
- [ ] **pip** package manager (comes with Python)
- [ ] **Git** (optional, for cloning)
- [ ] **Supabase account** ([Sign up free](https://supabase.com))
- [ ] **Text editor** (VS Code, PyCharm, etc.)
- [ ] **Web browser** (Chrome, Firefox, Edge, Safari)

## Installation Methods

Choose one of the following methods:

### Method 1: Automated Setup (Recommended) ⚡

**Step 1: Download/Clone Project**
```bash
# If using Git
git clone <repository-url>
cd "Smart Attandance"

# Or download ZIP and extract
```

**Step 2: Run Setup Script**
```bash
python setup.py
```

The script will:
- ✅ Check Python version
- ✅ Verify all project files
- ✅ Install dependencies
- ✅ Create .env file
- ✅ Guide you through configuration

**Step 3: Setup Supabase Database**

Follow the on-screen instructions to:
1. Create Supabase project
2. Run database_setup.sql
3. Get your credentials

**Step 4: Start Application**
```bash
python app.py
```

Visit: `http://localhost:5000`

---

### Method 2: Manual Setup 🔨

**Step 1: Install Python Dependencies**
```bash
pip install -r requirements.txt
```

**Step 2: Create Environment File**
```bash
# Copy template
cp .env.example .env

# Edit .env with your favorite editor
notepad .env  # Windows
nano .env     # Linux/Mac
```

Add your credentials:
```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SECRET_KEY=your-secret-key-here
```

**Step 3: Generate Secret Key**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

Copy the output to SECRET_KEY in .env

**Step 4: Setup Supabase**

1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Go to SQL Editor
4. Copy contents of `database_setup.sql`
5. Paste and run

**Step 5: Verify Database**
```sql
-- Run in Supabase SQL Editor
SELECT * FROM users;
SELECT * FROM otp;
SELECT * FROM attendance;
```

**Step 6: Start Application**
```bash
python app.py
```

---

## Detailed Supabase Setup

### Creating Supabase Project

1. **Sign Up/Login**
   - Visit [supabase.com](https://supabase.com)
   - Click "Start your project"
   - Sign in with GitHub/Google/Email

2. **Create New Project**
   - Click "New Project"
   - Choose organization (or create one)
   - Fill in details:
     - **Name**: Smart Attendance
     - **Database Password**: (save this!)
     - **Region**: Choose closest to you
     - **Pricing Plan**: Free tier is sufficient
   - Click "Create new project"
   - Wait 2-3 minutes for setup

3. **Get API Credentials**
   - Go to **Settings** → **API**
   - Copy **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - Copy **anon/public key** (starts with `eyJ...`)
   - Save these for .env file

### Running Database Setup

1. **Open SQL Editor**
   - In Supabase dashboard
   - Click **SQL Editor** in sidebar
   - Click **New Query**

2. **Execute Setup Script**
   - Open `database_setup.sql` in your text editor
   - Copy ALL contents (Ctrl+A, Ctrl+C)
   - Paste into Supabase SQL Editor
   - Click **Run** or press Ctrl+Enter

3. **Verify Tables Created**
   - Go to **Table Editor** in sidebar
   - You should see:
     - ✅ users
     - ✅ otp
     - ✅ attendance

4. **Check Demo Data**
   - Click on **users** table
   - You should see 2 demo users:
     - staff@example.com
     - student@example.com

### Troubleshooting Supabase

**Issue: "relation already exists"**
- Tables already created
- Either drop tables first or skip this error

**Issue: "permission denied"**
- Check you're using the correct project
- Verify you have admin access

**Issue: "syntax error"**
- Ensure you copied the entire SQL file
- Check for any missing characters

---

## Verifying Installation

### 1. Check Python Installation
```bash
python --version
# Should show: Python 3.8.x or higher
```

### 2. Check Dependencies
```bash
pip list | grep -E "Flask|supabase|python-dotenv|Werkzeug"
```

Should show:
```
Flask           3.0.0
supabase        2.3.0
python-dotenv   1.0.0
Werkzeug        3.0.1
```

### 3. Check Environment Variables
```bash
# Windows
type .env

# Linux/Mac
cat .env
```

Should contain:
- SUPABASE_URL
- SUPABASE_KEY
- SECRET_KEY

### 4. Test Database Connection
```bash
python -c "from supabase_config import get_supabase_client; print('✅ Supabase connected!')"
```

### 5. Start Application
```bash
python app.py
```

Should see:
```
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:5000
```

### 6. Test in Browser
1. Open `http://localhost:5000`
2. Should redirect to login page
3. Try logging in with demo credentials

---

## Common Installation Issues

### Issue: "pip not found"
**Solution:**
```bash
# Windows
python -m pip install -r requirements.txt

# Linux/Mac
python3 -m pip install -r requirements.txt
```

### Issue: "Module not found: supabase"
**Solution:**
```bash
pip install supabase --upgrade
```

### Issue: "Port 5000 already in use"
**Solution:**
```bash
# Kill process on port 5000 (Windows)
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Or change port in app.py
app.run(debug=True, host='0.0.0.0', port=5001)
```

### Issue: "Supabase connection timeout"
**Solution:**
- Check internet connection
- Verify SUPABASE_URL is correct
- Check Supabase project is active
- Verify API key is correct

### Issue: ".env file not found"
**Solution:**
```bash
# Create from template
cp .env.example .env

# Or create manually
echo SUPABASE_URL=your_url > .env
echo SUPABASE_KEY=your_key >> .env
echo SECRET_KEY=your_secret >> .env
```

### Issue: "Permission denied" (Linux/Mac)
**Solution:**
```bash
# Make setup script executable
chmod +x setup.py

# Or run with python
python setup.py
```

---

## Platform-Specific Instructions

### Windows

**Using Command Prompt:**
```cmd
cd "Smart Attandance"
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

**Using PowerShell:**
```powershell
cd "Smart Attandance"
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

### macOS

```bash
cd "Smart Attandance"
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
python3 app.py
```

### Linux (Ubuntu/Debian)

```bash
# Install Python if needed
sudo apt update
sudo apt install python3 python3-pip python3-venv

# Setup project
cd "Smart Attandance"
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
python3 app.py
```

---

## Virtual Environment (Recommended)

Using a virtual environment isolates dependencies:

**Create Virtual Environment:**
```bash
# Windows
python -m venv venv

# Linux/Mac
python3 -m venv venv
```

**Activate Virtual Environment:**
```bash
# Windows (Command Prompt)
venv\Scripts\activate

# Windows (PowerShell)
.\venv\Scripts\Activate.ps1

# Linux/Mac
source venv/bin/activate
```

**Install Dependencies:**
```bash
pip install -r requirements.txt
```

**Deactivate When Done:**
```bash
deactivate
```

---

## Post-Installation Steps

### 1. Test Login
- Staff: `staff@example.com` / `staff123`
- Student: `student@example.com` / `student123`

### 2. Test OTP Flow
1. Login as staff
2. Generate OTP
3. Open incognito/private window
4. Login as student
5. Enter OTP
6. Verify attendance marked

### 3. Check Database
- Go to Supabase Table Editor
- Check attendance table
- Should see new record

### 4. Customize (Optional)
- Change colors in `static/css/style.css`
- Modify OTP expiry in `app.py`
- Add more users in Supabase

---

## Next Steps

After successful installation:

1. ✅ Read [README.md](README.md) for full documentation
2. ✅ Review [QUICKSTART.md](QUICKSTART.md) for quick reference
3. ✅ Check [TESTING.md](TESTING.md) for testing procedures
4. ✅ Explore [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) for architecture
5. ✅ Consider deployment (see README.md)

---

## Getting Help

If you encounter issues:

1. **Check logs** - Look at Flask console output
2. **Browser console** - Press F12, check for errors
3. **Supabase logs** - Check Supabase dashboard
4. **Review docs** - Read README.md and other guides
5. **Verify credentials** - Double-check .env file

---

## Installation Checklist

- [ ] Python 3.8+ installed
- [ ] Dependencies installed (`pip install -r requirements.txt`)
- [ ] Supabase project created
- [ ] Database tables created (ran database_setup.sql)
- [ ] .env file created with credentials
- [ ] Application starts without errors
- [ ] Can access http://localhost:5000
- [ ] Can login with demo credentials
- [ ] OTP generation works
- [ ] Attendance marking works

---

**Congratulations! Your Smart Attendance System is ready! 🎉**

For questions or issues, refer to the documentation or check the troubleshooting section.
