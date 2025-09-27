<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>
<%
    if (session == null || session.getAttribute("hod_id") == null) {
        response.sendRedirect("hodLogin.jsp");
        return;
    }

    String hodName = (String) session.getAttribute("hod_name"); 
    String hodDept = (String) session.getAttribute("hod_department");
    String hodDesignation = (String) session.getAttribute("hod_designation");

    // Handle department selection update by admin
    String newSelectedDept = request.getParameter("select_department");
    session.setAttribute("hod_department", hodDept);
    if ("Admin".equalsIgnoreCase(hodDesignation) && newSelectedDept != null && !newSelectedDept.trim().isEmpty()) {
        hodDept = newSelectedDept;
        session.setAttribute("hod_department", hodDept);
    }

    // Fetch all distinct departments for the dropdown if admin
    
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HOD Home Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* Your existing CSS here */
        /* ... same as before ... */
        .admin-header, .hod-header {
            text-align: center;
            font-weight: bold;
            font-size: 24px;
            margin: 20px 0;
            letter-spacing: 2px;
            text-transform: uppercase;
        }
        .admin-header { color: #d9534f; }
        .hod-header { color: #0275d8; }
        .container { width: 90%; max-width: 1000px; margin: auto; }
        .subtitle { font-size: 18px; margin-bottom: 25px; color: #555; text-align: center; }
        .button-group {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            justify-items: center;
            margin-bottom: 40px;
        }
        .button-group form { margin: 0; width: 100%; display: flex; justify-content: center; }
        button {
            background-color: #5a9;
            border: none;
            color: white;
            padding: 12px 22px;
            font-size: 15px;
            border-radius: 5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.3s ease;
            white-space: nowrap;
            max-width: 250px;
            width: 100%;
            justify-content: center;
        }
        button i { font-size: 16px; }
        button:hover { background-color: #478060; }
        .remove-btn { background-color: #d9534f; }
        .remove-btn:hover { background-color: #b53733; }
        .update-btn { background-color: #0275d8; }
        .update-btn:hover { background-color: #025aa5; }
        .batch-btn { background-color: #f0ad4e; }
        .batch-btn:hover { background-color: #d48820; }
        .process-btn { background-color: #5bc0de; }
        .process-btn:hover { background-color: #31b0d5; }
        .add-btn { background-color: #5cb85c; }
        .add-btn:hover { background-color: #449d44; }
        .logout {
            text-align: right;
            margin-top: 30px;
            padding-right: 20px;
        }
        .logout a {
            background-color: transparent;
            border: 2px solid #333;
            color: #333;
            font-weight: bold;
            font-size: 16px;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .logout a i {
            font-size: 18px;
        }
        .logout a:hover {
            background-color: #d9534f;
            color: white;
            border-color: #d9534f;
        }
        /* Department select box style */
        .dept-select-form {
            text-align: center;
            margin-bottom: 30px;
        }
        .dept-select-form select {
            font-size: 16px;
            padding: 8px 12px;
            border-radius: 5px;
            border: 1px solid #ccc;
            min-width: 250px;
        }
        .dept-select-form input[type="submit"] {
            padding: 8px 16px;
            font-size: 16px;
            margin-left: 10px;
            cursor: pointer;
            border-radius: 5px;
            border: none;
            background-color: #0275d8;
            color: white;
            transition: background-color 0.3s ease;
        }
        .dept-select-form input[type="submit"]:hover {
            background-color: #025aa5;
        }
    </style>
</head>
<body  class="bubbles">

<!-- ADMIN or HOD uppercase, colored, centered -->
<div class="<%= "Admin".equalsIgnoreCase(hodDesignation) ? "admin-header" : "hod-header" %>">
    <%= ("Admin".equalsIgnoreCase(hodDesignation)) ? "ADMIN" : "HOD" %>
</div>

<div class="container">
    <h2 style="text-align:center;">Welcome, <%= (hodName != null ? hodName : "HOD") %></h2>

    <% if ("Admin".equalsIgnoreCase(hodDesignation)) { %>
        <!-- Department selection form for Admin -->
        
        <form class="dept-select-form" method="post" action="">
            <label for="select_department">Select Department:</label>
           <select name="select_department" id="select_department" required>
    <option value="">-- Select Department --</option>
    
    <!-- Static options -->
    <option value="MCA" <%= "MCA".equals(hodDept) ? "selected" : "" %>>MCA</option>
    <option value="MBA" <%= "MBA".equals(hodDept) ? "selected" : "" %>>MBA</option>
    <option value="MTECH" <%= "MTECH".equals(hodDept) ? "selected" : "" %>>MTECH</option>
     <option value="CSE" <%= "CSE".equals(hodDept) ? "selected" : "" %>>CSE</option>
      <option value="EEE" <%= "EEE".equals(hodDept) ? "selected" : "" %>>EEE</option>
    
    <!-- Dynamic options from faculty table -->
    
</select>

            <input type="submit" value="Change Department">
        </form>

        <div class="subtitle">Selected Department: <%= hodDept %></div>
    <% } else { %>
        <div class="subtitle">Department: <%= hodDept %></div>
    <% } %>

    <div class="button-group">
        <!-- Your buttons here (same as before) -->
        <form action="addFaculty.jsp" method="get">
            <button type="submit" class="add-btn"><i class="fas fa-user-plus"></i> Add Faculty</button>
        </form>
        <form action="removeFaculty.jsp" method="get">
            <button type="submit" class="remove-btn"><i class="fas fa-user-minus"></i> Remove Faculty</button>
        </form>
        <form action="updateFaculty.jsp" method="get">
            <button type="submit" class="update-btn"><i class="fas fa-user-edit"></i> View / Update Faculty</button>
        </form>
        <form action="addNewSubject.jsp" method="get">
            <button type="submit" class="add-btn"><i class="fas fa-book-medical"></i> Add New Subject</button>
        </form>
        <form action="removeSubject.jsp" method="get">
            <button type="submit" class="remove-btn"><i class="fas fa-book-dead"></i> Remove Subject</button>
        </form>
        <form action="updateSubjects.jsp" method="get">
            <button type="submit" class="update-btn"><i class="fas fa-book-open"></i> View / Update Subjects</button>
        </form>
        <form action="addNewBatch.jsp" method="get">
            <button type="submit" class="batch-btn"><i class="fas fa-layer-group"></i> Add New Batch</button>
        </form>
        <form action="hodselection.jsp" method="get">
            <button type="submit" class="process-btn"><i class="fas fa-cogs"></i> Internal Marks Generation</button>
        </form>
        <form action="updateStudents.jsp" method="get">
            <button type="submit" class="update-btn"><i class="fas fa-user-graduate"></i> View / Update Students</button>
        </form>
        <form action="promoteBatch.jsp" method="get">
            <button type="submit" class="update-btn"><i class="fas fa-user-graduate"></i> PromoteBatch</button>
        </form>

        <% if ("Admin".equalsIgnoreCase(hodDesignation)) { %>
            <form action="viewChangeHOD.jsp" method="get">
                <button type="submit" class="update-btn"><i class="fas fa-user-shield"></i> View / Change HOD</button>
            </form>
        <% } %>
    </div>

    <!-- Logout aligned right -->
    <div class="logout">
        <a href="index.jsp">
            <i class="fas fa-sign-out-alt"></i> 
            <% if ("Admin".equalsIgnoreCase(hodDesignation)) { %>
                admin Logout
            <% } else { %>
                hod Logout
            <% } %>
        </a>
    </div>
</div>

</body>
<style>


body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    /* Light animated gradient with more colors */
    background: linear-gradient(-45deg, 
        #d4c1ff,  /* lavender */
        #a0d8ef,  /* light blue */
        #ffe0b2,  /* soft peach */
        #fff3b0,  /* light yellow */
        #c1ffd7,  /* mint green */
        #ffd1dc   /* pale pink */
    );
    background-size: 600% 600%;
    animation: gradientBG 20s ease infinite;
    min-height: 100vh;
}

/* Gradient animation */
@keyframes gradientBG {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

</style>

</html>
