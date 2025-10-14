// ===================================
// ANALYTICS & STATISTICS
// ===================================

// Load attendance statistics for staff dashboard
async function loadAttendanceStats() {
    try {
        const response = await fetch('/api/attendance/stats');
        const data = await response.json();
        
        if (data.success) {
            updateStatsDisplay(data);
        }
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

// Update statistics display
function updateStatsDisplay(data) {
    // Update today's attendance
    const todayElement = document.getElementById('todayAttendance');
    if (todayElement) {
        todayElement.textContent = data.today_attendance;
    }
    
    // Update total students
    const totalElement = document.getElementById('totalStudents');
    if (totalElement) {
        totalElement.textContent = data.total_students;
    }
    
    // Update percentage
    const percentElement = document.getElementById('attendancePercentage');
    if (percentElement) {
        percentElement.textContent = data.attendance_percentage + '%';
    }
    
    // Update period breakdown
    const periodElement = document.getElementById('periodBreakdown');
    if (periodElement && data.by_period) {
        let html = '<div class="period-stats">';
        for (let period = 1; period <= 8; period++) {
            const count = data.by_period[period] || 0;
            html += `<div class="period-stat">
                <span class="period-label">Period ${period}</span>
                <span class="period-count">${count}</span>
            </div>`;
        }
        html += '</div>';
        periodElement.innerHTML = html;
    }
}

// Load student statistics
async function loadStudentStats() {
    try {
        const response = await fetch('/api/student/stats');
        const data = await response.json();
        
        if (data.success) {
            updateStudentStatsDisplay(data);
        }
    } catch (error) {
        console.error('Error loading student stats:', error);
    }
}

// Update student statistics display
function updateStudentStatsDisplay(data) {
    const totalDaysElement = document.getElementById('totalDays');
    if (totalDaysElement) {
        totalDaysElement.textContent = data.total_days;
    }
    
    const totalPeriodsElement = document.getElementById('totalPeriods');
    if (totalPeriodsElement) {
        totalPeriodsElement.textContent = data.total_periods;
    }
    
    const recentCountElement = document.getElementById('recentCount');
    if (recentCountElement) {
        recentCountElement.textContent = data.recent_count;
    }
    
    // Update period breakdown
    const periodElement = document.getElementById('studentPeriodBreakdown');
    if (periodElement && data.by_period) {
        let html = '<div class="period-stats">';
        for (let period = 1; period <= 8; period++) {
            const count = data.by_period[period] || 0;
            html += `<div class="period-stat">
                <span class="period-label">Period ${period}</span>
                <span class="period-count">${count}</span>
            </div>`;
        }
        html += '</div>';
        periodElement.innerHTML = html;
    }
}

// Export attendance data as CSV
async function exportAttendanceCSV() {
    try {
        const startDate = document.getElementById('exportStartDate')?.value || new Date().toISOString().split('T')[0];
        const endDate = document.getElementById('exportEndDate')?.value || new Date().toISOString().split('T')[0];
        
        const url = `/api/export/csv?start_date=${startDate}&end_date=${endDate}`;
        window.location.href = url;
        
        showMessage('Downloading attendance report...', 'success');
    } catch (error) {
        console.error('Error exporting CSV:', error);
        showMessage('Error exporting data', 'error');
    }
}

// Load current period info
async function loadCurrentPeriod() {
    try {
        const response = await fetch('/api/current_period');
        const data = await response.json();
        
        if (data.success) {
            updateCurrentPeriodDisplay(data);
        }
    } catch (error) {
        console.error('Error loading current period:', error);
    }
}

// Update current period display
function updateCurrentPeriodDisplay(data) {
    const periodElement = document.getElementById('currentPeriodInfo');
    if (periodElement) {
        if (data.is_valid && data.period) {
            periodElement.innerHTML = `
                <div class="period-active">
                    <i class="fas fa-clock"></i>
                    <span>Period ${data.period}</span>
                    <span class="period-time">${data.start_time} - ${data.end_time}</span>
                </div>
            `;
            periodElement.className = 'period-info active';
        } else {
            periodElement.innerHTML = `
                <div class="period-inactive">
                    <i class="fas fa-pause-circle"></i>
                    <span>${data.message || 'Break Time'}</span>
                </div>
            `;
            periodElement.className = 'period-info inactive';
        }
    }
}

// Auto-refresh stats every 30 seconds
function startStatsAutoRefresh() {
    // Initial load
    loadCurrentPeriod();
    
    // Refresh every 30 seconds
    setInterval(() => {
        loadCurrentPeriod();
        
        // Reload stats based on user role
        if (document.getElementById('todayAttendance')) {
            loadAttendanceStats();
        }
        if (document.getElementById('totalDays')) {
            loadStudentStats();
        }
    }, 30000);
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Load stats based on which elements exist
    if (document.getElementById('todayAttendance')) {
        loadAttendanceStats();
    }
    
    if (document.getElementById('totalDays')) {
        loadStudentStats();
    }
    
    // Start auto-refresh
    startStatsAutoRefresh();
    
    // Export button
    const exportBtn = document.getElementById('exportBtn');
    if (exportBtn) {
        exportBtn.addEventListener('click', exportAttendanceCSV);
    }
});
