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
        String studentId = request.getParameter("student_id");
        String studentName = request.getParameter("student_name");
        String sem = request.getParameter("sem");
        String year = request.getParameter("year");
        String batchYear = request.getParameter("batch_year");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO studentdetails (student_id, student_name, student_department,stu_sem,stu_year,stu_batchyear) VALUES (?,?,?,?,?, ?)"
            );
            ps.setString(1, studentId);
            ps.setString(2, studentName);
            ps.setString(3, dept);
            ps.setString(4, sem);
            ps.setString(5, year);
            ps.setString(6, batchYear);

            int rows = ps.executeUpdate();
            message = "New student added successfully.";

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message =  e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Batch</title>
<style>
body {
    font-family: Arial, sans-serif;
    display: flex; 
    justify-content: center; 
    align-items: center;
    height: 100vh; 
    margin: 0;
    transition: background 2s ease;
}

.container {
    width: 500px;
    padding: 25px;
    background-color: rgba(255,255,255,0.95);
    border-radius: 10px;
    box-shadow: 0 0 15px rgba(0,0,0,0.2);
    z-index: 1;
}

h2 {
    text-align: center;
}

form {
    display: flex;
    flex-direction: column;
}

input, select {
    padding: 10px;
    margin: 10px 0;
    border-radius: 5px;
    border: 1px solid #ccc;
}

input[type="submit"] {
    background-color: #007BFF;
    color: white;
    border: none;
    font-size: 16px;
    cursor: pointer;
    border-radius: 5px;
}

input[type="submit"]:hover {
    background-color: #0056b3;
}

.back {
    text-align: center;
    margin-top: 15px;
}

.back a {
    text-decoration: none;
    color: #007BFF;
}
</style>
</head>
<body>

<% if (!message.isEmpty()) { %>
<script>
    alert("<%= message.replace("\"", "\\\"") %>");
</script>
<% } %>

<div class="container">
    <h2>Add New Batch - Student Entry</h2>
    <form method="post" action="addNewBatch.jsp">
        <input type="text" name="student_id" placeholder="Student ID" required />
        <input type="text" name="student_name" placeholder="Student Name" required />

        <select name="sem" required>
            <option value="">-- Select Semester --</option>
            <% for(int i=1;i<=8;i++){ %>
                <option value="<%=i%>"><%=i%> <%=(i==1?"st":i==2?"nd":i==3?"rd":"th")%> Sem</option>
            <% } %>
        </select>

        <select name="year" required>
            <option value="">-- Select Year --</option>
            <% for(int i=1;i<=4;i++){ %>
                <option value="<%=i%>"><%=i%> <%=(i==1?"st":i==2?"nd":i==3?"rd":"th")%> Year</option>
            <% } %>
        </select>

        <input type="text" name="batch_year" placeholder="Batch Year (e.g. 2025)" required />

        <input type="submit" value="Add Student" />
    </form>

    <div class="back">
        <a href="hodHomePage.jsp">← Back to Home</a>
    </div>
</div>

<script>
let gradients = [
    'linear-gradient(135deg, #6a82fb, #fc5c7d)',
    'linear-gradient(135deg, #ff9a9e, #fad0c4)',
    'linear-gradient(135deg, #a1c4fd, #c2e9fb)',
    'linear-gradient(135deg, #fbc2eb, #a6c1ee)',
    'linear-gradient(135deg, #d4fc79, #96e6a1)'
];
let index = 0;
setInterval(()=>{
    index = (index + 1) % gradients.length;
    document.body.style.background = gradients[index];
}, 3000);
document.body.style.background = gradients[0];
</script>

</body>
</html>

