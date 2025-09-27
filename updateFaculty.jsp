<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page session="true" %>
<%
    if (session == null || session.getAttribute("hod_id") == null) {
        response.sendRedirect("hodLogin.jsp");
        return;
    }

    String designation = (String) session.getAttribute("hod_designation"); // "Admin" or "HOD"
    String dept = (String) session.getAttribute("hod_department");

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fid = request.getParameter("fid");
        String fname = request.getParameter("fname");
        String fpass = request.getParameter("fpass");
        String fdep = request.getParameter("fdep");
        String old_fid = request.getParameter("old_fid");

        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if ("Admin".equalsIgnoreCase(designation)) {
                PreparedStatement checkDup = conn.prepareStatement(
                    "SELECT COUNT(*) FROM faculty WHERE faculty_id = ?"
                );
                checkDup.setString(1, fid);
                ResultSet dupRs = checkDup.executeQuery();
                dupRs.next();
                if (dupRs.getInt(1) > 0 && !fid.equalsIgnoreCase(old_fid)) {
                    out.println("<script>alert('Faculty ID already exists.'); window.location.href='updateFaculty.jsp';</script>");
                    conn.rollback();
                    return;
                }
                dupRs.close();
                checkDup.close();

                Statement disableFK = conn.createStatement();
                disableFK.execute("SET FOREIGN_KEY_CHECKS=0");

                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE faculty SET faculty_id=?, faculty_name=?, faculty_password=?, faculty_department=? WHERE faculty_id=? AND faculty_department=?"
                );
                ps.setString(1, fid);
                ps.setString(2, fname);
                ps.setString(3, fpass);
                ps.setString(4, fdep);
                ps.setString(5, old_fid);
                ps.setString(6, dept);
                ps.executeUpdate();
                ps.close();

                PreparedStatement psSubjects = conn.prepareStatement(
                    "UPDATE subjects SET fid=? WHERE fid=?"
                );
                psSubjects.setString(1, fid);
                psSubjects.setString(2, old_fid);
                psSubjects.executeUpdate();
                psSubjects.close();

                disableFK.execute("SET FOREIGN_KEY_CHECKS=1");
                disableFK.close();
                conn.commit();
                out.println("<script>alert('Faculty updated successfully.'); window.location.href='updateFaculty.jsp';</script>");
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE faculty SET faculty_name=?, faculty_password=? WHERE faculty_id=? AND faculty_department=?"
                );
                ps.setString(1, fname);
                ps.setString(2, fpass);
                ps.setString(3, fid);
                ps.setString(4, dept);
                int updated = ps.executeUpdate();
                ps.close();
                if (updated > 0) {
                    conn.commit();
                    out.println("<script>alert('Faculty updated successfully.'); window.location.href='updateFaculty.jsp';</script>");
                } else {
                    conn.rollback();
                    out.println("<script>alert('Update failed.'); window.location.href='updateFaculty.jsp';</script>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error while updating faculty.'); window.location.href='updateFaculty.jsp';</script>");
        }
    }

    // Fetch faculty records
    Connection conn = DBConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM faculty WHERE faculty_department = ?");
    ps.setString(1, dept);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Faculty</title>
    <style>
        /* Light animated gradient background */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(-45deg, #d4c1ff, #a0d8ef, #ffe0b2, #fff3b0, #c1ffd7, #ffd1dc);
            background-size: 600% 600%;
            animation: gradientBG 20s ease infinite;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Container */
        h2 {
            text-align: center;
            margin-top: 30px;
            color: #333;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background: rgba(255,255,255,0.9);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            border-radius: 10px;
            overflow: hidden;
        }

        th { background-color: #4CAF50; color: white; padding: 12px; }
        td { padding: 10px; text-align: center; }

        input[type="text"], input[type="password"] {
            padding: 6px;
            width: 90%;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[readonly] { background-color: #f0f0f0; }
        input[type="submit"] {
            padding: 6px 12px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover { background-color: #0b7dda; }

        .back-button { text-align: center; margin-top: 25px; }
        .back-button a {
            text-decoration: none;
            color: #333;
            background-color: #ddd;
            padding: 8px 15px;
            border-radius: 5px;
        }
        .back-button a:hover { background-color: #bbb; }
        .message { text-align: center; font-weight: bold; color: green; margin-top: 20px; }

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

<!-- Add bubbles -->
<%
    for (int i = 0; i < 20; i++) { 
%>
    <div class="bubble" style="
        width:<%= (2 + (int)(Math.random()*4)) %>px;
        height:<%= (2 + (int)(Math.random()*4)) %>px;
        left:<%= (int)(Math.random()*100) %>%;
        animation-duration:<%= (15 + (int)(Math.random()*15)) %>s;
        animation-delay:<%= (int)(Math.random()*20) %>s;
    "></div>
<% } %>

<h2>Update Faculty Records</h2>

<table border="1">
    <tr>
        <th>Faculty ID</th>
        <th>Faculty Name</th>
        <th>Password</th>
        <th>Department</th>
        <th>Update</th>
    </tr>

<% while (rs.next()) { %>
    <tr>
        <form method="post">
            <input type="hidden" name="old_fid" value="<%= rs.getString("faculty_id") %>" />
            <td>
                <input type="text" name="fid" value="<%= rs.getString("faculty_id") %>"
                       <%= "Admin".equalsIgnoreCase(designation) ? "" : "readonly" %> />
            </td>
            <td>
                <input type="text" name="fname" value="<%= rs.getString("faculty_name") %>" required />
            </td>
            <td>
                <input type="text" name="fpass" value="<%= rs.getString("faculty_password") %>" required />
            </td>
            <td>
                <input type="text" name="fdep" value="<%= rs.getString("faculty_department") %>"
                       <%= "Admin".equalsIgnoreCase(designation) ? "" : "readonly" %> />
            </td>
            <td>
                <input type="submit" value="Update" />
            </td>
        </form>
    </tr>
<% } %>
</table>

<div class="back-button">
    <a href="hodHomePage.jsp">Back to Home</a>
</div>

</body>
</html>

