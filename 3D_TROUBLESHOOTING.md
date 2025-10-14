# 🔧 3D Background Troubleshooting Guide

## ✅ Quick Checklist

### 1. Check Browser Console
Open Developer Tools (F12) and look for these messages:

**Expected Console Output:**
```
DOM loaded, checking for Three.js...
Three.js found! Initializing 3D background...
3D Background: Renderer created successfully
3D Background: Canvas added to DOM
3D Background: Central sphere created
3D Background: Geometry group added to scene
3D Background: Particle system created with 1000 particles
```

### 2. Verify Files Exist
- ✅ `static/js/3d-background.js`
- ✅ `static/css/style.css` (with #canvas-3d styles)
- ✅ `templates/base.html` (with canvas div and scripts)

### 3. Check Network Tab
- ✅ Three.js CDN loaded (should be ~600KB)
- ✅ 3d-background.js loaded
- ✅ No 404 errors

---

## 🐛 Common Issues & Solutions

### Issue 1: "3D Background not visible at all"

**Symptoms:**
- Page loads but no 3D animation
- Console shows no errors

**Solutions:**
1. **Check CSS opacity:**
   ```css
   #canvas-3d {
       opacity: 0.8; /* Increase if too faint */
   }
   ```

2. **Check z-index:**
   ```css
   #canvas-3d {
       z-index: 0; /* Should be 0 or positive */
   }
   ```

3. **Hard refresh:** Press `Ctrl + Shift + R` (Windows) or `Cmd + Shift + R` (Mac)

---

### Issue 2: "Three.js not loaded"

**Console Error:**
```
Three.js not loaded! 3D background disabled.
```

**Solutions:**
1. **Check internet connection** - Three.js loads from CDN
2. **Try alternative CDN:**
   ```html
   <!-- Replace in base.html -->
   <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js"></script>
   ```
3. **Download Three.js locally:**
   - Download from: https://threejs.org/
   - Place in `static/js/three.min.js`
   - Update script src in base.html

---

### Issue 3: "canvas-3d element not found"

**Console Error:**
```
3D Background: canvas-3d element not found!
```

**Solutions:**
1. **Check base.html has:**
   ```html
   <div id="canvas-3d"></div>
   ```

2. **Verify it's BEFORE navbar:**
   ```html
   <body>
       <div id="canvas-3d"></div>  <!-- Must be here -->
       <nav class="navbar">...</nav>
   </body>
   ```

3. **Clear browser cache** and reload

---

### Issue 4: "3D visible but too faint"

**Symptoms:**
- 3D loads but barely visible
- Hard to see objects

**Solutions:**

1. **Increase canvas opacity:**
   ```css
   /* In style.css */
   #canvas-3d {
       opacity: 1.0; /* Max visibility */
   }
   ```

2. **Increase object opacity:**
   ```javascript
   /* In 3d-background.js */
   // Sphere
   opacity: 0.9,  // Was 0.7
   
   // Cubes
   opacity: 1.0,  // Was 0.9
   
   // Particles
   opacity: 1.0,  // Was 0.9
   ```

3. **Increase lighting:**
   ```javascript
   /* In 3d-background.js */
   const ambientLight = new THREE.AmbientLight(0x404040, 5); // Was 3
   ```

---

### Issue 5: "Low FPS / Laggy"

**Symptoms:**
- Animation stutters
- Page feels slow

**Solutions:**

1. **Reduce particle count:**
   ```javascript
   /* In 3d-background.js, line 134 */
   const particleCount = 500; // Was 1000
   ```

2. **Simplify geometry:**
   ```javascript
   /* Reduce sphere segments */
   const sphereGeometry = new THREE.SphereGeometry(100, 16, 16); // Was 32, 32
   ```

3. **Disable on mobile:**
   ```javascript
   /* Add at start of init3DBackground() */
   if (window.innerWidth < 768) {
       console.log('Mobile detected, skipping 3D');
       return;
   }
   ```

---

### Issue 6: "3D blocks content clicks"

**Symptoms:**
- Can't click buttons
- Links don't work

**Solutions:**

1. **Check pointer-events:**
   ```css
   #canvas-3d {
       pointer-events: none; /* Must be none */
   }
   ```

2. **Verify z-index:**
   ```css
   #canvas-3d {
       z-index: 0; /* Behind content */
   }
   
   .main-content {
       z-index: 1; /* Above 3D */
   }
   ```

---

### Issue 7: "3D not rotating"

**Symptoms:**
- 3D loads but stays static
- No animation

**Solutions:**

1. **Check animate() is called:**
   ```javascript
   /* Should be at end of init3DBackground() */
   animate();
   ```

2. **Check requestAnimationFrame:**
   ```javascript
   function animate() {
       requestAnimationFrame(animate); // Must be first line
       // ... rest of code
   }
   ```

3. **Check browser tab is active** - animations pause when tab is inactive

---

## 🧪 Testing Steps

### Step 1: Open Browser Console
```
F12 (Windows) or Cmd+Option+I (Mac)
```

### Step 2: Check for Errors
Look for red error messages

### Step 3: Verify Three.js
Type in console:
```javascript
typeof THREE
```
Should return: `"object"`

### Step 4: Check Canvas Element
Type in console:
```javascript
document.getElementById('canvas-3d')
```
Should return: `<div id="canvas-3d">...</div>`

### Step 5: Check Renderer
Type in console:
```javascript
document.querySelector('#canvas-3d canvas')
```
Should return: `<canvas>...</canvas>`

---

## 🎨 Visibility Adjustments

### Make More Visible:
```css
/* style.css */
#canvas-3d {
    opacity: 1.0;        /* Max opacity */
    filter: brightness(1.5); /* Brighter */
}
```

### Make Less Visible:
```css
/* style.css */
#canvas-3d {
    opacity: 0.3;        /* Subtle */
    filter: brightness(0.7); /* Dimmer */
}
```

### Change Background Color:
```javascript
/* 3d-background.js */
scene.fog = new THREE.FogExp2(0x1a1a1a, 0.001); // Dark gray fog
```

---

## 📱 Mobile Optimization

### Disable on Small Screens:
```javascript
/* Add to init3DBackground() */
if (window.innerWidth < 768 || /Mobi|Android/i.test(navigator.userAgent)) {
    console.log('Mobile device detected, 3D disabled');
    return;
}
```

### Reduce Quality on Mobile:
```javascript
/* Detect mobile */
const isMobile = window.innerWidth < 768;

/* Adjust particle count */
const particleCount = isMobile ? 300 : 1000;

/* Simplify geometry */
const segments = isMobile ? 16 : 32;
```

---

## 🔍 Debug Mode

### Enable Detailed Logging:
```javascript
/* Add to 3d-background.js */
const DEBUG = true;

function log(message) {
    if (DEBUG) console.log('[3D BG]', message);
}

/* Use throughout code */
log('Initializing...');
log('Sphere created');
log('Animation frame:', frameCount);
```

### Show FPS Counter:
```javascript
/* Add to animate() */
let lastTime = Date.now();
let frames = 0;

function animate() {
    requestAnimationFrame(animate);
    
    frames++;
    const now = Date.now();
    if (now - lastTime > 1000) {
        console.log('FPS:', frames);
        frames = 0;
        lastTime = now;
    }
    
    // ... rest of code
}
```

---

## ✅ Final Checklist

- [ ] Three.js CDN loads (check Network tab)
- [ ] Console shows initialization messages
- [ ] No red errors in console
- [ ] `#canvas-3d` div exists in DOM
- [ ] Canvas element inside `#canvas-3d`
- [ ] CSS opacity is visible (0.5 - 1.0)
- [ ] z-index is correct (0 for canvas, 1+ for content)
- [ ] pointer-events is none
- [ ] Animation is running (objects rotating)
- [ ] FPS is smooth (30+ FPS)

---

## 🆘 Still Not Working?

### Last Resort Solutions:

1. **Clear all caches:**
   - Browser cache: Ctrl+Shift+Delete
   - Hard reload: Ctrl+Shift+R
   - Restart browser

2. **Try different browser:**
   - Chrome (recommended)
   - Firefox
   - Edge

3. **Check browser support:**
   - WebGL must be enabled
   - Visit: https://get.webgl.org/
   - Should show spinning cube

4. **Disable browser extensions:**
   - Ad blockers may block CDN
   - Privacy extensions may interfere

5. **Check console for ANY errors:**
   - Even unrelated errors can break JS
   - Fix all errors before 3D will work

---

**If you've followed all steps and it's still not visible, check the browser console and share the error messages!** 🔧
