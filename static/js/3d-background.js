// ===================================
// 3D ANIMATED BACKGROUND
// Smart Attendance System - GCEE
// ===================================

let scene, camera, renderer, particles, geometryGroup;
let mouseX = 0, mouseY = 0;
let windowHalfX = window.innerWidth / 2;
let windowHalfY = window.innerHeight / 2;

// Initialize 3D Scene
function init3DBackground() {
    // Create scene
    scene = new THREE.Scene();
    scene.fog = new THREE.FogExp2(0x000000, 0.001);

    // Create camera
    camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        1,
        3000
    );
    camera.position.set(300, 0, 800);

    // Create renderer
    renderer = new THREE.WebGLRenderer({ 
        alpha: true, 
        antialias: true 
    });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setClearColor(0x000000, 0);
    
    console.log('3D Background: Renderer created successfully');

    // Add to DOM
    const canvas = document.getElementById('canvas-3d');
    if (canvas) {
        canvas.appendChild(renderer.domElement);
        console.log('3D Background: Canvas added to DOM');
    } else {
        console.error('3D Background: canvas-3d element not found!');
        return;
    }

    // Create 3D Objects
    createAttendanceModel();
    createParticleSystem();
    createGoldenRings();

    // Event listeners
    document.addEventListener('mousemove', onDocumentMouseMove, false);
    window.addEventListener('resize', onWindowResize, false);

    // Start animation
    animate();
}

// Create Attendance System 3D Model
function createAttendanceModel() {
    geometryGroup = new THREE.Group();

    // Central Icosahedron (professional geometric shape)
    const icoGeometry = new THREE.IcosahedronGeometry(120, 1);
    const icoMaterial = new THREE.MeshPhongMaterial({
        color: 0xD4AF37,
        transparent: true,
        opacity: 0.8,
        wireframe: true,
        emissive: 0xD4AF37,
        emissiveIntensity: 0.6
    });
    const icosahedron = new THREE.Mesh(icoGeometry, icoMaterial);
    geometryGroup.add(icosahedron);
    
    // Inner sphere for depth
    const sphereGeometry = new THREE.SphereGeometry(80, 32, 32);
    const sphereMaterial = new THREE.MeshPhongMaterial({
        color: 0xC0C0C0,
        transparent: true,
        opacity: 0.3,
        wireframe: true,
        emissive: 0xC0C0C0,
        emissiveIntensity: 0.3
    });
    const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
    geometryGroup.add(sphere);
    console.log('3D Background: Professional geometry created');

    // Orbiting Cubes (represent students/staff)
    const cubeGeometry = new THREE.BoxGeometry(20, 20, 20);
    const cubeMaterial = new THREE.MeshPhongMaterial({
        color: 0xD4AF37,
        transparent: true,
        opacity: 0.9,
        emissive: 0xD4AF37,
        emissiveIntensity: 0.6
    });

    const cubes = [];
    for (let i = 0; i < 8; i++) {
        const cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
        const angle = (i / 8) * Math.PI * 2;
        const radius = 220;
        cube.position.x = Math.cos(angle) * radius;
        cube.position.y = Math.sin(angle) * radius;
        cube.position.z = Math.sin(angle * 2) * 50;
        cube.userData = { angle: angle, radius: radius, speed: 0.01 + i * 0.001 };
        geometryGroup.add(cube);
        cubes.push(cube);
    }
    
    // Add connecting lines between cubes (network effect)
    const lineMaterial = new THREE.LineBasicMaterial({
        color: 0xD4AF37,
        transparent: true,
        opacity: 0.2
    });
    
    for (let i = 0; i < cubes.length; i++) {
        const nextIndex = (i + 1) % cubes.length;
        const points = [
            cubes[i].position,
            cubes[nextIndex].position
        ];
        const lineGeometry = new THREE.BufferGeometry().setFromPoints(points);
        const line = new THREE.Line(lineGeometry, lineMaterial);
        geometryGroup.add(line);
    }

    // Hexagonal rings for professional look
    const hexPoints = [];
    for (let i = 0; i < 6; i++) {
        const angle = (i / 6) * Math.PI * 2;
        hexPoints.push(new THREE.Vector3(
            Math.cos(angle) * 180,
            Math.sin(angle) * 180,
            0
        ));
    }
    hexPoints.push(hexPoints[0]); // Close the hexagon
    
    const hexGeometry = new THREE.BufferGeometry().setFromPoints(hexPoints);
    const hexMaterial = new THREE.LineBasicMaterial({
        color: 0xD4AF37,
        transparent: true,
        opacity: 0.4
    });
    
    const hex1 = new THREE.Line(hexGeometry, hexMaterial);
    hex1.rotation.x = Math.PI / 6;
    geometryGroup.add(hex1);
    
    const hex2 = new THREE.Line(hexGeometry, hexMaterial);
    hex2.rotation.y = Math.PI / 6;
    geometryGroup.add(hex2);
    
    const hex3 = new THREE.Line(hexGeometry, hexMaterial);
    hex3.rotation.z = Math.PI / 6;
    geometryGroup.add(hex3);

    // Add lights
    const ambientLight = new THREE.AmbientLight(0x404040, 3);
    scene.add(ambientLight);

    const pointLight1 = new THREE.PointLight(0xD4AF37, 2, 1000);
    pointLight1.position.set(200, 200, 200);
    scene.add(pointLight1);

    const pointLight2 = new THREE.PointLight(0xC0C0C0, 1.5, 1000);
    pointLight2.position.set(-200, -200, -200);
    scene.add(pointLight2);
    
    const pointLight3 = new THREE.PointLight(0xFFFFFF, 1, 1000);
    pointLight3.position.set(0, 0, 500);
    scene.add(pointLight3);

    scene.add(geometryGroup);
    console.log('3D Background: Geometry group added to scene');
}

// Create Particle System
function createParticleSystem() {
    const particlesGeometry = new THREE.BufferGeometry();
    const particleCount = 500; // Reduced for professional look
    const positions = new Float32Array(particleCount * 3);
    const colors = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
        // Concentrated around center
        const radius = Math.random() * 600 + 200;
        const theta = Math.random() * Math.PI * 2;
        const phi = Math.random() * Math.PI;
        
        positions[i] = radius * Math.sin(phi) * Math.cos(theta);
        positions[i + 1] = radius * Math.sin(phi) * Math.sin(theta);
        positions[i + 2] = radius * Math.cos(phi);

        // Gold and silver colors
        const isGold = Math.random() > 0.5;
        if (isGold) {
            colors[i] = 0.83;     // R
            colors[i + 1] = 0.69; // G
            colors[i + 2] = 0.22; // B
        } else {
            colors[i] = 0.75;     // R
            colors[i + 1] = 0.75; // G
            colors[i + 2] = 0.75; // B
        }
    }

    particlesGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    particlesGeometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));

    const particlesMaterial = new THREE.PointsMaterial({
        size: 2,
        vertexColors: true,
        transparent: true,
        opacity: 0.7,
        blending: THREE.AdditiveBlending
    });

    particles = new THREE.Points(particlesGeometry, particlesMaterial);
    scene.add(particles);
    console.log('3D Background: Particle system created with', particleCount, 'particles');
}

// Create Professional Grid Background
function createGoldenRings() {
    // Create subtle grid lines
    const gridHelper = new THREE.GridHelper(800, 20, 0xD4AF37, 0xC0C0C0);
    gridHelper.material.transparent = true;
    gridHelper.material.opacity = 0.1;
    gridHelper.position.z = -400;
    gridHelper.rotation.x = Math.PI / 2;
    scene.add(gridHelper);
}

// Animation Loop
function animate() {
    requestAnimationFrame(animate);

    // Rotate main geometry group
    if (geometryGroup) {
        geometryGroup.rotation.y += 0.001;
        geometryGroup.rotation.x += 0.0005;

        // Animate orbiting cubes
        geometryGroup.children.forEach((child, index) => {
            if (child.userData.angle !== undefined) {
                child.userData.angle += child.userData.speed;
                child.position.x = Math.cos(child.userData.angle) * child.userData.radius;
                child.position.y = Math.sin(child.userData.angle) * child.userData.radius;
                child.position.z = Math.sin(child.userData.angle * 2) * 50;
                child.rotation.x += 0.01;
                child.rotation.y += 0.01;
            }
        });
    }

    // Rotate particles
    if (particles) {
        particles.rotation.y += 0.0002;
        particles.rotation.x += 0.0001;
    }

    // Camera movement based on mouse
    camera.position.x += (mouseX - camera.position.x) * 0.05;
    camera.position.y += (-mouseY - camera.position.y) * 0.05;
    camera.lookAt(scene.position);

    renderer.render(scene, camera);
}

// Mouse move handler
function onDocumentMouseMove(event) {
    mouseX = (event.clientX - windowHalfX) / 10;
    mouseY = (event.clientY - windowHalfY) / 10;
}

// Window resize handler
function onWindowResize() {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize(window.innerWidth, window.innerHeight);
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, checking for Three.js...');
    
    // Check if Three.js is loaded
    if (typeof THREE !== 'undefined') {
        console.log('Three.js found! Initializing 3D background...');
        init3DBackground();
    } else {
        console.error('Three.js not loaded! 3D background disabled.');
        console.log('Make sure Three.js CDN is loaded before this script.');
    }
});

// Cleanup on page unload
window.addEventListener('beforeunload', function() {
    if (renderer) {
        renderer.dispose();
    }
});
