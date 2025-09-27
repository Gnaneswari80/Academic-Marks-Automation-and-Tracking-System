<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %> 
<%
    // Handle POST request: store values in session and redirect
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String sem = request.getParameter("sem");
        String year = request.getParameter("year");
        String batchYear = request.getParameter("batchYear");

        if (sem != null && year != null && batchYear != null &&
            !sem.isEmpty() && !year.isEmpty() && !batchYear.isEmpty()) {

            session.setAttribute("sem", sem);
            session.setAttribute("year", year);
            session.setAttribute("batchYear", batchYear);

            response.sendRedirect("hodsubjectselection.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Selection</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(-45deg, #6a11cb, #2575fc, #ff9a9e, #fad0c4);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        form {
            background: rgba(255,255,255,0.95);
            padding: 25px;
            border-radius: 10px;
            max-width: 350px;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #aaa;
            font-size: 14px;
        }

        input[type="submit"] {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background: #28a745;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        input[type="submit"]:hover {
            background: #218838;
        }

        button.back-btn {
            position: absolute;
            top: 10px;
            left: 10px;
            padding: 6px 12px;
            font-size: 14px;
            cursor: pointer;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        button.back-btn:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

    <button class="back-btn" onclick="window.location.href='hodHomePage.jsp'">&larr; Back</button>

    <form method="post" action="hodselection.jsp">
        <h2>Select Semester / Year / Batch</h2>

        <label for="sem">Semester:</label>
        <select name="sem" id="sem" required>
            <option value="">--Select Semester--</option>
            <% for(int i=1; i<=8; i++) { %>
                <option value="<%=i%>" <%= String.valueOf(i).equals(session.getAttribute("sem")) ? "selected" : "" %>><%= i %></option>
            <% } %>
        </select>

        <label for="year">Year:</label>
        <select name="year" id="year" required>
            <option value="">--Select Year--</option>
            <% for(int i=1; i<=4; i++) { %>
                <option value="<%=i%>" <%= String.valueOf(i).equals(session.getAttribute("year")) ? "selected" : "" %>><%= i %></option>
            <% } %>
        </select>

        <label for="batchYear">Batch Year:</label>
        <select name="batchYear" id="batchYear" required>
            <option value="">--Select Batch Year--</option>
            <%
                int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                String selectedBatchYear = (String)session.getAttribute("batchYear");
                for (int i = currentYear; i >= currentYear - 10; i--) {
            %>
                <option value="<%= i %>" <%= (selectedBatchYear != null && selectedBatchYear.equals(String.valueOf(i))) ? "selected" : "" %>><%= i %></option>
            <%
                }
            %>
        </select>

        <input type="submit" value="Submit">
    </form>

</body>
</html>
