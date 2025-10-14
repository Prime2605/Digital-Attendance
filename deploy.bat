@echo off
echo ========================================
echo Smart Attendance System - Deploy Script
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed!
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    echo Then run this script again.
    pause
    exit /b 1
)

echo [OK] Git is installed
echo.

REM Check if git repo is initialized
if not exist .git (
    echo [STEP 1] Initializing Git repository...
    git init
    echo [OK] Git repository initialized
    echo.
) else (
    echo [OK] Git repository already exists
    echo.
)

REM Add all files
echo [STEP 2] Adding files to Git...
git add .
echo [OK] Files added
echo.

REM Commit changes
echo [STEP 3] Committing changes...
git commit -m "Fix cross-server OTP and timezone issues"
if errorlevel 1 (
    echo [INFO] No changes to commit or already committed
) else (
    echo [OK] Changes committed
)
echo.

REM Check if remote exists
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo [STEP 4] Setting up GitHub remote...
    echo.
    echo Please enter your GitHub repository URL:
    echo Example: https://github.com/yourusername/smart-attendance-gcee.git
    echo.
    set /p REPO_URL="Repository URL: "
    
    git remote add origin %REPO_URL%
    echo [OK] Remote added
    echo.
) else (
    echo [OK] Remote already configured
    echo.
)

REM Push to GitHub
echo [STEP 5] Pushing to GitHub...
echo.
echo This will push your code to GitHub.
echo You may be asked for your GitHub username and password.
echo.
pause

git branch -M main
git push -u origin main

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to push to GitHub
    echo.
    echo Common solutions:
    echo 1. Check your GitHub credentials
    echo 2. Make sure the repository exists on GitHub
    echo 3. Check your internet connection
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo [SUCCESS] Code pushed to GitHub!
    echo.
    echo ========================================
    echo Next Steps:
    echo ========================================
    echo.
    echo 1. Go to https://vercel.com/
    echo 2. Sign in with GitHub
    echo 3. Click "Add New..." - "Project"
    echo 4. Import your repository
    echo 5. Add environment variables (see DEPLOYMENT_GUIDE.md)
    echo 6. Click "Deploy"
    echo.
    echo 7. Run migration in Supabase:
    echo    - Open migration_add_staff_info.sql
    echo    - Copy contents
    echo    - Paste in Supabase SQL Editor
    echo    - Click Run
    echo.
    echo ========================================
    echo.
    pause
)
