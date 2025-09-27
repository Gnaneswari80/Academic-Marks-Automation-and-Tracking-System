<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String sem = (String) session.getAttribute("sem");
    String year = (String) session.getAttribute("year");
    String dep = (String) session.getAttribute("hod_department");

    if (sem == null || year == null || dep == null) {
%>
        <p style="color:red;">Please select semester, year, and department first.</p>
<%
        return;
    }

    String selectedSubjectId = request.getParameter("selectedSubjectId");
    String selectedSubjectName = null;

    if (selectedSubjectId != null && !selectedSubjectId.trim().isEmpty()) {
        selectedSubjectName = request.getParameter("subjectName_" + selectedSubjectId);
        session.setAttribute("selectedSubjectId", selectedSubjectId);
        session.setAttribute("selectedSubjectName", selectedSubjectName);
        response.sendRedirect("hodviewmarks.jsp");
        return;
    }

    // Random gradient backgrounds
    String[] gradients = {
        "linear-gradient(to right, #f8f9fa, #e0f7fa)",
        "linear-gradient(to right, #ffe5b4, #ffcccb)",
        "linear-gradient(to right, #d4edda, #c3e6cb)",
        "linear-gradient(to right, #d1ecf1, #bee5eb)",
        "linear-gradient(to right, #fff3cd, #ffeeba)",
        "linear-gradient(to right, #f5c6cb, #f8d7da)",
        "linear-gradient(to right, #cce5ff, #b8daff)"
    };
    Random rand = new Random();
    String bgGradient = gradients[rand.nextInt(gradients.length)];
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>HOD Subject Selection</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background: <%= bgGradient %>;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: background 0.5s ease;
        }

        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            max-width: 600px;
        }

        button.subject-btn {
            padding: 12px 25px;
            font-size: 1rem;
            cursor: pointer;
            border: 2px solid #00796b;
            border-radius: 6px;
            background-color: #ffffff;
            color: #00796b;
            transition: 0.3s;
        }

        button.subject-btn:hover {
            background-color: #00796b;
            color: #ffffff;
        }

        p.no-subjects {
            color: #333;
            font-style: italic;
            text-align: center;
        }

        button.back-btn {
            position: absolute;
            top: 15px;
            left: 15px;
            padding: 6px 12px;
            font-size: 14px;
            cursor: pointer;
            background-color: #004d40;
            color: white;
            border: none;
            border-radius: 4px;
            transition: 0.3s;
        }

        button.back-btn:hover {
            background-color: #00695c;
        }
    </style>
</head>
<body>

    <button class="back-btn" onclick="window.location.href='hodselection.jsp'">&larr; Back</button>

    <h2>Select Subject for Semester: <%= sem %>, Year: <%= year %>, Department: <%= dep.toUpperCase() %></h2>

<%
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/midmarks_db";
        String user = "root";
        String password = "";
        conn = DriverManager.getConnection(url, user, password);

        String sql = "SELECT subject_id, subject_name FROM subjects WHERE sem=? AND year=? AND dept=?";
        pst = conn.prepareStatement(sql);
        pst.setString(1, sem);
        pst.setString(2, year);
        pst.setString(3, dep);
        rs = pst.executeQuery();

        boolean found = false;
%>

<form method="post" action="hodsubjectselection.jsp">
    <%
        while (rs.next()) {
            found = true;
            String subjectId = rs.getString("subject_id");
            String subjectName = rs.getString("subject_name");
    %>
        <button type="submit" name="selectedSubjectId" value="<%= subjectId %>" class="subject-btn">
            <%= subjectName %> (<%= subjectId %>)
        </button>
        <input type="hidden" name="subjectName_<%= subjectId %>" value="<%= subjectName %>" />
    <%
        }

        if (!found) {
    %>
        <p class="no-subjects">No subjects found for the selected semester, year, and department.</p>
    <%
        }
    %>
</form>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (pst != null) pst.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

</body>
</html>

