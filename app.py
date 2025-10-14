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
    # Use IST timezone (India Standard Time)
    from datetime import timezone, timedelta
    ist = timezone(timedelta(hours=5, minutes=30))
    current_time = datetime.now(ist).time()
    
    for period_num, (start_time, end_time) in PERIOD_TIMINGS.items():
        if start_time <= current_time <= end_time:
            return period_num
    
    # For testing: Always return period 1 if outside hours (REMOVE IN PRODUCTION)
    # return 1
    
    return None  # Break time or outside college hours

def is_valid_attendance_time():
    """Check if current time is within valid attendance period"""
    return get_current_period() is not None

def is_otp_valid(otp_code):
    """Check if OTP exists and is not expired - STRICT server-side validation using DATABASE"""
    try:
        # Check database first (shared across all servers)
        response = supabase.table('otp').select('*').eq('otp_code', otp_code).order('created_at', desc=True).limit(1).execute()
        
        if not response.data or len(response.data) == 0:
            return False, "Invalid OTP", None
        
        otp_data = response.data[0]
        expires_at_str = otp_data['expires_at']
        created_at_str = otp_data['created_at']
        staff_name = otp_data.get('staff_name', 'Unknown Staff')
        
        # Parse timestamps
        expires_at = datetime.fromisoformat(expires_at_str.replace('Z', '+00:00'))
        created_at = datetime.fromisoformat(created_at_str.replace('Z', '+00:00'))
        
        # Get current time in UTC
        from datetime import timezone
        current_time = datetime.now(timezone.utc)
        
        # Make expires_at and created_at timezone-aware if they aren't
        if expires_at.tzinfo is None:
            expires_at = expires_at.replace(tzinfo=timezone.utc)
        if created_at.tzinfo is None:
            created_at = created_at.replace(tzinfo=timezone.utc)
        
        # STRICT: Calculate exact time difference
        time_elapsed = (current_time - created_at).total_seconds()
        
        # STRICT: Must be within 30 seconds (increased for cross-server delay)
        if time_elapsed > 30.0 or current_time > expires_at:
            return False, "OTP expired (30 second limit)", None
        
        return True, "Valid", staff_name
    except Exception as e:
        print(f"Error validating OTP: {e}")
        return False, f"Error validating OTP: {str(e)}", None

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
    expires_at = datetime.now() + timedelta(seconds=30)  # 30 seconds for cross-server compatibility
    
    # Get staff name and department
    try:
        staff_info = supabase.table('users').select('name, department').eq('id', session['user_id']).single().execute()
        staff_name = staff_info.data.get('name', 'Unknown Staff')
        staff_dept = staff_info.data.get('department', '')
        staff_display = f"{staff_name} – {staff_dept}" if staff_dept else staff_name
    except:
        staff_display = session.get('user_name', 'Unknown Staff')
    
    # Store OTP in memory
    active_otps[otp_code] = {
        'generated_by': session['user_id'],
        'staff_name': staff_display,
        'created_at': datetime.now(),
        'expires_at': expires_at
    }
    
    # Store in database for logging with precise timestamp
    try:
        current_timestamp = datetime.now()
        supabase.table('otp').insert({
            'otp_code': otp_code,
            'generated_by': session['user_id'],
            'staff_name': staff_display,
            'created_at': current_timestamp.isoformat(),
            'expires_at': expires_at.isoformat()
        }).execute()
    except Exception as e:
        print(f"Error storing OTP in database: {e}")
    
    return jsonify({
        'success': True,
        'otp': otp_code,
        'staff': staff_display,
        'expires_in': 30,  # Changed to 30 seconds for cross-server compatibility
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
        # For testing: Allow attendance anytime (REMOVE IN PRODUCTION)
        current_period = 1
        # Uncomment below for production:
        # return jsonify({
        #     'success': False, 
        #     'message': 'Attendance window closed. Please wait for the next period.'
        # })
    
    # Cleanup expired OTPs
    cleanup_expired_otps()
    
    # STRICT server-side OTP validation
    is_valid, validation_message, staff_name = is_otp_valid(otp_code)
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
            'staff': staff_name,
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

# ===================================
# ESSENTIAL FEATURES - STATISTICS & REPORTS
# ===================================

@app.route('/api/attendance/stats')
def attendance_stats():
    """Get attendance statistics (staff only)"""
    if 'user_id' not in session or session.get('role') != 'staff':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    try:
        today = datetime.now().date().isoformat()
        
        # Today's attendance count
        today_response = supabase.table('attendance').select('id', count='exact').eq('date', today).execute()
        today_count = today_response.count if hasattr(today_response, 'count') else len(today_response.data)
        
        # Total students
        students_response = supabase.table('users').select('id', count='exact').eq('role', 'student').execute()
        total_students = students_response.count if hasattr(students_response, 'count') else len(students_response.data)
        
        # Attendance by period today
        period_response = supabase.table('attendance').select('period').eq('date', today).execute()
        periods_data = {}
        for record in period_response.data:
            period = record['period']
            periods_data[period] = periods_data.get(period, 0) + 1
        
        # Calculate percentage
        attendance_percentage = round((today_count / total_students * 100), 2) if total_students > 0 else 0
        
        return jsonify({
            'success': True,
            'today_attendance': today_count,
            'total_students': total_students,
            'attendance_percentage': attendance_percentage,
            'by_period': periods_data,
            'current_period': get_current_period()
        })
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/attendance/report')
def attendance_report():
    """Get detailed attendance report with filters"""
    if 'user_id' not in session or session.get('role') != 'staff':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    try:
        # Get query parameters
        start_date = request.args.get('start_date', datetime.now().date().isoformat())
        end_date = request.args.get('end_date', datetime.now().date().isoformat())
        department = request.args.get('department', None)
        
        # Build query
        query = supabase.table('attendance').select('*, users(name, email, department, year)')
        query = query.gte('date', start_date).lte('date', end_date)
        query = query.order('created_at', desc=True)
        
        response = query.execute()
        
        # Filter by department if specified
        records = response.data
        if department:
            records = [r for r in records if r.get('users', {}).get('department') == department]
        
        return jsonify({
            'success': True,
            'records': records,
            'count': len(records)
        })
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/student/stats')
def student_stats():
    """Get student's personal attendance statistics"""
    if 'user_id' not in session or session.get('role') != 'student':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    try:
        # Get all attendance records for this student
        response = supabase.table('attendance').select('*').eq('student_id', session['user_id']).execute()
        records = response.data
        
        # Calculate statistics
        total_days = len(set([r['date'] for r in records]))
        total_periods = len(records)
        
        # Group by period
        by_period = {}
        for record in records:
            period = record['period']
            by_period[period] = by_period.get(period, 0) + 1
        
        # Recent attendance (last 7 days)
        seven_days_ago = (datetime.now() - timedelta(days=7)).date().isoformat()
        recent = [r for r in records if r['date'] >= seven_days_ago]
        
        return jsonify({
            'success': True,
            'total_days': total_days,
            'total_periods': total_periods,
            'by_period': by_period,
            'recent_count': len(recent),
            'all_records': records
        })
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/export/csv')
def export_csv():
    """Export attendance data as CSV (staff only)"""
    if 'user_id' not in session or session.get('role') != 'staff':
        return jsonify({'success': False, 'message': 'Unauthorized'}), 403
    
    try:
        from io import StringIO
        import csv
        
        # Get date range
        start_date = request.args.get('start_date', datetime.now().date().isoformat())
        end_date = request.args.get('end_date', datetime.now().date().isoformat())
        
        # Fetch data
        response = supabase.table('attendance').select('*, users(name, email, department, year)').gte('date', start_date).lte('date', end_date).order('created_at', desc=True).execute()
        
        # Create CSV
        output = StringIO()
        writer = csv.writer(output)
        
        # Write header
        writer.writerow(['Date', 'Period', 'Time', 'Student Name', 'Email', 'Department', 'Year', 'Status'])
        
        # Write data
        for record in response.data:
            user = record.get('users', {})
            writer.writerow([
                record['date'],
                record['period'],
                record['time'],
                user.get('name', 'N/A'),
                user.get('email', 'N/A'),
                user.get('department', 'N/A'),
                user.get('year', 'N/A'),
                record['status']
            ])
        
        # Return CSV
        from flask import Response
        output.seek(0)
        return Response(
            output.getvalue(),
            mimetype='text/csv',
            headers={'Content-Disposition': f'attachment; filename=attendance_{start_date}_to_{end_date}.csv'}
        )
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/current_period')
def current_period_api():
    """Get current period information"""
    period = get_current_period()
    if period:
        start_time, end_time = PERIOD_TIMINGS[period]
        return jsonify({
            'success': True,
            'period': period,
            'start_time': start_time.strftime('%H:%M'),
            'end_time': end_time.strftime('%H:%M'),
            'is_valid': True
        })
    else:
        return jsonify({
            'success': True,
            'period': None,
            'is_valid': False,
            'message': 'Break time or outside college hours'
        })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
