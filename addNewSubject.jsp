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
        String subjectName = request.getParameter("subject_name");
        String year = request.getParameter("year");
        String sem = request.getParameter("sem");
        String fid = request.getParameter("fid");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO subjects (subject_id, subject_name, year, sem, dept, fid) VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, subjectId);
            ps.setString(2, subjectName);
            ps.setString(3, year);
            ps.setString(4, sem);
            ps.setString(5, dept);
            ps.setString(6, fid);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "Subject added successfully.";
            } else {
                message = "Failed to add subject.";
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Something went wrong, subject not added";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Subject</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(-45deg, #d4c1ff, #a0d8ef, #ffe0b2, #fff3b0, #c1ffd7, #ffd1dc);
            background-size: 600% 600%;
            animation: gradientBG 20s ease infinite;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            width: 450px;
            padding: 25px;
            background: rgba(255,255,255,0.9);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            border-radius: 15px;
            z-index: 1;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input, select {
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }

        .back {
            margin-top: 15px;
            text-align: center;
        }

        .back a {
            text-decoration: none;
            color: #007BFF;
        }

        .back a:hover {
            text-decoration: underline;
        }

        /* Small floating bubbles */
        .bubble {
            position: absolute;
            background: rgba(255,255,255,0.4);
            border-radius: 50%;
            animation: floatUp 20s linear infinite;
            opacity: 0.6;
        }

        @keyframes floatUp {
            0% { transform: translateY(100vh) scale(1); opacity:0.6; }
            100% { transform: translateY(-10vh) scale(1); opacity:0; }
        }
    </style>
</head>
<body>

<!-- Bubbles -->
<%
    for (int i = 0; i < 20; i++) { 
%>
    <div class="bubble" style="
        width:<%= (4 + (int)(Math.random()*6)) %>px;
        height:<%= (4 + (int)(Math.random()*6)) %>px;
        left:<%= (int)(Math.random()*100) %>%;
        animation-duration:<%= (15 + (int)(Math.random()*15)) %>s;
        animation-delay:<%= (int)(Math.random()*20) %>s;
    "></div>
<% } %>

<div class="container">
    <h2>Add New Subject</h2>
    <form method="post" action="addNewSubject.jsp">
        <input type="text" name="subject_id" placeholder="Subject ID" required />
        <input type="text" name="subject_name" placeholder="Subject Name" required />

        <select name="year" required>
            <option value="">-- Select Year --</option>
            <option value="1">1st Year</option>
            <option value="2">2nd Year</option>
            <option value="3">3rd Year</option>
            <option value="4">4th Year</option>
        </select>

        <select name="sem" required>
            <option value="">-- Select Semester --</option>
            <option value="1">1st Sem</option>
            <option value="2">2nd Sem</option>
            <option value="3">3rd Sem</option>
            <option value="4">4th Sem</option>
            <option value="5">5th Sem</option>
            <option value="6">6th Sem</option>
            <option value="7">7th Sem</option>
            <option value="8">8th Sem</option>
        </select>

        <input type="text" name="fid" placeholder="Faculty ID (fid)" required />

        <input type="submit" value="Add Subject" />
    </form>

    <div class="back">
        <a href="hodHomePage.jsp">← Back to Home</a>
    </div>
</div>

<% if (!message.isEmpty()) { %>
<script>
    alert("<%= message %>");
</script>
<% } %>

</body>
</html>
