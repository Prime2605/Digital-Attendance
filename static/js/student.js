// ===================================
// STUDENT DASHBOARD - OTP SUBMISSION
// ===================================

document.addEventListener('DOMContentLoaded', function() {
    const otpForm = document.getElementById('otpForm');
    const otpInput = document.getElementById('otpInput');
    const otpMessage = document.getElementById('otpMessage');
    
    if (otpForm) {
        otpForm.addEventListener('submit', submitOTP);
    }
    
    // Auto-format OTP input (only numbers)
    if (otpInput) {
        otpInput.addEventListener('input', function(e) {
            // Remove non-numeric characters
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Limit to 6 digits
            if (this.value.length > 6) {
                this.value = this.value.slice(0, 6);
            }
        });
        
        // Auto-submit when 6 digits are entered (optional)
        otpInput.addEventListener('input', function(e) {
            if (this.value.length === 6) {
                // Optional: auto-submit
                // otpForm.dispatchEvent(new Event('submit'));
            }
        });
    }
});

async function submitOTP(event) {
    event.preventDefault();
    
    const otpInput = document.getElementById('otpInput');
    const otpMessage = document.getElementById('otpMessage');
    const submitBtn = event.target.querySelector('button[type="submit"]');
    const otpValue = otpInput.value.trim();
    
    // Validate OTP
    if (otpValue.length !== 6) {
        showOTPMessage('Please enter a valid 6-digit OTP', 'error');
        return;
    }
    
    // Disable button and show loading
    setButtonLoading(submitBtn, true);
    
    try {
        const formData = new FormData();
        formData.append('otp', otpValue);
        
        const response = await fetch('/submit_otp', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.success) {
            showOTPMessage(data.message, 'success');
            showMessage('Attendance marked successfully!', 'success');
            
            // Clear input
            otpInput.value = '';
            
            // Reload page after 2 seconds to show updated attendance
            setTimeout(function() {
                window.location.reload();
            }, 2000);
        } else {
            showOTPMessage(data.message, 'error');
            showMessage(data.message, 'error');
            
            // Clear input on error
            otpInput.value = '';
            otpInput.focus();
        }
    } catch (error) {
        console.error('Error submitting OTP:', error);
        showOTPMessage('Error submitting OTP. Please try again.', 'error');
        showMessage('Error submitting OTP. Please try again.', 'error');
    } finally {
        setButtonLoading(submitBtn, false);
    }
}

function showOTPMessage(message, type) {
    const otpMessage = document.getElementById('otpMessage');
    
    otpMessage.textContent = message;
    otpMessage.className = `otp-message ${type}`;
    otpMessage.style.display = 'block';
    
    // Auto-hide after 5 seconds
    setTimeout(function() {
        otpMessage.style.display = 'none';
    }, 5000);
}

// Add visual feedback for input
document.addEventListener('DOMContentLoaded', function() {
    const otpInput = document.getElementById('otpInput');
    
    if (otpInput) {
        otpInput.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
            this.parentElement.style.transition = 'transform 0.2s ease';
        });
        
        otpInput.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
    }
});
