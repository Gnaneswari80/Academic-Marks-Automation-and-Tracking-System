<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Faculty Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            height: 100vh;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg,#6a82fb,#fc5c7d);
            transition: background 3s ease;
        }

        /* Bubble container */
        .bubbles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
            z-index: 0;
        }

        .bubble {
            position: absolute;
            bottom: -100px;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            animation: rise 15s linear infinite;
        }

        @keyframes rise {
            0% { transform: translateY(0) scale(1); opacity: 0.5; }
            50% { opacity: 0.7; }
            100% { transform: translateY(-120vh) scale(1.2); opacity: 0; }
        }

        /* Dashboard card */
        .container {
            position: relative;
            z-index: 1;
            text-align: center;
            background: rgba(255,255,255,0.95);
            padding: 50px 70px;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(40px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        h2 {
            margin-bottom: 35px;
            color: #007bff;
        }

        button {
            padding: 15px 35px;
            margin: 10px;
            font-size: 16px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            color: #fff;
            background: linear-gradient(135deg,#007bff,#33a1ff);
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        button:hover {
            background: linear-gradient(135deg,#0056b3,#1a8cff);
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .back-btn {
            background: linear-gradient(135deg,#f44336,#e57373);
            color: #fff;
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 20px;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            background: linear-gradient(135deg,#d32f2f,#ef5350);
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

    <!-- Bubbles -->
    <div class="bubbles" id="bubbles"></div>

    <!-- Dashboard card -->
    <div class="container">
        <h2>Faculty Dashboard</h2>
        <form action="scheme.jsp" method="get" style="display:inline;">
            <button type="submit">Scheme</button>
        </form>
        <form action="marksEntry.jsp" method="get" style="display:inline;">
            <button type="submit">Post Marks</button>
        </form>

        <!-- Back Button -->
        <form action="variouswaystoentermars.jsp" method="get">
            <button type="submit" class="back-btn">&larr; Back</button>
        </form>
    </div>

    <script>
        // Animated gradient background
        let gradientIndex = 0;
        const gradients = [
            'linear-gradient(135deg, #6a82fb, #fc5c7d)',
            'linear-gradient(135deg, #ff9a9e, #fad0c4)',
            'linear-gradient(135deg, #a1c4fd, #c2e9fb)',
            'linear-gradient(135deg, #fbc2eb, #a6c1ee)',
            'linear-gradient(135deg, #d4fc79, #96e6a1)'
        ];
        setInterval(() => {
            gradientIndex = (gradientIndex + 1) % gradients.length;
            document.body.style.background = gradients[gradientIndex];
        }, 3000);
        document.body.style.background = gradients[0];

        // Create bubbles dynamically
        const bubbleContainer = document.getElementById('bubbles');
        const bubbleCount = 30;

        for(let i=0; i<bubbleCount; i++){
            let bubble = document.createElement('div');
            bubble.className = 'bubble';
            let size = Math.random()*40 + 20; // 20-60px
            bubble.style.width = size + 'px';
            bubble.style.height = size + 'px';
            bubble.style.left = Math.random()*100 + 'vw';
            bubble.style.animationDuration = (10 + Math.random()*15) + 's';
            bubble.style.animationDelay = Math.random()*15 + 's';
            bubbleContainer.appendChild(bubble);
        }
    </script>

</body>
</html>

