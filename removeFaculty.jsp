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
    String messageColor = "green";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fid = request.getParameter("faculty_id");

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement checkPs = conn.prepareStatement("SELECT COUNT(*) FROM subjects WHERE fid = ?");
            checkPs.setString(1, fid);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                message = "Cannot delete. Faculty is assigned to one or more subjects. Unassign them first.";
                messageColor = "red";
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM faculty WHERE faculty_id = ? AND faculty_department = ?"
                );
                ps.setString(1, fid);
                ps.setString(2, dept);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    message = "Faculty removed successfully.";
                    messageColor = "green";
                } else {
                    message = "Faculty not found or doesn't belong to your department.";
                    messageColor = "red";
                }
                ps.close();
            }

            rs.close();
            checkPs.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
            messageColor = "red";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Remove Faculty</title>
<style>
/* Body + Animated Gradient Background + Sparkles */
body {
    font-family: 'Segoe UI', sans-serif;
    margin:0; padding:0;
    min-height:100vh;
    display:flex; justify-content:center; align-items:center;
    background: linear-gradient(135deg, #6a82fb, #fc5c7d);
    transition: background 2s ease;
    overflow: hidden;
    background-size: 400% 400%;
    animation: gradientBG 15s ease infinite;
}

@keyframes gradientBG {
    0% {background-position:0% 50%;}
    50% {background-position:100% 50%;}
    100% {background-position:0% 50%;}
}

.sparkle {
    position:absolute;
    width:3px; height:3px;
    background:white;
    border-radius:50%;
    opacity:0.6;
    animation: sparkleMove linear infinite;
}

@keyframes sparkleMove {
    0% { transform: translateY(0px); opacity:1; }
    100% { transform: translateY(-500px); opacity:0; }
}

/* Container Card */
.container {
    background: rgba(255,255,255,0.95);
    padding: 35px 45px;
    border-radius:16px;
    max-width:450px;
    width:100%;
    box-shadow:0 20px 40px rgba(0,0,0,0.2);
    position: relative;
    z-index:1;
    animation: fadeInUp 1s ease-out;
}
@keyframes fadeInUp { 0%{opacity:0; transform:translateY(40px);}100%{opacity:1;transform:translateY(0);} }

h2 { text-align:center; margin-bottom:20px; color:#333; }
input[type="text"], input[type="submit"] {
    padding:12px; margin-bottom:15px; border-radius:8px; border:1px solid #ccc; font-size:14px;
}
input[type="submit"] {
    background-color:#ff4d4d; color:white; font-weight:bold; cursor:pointer; border:none; transition:0.3s;
}
input[type="submit"]:hover { background-color:#d93636; }
.back { text-align:center; margin-top:15px; }
.back a { text-decoration:none; color:#0275d8; font-weight:bold; transition:0.3s; }
.back a:hover { color:#014c8c; }
.message { text-align:center; margin-top:10px; font-weight:bold; color: <%= messageColor %>; }
</style>
</head>
<body>

<div class="container">
    <h2>Remove Faculty</h2>
    <form method="post" action="removeFaculty.jsp">
        <input type="text" name="faculty_id" placeholder="Faculty ID to Remove" required />
        <input type="submit" value="Remove Faculty" />
    </form>
    
    <div class="back"><a href="hodHomePage.jsp">← Back to Home</a></div>

<% if (!message.isEmpty()) { %>
    <script type="text/javascript">
        alert("<%= message %>");
    </script>
<% } %>

</div>

<script>
// Gradient cycling
const gradients = [
    'linear-gradient(135deg, #6a82fb, #fc5c7d)',
    'linear-gradient(135deg, #ff9a9e, #fad0c4)',
    'linear-gradient(135deg, #a1c4fd, #c2e9fb)',
    'linear-gradient(135deg, #fbc2eb, #a6c1ee)',
    'linear-gradient(135deg, #d4fc79, #96e6a1)'
];
let index=0;
setInterval(()=> {
    index=(index+1)%gradients.length;
    document.body.style.background=gradients[index];
},3000);
document.body.style.background=gradients[0];

// Floating sparkles
for(let i=0;i<25;i++){
    let s=document.createElement('div');
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
