<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%
    String errorMsg = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fid = request.getParameter("fid");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT faculty_id, faculty_name FROM faculty WHERE faculty_id = ? AND faculty_password = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fid);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        session.setAttribute("faculty_id", rs.getString("faculty_id"));
                        session.setAttribute("faculty_name", rs.getString("faculty_name"));
                        response.sendRedirect("getSubjects.jsp");
                        return;
                    } else {
                        errorMsg = "Invalid Faculty ID or Password.";
                    }
                }
            }
        } catch (Exception e) {
            errorMsg = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Faculty Login</title>

<style>
/* Basic resets */
* { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', sans-serif; }

/* Body & animated gradient */
body {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
    transition: background 3s ease;
    background: linear-gradient(135deg, #6a82fb, #fc5c7d);
}

/* Floating clouds layers */
.cloud-layer {
    position: fixed;
    top: 0;
    left: 0;
    width: 200%;
    height: 100%;
    background-repeat: repeat-x;
    background-size: contain;
    animation: moveClouds linear infinite;
    pointer-events: none;
    opacity: 0.25;
    z-index: 0;
}
.cloud-layer.layer1 {
    background-image: radial-gradient(circle at 30% 50%, rgba(255,255,255,0.9) 0%, transparent 70%),
                      radial-gradient(circle at 70% 40%, rgba(255,255,255,0.8) 0%, transparent 60%);
    animation-duration: 120s;
}
.cloud-layer.layer2 {
    background-image: radial-gradient(circle at 20% 60%, rgba(255,255,255,0.85) 0%, transparent 70%),
                      radial-gradient(circle at 80% 50%, rgba(255,255,255,0.75) 0%, transparent 60%);
    animation-duration: 180s;
}
@keyframes moveClouds { from { transform: translateX(0); } to { transform: translateX(-50%); } }

/* Sparkles effect */
.sparkle {
    position: absolute;
    width: 3px;
    height: 3px;
    background: white;
    border-radius: 50%;
    opacity: 0.8;
    animation: sparkleMove 6s linear infinite;
}
@keyframes sparkleMove { 0% { transform: translateY(0px); opacity:1; } 100% { transform: translateY(-500px); opacity:0; } }

/* Login box */
.login-container {
    position: relative;
    background: rgba(255,255,255,0.95);
    padding: 35px 45px;
    border-radius: 16px;
    max-width: 400px;
    width: 100%;
    box-shadow: 0 20px 40px rgba(0,0,0,0.25), 0 0 15px rgba(255,255,255,0.1) inset;
    z-index: 1;
    animation: fadeInUp 1s ease-out;
}

/* Fade-in animation */
@keyframes fadeInUp {
    0% { opacity: 0; transform: translateY(40px); }
    100% { opacity: 1; transform: translateY(0); }
}

/* Typography & inputs */
h2 { text-align:center; margin-bottom:20px; color:#333; }
label { font-weight:bold; display:block; margin-top:15px; color:#555; }
input[type="text"], input[type="password"] {
    width: 100%; padding: 12px; margin-top:5px;
    border: 1px solid #ccc; border-radius: 8px;
    font-size: 14px;
    transition: all 0.3s ease;
}
input[type="text"]:focus, input[type="password"]:focus {
    border-color: #fc5c7d;
    box-shadow: 0 0 10px rgba(252,92,125,0.5);
    outline: none;
}

/* Submit button */
input[type="submit"] {
    width: 100%; padding: 12px;
    background: linear-gradient(135deg, #fc5c7d, #ff758c);
    color: #fff; font-weight: bold; font-size: 16px;
    border:none; border-radius: 10px;
    cursor: pointer;
    margin-top:20px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
input[type="submit"]:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 20px rgba(252,92,125,0.4);
}

/* Error message */
.error-message { color:#d9534f; font-weight:bold; text-align:center; margin-top:15px; }

/* Back button */
.back-button { display:inline-block; margin-bottom:10px; font-size:14px; text-decoration:none; color:#fc5c7d; font-weight:bold; }
.back-button:hover { color:#ff758c; }
</style>
</head>

<body>
<!-- Cloud layers -->
<div class="cloud-layer layer1"></div>
<div class="cloud-layer layer2"></div>

<!-- Sparkles -->
<script>
for(let i=0;i<30;i++){
    let s = document.createElement('div');
    s.className='sparkle';
    s.style.left = Math.random()*100+'vw';
    s.style.top = Math.random()*100+'vh';
    s.style.animationDuration = 4+Math.random()*4+'s';
    s.style.width = s.style.height = 2+Math.random()*4+'px';
    document.body.appendChild(s);
}
</script>

<div class="login-container">
    <a href="index.jsp" class="back-button">&#8592; Back</a>
    <h2>Faculty Login</h2>
    <form method="post">
        <label for="fid">Faculty ID</label>
        <input type="text" name="fid" id="fid" required>

        <label for="password">Password</label>
        <input type="password" name="password" id="password" required>

        <input type="submit" value="Login">
    </form>
    <p class="error-message"><%= errorMsg %></p>
</div>

<script>
// Smooth animated background gradients
let gradientIndex = 0;
const gradients = [
    'linear-gradient(135deg, #6a82fb, #fc5c7d)',
    'linear-gradient(135deg, #ff9a9e, #fad0c4)',
    'linear-gradient(135deg, #a1c4fd, #c2e9fb)',
    'linear-gradient(135deg, #fbc2eb, #a6c1ee)',
    'linear-gradient(135deg, #d4fc79, #96e6a1)'
];
function animateGradient() {
    gradientIndex = (gradientIndex + 1) % gradients.length;
    document.body.style.background = gradients[gradientIndex];
}
setInterval(animateGradient, 4000);
</script>
</body>
</html>
