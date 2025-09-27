<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MidMarks System - Home</title>
    <style>
        /* Body setup */
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
            transition: background 2s ease;
        }

        /* College banner */
        .college-banner {
            width: 100%;
            max-height: 250px;
            object-fit: contain;
            display: block;
            margin-bottom: 20px;
        }

        /* Container card */
        .container {
            background: rgba(255,255,255,0.95);
            padding: 35px 45px;
            border-radius: 16px;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            text-align: center;
            z-index: 1;
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            0% { opacity:0; transform:translateY(40px); }
            100% { opacity:1; transform:translateY(0); }
        }

        h2 {
            margin-bottom: 25px;
            color: #333;
        }

        /* Buttons */
        a {
            display: block;
            padding: 14px;
            margin: 12px 0;
            background: linear-gradient(135deg,#fc5c7d,#ff758c);
            color: #fff;
            font-weight: bold;
            font-size: 16px;
            text-decoration: none;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        a:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(252,92,125,0.4);
        }

        /* Sparkles */
        .sparkle {
            position: absolute;
            background: white;
            border-radius: 50%;
            opacity: 0.6;
            animation: sparkleMove linear infinite;
        }
        @keyframes sparkleMove {
            0% { transform: translateY(0px); opacity:1; }
            100% { transform: translateY(-500px); opacity:0; }
        }

        /* Responsive adjustments */
        @media(max-width:768px) {
            .container { padding: 25px 30px; }
            .college-banner { max-height:180px; }
        }
    </style>
</head>
<body>

    <!-- College Banner -->
    <img src="https://www.sietk.org/images/sietk-logo.png" 
         alt="SIETK Logo" 
         class="college-banner">

    <!-- Login Card -->
    <div class="container">
        <h2>Academic Marks Automation and Tracking System</h2>
        <a href="facultylogin.jsp">Faculty Login</a>
        <a href="hodLogin.jsp">Admin/HOD Login</a>
    </div>

    <!-- Floating sparkles -->
    <script>
        // Animated gradient
        const gradients = [
            'linear-gradient(105deg, #1a82fb, #fc5c7d)'
        ];
        let gradientIndex = 0;
        document.body.style.background = gradients[0];
        setInterval(() => {
            gradientIndex = (gradientIndex + 1) % gradients.length;
            document.body.style.setProperty("background", gradients[gradientIndex]);
        }, 3000);

        // Sparkles
        for(let i=0; i<25; i++){
            let s = document.createElement('div');
            s.className='sparkle';
            s.style.left = Math.random()*100 + 'vw';
            s.style.top = Math.random()*100 + 'vh';
            s.style.width = s.style.height = 2 + Math.random()*4 + 'px';
            s.style.animationDuration = 6 + Math.random()*6 + 's';
            document.body.appendChild(s);
        }
    </script>
</body>
</html>

