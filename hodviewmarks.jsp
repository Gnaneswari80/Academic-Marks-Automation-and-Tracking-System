<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Session variables
    String sem = (String) session.getAttribute("sem");
    String year = (String) session.getAttribute("year");
   
    String subject_name = (String) session.getAttribute("selectedSubjectName");
    String batchYear = (String) session.getAttribute("batchYear");
    String subjectId = (String) session.getAttribute("selectedSubjectId");
    String department = (String) session.getAttribute("hod_department");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Store levels for mid1 and mid2
    Map<String, String> mid1Levels = new HashMap<>();
    Map<String, String> mid2Levels = new HashMap<>();
 // Store COs for mid1 and mid2
 
    
    Map<String,String> mid1COs = new HashMap<String,String>();
       Map<String,String> mid2COs = new HashMap<String,String>();
    // Store MaX for mid1 and mid2    
Map<String, String> mid1Max = new HashMap<>();
       Map<String, String> mid2Max = new HashMap<>();
    		
    // Store marks for each student for mid1 and mid2
       Map<String, Map<String, String>> studentMid1Marks = new HashMap<>();
       Map<String, Map<String, String>> studentMid2Marks = new HashMap<>();
       
       // Store student details
       List<Map<String, String>> students = new ArrayList<>();	

		 
    		
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/midmarks_db", "root", "");

        String sql = "SELECT * FROM questionlevels WHERE qlBatchYear=? AND qlSubjectId=? AND qlSem=? AND qlYear=? AND qlMid IN ('mid1','mid2')";
        ps = con.prepareStatement(sql);
        ps.setString(1, batchYear);
        ps.setString(2, subjectId);
        ps.setString(3, sem);
        ps.setString(4, year);

        rs = ps.executeQuery();

        while (rs.next()) {
            String mid = rs.getString("qlMid"); // mid1 or mid2
            for (char q = '1'; q <= '6'; q++) {
            	for(char sub='a'; sub<='b'; sub++){
            	    String col = "level_" + q + sub;
            	    String val = rs.getString(col); 
            	    if (val == null || val.equals("0")) val = "";
            	    if (mid.equalsIgnoreCase("mid1")) {
            	        mid1Levels.put(col, val); }
            	    else if (mid.equalsIgnoreCase("mid2")) {
            	        mid2Levels.put(col, val); }
            	}

            }
        }
        
        
        /////////////////////
     

String sql2 = "SELECT * FROM questionco WHERE qcBatchYear=? AND qcSubjectId=? AND qcSem=? AND qcYear=? AND qcMid IN ('mid1','mid2')";
ps = con.prepareStatement(sql2);
ps.setString(1, batchYear);
ps.setString(2, subjectId);
ps.setString(3, sem);
ps.setString(4, year);

rs = ps.executeQuery();

while (rs.next()) {
    String mid = rs.getString("qcMid"); // mid1 or mid2

    // OBJ & ASS
    for (int i=1; i<=3; i++) {
        String col = "co_obj_" + i;
        String val = rs.getString(col);
        if (val == null || val=="0") val = "";
        if (mid.equalsIgnoreCase("mid1")) mid1COs.put(col, val);
        else mid2COs.put(col, val);
    }
    for (int i=1; i<=3; i++) {
        String col = "co_ass_" + i;
        String val = rs.getString(col);
        if (val == null || val=="0") val = "";
        if (mid.equalsIgnoreCase("mid1")) mid1COs.put(col, val);
        else mid2COs.put(col, val);
    }

    // Q1–Q6 (a–d)
    for (int q=1; q<=6; q++) {
        for (char sub='a'; sub<='b'; sub++) {
            String col = "co_" + q + sub;
            String val = rs.getString(col);
            if (val == null || val=="0") val = "";
            if (mid.equalsIgnoreCase("mid1")) mid1COs.put(col, val);
            else mid2COs.put(col, val);
        }
    }
}
///////////////////////////
 String sqlMax = "SELECT * FROM questionmaxmarks WHERE qmmBatchYear=? AND qmmSubjectId=? AND qmmSem=? AND qmmYear=? AND qmmMid IN ('mid1','mid2')";
    ps = con.prepareStatement(sqlMax);
    ps.setString(1, batchYear);
    ps.setString(2, subjectId);
    ps.setString(3, sem);
    ps.setString(4, year);

    rs = ps.executeQuery();

    while(rs.next()) {
        String mid = rs.getString("qmmMid"); // mid1 or mid2

        // OBJ max
        for(int i=1; i<=3; i++){
            String col = "max_obj_" + i;
            String val = rs.getString(col);
            if (val == null || val=="0") val = "";
            if(mid.equalsIgnoreCase("mid1")) mid1Max.put(col, val);
            else mid2Max.put(col, val);
        }

        // ASS max
        for(int i=1; i<=3; i++){
            String col = "max_ass_" + i;
            String val = rs.getString(col);
            if (val == null || val=="0") val = "";
            if(mid.equalsIgnoreCase("mid1")) mid1Max.put(col, val);
            else mid2Max.put(col, val);
        }

        // Questions max Q1–Q6 (a–d)
        for(int q=1; q<=6; q++){
            for(char sub='a'; sub<='d'; sub++){
                String col = "max_" + q + sub;
                String val = rs.getString(col);
                if (val == null || val=="0") val = "";
                if(mid.equalsIgnoreCase("mid1")) mid1Max.put(col, val);
                else mid2Max.put(col, val);
            }
        }
    }
    	
    //////////////////////////////////
      // 1️⃣ Fetch students
        String sqlStudents = "SELECT * FROM studentdetails WHERE student_department=? AND stu_sem=? AND stu_year=? AND stu_batchyear=?";
        ps = con.prepareStatement(sqlStudents);
        ps.setString(1, department);
        ps.setString(2, sem);
        ps.setString(3, year);
        ps.setString(4, batchYear);
        rs = ps.executeQuery();
        
        while(rs.next()) {
            Map<String,String> stu = new HashMap<>();
            stu.put("student_id", rs.getString("student_id"));
            stu.put("student_name", rs.getString("student_name"));
            students.add(stu);
        }
        rs.close();
        ps.close();
        
        // 2️⃣ Fetch marks from studentmidmarks
        String sqlMarks = "SELECT * FROM studentmidmarks WHERE smmDepartment=? AND student_sem=? AND student_year=? AND sbatch_year=? AND sub_id=?";
        ps = con.prepareStatement(sqlMarks);
        ps.setString(1, department);
        ps.setString(2, sem);
        ps.setString(3, year);
        ps.setString(4, batchYear);
        ps.setString(5, subjectId );
        rs = ps.executeQuery();
        
        while(rs.next()) {
            String sid = rs.getString("sid");
            String mid = rs.getString("smmMid"); // mid1 or mid2
            // fetch status from studentmidmarks
            String statusVal = rs.getString("status");
            if (statusVal == null) statusVal = "Present";

            Map<String,String> marks = new HashMap<>();
            // save status
            marks.put("status", statusVal);

            // OBJ1-3
            for(int i=1; i<=3; i++){
                String val = rs.getString("marks_obj_" + i);
                if(val == null || val.equals("-1")) val = "0";
                marks.put("obj" + i, val);
            }
            // ASS1-3
            for(int i=1; i<=3; i++) {
                String val = rs.getString("marks_ass_" + i);
                if(val == null || val.equals("-1")) val = "0";
                marks.put("ass" + i, val);
            }
            // Q1–6 (a–d)
            for(int q=1; q<=6; q++){
                for(char sub='a'; sub<='d'; sub++){
                    String col = "marks_" + q + sub;
                    String val = rs.getString(col);
                    if(val == null || val.equals("-1")) val = "0";
                    marks.put(col, val);
                }
            }

            if(mid.equalsIgnoreCase("mid1")) studentMid1Marks.put(sid, marks);
            else studentMid2Marks.put(sid, marks);
        }
    
    
    
    
    
        
    } catch (Exception e) {
        out.println("Error fetching question levels: " + e);
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
<html>
<head>
<style>
/* Info bar (Semester, Year, Subject etc.) */
.info-bar {
  width: 95%;
  max-width: 1200px;
  margin: 15px auto;
  background: linear-gradient(135deg, #e3f2fd, #ffffff);
  padding: 15px 25px;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 500;
  line-height: 1.8;
  color: #333;
  box-shadow: 0 3px 10px rgba(0,0,0,0.1);
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.info-bar b {
  color: #1976d2;
}

/* Table wrapper */
.table-container {
  overflow-x: auto;
  max-width: 100%;
  margin: 20px auto;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

/* Table */
table {
  border-collapse: collapse;
  width: 100%;
  font-size: 14px;
}

table th, table td {
  border: 1px solid #ddd;
  padding: 6px 8px;
  text-align: center;
}

table th {
  background: #1976d2;
  color: white;
  font-weight: 600;
  font-size: 13px;
}

table tr:nth-child(even) {
  background: #f9f9f9;
}

table tr:hover {
  background: #f1f7ff;
}
input[disabled] {
    background-color: #ffcccc; /* light red */
    color: #555;              /* optional, make text visible */
  }
  .absentMid {
    background-color: #ffcccc; /* light red for absent inputs */
}

.internal.absentInternal {
    background-color: #ffe6e6; /* subtle red for internal when both mids absent */
}

/* Input fields */
table input[type="text"] {
  width: 45px;
  padding: 3px;
  text-align: center;
  border: 1px solid #ccc;
  border-radius: 5px;
  transition: 0.2s;
}

table input[type="text"]:focus {
  outline: none;
  border-color: #1976d2;
  box-shadow: 0 0 5px rgba(25,118,210,0.4);
}

/* Highlight absent cells */
.absentMid {
  background: #ffcdd2;
  color: #c62828;
  font-weight: bold;
}

/* Totals & internal */
.midTotal, .internal {
  background: #e3f2fd;
  font-weight: bold;
  border: 1px solid #90caf9;
  border-radius: 5px;
  color: #0d47a1;
}

/* Buttons */
input[type="submit"], button {
  background: #1976d2;
  color: white;
  padding: 8px 18px;
  border: none;
  border-radius: 6px;
  font-size: 15px;
  cursor: pointer;
  transition: background 0.2s;
}

input[type="submit"]:hover, button:hover {
  background: #1565c0;
}

.back-btn {
  margin-left: 10px;
  background: #6c757d;
}

.back-btn:hover {
  background: #5a6268;
}
 body {
      transition: background 2s ease; /* Smooth transition */
      height: 100vh;
      margin: 0;
    }
        
</style>

 
</head>
<!-- Display session values -->
<!-- Display session values -->
<body>
<div class="info-bar">
    <b>Semester:</b> <%= sem %> 
    <b>Year:</b> <%= year %> 
    <b>Subject Name:</b> <%= subject_name %> 
    <b>Subject ID:</b> <%= subjectId %> 
    <b>Batch Year:</b> <%= batchYear %> 
    <b>Mid:</b> 1 & 2
</div>



<form action="hodsavemarks.jsp" method="post">


<div style="overflow-x:auto; max-width:200%; border:1px solid #ddd; padding:5px;    
        margin:10px auto; 
            background:#e3f2fd; padding:15px; border-radius:10px; 
            font-size:16px; line-height:1.8; color:#333; 
            box-shadow:0 2px 8px rgba(0,0,0,0.15)">
  
  <table border="1" cellspacing="0" cellpadding="5" style="border-collapse:collapse; min-width:1800px;">
    
    <!-- First header row -->
    <tr>
      <th rowspan="3">Questions</th>
      
      <!-- Mid-1 header -->
      <th colspan="18">Mid-1</th>
      
      <!-- Mid-2 header -->
      <th colspan="18"   >Mid-2</th>
     
      <!-- mid1 value -->
      <th rowspan="5">Mid1 mark</th>
      <!-- mid2 value -->
      <th rowspan="5">Mid2 mark</th>
       <!-- Internal mark -->
      <th rowspan="5">Internal mark</th>
      <!-- Extra CO columns -->
<th colspan="6" rowspan="4">CO Marks</th>
      
     
      
    </tr>

    <!-- Second header row -->
    <tr>
      <!-- Mid-1 OBJ/ASS + Questions -->
      <th colspan="3"    rowspan="3">OBJ1</th>
      <th colspan="3"   rowspan="3">ASS1</th>
      <th colspan="2">1</th>
      <th colspan="2">2</th>
      <th colspan="2">3</th>
      <th colspan="2">4</th>
      <th colspan="2">5</th>
      <th colspan="2">6</th>

      <!-- Mid-2 OBJ/ASS + Questions -->
      <th colspan="3" rowspan="3">OBJ1</th>
      <th colspan="3"   rowspan="3">ASS1</th>
      <th colspan="2">1</th>
      <th colspan="2">2</th>
      <th colspan="2">3</th>
      <th colspan="2">4</th>
      <th colspan="2">5</th>
      <th colspan="2">6</th>

    </tr>

    <!-- Third header row (a–d) -->
    <tr>
      
        <% for(int q=1; q<=6; q++){ %>
  <th>a</th><th>b</th>
<% } %>

    
    <% for(int q=1; q<=6; q++){ %>
  <th>a</th><th>b</th>
<% } %>

    </tr>

  <!-- Level row -->
<tr>
  <th>Level</th>
  <% for(int mid=1; mid<=2; mid++){ 
         Map<String,String> currentMap = (mid==1 ? mid1Levels : mid2Levels); 
         String midStr = "mid" + mid;
  %>
    <% for(int q=1; q<=6; q++){ 
         for(char sub='a'; sub<='b'; sub++){ 
            String col = "level_" + q + sub;
            String val = currentMap.getOrDefault(col, ""); // default 0 if null
    %>
      <td>
        <input type="text" name="mid<%=mid%>_q<%=q%><%=sub%>_level" value="<%= val %>" size="3">
      </td>
    <%   } // end sub
       } // end q
    %>
  <% } // end mid loop %>
  
  
  
  
  
</tr>


    <!-- CO row -->
 <!-- CO row -->
<tr>
  <th>CO</th>
  <% for (int mid = 1; mid <= 2; mid++) { 
         Map<String,String> currentCO = (mid == 1 ? mid1COs : mid2COs);
  %>
      <!-- OBJ1 (3 columns) -->
      <td><input type="text" name="mid<%=mid%>_obj1_co1" value="<%= currentCO.getOrDefault("co_obj_1","") %>" size="3"></td>
      <td><input type="text" name="mid<%=mid%>_obj1_co2" value="<%= currentCO.getOrDefault("co_obj_2","") %>" size="3"></td>
      <td><input type="text" name="mid<%=mid%>_obj1_co3" value="<%= currentCO.getOrDefault("co_obj_3","") %>" size="3"></td>

      <!-- ASS1 (3 columns) -->
      <td><input type="text" name="mid<%=mid%>_ass1_co1" value="<%= currentCO.getOrDefault("co_ass_1","") %>" size="3"></td>
      <td><input type="text" name="mid<%=mid%>_ass1_co2" value="<%= currentCO.getOrDefault("co_ass_2","") %>" size="3"></td>
      <td><input type="text" name="mid<%=mid%>_ass1_co3" value="<%= currentCO.getOrDefault("co_ass_3","") %>" size="3"></td>

      <!-- Q1–Q6 (a–d) -->
      <% for(int q=1; q<=6; q++){ %>
          <td><input type="text" name="mid<%=mid%>_q<%=q%>a_co" value="<%= currentCO.getOrDefault("co_"+q+"a","") %>" size="3"></td>
          <td><input type="text" name="mid<%=mid%>_q<%=q%>b_co" value="<%= currentCO.getOrDefault("co_"+q+"b","") %>" size="3"></td>
         
      <% } %>
      
      
      
      
  <% } %>
  
  
  <th>CO1</th><th>CO2</th><th>CO3</th><th>CO4</th><th>CO5</th><th>CO6</th>
  
</tr>





<!-- Max marks row (replace your current block) -->
<tr>
  <th>Max</th>
  <% for(int mid=1; mid<=2; mid++){ 
       Map<String,String> currentMax = (mid==1 ? mid1Max : mid2Max);
  %>
    <!-- OBJ (obj1,obj2,obj3) -->
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_obj1_max" data-q="mid<%=mid%>_obj1" value="<%= currentMax.getOrDefault("max_obj_1","") %>" size="3" min="0">
    </td>
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_obj2_max" data-q="mid<%=mid%>_obj2" value="<%= currentMax.getOrDefault("max_obj_2","") %>" size="3" min="0">
    </td>
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_obj3_max" data-q="mid<%=mid%>_obj3" value="<%= currentMax.getOrDefault("max_obj_3","") %>" size="3" min="0">
    </td>

    <!-- ASS (ass1,ass2,ass3) -->
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_ass1_max" data-q="mid<%=mid%>_ass1" value="<%= currentMax.getOrDefault("max_ass_1","") %>" size="3" min="0">
    </td>
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_ass2_max" data-q="mid<%=mid%>_ass2" value="<%= currentMax.getOrDefault("max_ass_2","") %>" size="3" min="0">
    </td>
    <td>
      <input type="number" class="maxMark" name="mid<%=mid%>_ass3_max" data-q="mid<%=mid%>_ass3" value="<%= currentMax.getOrDefault("max_ass_3","") %>" size="3" min="0">
    </td>

    <!-- Q1–Q6 (a–b) -->
    <% for(int q=1; q<=6; q++){ 
         for(char sub='a'; sub<='b'; sub++){
    %>
        <td>
          <input type="number" class="maxMark" 
                 name="mid<%=mid%>_q<%=q%><%=sub%>_max" 
                 data-q="mid<%=mid%>_q<%=q%><%=sub%>" 
                 value="<%= currentMax.getOrDefault("max_"+q+sub,"") %>" size="3" min="0">
        </td>
    <% } } %>

  <% } %>

  <!-- fixed summary column headers unchanged -->
  <th>30</th>
  <th>30</th>
  <th>40</th>

  <% for(int i=1; i<=6; i++){ %>
      <td><input type="number" name="co_max<%=i%>" value="40" size="3" min="0"></td>
  <% } %>
</tr>

<%
boolean includeOBJ = true; // all courses include OBJ1-3
String dept = (String) session.getAttribute("hod_department");
boolean isSpecialDept = dept.equalsIgnoreCase("MCA") || dept.equalsIgnoreCase("MBA") || dept.equalsIgnoreCase("MTech");

// Student marks rows
// Student marks rows
for(Map<String,String> student : students){ 
    String studentId = student.get("student_id");
    Map<String,String> marksMid1 = studentMid1Marks.getOrDefault(studentId, new HashMap<>());
    Map<String,String> marksMid2 = studentMid2Marks.getOrDefault(studentId, new HashMap<>());

    // mid-specific absence flags (derived from studentmidmarks.status)
    boolean mid1Absent = "absent".equalsIgnoreCase(marksMid1.getOrDefault("status","present"));
    boolean mid2Absent = "absent".equalsIgnoreCase(marksMid2.getOrDefault("status","present"));
    boolean totallyAbsent = mid1Absent && mid2Absent; // for CO inputs handling

%>
<tr>
    <td><%= studentId %></td>

    <% for(int mid=1; mid<=2; mid++){
         Map<String,String> marks = (mid==1 ? marksMid1 : marksMid2);
         Map<String,String> currentMax = (mid==1 ? mid1Max : mid2Max);
         boolean isAbsentThisMid = (mid==1 ? mid1Absent : mid2Absent);
    %>

        <!-- OBJ1-3 -->
        <% for(int i=1;i<=3;i++){ 
             String objVal = marks.getOrDefault("obj"+i,"0");
        %>
        <td>
          <input type="text"
                 name="mid<%=mid%>_obj<%=i%>_<%=studentId%>"
                 class="mid<%=mid%> <%= isAbsentThisMid ? "absentMid" : "" %>"
                 data-student="<%=studentId%>"
                 data-max='<%= currentMax.getOrDefault("max_obj_"+i,"0") %>'
                 value="<%= isAbsentThisMid ? "" : objVal %>"
                 <%= isAbsentThisMid ? "disabled" : "" %> >
          <% if(isAbsentThisMid){ %>
              <!-- submit status so hodsavemarks.jsp knows this mid is absent -->
              <input type="hidden" name="mid<%=mid%>_status_<%=studentId%>" value="Absent" />
          <% } %>
        </td>
        <% } %>

      <!-- ASS1-3 (always editable) -->
<% for(int i=1;i<=3;i++){ 
     String assVal = marks.getOrDefault("ass"+i,"0");
%>
<td>
  <input type="text" 
         name="mid<%=mid%>_ass<%=i%>_<%=studentId%>" 
         class="mid<%=mid%>" 
         data-student="<%=studentId%>"
         data-max='<%= currentMax.getOrDefault("max_ass_"+i,"0") %>'
         value="<%= assVal %>"  
         size="3">
</td>
<% } %>


        <!-- Q1-6 (a-b) -->
        <% for(int q=1;q<=6;q++){
             for(char sub='a'; sub<='b'; sub++){
                String col = "marks_" + q + sub;
                String val = marks.getOrDefault(col,"0");
        %>
        <td>
          <input type="text" 
                 name="mid<%=mid%>_q<%=q%><%=sub%>_<%=studentId%>" 
                 class="mid<%=mid%>" 
                 data-student="<%=studentId%>"
                 data-max='<%= currentMax.getOrDefault("max_"+q+sub,"0") %>'
                 value="<%= isAbsentThisMid ? "" : val %>" 
                 size="3"
                 <%= isAbsentThisMid ? "disabled" : "" %> >
        </td>
        <% }} %>

    <% } %>

    <!-- calculate totals only if mids are present -->
    <%
    Integer mid1Total = null;
    Integer mid2Total = null;

    if(!mid1Absent){
        int m1 = 0;
        if(includeOBJ) m1 += Math.max(0, Integer.parseInt(marksMid1.getOrDefault("obj1","0")));
        for (int[] pair : new int[][]{{1,2},{3,4},{5,6}}){
            m1 += Math.max(
                Math.max(0, Integer.parseInt(marksMid1.getOrDefault("marks_"+pair[0]+"a","0"))) + Math.max(0, Integer.parseInt(marksMid1.getOrDefault("marks_"+pair[0]+"b","0"))),
                Math.max(0, Integer.parseInt(marksMid1.getOrDefault("marks_"+pair[1]+"a","0"))) + Math.max(0, Integer.parseInt(marksMid1.getOrDefault("marks_"+pair[1]+"b","0")))
            );
        }
        mid1Total = m1;
    }

    if(!mid2Absent){
        int m2 = 0;
        if(includeOBJ) m2 += Math.max(0, Integer.parseInt(marksMid2.getOrDefault("obj1","0")));
        for (int[] pair : new int[][]{{1,2},{3,4},{5,6}}){
            m2 += Math.max(
                Math.max(0, Integer.parseInt(marksMid2.getOrDefault("marks_"+pair[0]+"a","0"))) + Math.max(0, Integer.parseInt(marksMid2.getOrDefault("marks_"+pair[0]+"b","0"))),
                Math.max(0, Integer.parseInt(marksMid2.getOrDefault("marks_"+pair[1]+"a","0"))) + Math.max(0, Integer.parseInt(marksMid2.getOrDefault("marks_"+pair[1]+"b","0")))
            );
        }
        mid2Total = m2;
    }

    // ASS contributions (0 if absent)
  // ASS1 always counts, even if student is absent in the mid
int Mid1Ass = Math.max(0, Integer.parseInt(marksMid1.getOrDefault("ass1","0")));
int Mid2Ass = Math.max(0, Integer.parseInt(marksMid2.getOrDefault("ass1","0")));


    // internal only if BOTH mids are present (adjust this logic if you want different rule)
    // Internal calculation
String internalDisplay;
if (mid1Absent && mid2Absent) {
    // both absent
    internalDisplay = "Absent";
} else if (mid1Absent) {
    // only mid1 absent → take mid2
    double baseMid2 = isSpecialDept ? mid2Total : (mid2Total/4 + mid2Total/2);
    internalDisplay = String.valueOf(baseMid2 * 0.8 + Mid2Ass+Mid1Ass);
} else if (mid2Absent) {
    // only mid2 absent → take mid1
   double baseMid1 = isSpecialDept ? mid1Total : (mid1Total/4 + mid1Total/2);
    internalDisplay = String.valueOf(baseMid1 * 0.8 + Mid1Ass+Mid2Ass);
} else {
    // both present → weighted 80-20
    double baseMid1 = isSpecialDept ? mid1Total : (mid1Total/4 + mid1Total/2);
    double baseMid2 = isSpecialDept ? mid2Total : (mid2Total/4 + mid2Total/2);
   double internalMark = (Math.max(baseMid1, baseMid2) * 0.8
                           + Math.min(baseMid1, baseMid2) * 0.2)
                           + Mid1Ass + Mid2Ass;
    internalDisplay = String.valueOf(internalMark);
}

    %>

    <!-- Mid1 & Mid2 totals -->
    <td><input type="text" class="midTotal" readonly value="<%= (mid1Absent ? "Absent" : (mid1Total == null ? "0" : mid1Total)) %>"></td>
    <td><input type="text" class="midTotal" readonly value="<%= (mid2Absent ? "Absent" : (mid2Total == null ? "0" : mid2Total)) %>"></td>

    <!-- Internal mark -->
    <td><input type="text" class="internal" readonly value="<%= internalDisplay %>"></td>

    <!-- CO1–CO6: disable only if totally absent (both mids absent) -->
    <% for(int i=1; i<=6; i++){ %>
        <td>
            <input type="text" name="co<%=i%>_<%=studentId%>" value="" size="3" <%= totallyAbsent ? "disabled" : "" %> >
        </td>
    <% } %>

</tr>
<% } // end for students %>

<script>
window.onload = function() {
    var dept = "<%= dept %>";
    var isSpecialDept = dept && (dept.toUpperCase() === "MCA" || dept.toUpperCase() === "MBA" || dept.toUpperCase() === "MTECH");

    // --- Recalculate one student's row ---
    function recalcRow(row) {
        var studentId = row.querySelector("td").textContent.trim();

        var mid1Obj = row.querySelector("input[name='mid1_obj1_" + studentId + "']");
        var mid2Obj = row.querySelector("input[name='mid2_obj1_" + studentId + "']");
        var mid1Absent = mid1Obj && mid1Obj.disabled;
        var mid2Absent = mid2Obj && mid2Obj.disabled;

        function val(name) {
            var el = row.querySelector("input[name='" + name + "']");
            if(!el || el.disabled || el.value.trim().toLowerCase() === "absent") return 0;
            var max = parseInt(el.getAttribute("data-max"));
            var v = parseInt(el.value) || 0;
            if(!isNaN(max) && v > max) v = max;
            if(v < 0) v = 0;
            return v;
        }

        var mid1Total = 0, mid2Total = 0;
        if(!mid1Absent) {
            mid1Total += val("mid1_obj1_" + studentId);
            for(var q=1;q<=6;q+=2){
                var s1 = val("mid1_q"+q+"a_"+studentId) + val("mid1_q"+q+"b_"+studentId);
                var s2 = val("mid1_q"+(q+1)+"a_"+studentId) + val("mid1_q"+(q+1)+"b_"+studentId);
                mid1Total += Math.max(s1,s2);
            }
        }
        if(!mid2Absent) {
            mid2Total += val("mid2_obj1_" + studentId);
            for(var q2=1;q2<=6;q2+=2){
                var t1 = val("mid2_q"+q2+"a_"+studentId) + val("mid2_q"+q2+"b_"+studentId);
                var t2 = val("mid2_q"+(q2+1)+"a_"+studentId) + val("mid2_q"+(q2+1)+"b_"+studentId);
                mid2Total += Math.max(t1,t2);
            }
        }

        var midInputs = row.querySelectorAll(".midTotal");
        if(midInputs.length >= 2){
            midInputs[0].value = mid1Absent ? "Absent" : mid1Total;
            midInputs[1].value = mid2Absent ? "Absent" : mid2Total;
        }

        var internalInput = row.querySelector(".internal");
        if(internalInput){
            var Mid1Ass = parseInt(row.querySelector("input[name='mid1_ass1_" + studentId + "']").value) || 0;
            var Mid2Ass = parseInt(row.querySelector("input[name='mid2_ass1_" + studentId + "']").value) || 0;
            var totalAss = Mid1Ass + Mid2Ass;

            if(mid1Absent && mid2Absent){
                internalInput.value = totalAss;
            } else if(mid1Absent){
                var baseMid2 = isSpecialDept ? mid2Total : (mid2Total/4)+Math.floor(mid2Total/2);
                internalInput.value = baseMid2*0.8 + totalAss;
            } else if(mid2Absent){
                var baseMid1 = isSpecialDept ? mid1Total : (mid1Total/4)+Math.floor(mid1Total/2);
                internalInput.value = baseMid1 *0.8+ totalAss;
            } else {
                var baseMid1 = isSpecialDept ? mid1Total : (mid1Total/4)+Math.floor(mid1Total/2);
                var baseMid2 = isSpecialDept ? mid2Total : (mid2Total/4)+Math.floor(mid2Total/2);
                internalInput.value = Math.max(baseMid1,baseMid2)*0.8 + Math.min(baseMid1,baseMid2)*0.2 + totalAss;
            }
        }
    }

    // --- Enforce max marks ---
    function enforceMax(inputEl){
        var max = parseInt(inputEl.getAttribute("data-max"));
        var v = parseInt(inputEl.value);
        if(isNaN(v)) v = 0;
        if(!isNaN(max) && v > max) inputEl.value = max;
        if(v < 0) inputEl.value = 0;
    }

    // --- Student input listeners with debounce auto-copy ---
    document.querySelectorAll("input[type='text']").forEach(function(input){
        if(input.classList.contains("maxMark")) return;

        let timer = null;
        input.addEventListener("input", function(){
            clearTimeout(timer);
            let that = this;
            timer = setTimeout(function(){
                enforceMax(that);
                var name = that.name;
                var val = that.value;
                var row = that.closest("tr");

                // Auto-copy obj1 -> obj2, obj3
                if(name.includes("_obj1_")){
                    ["obj2","obj3"].forEach(function(obj){
                        var target = row.querySelector("input[name='" + name.replace("obj1", obj) + "']");
                        if(target && !target.disabled){
                            target.value = val;
                            enforceMax(target);
                        }
                    });
                }

                // Auto-copy ass1 -> ass2, ass3
                if(name.includes("_ass1_")){
                    ["ass2","ass3"].forEach(function(as){
                        var target = row.querySelector("input[name='" + name.replace("ass1", as) + "']");
                        if(target && !target.disabled){
                            target.value = val;
                            enforceMax(target);
                        }
                    });
                }

                recalcRow(row);
            }, 200); // debounce delay
        });
    });

    // --- Max mark change handler (with auto-copy for obj/ass) ---
 // --- Max mark change handler (works for all max fields) ---
 // --- Max mark change handler (works for all max fields) ---
    document.querySelectorAll(".maxMark").forEach(function(maxInput){
        let timer = null;

        function applyMax() {
            var newMax = parseInt(maxInput.value) || 0;
            // prefer data-q (explicit), fallback to name based prefix
            var qKey = maxInput.dataset.q || maxInput.name.replace(/_max\d*$/,"");

            // Update all student inputs whose name starts with this prefix
            // e.g. qKey = "mid1_obj2" will match "mid1_obj2_<studentId>"
            document.querySelectorAll("input[name^='" + qKey + "_']").forEach(function(inp){
                inp.setAttribute("data-max", newMax);
                // also set HTML max attribute for browser UI (if input type=number)
                try { inp.max = newMax; } catch(e){}
                // Clamp existing value to newMax
                var cur = parseInt(inp.value) || 0;
                if(!isNaN(newMax) && cur > newMax) inp.value = newMax;
                // Run enforce & recalc for the row
                enforceMax(inp);
                var row = inp.closest("tr");
                if(row) recalcRow(row);
            });

            // If this is obj1_max or ass1_max, auto-copy to obj2/obj3 or ass2/ass3
            // (keeps your previous auto-copy behavior)
            if(qKey.match(/obj1$/)){
                var base = qKey.replace(/obj1$/,'');
                ["obj2","obj3"].forEach(function(obj){
                    var target = document.querySelector("input[name='" + (base + obj + "_max") + "']");
                    if(target){
                        if (target.value != newMax) {
                            target.value = newMax;
                            target.dispatchEvent(new Event("input"));
                        }
                    }
                });
            }
            if(qKey.match(/ass1$/)){
                var baseA = qKey.replace(/ass1$/,'');
                ["ass2","ass3"].forEach(function(as){
                    var target = document.querySelector("input[name='" + (baseA + as + "_max") + "']");
                    if(target){
                        if (target.value != newMax) {
                            target.value = newMax;
                            target.dispatchEvent(new Event("input"));
                        }
                    }
                });
            }
        }

        maxInput.addEventListener("input", function(){
            clearTimeout(timer);
            timer = setTimeout(applyMax, 150);
        });
        maxInput.addEventListener("change", applyMax);
        maxInput.addEventListener("blur", applyMax);
    });

};

</script>

    
  </table>

  
  
<br>
<input type="submit" value="Save/Update" />
</div>
</form>

<!-- Back button -->
<form action="hodsubjectselection.jsp" method="get" style="display:inline;">
    <input type="submit" value="Back" class="back-btn"/>
</form>

</body>


<script>
let gradients = [
    "linear-gradient(to right, #f8f9fa, #d1e7ff)",    // light grey -> soft blue
    "linear-gradient(to right, #ffe5b4, #ffcccb)",    // peach -> pink
    "linear-gradient(to right, #d4edda, #c3e6cb)",    // light green
    "linear-gradient(to right, #d1ecf1, #bee5eb)",    // aqua
    "linear-gradient(to right, #fceabb, #f8b500)",    // yellow -> orange
    "linear-gradient(to right, #fbc2eb, #a6c1ee)",    // pink -> purple
    "linear-gradient(to right, #ff9a9e, #fad0c4)",    // pink -> peach
      // blue -> light blue
    "linear-gradient(to right, #fddb92, #d1fdff)",    // gold -> light cyan
    "linear-gradient(to right, #ffecd2, #fcb69f)",    // soft peach -> light orange
    "linear-gradient(to right, #e0c3fc, #8ec5fc)",    // purple -> sky blue
    "linear-gradient(to right, #fef9d7, #f9d29d)",    // light yellow -> warm orange
    "linear-gradient(to right, #cfd9df, #e2ebf0)",    // grey -> soft blue
    "linear-gradient(to right, #fbc8d4, #9796f0)",    // pink -> purple gradient
    "linear-gradient(to right, #89f7fe, #66a6ff)",    // aqua -> blue
    "linear-gradient(to right, #f6d365, #fda085)",    // yellow -> coral
    "linear-gradient(to right, #e0c3fc, #8ec5fc)",    // lavender -> blue
    "linear-gradient(to right, #f9f7f7, #e0eafc)",    // white -> soft blue
    "linear-gradient(to right, #ffecd2, #fcb69f)",    // peach -> pink
    "linear-gradient(to right, #a8edea, #fed6e3)"     // mint -> light pink
];


let index = 0;

function changeBackground() {
    document.body.style.background = gradients[index];
    index = (index + 1) % gradients.length;
}

// Change background every 2 seconds
setInterval(changeBackground, 2000);

// Initial load
changeBackground();
</script>

</html>