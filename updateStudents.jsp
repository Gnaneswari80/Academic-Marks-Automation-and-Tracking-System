<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Update Student Details</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 30px; background-color: #f4f4f9; }
    h2 { text-align: center; color: #333; }
    form { display: flex; flex-wrap: wrap; gap: 15px; justify-content: center; margin-bottom: 30px; }
    label { font-weight: bold; }
    input[type="text"], select { padding: 6px; width: 150px; }
    input[type="submit"], button {
        padding: 8px 15px;
        background-color: #007bff;
        border: none;
        color: white;
        cursor: pointer;
        border-radius: 5px;
    }
    input.back-btn {
        background-color: #ff7f50;
        color: white;
        font-weight: bold;
    }
    input.back-btn:hover { background-color: #e0663e; }
    input[type="submit"]:hover, button:hover { background-color: #0056b3; }
    table { width: 100%; border-collapse: collapse; background-color: white; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
    th { background-color: #007bff; color: white; }
    tr:nth-child(even) { background-color: #f2f2f2; }
    .message { color: red; text-align: center; margin-top: 20px; }
    .delete-btn {
        background-color: #dc3545 !important;
    }
    .delete-btn:hover {
        background-color: #b02a37 !important;
    }
  </style>
  <script>
    function confirmDelete() {
      return confirm("Are you sure you want to delete this student?");
    }
  </script>
</head>
<body>

<h2>Update Student Details</h2>

<!-- Filter Form -->
<form method="post">
  <label>Batch Year:</label>
  <input type="text" name="batch_year" value="<%= request.getParameter("batch_year")==null?"":request.getParameter("batch_year") %>" required>
  <label>Year:</label>
  <select name="year" required>
    <option value="">Select</option>
    <% for(int y=1; y<=4; y++){ %>
      <option value="<%=y%>" <%= (""+y).equals(request.getParameter("year"))?"selected":"" %>><%=y%></option>
    <% } %>
  </select>
  <input type="submit" value="Fetch Students">
</form>

<%
String dept = (String) session.getAttribute("hod_department");
String role = (String) session.getAttribute("hod_designation"); // Admin or HOD
String batch = request.getParameter("batch_year");
String year = request.getParameter("year");
String popupMsg = null;

if(batch != null && year != null && dept != null){
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();

        // --- Handle update ---
        if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("update") != null){
            String originalSid = request.getParameter("original_sid");
            String sid = request.getParameter("sid");
            String sname = request.getParameter("sname");
            String syear = request.getParameter("syear");
            String sbatch = request.getParameter("sbatch");
            String sdept = request.getParameter("sdept");
            String ssem = request.getParameter("ssem");

            PreparedStatement ups = conn.prepareStatement(
                "UPDATE studentdetails SET student_id=?, student_name=?, stu_year=?, stu_sem=?, stu_batchyear=?, student_department=? WHERE student_id=?"
            );
            ups.setString(1, sid);
            ups.setString(2, sname);
            ups.setString(3, syear);
            ups.setString(4, ssem); // update semester
            ups.setString(5, sbatch);
            ups.setString(6, sdept);
            ups.setString(7, originalSid);
            int updated = ups.executeUpdate();
            if(updated>0){
                popupMsg = "Student ID " + sid + " updated successfully!";
            } else {
                popupMsg = "Update failed for Student ID " + sid;
            }
            ups.close();
        }

        // --- Handle delete ---
        if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete") != null){
            String sid = request.getParameter("original_sid");
            PreparedStatement dps = conn.prepareStatement("DELETE FROM studentdetails WHERE student_id=?");
            dps.setString(1, sid);
            int deleted = dps.executeUpdate();
            if(deleted>0){
                popupMsg = "Student ID " + sid + " deleted successfully!";
            } else {
                popupMsg = "Delete failed for Student ID " + sid;
            }
            dps.close();
        }

        // --- Fetch students ---
        String sql = "SELECT * FROM studentdetails WHERE stu_batchyear=? AND stu_year=? AND student_department=?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, batch);
        ps.setString(2, year);
        ps.setString(3, dept);
        rs = ps.executeQuery();

        boolean any = false;
%>
<table>
<tr>
  <th>ID</th><th>Name</th><th>Year</th><th>Semester</th><th>Batch</th><th>Dept</th><th>Action</th>
</tr>
<%
        while(rs.next()){
            any = true;
%>
<tr>
<form method="post">
  <td>
    <input type="hidden" name="original_sid" value="<%= rs.getString("student_id") %>">
    <input type="text" name="sid" value="<%= rs.getString("student_id") %>" <%= "Admin".equalsIgnoreCase(role) ? "" : "readonly" %>>
  </td>
  <td><input type="text" name="sname" value="<%= rs.getString("student_name") %>" required></td>
  <td><input type="text" name="syear" value="<%= rs.getString("stu_year") %>" required></td>
  <td>
    <select name="ssem" required>
      <option value="1" <%= "1".equals(rs.getString("stu_sem"))?"selected":"" %>>1</option>
      <option value="2" <%= "2".equals(rs.getString("stu_sem"))?"selected":"" %>>2</option>
    </select>
  </td>
  <td><input type="text" name="sbatch" value="<%= rs.getString("stu_batchyear") %>" required></td>
  <td><input type="text" name="sdept" value="<%= rs.getString("student_department") %>" <%= "Admin".equalsIgnoreCase(role) ? "" : "readonly" %>></td>
  <td>
    <input type="hidden" name="batch_year" value="<%= batch %>">
    <input type="hidden" name="year" value="<%= year %>">
    <input type="submit" name="update" value="Update">
    <input type="submit" name="delete" value="Delete" class="delete-btn" onclick="return confirmDelete();">
  </td>
</form>
</tr>
<%
        }
        if(!any){
%>
<tr><td colspan="7" class="message">No students found.</td></tr>
<%
        }
    } catch(Exception e){
        out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
    } finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){}
        try{ if(ps!=null) ps.close(); } catch(Exception e){}
        try{ if(conn!=null) conn.close(); } catch(Exception e){}
    }
%>
</table>
<% }
if(popupMsg != null){ %>
<script>
 alert("<%= popupMsg %>");
 window.location.href="updateStudents.jsp?batch_year=<%= batch %>&year=<%= year %>";
</script>
<% } %>

<br>
<form action="hodHomePage.jsp" method="get" style="text-align: center;">
  <input type="submit" value="Back to HOD Home" class="back-btn">
</form>

</body>
</html>

