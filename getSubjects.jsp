<%@ page import="java.sql.*" %> 
<%@ page session="true" %>
<%
    String fid = (String) session.getAttribute("faculty_id");
    if(fid == null){
        response.sendRedirect("facultylogin.jsp");
        return;
    }

    String errorMsg = "";
    if("POST".equalsIgnoreCase(request.getMethod())){
        String dept = request.getParameter("department");
        String sem = request.getParameter("sem");
        String year = request.getParameter("year");
        String batchYear = request.getParameter("batchYear");
        String subjectId = request.getParameter("subject");
        String mid = request.getParameter("mid");

        String subjectName = null;
        if(subjectId != null && !subjectId.isEmpty()){
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try(Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/midmarks_db","root","")){
                    PreparedStatement ps = con.prepareStatement("SELECT subject_name FROM subjects WHERE subject_id=?");
                    ps.setString(1, subjectId);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()) subjectName = rs.getString("subject_name");
                    rs.close(); ps.close();
                }
            } catch(Exception e){ errorMsg = e.getMessage(); }
        }

        if(dept != null && sem != null && year != null && batchYear != null && subjectId != null && mid != null){
            session.setAttribute("department", dept);
            session.setAttribute("sem", sem);
            session.setAttribute("year", year);
            session.setAttribute("batchYear", batchYear);
            session.setAttribute("subjectId", subjectId);
            session.setAttribute("subject_name", subjectName);
            session.setAttribute("mid", mid);

            response.sendRedirect("variouswaystoentermars.jsp");
            return;
        } else { errorMsg = "Please fill all fields"; }
    }

    // AJAX for subjects
    String action = request.getParameter("action");
    if("loadSubjects".equals(action)){
        response.setContentType("text/html");
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");
        String year = request.getParameter("year");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try(Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/midmarks_db","root","")){
                PreparedStatement ps = con.prepareStatement("SELECT subject_id, subject_name FROM subjects WHERE fid=? AND dept=? AND sem=? AND year=?");
                ps.setString(1,fid);
                ps.setString(2,dept);
                ps.setString(3,sem);
                ps.setString(4,year);
                ResultSet rs = ps.executeQuery();
                while(rs.next()){
                    out.println("<option value='"+rs.getString("subject_id")+"'>"+rs.getString("subject_id")+" - "+rs.getString("subject_name")+"</option>");
                }
                rs.close(); ps.close();
            }
        } catch(Exception e){ out.println("<option disabled>Error loading subjects</option>"); e.printStackTrace(); }
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Subject</title>
<style>
body { 
    font-family: 'Segoe UI', sans-serif; 
    display:flex; justify-content:center; align-items:center; 
    height:100vh; margin:0; transition: background 2s ease; 
}

/* Container Card */
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
@keyframes fadeInUp { 0%{opacity:0; transform:translateY(40px);}100%{opacity:1;transform:translateY(0);} }

h2 { text-align:center; margin-bottom:20px; color:#333; }
label { font-weight:bold; display:block; margin-top:15px; color:#555; }
select { width:100%; padding:12px; margin-top:5px; border-radius:8px; border:1px solid #ccc; font-size:14px; transition: all 0.3s ease; }
select:hover, select:focus { border-color:#fc5c7d; box-shadow:0 0 10px rgba(252,92,125,0.3); outline:none; }

input[type="submit"] {
    width:100%; padding:12px;
    background: linear-gradient(135deg,#fc5c7d,#ff758c);
    color:#fff; font-weight:bold; font-size:16px;
    border:none; border-radius:10px; cursor:pointer;
    margin-top:20px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
input[type="submit"]:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 20px rgba(252,92,125,0.4);
}

.error-message { color:#d9534f; font-weight:bold; text-align:center; margin-top:15px; }
.back-button { display:inline-block; margin-bottom:15px; text-decoration:none; color:#333; font-weight:bold;}
.back-button:hover { color:#fc5c7d; }

/* Optional: small floating sparkles */
.sparkle {
    position:absolute; width:3px; height:3px; background:white; border-radius:50%; opacity:0.6;
    animation: sparkleMove 6s linear infinite;
}
@keyframes sparkleMove { 0% { transform: translateY(0px); opacity:1; } 100% { transform: translateY(-500px); opacity:0; } }
</style>
</head>
<body>

<div class="container">
<a href="facultylogin.jsp" class="back-button">&#8592; Back</a>

<h2>Select Subject and Details</h2>
<% if(!errorMsg.isEmpty()){ %><p class="error-message"><%=errorMsg%></p><% } %>

<form method="post">
    <label>Department:</label>
    <select id="department" name="department" required>
        <option value="" disabled selected>-- Select Department --</option>
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

    <label>Semester:</label>
    <select id="sem" name="sem" required>
        <option value="" disabled selected>-- Select Semester --</option>
        <% for(int i=1;i<=8;i++){ %><option value="<%=i%>"><%=i%></option><% } %>
    </select>

    <label>Year:</label>
    <select id="year" name="year" required>
        <option value="" disabled selected>-- Select Year --</option>
        <% for(int i=1;i<=4;i++){ %><option value="<%=i%>"><%=i%></option><% } %>
    </select>

    <label>Batch Year:</label>
    <select name="batchYear" required>
        <option value="" disabled selected>-- Select Batch Year --</option>
        <% int currentYear=java.util.Calendar.getInstance().get(java.util.Calendar.YEAR); 
           for(int y=currentYear; y>=currentYear-10; y--){ %>
           <option value="<%=y%>"><%=y%></option>
        <% } %>
    </select>

    <label>Mid:</label>
    <select name="mid" required>
        <option value="mid1">Mid 1</option>
        <option value="mid2">Mid 2</option>
    </select>

    <label>Subject:</label>
    <select id="subject" name="subject" required>
        <option value="" disabled selected>-- Select Subject --</option>
    </select>

    <input type="submit" value="Proceed to Enter Marks">
</form>
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
    s.className='sparkle';
    s.style.left=Math.random()*100+'vw';
    s.style.top=Math.random()*100+'vh';
    s.style.width=s.style.height=2+Math.random()*4+'px';
    s.style.animationDuration=4+Math.random()*4+'s';
    document.body.appendChild(s);
}

// Dynamic subjects loading
function loadSubjects(){
    var dept = document.getElementById("department").value;
    var sem = document.getElementById("sem").value;
    var year = document.getElementById("year").value;
    if(dept && sem && year){
        fetch("getSubjects.jsp?action=loadSubjects&dept="+dept+"&sem="+sem+"&year="+year)
        .then(res=>res.text())
        .then(html=>{ 
            document.getElementById("subject").innerHTML = "<option value='' disabled selected>-- Select Subject --</option>" + html;
        }).catch(err=>console.error(err));
    }
}
document.getElementById("department").addEventListener("change", loadSubjects);
document.getElementById("sem").addEventListener("change", loadSubjects);
document.getElementById("year").addEventListener("change", loadSubjects);
</script>
</body>
</html>
