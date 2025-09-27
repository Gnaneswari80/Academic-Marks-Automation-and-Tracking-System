<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Promote Batch</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f4f9; padding:30px; }
        .container { max-width:650px; margin:auto; background:#fff; padding:20px; border-radius:10px; box-shadow:0 0 10px #ccc; }
        h2 { text-align:center; margin-bottom:20px; }
        label { display:block; margin:10px 0 5px; font-weight:bold; }
        select, input, button { width:100%; padding:8px; margin-bottom:15px; border-radius:6px; border:1px solid #ccc; }
        button { background:#28a745; color:white; font-weight:bold; cursor:pointer; }
        button:hover { background:#218838; }
    </style>
</head>
<body>
<div class="container">
<div class="back">
        <a href="hodHomePage.jsp">← Back to Home</a>
    </div>
    <%
    String dept = (String) session.getAttribute("hod_department");
%>
    <h2>Promote Batch</h2>
<div class="dept-name">Department: <%= dept %></div>
    <form method="post">
        <label>Batch Year</label>
        <input type="number" name="batchYear" required>

        <label>Current Year</label>
        <select name="year" required>
            <option value="1">1st Year</option>
            <option value="2">2nd Year</option>
            <option value="3">3rd Year</option>
            <option value="4">4th Year</option>
        </select>

        <label>Current Semester</label>
        <select name="sem" required>
            <option value="1">Sem 1</option>
            <option value="2">Sem 2</option>
        </select>

        <button type="submit">Promote</button>
    </form>

<%
    // HOD department from session
     dept = (String) session.getAttribute("hod_department");

    String batchYearStr = request.getParameter("batchYear");
    String yearStr = request.getParameter("year");
    String semStr = request.getParameter("sem");
    String popupMsg = null; // for JS alert

    if(dept != null && batchYearStr != null && yearStr != null && semStr != null){
        int batchYear = Integer.parseInt(batchYearStr);
        int year = Integer.parseInt(yearStr);
        int sem = Integer.parseInt(semStr);

        int maxYear = (dept.equalsIgnoreCase("MCA") || dept.equalsIgnoreCase("MBA") || dept.equalsIgnoreCase("MTech")) ? 2 : 4;

        if(year == maxYear && sem == 2){
            popupMsg = "❌ Cannot promote. " + dept + " batch " + batchYear + " is already in final year, semester 2.";
        } else {
            try(Connection con = DBConnection.getConnection()){
                int newSem = sem + 1;
                int newYear = year;

                if(newSem > 2){ // reset semester and increment year
                    newSem = 1;
                    newYear++;
                }

                String sql = "UPDATE studentdetails SET stu_sem=?, stu_year=? WHERE student_department=? AND stu_year=? AND stu_sem=? AND stu_batchyear=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, newSem);
                ps.setInt(2, newYear);
                ps.setString(3, dept);
                ps.setInt(4, year);
                ps.setInt(5, sem);
                ps.setInt(6, batchYear);

                int updated = ps.executeUpdate();

                if(updated > 0){
                    popupMsg = "✅ Successfully promoted " + dept + " batch " + batchYear + " from Year " + year + " Sem " + sem + " → Year " + newYear + " Sem " + newSem + ".";
                } else {
                    popupMsg = "⚠️ No students found for the given batch details.";
                }
            } catch(Exception e){
                popupMsg = "❌ Error: " + e.getMessage();
                e.printStackTrace();
            }
        }
    }

    if(popupMsg != null){
%>
<script>
    alert("<%=popupMsg%>");
    window.location.href="promoteBatch.jsp"; // reload page
</script>
<%
    }
%>
</div>
</body>
</html>

