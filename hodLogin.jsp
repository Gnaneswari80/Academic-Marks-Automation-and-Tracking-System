<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>  
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HOD / Admin Login</title>
<style>
/* Animated Gradient Background */
body { 
    font-family: Arial, sans-serif; 
    margin: 0; 
    padding: 0; 
    height: 100vh; 
    display: flex; 
    justify-content: center; 
    align-items: center;
    overflow: hidden; 
    background: linear-gradient(-45deg, #6a11cb, #2575fc, #ff6a00, #ffb347);
    background-size: 400% 400%;
    animation: gradientBG 15s ease infinite;
}

/* Gradient Animation */
@keyframes gradientBG {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Floating Bubbles */
.bubble {
    position: absolute;
    border-radius: 50%;
    opacity: 0.3;
    animation: floatUp linear infinite;
}

@keyframes floatUp {
    0% { transform: translateY(100vh) scale(0.5); opacity: 0.3; }
    100% { transform: translateY(-50vh) scale(1); opacity: 0; }
}

/* Login Container */
.login-container { 
    position: relative;
    z-index: 10;
    background: rgba(255,255,255,0.95); 
    padding: 30px 35px; 
    border-radius: 12px; 
    box-shadow: 0 10px 25px rgba(0,0,0,0.3); 
    width: 340px;
}

h2 { text-align: center; margin-bottom: 25px; color: #333; }
label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
input, select { 
    width: 100%; 
    padding: 10px; 
    margin-top: 5px; 
    border: 1px solid #ccc; 
    border-radius: 6px; 
    font-size: 14px;
}
input[type="submit"] { 
    margin-top: 20px; 
    background: #2575fc; 
    color: white; 
    border: none; 
    font-weight: bold; 
    cursor: pointer; 
    transition: 0.3s;
}
input[type="submit"]:hover { background: #6a11cb; }
.error { 
    margin-top: 15px; 
    padding: 10px; 
    background-color: #f8d7da; 
    border: 1px solid #f5c6cb; 
    color: #721c24; 
    border-radius: 6px; 
    text-align: center; 
    font-weight: bold; 
}
.info-text { font-size: 12px; color: #555; margin-top: 5px; }

@media(max-width:400px){
    .login-container { width: 90%; padding: 25px; }
}
</style>
</head>
<body>

<!-- Floating bubbles -->
<script>
const colors = [
    'rgba(255, 255, 255, 0.6)',  // soft white
    'rgba(248, 249, 250, 0.6)',  // very light gray
    'rgba(209, 236, 241, 0.6)',  // pastel blue
    'rgba(195, 230, 203, 0.6)',  // pastel green
    'rgba(255, 238, 186, 0.6)',  // pastel yellow
    'rgba(255, 200, 200, 0.5)',  // soft pink
    'rgba(220, 200, 255, 0.5)'   // soft lavender
];

const bubbleCount = 25;
for(let i=0;i<bubbleCount;i++){
    let bubble = document.createElement('div');
    bubble.className = 'bubble';
    let size = Math.random() * 40 + 10; // 10-50px
    bubble.style.width = size + 'px';
    bubble.style.height = size + 'px';
    bubble.style.left = Math.random() * 100 + 'vw';
    bubble.style.background = colors[Math.floor(Math.random()*colors.length)];
    bubble.style.animationDuration = (Math.random()*10+5)+'s';
    bubble.style.animationDelay = Math.random()*10+'s';
    document.body.appendChild(bubble);
}
</script>

<div class="login-container">
<a href="index.jsp" class="back-button">&#8592; Back</a>
    <h2>HOD / Admin Login</h2>
    <form method="post" action="hodLogin.jsp">
        <label for="hod_id">User ID:</label>
        <input type="text" name="hod_id" id="hod_id" required>

        <label for="hod_password">Password:</label>
        <input type="password" name="hod_password" id="hod_password" required>

        <label for="hod_department">Department:</label>
        <select name="hod_department" id="hod_department" required>
            <option value="">Select Department</option>
            <option value="CSE">CSE</option>
        <option value="ECE">ECE</option>
        <option value="EEE">EEE</option>
        <option value="MCA">MCA</option>
        <option value="MBA">MBA</option>
        <option value="MTech">MTech</option>
        <option value="Mech">Mech</option>
        <option value="CIVIL">CIVIL</option>
        <option value="AGRI">AGRI</option>
        <option value="BS&S">BS&H</option>
        </select>
        <p class="info-text">
            For Admins: Select the department you want to manage.<br>
            For HODs: Select your own department.
        </p>

        <input type="submit" value="Login">
    </form>

<%
    String hod_id = request.getParameter("hod_id");
    String hod_password = request.getParameter("hod_password");
    String hod_department = request.getParameter("hod_department");

    if (hod_id != null && hod_password != null && hod_department != null 
        && !hod_id.trim().isEmpty() && !hod_password.trim().isEmpty() && !hod_department.trim().isEmpty()) {
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();

            // Check admin
            ps = con.prepareStatement(
                "SELECT faculty_name, faculty_designation FROM faculty " +
                "WHERE faculty_id = ? AND faculty_password = ? AND faculty_designation = 'Admin'"
            );
            ps.setString(1, hod_id);
            ps.setString(2, hod_password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("hod_id", hod_id);
                session.setAttribute("hod_department", hod_department);
                session.setAttribute("hod_name", rs.getString("faculty_name"));
                session.setAttribute("hod_designation", "Admin");
                response.sendRedirect("hodHomePage.jsp");
                return;
            }
            rs.close();
            ps.close();

            // Check HOD
            ps = con.prepareStatement(
                "SELECT faculty_name, faculty_designation FROM faculty " +
                "WHERE faculty_id = ? AND faculty_password = ? " +
                "AND faculty_department = ? AND faculty_designation = 'HOD'"
            );
            ps.setString(1, hod_id);
            ps.setString(2, hod_password);
            ps.setString(3, hod_department);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("hod_id", hod_id);
                session.setAttribute("hod_department", hod_department);
                session.setAttribute("hod_name", rs.getString("faculty_name"));
                session.setAttribute("hod_designation", "HOD");
                response.sendRedirect("hodHomePage.jsp");
                return;
            } else {
%>
                <div class="error">Invalid credentials.</div>
<%
            }
        } catch (Exception e) {
%>
            <div class="error">Error: <%= e.getMessage() %></div>
<%
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e) {}
            try { if (ps != null) ps.close(); } catch(Exception e) {}
            try { if (con != null) con.close(); } catch(Exception e) {}
        }
    }
%>

</div>
</body>
</html>
