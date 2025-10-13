import os
import secrets
from datetime import datetime, timedelta, time
from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from werkzeug.security import check_password_hash, generate_password_hash
from supabase_config import get_supabase_client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

# Get Supabase client
supabase = get_supabase_client()

# In-memory OTP storage (for demo purposes - in production, use Redis or database)
active_otps = {}

# Period timings - Government College of Engineering, Erode
PERIOD_TIMINGS = {
    1: (time(9, 0), time(9, 50)),    # 1st Period: 9:00 AM - 9:50 AM
    2: (time(9, 50), time(10, 40)),  # 2nd Period: 9:50 AM - 10:40 AM
    3: (time(11, 0), time(11, 50)),  # 3rd Period: 11:00 AM - 11:50 AM
    4: (time(11, 50), time(12, 40)), # 4th Period: 11:50 AM - 12:40 PM
    5: (time(13, 40), time(14, 25)), # 5th Period: 1:40 PM - 2:25 PM
    6: (time(14, 25), time(15, 10)), # 6th Period: 2:25 PM - 3:10 PM
    7: (time(15, 20), time(16, 5)),  # 7th Period: 3:20 PM - 4:05 PM
    8: (time(16, 5), time(16, 50))   # 8th Period: 4:05 PM - 4:50 PM
}

def generate_otp():
    """Generate a 6-digit OTP"""
    return ''.join([str(secrets.randbelow(10)) for _ in range(6)])

def get_current_period():
    """Get current period number based on time, returns None if in break"""
    current_time = datetime.now().time()
    
    for period_num, (start_time, end_time) in PERIOD_TIMINGS.items():
        if start_time <= current_time <= end_time:
            return period_num
    
    return None  # Break time or outside college hours

def is_valid_attendance_time():
    """Check if current time is within valid attendance period"""
    return get_current_period() is not None

def is_otp_valid(otp_code):
    """Check if OTP exists and is not expired - STRICT server-side validation"""
    if otp_code not in active_otps:
        return False, "Invalid OTP"
    
    otp_data = active_otps[otp_code]
    expires_at = otp_data['expires_at']
    created_at = otp_data['created_at']
    
    # STRICT: Calculate exact time difference
    current_time = datetime.now()
    time_elapsed = (current_time - created_at).total_seconds()
    
    # STRICT: Must be within 10 seconds, no tolerance
    if time_elapsed > 10.0 or current_time > expires_at:
        # OTP expired, remove it immediately
        del active_otps[otp_code]
        return False, "OTP expired (10 second limit)"
    
    return True, "Valid"

def cleanup_expired_otps():
    """Remove expired OTPs from memory"""
    current_time = datetime.now()
    expired_otps = [otp for otp, data in active_otps.items() 
                    if data['expires_at'] < current_time]
    for otp in expired_otps:
        del active_otps[otp]

@app.route('/')
def index():
    """Home page - redirect to login"""
    if 'user_id' in session:
        if session.get('role') == 'staff':
            return redirect(url_for('staff_dashboard'))
        else:
            return redirect(url_for('student_dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Login page for both staff and students"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        try:
            # Query user from Supabase
            response = supabase.table('users').select('*').eq('email', email).execute()
            
            if response.data and len(response.data) > 0:
                user = response.data[0]
                
                # Check password (in production, use hashed passwords)
                if user['password'] == password:
                    # Set session
                    session['user_id'] = user['id']
                    session['user_name'] = user['name']
                    session['role'] = user['role']
                    session['email'] = user['email']
                    
                    flash(f'Welcome, {user["name"]}!', 'success')
                    
                    # Redirect based on role
                    if user['role'] == 'staff':
                        return redirect(url_for('staff_dashboard'))
                    else:
                        return redirect(url_for('student_dashboard'))
                else:
                    flash('Invalid email or password', 'error')
            else:
                flash('Invalid email or password', 'error')
        except Exception as e:
            flash(f'Login error: {str(e)}', 'error')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Logout user"""
    session.clear()
    flash('You have been logged out successfully', 'success')
    return redirect(url_for('login'))

@app.route('/staff')
def staff_dashboard():
    """Staff dashboard - OTP generation"""
    if 'user_id' not in session or session.get('role') != 'staff':
        flash('Access denied. Staff only.', 'error')
        return redirect(url_for('login'))
    
    # Cleanup expired OTPs
    cleanup_expired_otps()
    
    # Get recent attendance records with optimized query
    try:
        response = supabase.table('attendance').select('*, users(name)').order('created_at', desc=True).limit(10).execute()
        attendance_records = response.data if response.data else []
    except Exception as e:
        print(f"Error fetching attendance: {e}")
        attendance_records = []
    
    return render_template('staff_dashboard.html', 
                         user_name=session.get('user_name'),
                         attendance_records=attendance_records)

@app.route('/student')
def student_dashboard():
    """Student dashboard - OTP entry"""
    if 'user_id' not in session or session.get('role') != 'student':
        flash('Access denied. Students only.', 'error')
        return redirect(url_for('login'))
    
    # Get student's attendance history with optimized query
    try:
        response = supabase.table('attendance').select('*').eq('student_id', session['user_id']).order('created_at', desc=True).limit(10).execute()
        attendance_records = response.data if response.data else []
    except Exception as e:
        print(f"Error fetching student attendance: {e}")
        attendance_records = []
    
    return render_template('student_dashboard.html', 
                         user_name=session.get('user_name'),
                         attendance_records=attendance_records)

@app.route('/generate_otp', methods=['POST'])
def generate_otp_route():
    """Generate OTP (staff only)"""
    if 'user_id' not in session or session.get('role') != 'staff':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    # Check if current time is valid for attendance
    current_period = get_current_period()
    if current_period is None:
        return jsonify({
            'success': False, 
            'message': 'Attendance window closed. Please wait for the next period.'
        })
    
    # Cleanup expired OTPs
    cleanup_expired_otps()
    
    # Generate new OTP
    otp_code = generate_otp()
    expires_at = datetime.now() + timedelta(seconds=10)
    
    # Store OTP in memory
    active_otps[otp_code] = {
        'generated_by': session['user_id'],
        'created_at': datetime.now(),
        'expires_at': expires_at
    }
    
    # Store in database for logging with precise timestamp
    try:
        current_timestamp = datetime.now()
        supabase.table('otp').insert({
            'otp_code': otp_code,
            'generated_by': session['user_id'],
            'created_at': current_timestamp.isoformat(),
            'expires_at': expires_at.isoformat()
        }).execute()
    except Exception as e:
        print(f"Error storing OTP in database: {e}")
    
    return jsonify({
        'success': True,
        'otp': otp_code,
        'expires_in': 10,
        'period': current_period,
        'server_time': datetime.now().isoformat(),
        'expires_at': expires_at.isoformat()
    })

@app.route('/submit_otp', methods=['POST'])
def submit_otp():
    """Submit OTP for attendance (student only)"""
    if 'user_id' not in session or session.get('role') != 'student':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    otp_code = request.form.get('otp')
    
    if not otp_code:
        return jsonify({'success': False, 'message': 'OTP is required'})
    
    # Check if current time is valid for attendance
    current_period = get_current_period()
    if current_period is None:
        return jsonify({
            'success': False, 
            'message': 'Attendance window closed. Please wait for the next period.'
        })
    
    # Cleanup expired OTPs
    cleanup_expired_otps()
    
    # STRICT server-side OTP validation
    is_valid, validation_message = is_otp_valid(otp_code)
    if not is_valid:
        return jsonify({'success': False, 'message': validation_message})
    
    # Check if student already marked attendance for this period today
    today = datetime.now().date().isoformat()
    try:
        existing = supabase.table('attendance').select('id').eq('student_id', session['user_id']).eq('date', today).eq('period', current_period).limit(1).execute()
        
        if existing.data and len(existing.data) > 0:
            return jsonify({'success': False, 'message': f'Attendance already marked for Period {current_period}'})
    except Exception as e:
        print(f"Error checking existing attendance: {e}")
        return jsonify({'success': False, 'message': 'Database error'})
    
    # Mark attendance with precise timestamp and period
    try:
        attendance_time = datetime.now()
        supabase.table('attendance').insert({
            'student_id': session['user_id'],
            'date': today,
            'period': current_period,
            'time': attendance_time.strftime('%H:%M:%S'),
            'status': 'present',
            'created_at': attendance_time.isoformat()
        }).execute()
        
        # Remove used OTP immediately after successful attendance
        if otp_code in active_otps:
            del active_otps[otp_code]
        
        return jsonify({
            'success': True, 
            'message': f'Attendance marked successfully for Period {current_period}!',
            'period': current_period,
            'timestamp': attendance_time.isoformat()
        })
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error marking attendance: {str(e)}'})

@app.route('/check_otp_status/<otp_code>')
def check_otp_status(otp_code):
    """Check if OTP is still valid (for countdown timer)"""
    cleanup_expired_otps()
    
    if otp_code in active_otps:
        expires_at = active_otps[otp_code]['expires_at']
        remaining_seconds = max(0, int((expires_at - datetime.now()).total_seconds()))
        return jsonify({'valid': True, 'remaining_seconds': remaining_seconds})
    
    return jsonify({'valid': False, 'remaining_seconds': 0})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
