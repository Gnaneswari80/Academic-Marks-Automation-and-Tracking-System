<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Choose Marks Entry Method</title>
    <style>
        /* Animated gradient background */
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #6a82fb, #fc5c7d);
            transition: background 3s ease;
            overflow: hidden;
        }

        /* Container card */
        .container {
            background: rgba(255,255,255,0.95);
            padding: 35px 50px;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            text-align: center;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(40px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        h2 {
            margin-bottom: 25px;
            color: #333;
        }

        button {
            padding: 12px 25px;
            margin: 10px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .single {
            background: linear-gradient(135deg,#4CAF50,#81C784);
            color: white;
        }
        .single:hover {
            background: linear-gradient(135deg,#45a049,#66bb6a);
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .all {
            background: linear-gradient(135deg,#2196F3,#64B5F6);
            color: white;
        }
        .all:hover {
            background: linear-gradient(135deg,#0b7dda,#42a5f5);
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        /* Back button */
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

        /* Optional: floating sparkles */
        .sparkle {
            position:absolute; width:3px; height:3px; background:white; border-radius:50%; opacity:0.6;
            animation: sparkleMove 6s linear infinite;
        }
        @keyframes sparkleMove {
            0% { transform: translateY(0px); opacity:1; }
            100% { transform: translateY(-500px); opacity:0; }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Select Marks Entry Method</h2>
    
    <form action="enterSingleStudentMarks.jsp" method="get" style="display:inline;">
        <button type="submit" class="single">Enter Marks - One Student at a Time</button>
    </form>
    
    <form action="enterMarks.jsp" method="get" style="display:inline;">
        <button type="submit" class="all">Enter Marks - All Students</button>
    </form>

    <br>

    <!-- Back Button -->
    <form action="getSubjects.jsp" method="get">
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
setInterval(()=>{
    gradientIndex = (gradientIndex + 1) % gradients.length;
    document.body.style.background = gradients[gradientIndex];
}, 3000);
document.body.style.background = gradients[0];

// Floating sparkles
for(let i=0;i<25;i++){
    let s = document.createElement('div');
    s.className='sparkle';
    s.style.left=Math.random()*100+'vw';
    s.style.top=Math.random()*100+'vh';
    s.style.width=s.style.height=2+Math.random()*4+'px';
    s.style.animationDuration=4+Math.random()*4+'s';
    document.body.appendChild(s);
}
</script>

</body>
</html>
