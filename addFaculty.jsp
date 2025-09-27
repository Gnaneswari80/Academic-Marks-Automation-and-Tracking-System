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
        String fid = request.getParameter("faculty_id");
        String fname = request.getParameter("faculty_name");
        String pwd = request.getParameter("faculty_password");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO faculty (faculty_id, faculty_name, faculty_password, faculty_department) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, fid);
            ps.setString(2, fname);
            ps.setString(3, pwd);
            ps.setString(4, dept);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "Faculty added successfully.";
            } else {
                message = "Failed to add faculty.";
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = " Failed to add faculty,id aleady exists " ;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Faculty</title>
    <style>
        /* Soft animated gradient background */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(-45deg, 
                #d4c1ff, #a0d8ef, #ffe0b2, #fff3b0, #c1ffd7, #ffd1dc
            );
            background-size: 600% 600%;
            animation: gradientBG 20s ease infinite;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Form container */
        .container {
            width: 400px;
            background: rgba(255,255,255,0.9);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input[type="text"],
        input[type="password"] {
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        input[type="submit"] {
            padding: 12px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #449d44;
        }

        .back {
            margin-top: 15px;
            text-align: center;
        }

        .back a {
            text-decoration: none;
            color: #0275d8;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .back a:hover {
            color: #014c8c;
        }

        .message {
            text-align: center;
            margin-top: 10px;
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Faculty</h2>
    <form method="post" action="addFaculty.jsp">
        <input type="text" name="faculty_id" placeholder="Faculty ID" required />
        <input type="text" name="faculty_name" placeholder="Faculty Name" required />
        <input type="password" name="faculty_password" placeholder="Password" required />
        <input type="submit" value="Add Faculty" />
    </form>

   

    <div class="back">
        <a href="hodHomePage.jsp">← Back to Home</a>
    </div>
</div>
<%-- At the end of your JSP, before </body> --%>
<% if (!message.isEmpty()) { %>
    <script type="text/javascript">
        alert("<%= message %>");
    </script>
<% } %>

</body>
</html>

