# 🎓 Smart Attendance System

**Government College of Engineering, Erode**  
**B.E / B.Tech Program**

A modern, secure web-based attendance system with time-restricted OTP verification and period-based attendance tracking. Built with Flask, Supabase, and a premium gold-black-white-silver UI theme.

![Smart Attendance System](https://img.shields.io/badge/Flask-3.0.0-blue)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- 🔐 **Secure OTP Authentication** - Time-limited OTPs (10 seconds validity)
- ⏰ **Period-Based Attendance** - 8 periods with automatic break detection
- 👥 **Role-Based Access** - Separate dashboards for Staff and Students
- 📊 **Real-time Attendance Tracking** - Instant attendance marking and history
- 🎨 **Premium UI/UX** - Modern glass-morphism design with gold-black-silver theme
- 📱 **Responsive Design** - Works seamlessly on desktop and mobile devices
- 🔒 **Security First** - Session management, OTP expiry, and duplicate prevention
- 💾 **Supabase Integration** - Cloud-based PostgreSQL database
- 🏫 **College Branding** - Government College of Engineering, Erode

## 🎯 Tech Stack

- **Backend**: Flask (Python 3.8+)
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Session-based with OTP verification
- **Styling**: Custom CSS with glass-morphism effects
- **Icons**: Font Awesome 6
- **Fonts**: Google Fonts (Poppins)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.8 or higher
- pip (Python package manager)
- A Supabase account (free tier available)
- Git (optional, for cloning)

## 🚀 Quick Start

### 1. Clone or Download the Project

```bash
git clone <repository-url>
cd "Smart Attandance"
```

Or download and extract the ZIP file.

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Set Up Supabase Database

#### A. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in project details and create

#### B. Create Database Tables

Go to your Supabase project → SQL Editor → New Query, and run the following SQL:

```sql
-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('staff', 'student')),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create OTP table
CREATE TABLE otp (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    otp_code VARCHAR(6) NOT NULL,
    generated_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Create attendance table
CREATE TABLE attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES users(id),
    date DATE NOT NULL,
    time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'present',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_otp_code ON otp(otp_code);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(date);

-- Insert demo users
INSERT INTO users (name, role, email, password) VALUES
('Staff User', 'staff', 'staff@example.com', 'staff123'),
('Student User', 'student', 'student@example.com', 'student123');
```

#### C. Get Your Supabase Credentials

1. Go to Project Settings → API
2. Copy your **Project URL** (looks like: `https://xxxxx.supabase.co`)
3. Copy your **anon/public key** (starts with `eyJ...`)

### 4. Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and add your Supabase credentials:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_anon_key
SECRET_KEY=your_secret_key_here_change_this_in_production
```

**Important**: Generate a strong secret key for production:

```python
python -c "import secrets; print(secrets.token_hex(32))"
```

### 5. Run the Application

```bash
python app.py
```

The application will start on `http://localhost:5000`

### 6. Access the Application
Open your browser and navigate to:
```
http://localhost:5000
```

## 🔑 Login Credentials

### Staff Accounts (All 7 HODs)
**Password:** `staff123` (same for all)

| Department | Name | Email |
|------------|------|-------|
| Civil | Dr. P. Saravanakumar | staff1@gceerode.ac.in |
| Automobile | Dr. R. Senthilraja | staff2@gceerode.ac.in |
| Mechanical | Dr. K. Balamurugan | staff3@gceerode.ac.in |
| EEE | Dr. M. Mohammadha Hussaini | staff4@gceerode.ac.in |
| ECE | Mr. M. Raja | staff5@gceerode.ac.in |
| CSE | Dr. A. Saradha | staff6@gceerode.ac.in |
| IT | Dr. I. Bhuvaneshwarri | staff7@gceerode.ac.in |

**Legacy:** staff@example.com / staff123

### Student Accounts
**Password:** `student123` (same for all)

| Name | Department | Year | Email |
|------|------------|------|-------|
| Rajesh Kumar | CSE | 3 | student1@gceerode.ac.in |
| Priya Sharma | ECE | 2 | student2@gceerode.ac.in |

**Legacy:** student@example.com / student123

## 📖 User Guide

### For Staff

{{ ... }}
1. **Login** with staff credentials
2. Check **current period** status (displayed on dashboard)
3. Click **"Generate OTP"** button (only during valid periods)
4. A 6-digit OTP will be displayed for **10 seconds**
5. Share the OTP with students immediately
6. View recent attendance records in real-time

**Note:** OTP generation is blocked during breaks

### For Students

1. **Login** with student credentials
2. Get the OTP from your instructor
3. Enter the 6-digit OTP in the input field
4. Click **"Submit Attendance"**
5. Attendance will be marked if:
   - OTP is valid (not expired)
   - Current time is within a valid period
   - You haven't already marked attendance for this period
6. View your attendance history with period details

**Note:** Attendance submission is blocked during breaks

## ⏰ Period Timings

Attendance is allowed only during these periods:

| Period | Time | Duration |
|--------|------|----------|
| 1st Period | 9:00 AM - 9:50 AM | 50 min |
| 2nd Period | 9:50 AM - 10:40 AM | 50 min |
| **Break** | **10:40 AM - 11:00 AM** | **20 min** ❌ |
| 3rd Period | 11:00 AM - 11:50 AM | 50 min |
| 4th Period | 11:50 AM - 12:40 PM | 50 min |
| **Lunch Break** | **12:40 PM - 1:40 PM** | **60 min** ❌ |
| 5th Period | 1:40 PM - 2:25 PM | 45 min |
| 6th Period | 2:25 PM - 3:10 PM | 45 min |
| **Break** | **3:10 PM - 3:20 PM** | **10 min** ❌ |
| 7th Period | 3:20 PM - 4:05 PM | 45 min |
| 8th Period | 4:05 PM - 4:50 PM | 45 min |

**Note:** During breaks, the system will display: *"Attendance window closed. Please wait for the next period."*

## 🔒 Security Features

- ✅ **Time-Limited OTPs** - Expire after 10 seconds
- ✅ **Period-Based Validation** - Attendance only during class periods
- ✅ **Session Management** - Secure user sessions
- ✅ **Role-Based Access Control** - Staff and student separation
- ✅ **Duplicate Prevention** - One attendance per period per student
- ✅ **Input Validation** - Client and server-side validation
- ✅ **SQL Injection Protection** - Parameterized queries via Supabase

## 📁 Project Structure

```
Smart Attandance/
├── app.py                      # Main Flask application
├── supabase_config.py          # Supabase configuration
├── requirements.txt            # Python dependencies
├── .env                        # Environment variables (create this)
├── .env.example               # Environment template
├── README.md                   # This file
├── templates/
│   ├── base.html              # Base template
│   ├── login.html             # Login page
│   ├── staff_dashboard.html   # Staff dashboard
│   └── student_dashboard.html # Student dashboard
└── static/
    ├── css/
    │   └── style.css          # Main stylesheet
    └── js/
        ├── main.js            # Common JavaScript
        ├── staff.js           # Staff dashboard JS
        └── student.js         # Student dashboard JS
```

## 🎨 UI Theme

The application uses a premium color scheme:

- **Primary**: Gold (#D4AF37)
- **Background**: Black (#0A0A0A)
- **Text**: White (#FFFFFF)
- **Accents**: Silver (#C0C0C0)
- **Glass Effect**: Backdrop blur with transparency

## 🔧 Configuration

### Changing OTP Expiry Time

Edit `app.py`, line ~67:

```python
expires_at = datetime.now() + timedelta(seconds=10)  # Change 10 to desired seconds
```

### Customizing Colors

Edit `static/css/style.css`, CSS variables section:

```css
:root {
    --gold: #D4AF37;
    --black: #0A0A0A;
    --white: #FFFFFF;
    --silver: #C0C0C0;
    /* ... */
}
```

## 🚀 Deployment

### Deploy to Render

1. Create a `render.yaml` file:

```yaml
services:
  - type: web
    name: smart-attendance
    env: python
    buildCommand: pip install -r requirements.txt
    startCommand: gunicorn app:app
    envVars:
      - key: SUPABASE_URL
        sync: false
      - key: SUPABASE_KEY
        sync: false
      - key: SECRET_KEY
        sync: false
```

2. Add `gunicorn` to `requirements.txt`:

```
gunicorn==21.2.0
```

3. Push to GitHub and connect to Render

### Deploy to Vercel

1. Install Vercel CLI:

```bash
npm i -g vercel
```

2. Create `vercel.json`:

```json
{
  "builds": [
    {
      "src": "app.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "app.py"
    }
  ]
}
```

3. Deploy:

```bash
vercel
```

## 🐛 Troubleshooting

### Issue: "Module not found" error

**Solution**: Ensure all dependencies are installed:
```bash
pip install -r requirements.txt
```

### Issue: Supabase connection error

**Solution**: 
1. Check your `.env` file has correct credentials
2. Verify Supabase project is active
3. Check internet connection

### Issue: OTP not generating

**Solution**:
1. Check browser console for errors
2. Verify you're logged in as staff
3. Check Flask logs for backend errors

### Issue: Attendance not marking

**Solution**:
1. Ensure OTP hasn't expired (10 seconds)
2. Check if attendance already marked today
3. Verify student is logged in

## 📝 API Endpoints

| Endpoint | Method | Description | Access |
|----------|--------|-------------|--------|
| `/` | GET | Home page (redirects) | Public |
| `/login` | GET, POST | Login page | Public |
| `/logout` | GET | Logout user | Authenticated |
| `/staff` | GET | Staff dashboard | Staff only |
| `/student` | GET | Student dashboard | Student only |
| `/generate_otp` | POST | Generate OTP | Staff only |
| `/submit_otp` | POST | Submit OTP | Student only |

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Created with ❤️ by Cascade AI

## 🙏 Acknowledgments

- Flask framework
- Supabase for database hosting
- Font Awesome for icons
- Google Fonts for typography

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check the troubleshooting section
- Review Supabase documentation

## 🔮 Future Enhancements

- [ ] Email notifications for attendance
- [ ] QR code-based attendance
- [ ] Attendance reports and analytics
- [ ] Multi-class support
- [ ] Mobile app (React Native)
- [ ] Biometric authentication
- [ ] Export attendance to CSV/Excel
- [ ] Admin dashboard for management

---

**Note**: This is a demo application. For production use, implement additional security measures such as:
- Password hashing (bcrypt)
- HTTPS enforcement
- Rate limiting
- CSRF protection
- Input sanitization
- Audit logging
