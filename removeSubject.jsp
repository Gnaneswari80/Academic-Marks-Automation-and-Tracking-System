<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page session="true" %>
<%
    if (session == null || session.getAttribute("hod_id") == null) {
        response.sendRedirect("hodLogin.jsp");
        return;
    }

    String dept = (String) session.getAttribute("hod_department");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String subjectId = request.getParameter("subject_id");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM subjects WHERE subject_id = ? AND dept = ?");
            ps.setString(1, subjectId);
            ps.setString(2, dept);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "Subject removed successfully.";
            } else {
                message = "Subject ID not found or doesn't belong to your department.";
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Remove Subject</title>
    <style>
        /* Body + container styling */
        body { 
            font-family: 'Segoe UI', sans-serif; 
            display:flex; justify-content:center; align-items:center; 
            height:100vh; margin:0; transition: background 2s ease; 
            overflow:hidden;
        }
        .container { 
            background: rgba(255,255,255,0.95); 
            padding: 35px 45px; 
            border-radius:16px; 
            max-width:450px; width:100%; 
            box-shadow:0 20px 40px rgba(0,0,0,0.2); 
            animation: fadeInUp 1s ease-out;
            position: relative;
            z-index: 1;
        }
        @keyframes fadeInUp { 
            0%{opacity:0; transform:translateY(40px);} 
            100%{opacity:1; transform:translateY(0);} 
        }
        h2 { text-align:center; margin-bottom:20px; color:#333; }
        input[type="text"] {
            padding:12px; border-radius:8px; border:1px solid #ccc; margin-bottom:15px;
            width:100%; font-size:14px; transition: all 0.3s ease;
        }
        input[type="text"]:focus { border-color:#fc5c7d; box-shadow:0 0 10px rgba(252,92,125,0.3); outline:none; }
        input[type="submit"] { 
            padding:12px; background-color:#dc3545; color:white; border:none; border-radius:8px;
            font-size:16px; cursor:pointer; transition: all 0.3s ease; 
        }
        input[type="submit"]:hover { background-color:#b02a37; }
        .message { text-align:center; color:green; margin-top:10px; font-weight:bold; }
        .back { text-align:center; margin-top:15px; }
        .back a { text-decoration:none; color:#007BFF; }
        .back a:hover { text-decoration:underline; }

        /* Sparkles */
        .sparkle {
            position:absolute; border-radius:50%; background:white; opacity:0.6;
            animation: sparkleMove linear infinite;
        }
        @keyframes sparkleMove { 0%{transform:translateY(0); opacity:1;} 100%{transform:translateY(-500px); opacity:0;} }
    </style>
</head>
<body>

<div class="container">
    <h2>Remove Subject</h2>
    <form method="post" action="removeSubject.jsp">
        <input type="text" name="subject_id" placeholder="Enter Subject ID" required />
        <input type="submit" value="Remove Subject" />
    </form>

    <div class="message"><%= message %></div>

    <div class="back">
        <a href="hodHomePage.jsp">← Back to Home</a>
    </div>
</div>

<script>
    // Animated gradient
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
        s.className = 'sparkle';
        s.style.left = Math.random()*100+'vw';
        s.style.top = Math.random()*100+'vh';
        let size = 2 + Math.random()*4;
        s.style.width = size+'px';
        s.style.height = size+'px';
        s.style.animationDuration = 4 + Math.random()*4+'s';
        document.body.appendChild(s);
    }
</script>

</body>
</html>
