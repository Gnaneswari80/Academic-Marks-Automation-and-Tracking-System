<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Session variables
    String sem = (String) session.getAttribute("sem");
    String year = (String) session.getAttribute("year");
    String subjectId = (String) session.getAttribute("subjectId");
    String subject_name = (String) session.getAttribute("subject_name");
    String batchYear = (String) session.getAttribute("batchYear");
    String mid = (String) session.getAttribute("mid");
    String department = (String) session.getAttribute("department");
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String[] levels = new String[12]; // q1a..q6d
    String[] coValues = new String[18];
    // 3 objectives + 3 assignments + 6 questions × 4 subparts = 30 cols
    String[] maxMarksValues = new String[18];  
    
 // store in list
    java.util.List<java.util.Map<String,String>> studentData = new ArrayList<>();
    
    
    boolean hasData = false;   
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/midmarks_db","root",""
        );

        
        ////LEVEl
        String sql = "SELECT * FROM questionlevels " +
                     "WHERE qlSem=? AND qlYear=? AND qlSubjectId=? AND qlBatchYear=? AND qlMid=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, sem);
        ps.setString(2, year);
        ps.setString(3, subjectId);
        ps.setString(4, batchYear);
        ps.setString(5, mid);

        rs = ps.executeQuery();

        if(rs.next()) {
            String[] cols = {
                "level_1a","level_1b",
                "level_2a","level_2b",
                "level_3a","level_3b",
                "level_4a","level_4b",
                "level_5a","level_5b",
                "level_6a","level_6b"
            };

            for(int i=0; i<cols.length; i++) {
                levels[i] = rs.getString(cols[i]);
            }
        }
        
        
        /////CO// store OBJ, ASS and Q1a...Q6d
    
        
        sql = "SELECT * FROM questionco " +
                     "WHERE qcSem=? AND qcYear=? AND qcSubjectId=? AND qcBatchYear=? AND qcMid=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, sem);
        ps.setString(2, year);
        ps.setString(3, subjectId);
        ps.setString(4, batchYear);
        ps.setString(5, mid);

        rs = ps.executeQuery();

        if(rs.next()) {
            String[] cols = {
                "co_obj_1","co_obj_2","co_obj_3",
                "co_ass_1","co_ass_2","co_ass_3",
                "co_1a","co_1b",
                "co_2a","co_2b",
                "co_3a","co_3b",
                "co_4a","co_4b",
                "co_5a","co_5b",
                "co_6a","co_6b"
            };

            for(int i=0; i<cols.length; i++) {
                coValues[i] = rs.getString(cols[i]);
            }
        }
        
  
        //////////////
        
        sql = "SELECT * FROM questionmaxmarks WHERE qmmSem=? AND qmmYear=? AND qmmSubjectId=? AND qmmBatchYear=? AND qmmMid=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, sem);
        ps.setString(2, year);
        ps.setString(3, subjectId);
        ps.setString(4, batchYear);
        ps.setString(5, mid);

        rs = ps.executeQuery();

        if(rs.next()) {
            int i = 0;
            maxMarksValues[i++] = rs.getString("max_obj_1");
            maxMarksValues[i++] = rs.getString("max_obj_2");
            maxMarksValues[i++] = rs.getString("max_obj_3");

            maxMarksValues[i++] = rs.getString("max_ass_1");
            maxMarksValues[i++] = rs.getString("max_ass_2");
            maxMarksValues[i++] = rs.getString("max_ass_3");

            maxMarksValues[i++] = rs.getString("max_1a");
            maxMarksValues[i++] = rs.getString("max_1b");
          // maxMarksValues[i++] = rs.getString("max_1c");
           // maxMarksValues[i++] = rs.getString("max_1d");

            maxMarksValues[i++] = rs.getString("max_2a");
            maxMarksValues[i++] = rs.getString("max_2b");
           // maxMarksValues[i++] = rs.getString("max_2c");
           // maxMarksValues[i++] = rs.getString("max_2d");

            maxMarksValues[i++] = rs.getString("max_3a");
            maxMarksValues[i++] = rs.getString("max_3b");
            //maxMarksValues[i++] = rs.getString("max_3c");
          ///  maxMarksValues[i++] = rs.getString("max_3d");

            maxMarksValues[i++] = rs.getString("max_4a");
            maxMarksValues[i++] = rs.getString("max_4b");
            //maxMarksValues[i++] = rs.getString("max_4c");
            //maxMarksValues[i++] = rs.getString("max_4d");

            maxMarksValues[i++] = rs.getString("max_5a");
            maxMarksValues[i++] = rs.getString("max_5b");
            //maxMarksValues[i++] = rs.getString("max_5c");
            //maxMarksValues[i++] = rs.getString("max_5d");

            maxMarksValues[i++] = rs.getString("max_6a");
            maxMarksValues[i++] = rs.getString("max_6b");
           //maxMarksValues[i++] = rs.getString("max_6c");
            //maxMarksValues[i++] = rs.getString("max_6d");
        }
        
    /////////////
    
    // Fetch students from studentdetails, LEFT JOIN with studentmidmarks
        sql = "SELECT sd.student_id, sd.student_name, " +
                "smm.* FROM studentdetails sd " +
                "LEFT JOIN studentmidmarks smm ON sd.student_id = smm.sid " +
                "AND smm.sub_id=? AND smm.student_sem=? AND smm.student_year=? " +
                "AND smm.sbatch_year=? AND smm.smmDepartment=? AND smm.smmMid=? " +
                "WHERE sd.stu_sem=? AND sd.stu_year=? AND sd.stu_batchyear=? AND sd.student_department=?";

   ps = con.prepareStatement(sql);
   ps.setString(1, subjectId);
   ps.setString(2, sem);
   ps.setString(3, year);
   ps.setString(4, batchYear);
   ps.setString(5, department);
   ps.setString(6, mid);
   ps.setString(7, sem);
   ps.setString(8, year);
   ps.setString(9, batchYear);
   ps.setString(10, department);

   rs = ps.executeQuery();
   while(rs.next()){
	   Map<String,String> stu = new HashMap<>();
	   stu.put("student_id", rs.getString("student_id"));
	   stu.put("student_name", rs.getString("student_name"));

	   String[] cols = { "marks_obj_1","marks_obj_2","marks_obj_3",
	                     "marks_ass_1","marks_ass_2","marks_ass_3",
	                     "marks_1a","marks_1b","marks_2a","marks_2b",
	                     "marks_3a","marks_3b","marks_4a","marks_4b",
	                     "marks_5a","marks_5b","marks_6a","marks_6b" };
	   for(String col: cols){
	       String value = rs.getString(col);
	       stu.put(col, (value != null && !value.trim().isEmpty()) ? value : "");
	   }

	   // ← Add this line
	   String status = rs.getString("status");
	   stu.put("status", status != null ? status : "present"); // default present

	   studentData.add(stu);
	}

        
     
        
        
        
      //try end  
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try { if(rs!=null) rs.close(); } catch(Exception ex) {}
        try { if(ps!=null) ps.close(); } catch(Exception ex) {}
        try { 
        	if(con!=null) con.close(); 
        	} catch(Exception ex) {}
    }

    // Store in request scope for use in JSP
    request.setAttribute("levels", levels);
    		//
    request.setAttribute("coValues", coValues);
    		//
    request.setAttribute("maxMarksValues", maxMarksValues);
		//
		
		request.setAttribute("maxMarksValues", maxMarksValues);
		//store in request
		request.setAttribute("studentData", studentData);
		
		
		        
    		
		

		
%>





<head>
<style>
    body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #f8f9fa, #e0f7fa); /* gradient background */
    margin: 0;
    padding: 20px;
}


    h2 {
        text-align: center;
        color: #333;
    }

    form {
        background: #fff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    table {
        border-collapse: collapse;
        width: 100%;
        min-width: 1200px; /* for scrolling */
        background: #fff;
    }

    th, td {
        border: 1px solid #ccc;
        text-align: center;
        padding: 6px;
        font-size: 14px;
    }

    th {
        background: #007bff;
        color: white;
        font-weight: 600;
    }

    tr:nth-child(even) {
        background: #f2f6fc;
    }

    tr:hover {
        background: #e8f0fe;
    }

    input[type="text"], input[type="number"] {
        width: 50px;
        padding: 4px;
        border: 1px solid #bbb;
        border-radius: 5px;
        text-align: center;
    }

    input[type="submit"] {
        margin-top: 20px;
        background: #28a745;
        color: white;
        border: none;
        padding: 10px 18px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 15px;
        font-weight: bold;
    }

    input[type="submit"]:hover {
        background: #218838;
    }

    /* Make table horizontally scrollable */
   .table-container {
    background: rgba(255,255,255,0.9); /* slightly transparent table background */
}

</style>
</head>





<form action="submitMarks.jsp" method="post">
<!-- Display session values -->
<div style="width:95%; max-width:1200px; margin:10px auto; 
            background:pink; padding:15px; border-radius:10px; 
            font-size:16px; line-height:1.8; color:#333; 
            box-shadow:0 2px 8px rgba(0,0,0,0.15);">
    <b>Semester:</b> <%= sem %> &nbsp;&nbsp; 
    <b>Year:</b> <%= year %> &nbsp;&nbsp; 
    <b>Subject ID:</b> <%= subjectId %> &nbsp;&nbsp; 
    <b>Subject Name:</b><%=subject_name %>&nbsp;&nbsp;
    <b>Batch Year:</b> <%= batchYear %> &nbsp;&nbsp; 
    <b>Mid:</b> <%= mid %>&nbsp;&nbsp;
    <b>Department:</b> <%= department %>
    
</div>
   <div class="table-container">
<table border="1" cellspacing="0" cellpadding="5">
  <tr>
    <!-- First row -->
    <th rowspan="2">Questions</th>
    <th rowspan="3" colspan="3">OBJ1</th>
    <th rowspan="3" colspan="3">ASS1</th>
    <th colspan="2">1</th>
<th colspan="2">2</th>
<th colspan="2">3</th>
<th colspan="2">4</th>
<th colspan="2">5</th>
<th colspan="2">6</th>
<th rowspan="4">MID MARK</th>

  </tr>

  <tr>
    <!-- Second row (sub-columns under each number) -->
    <th>a</th><th>b</th>
<th>a</th><th>b</th>
<th>a</th><th>b</th>
<th>a</th><th>b</th>
<th>a</th><th>b</th>
<th>a</th><th>b</th>

  </tr>

  <tr>
    <!-- Third row: editable Level row -->
    <th>Level</th>

 <% for(int i=0; i<levels.length; i++) { %>
      <td><input type="text" name="level_<%=i%>" value="<%= (levels[i] != null ? levels[i] : "") %>" size="3"></td>
  <% } %>
  </tr>

  <tr>
    <!-- Fourth row: editable CO row -->
   <th>CO</th>
   <% 
String[] coData = (String[]) request.getAttribute("coValues"); 
if(coData != null) {
    for(int i=0; i<coData.length; i++) { %>
        <td><input type="text" name="co_<%=i%>" value="<%= coData[i] != null ? coData[i] : "" %>" size="3"></td>
    <% }
} else { %>
    <td colspan="33">No CO data available</td>
<% } %>

  </tr>
<!-- Fifth row: Max Marks -->
  <!-- Max Marks row -->
<tr>
    <th>Max Mark</th>
    <%
        String[] maxMarks = (String[]) request.getAttribute("maxMarksValues");
        if(maxMarks != null) {
            for(int i=0; i<maxMarks.length; i++) {
    %>
        <td>
            <input type="number" id="max_<%=i%>" name="max_<%=i%>" value="<%= maxMarks[i] != null ? maxMarks[i] : "" %>" size="3">
        </td>
    <% 
            }
        } 
    %>
    
    <th>30</th>
    
</tr>

<%
List<Map<String,String>> students = (List<Map<String,String>>) request.getAttribute("studentData");
if(students != null && !students.isEmpty()){
    for(Map<String,String> stu : students){
        boolean isAbsent = "absent".equalsIgnoreCase(stu.get("status"));
%>
<tr style="<%= isAbsent ? "background:#f8d7da;" : "" %>">
    <td>
        <%=stu.get("student_id")%>
        <input type="hidden" name="sid_<%=stu.get("student_id")%>" value="<%=stu.get("student_id")%>">
        <input type="hidden" name="name_<%=stu.get("student_id")%>" value="<%=stu.get("student_name")%>">
    </td>

<% 
String[] cols = {
    "marks_obj_1","marks_obj_2","marks_obj_3",
    "marks_ass_1","marks_ass_2","marks_ass_3",
    "marks_1a","marks_1b",
    "marks_2a","marks_2b",
    "marks_3a","marks_3b",
    "marks_4a","marks_4b",
    "marks_5a","marks_5b",
    "marks_6a","marks_6b"
};

for(int j=0;j<cols.length;j++){
    String markVal = stu.get(cols[j]);

    // For absent students, OBJ and Q-fields show blank, ASS remains editable
    boolean readonly = isAbsent && !cols[j].startsWith("marks_ass");
    if(isAbsent && readonly) markVal = ""; // display empty
    else if(markVal == null || markVal.trim().isEmpty()) markVal = "0"; // normal students
%>
<td>
    <input type="number"
           id="<%=stu.get("student_id")+"_"+j%>"
           name="<%=stu.get("student_id")+"_"+cols[j]%>"
           value="<%= markVal %>"
           size="3"
           <%= readonly ? "readonly style='background:#f8d7da; color:red'" : "" %> >
</td>
<% } %>

<td>
    <input type="text"
           id="mid_<%=stu.get("student_id")%>"
           name="mid_<%=stu.get("student_id")%>"
           value="<%= isAbsent ? "absent" : "0" %>"
           size="3"
           readonly
           style="<%= isAbsent ? "background:#f8d7da; color:red; font-weight:bold" : "" %>">
</td>
</tr>
<% }} %>





</table>
<br>





</div>

<div style="text-align: right; margin-top:15px;">
    <a href="variouswaystoentermars.jsp">
        <button type="button" style="
            background:#6c757d; 
            color:white; 
            border:none; 
            padding:10px 18px; 
            border-radius:6px; 
            cursor:pointer; 
            font-size:15px;">
             Back
        </button>
    </a>
</div>

<br>
<input type="submit" value="Save Marks">
</form>

<script>
// ✅ Get number safely
function getNum(id) {
    let el = document.getElementById(id);
    return el ? parseFloat(el.value) || 0 : 0;
}

// ✅ Check if BTech
function isBTech(dept) {
    return dept !== "MCA" && dept !== "MBA" && dept !== "MTech";
}

// ✅ Enforce max/min
function enforceMax(inputId, maxId) {
    let el = document.getElementById(inputId);
    let maxEl = document.getElementById(maxId);

    if (el) {
        let val = parseFloat(el.value);
        if (isNaN(val)) {
            el.value = 0;
            return;
        }

        // 🔥 Always read latest max
        let max = maxEl ? parseFloat(maxEl.value) || 0 : 0;

        if (val > max) el.value = max;  // cap at current max
        if (val < 0) el.value = 0;      // no negatives
    }
}

// ✅ Calculate MID
function calculateMid(studentId, department) {
    const midInput = document.getElementById("mid_" + studentId);
    if (midInput && midInput.value.toLowerCase() === "absent") return; // skip if absent

    let obj1 = getNum(studentId + "_0");

    let g1 = Math.max(
        getNum(studentId + "_6") + getNum(studentId + "_7"),
        getNum(studentId + "_8") + getNum(studentId + "_9")
    );
    let g2 = Math.max(
        getNum(studentId + "_10") + getNum(studentId + "_11"),
        getNum(studentId + "_12") + getNum(studentId + "_13")
    );
    let g3 = Math.max(
        getNum(studentId + "_14") + getNum(studentId + "_15"),
        getNum(studentId + "_16") + getNum(studentId + "_17")
    );

    let total = g1 + g2 + g3;

    if (isBTech(department)) {
        total += obj1; // OBJ1 for BTech
        if (total > 40) total = 40;
        total = (total / 40) * 30; // scale to 30
    } else {
        if (total > 30) total = 30; // MCA/MBA/MTech max 30
    }

    if (midInput) midInput.value = total.toFixed(2);
}

// ✅ Attach listeners
window.addEventListener("DOMContentLoaded", function () {
    const students = [
        <% for(int i=0; i<students.size(); i++){ %>
            {id:"<%=students.get(i).get("student_id")%>", dept:"<%=department%>"}<%= i < students.size()-1 ? "," : "" %>
        <% } %>
    ];

    const fieldIndices = Array.from({ length: 18 }, (_, i) => i); // 0..17

    students.forEach(stu => {
        fieldIndices.forEach(i => {
            let fieldId = stu.id + "_" + i;
            let el = document.getElementById(fieldId);

            if (el) {
                el.addEventListener("input", function () {
                    enforceMax(fieldId, "max_" + i);
                    calculateMid(stu.id, stu.dept);
                });

                // Enforce on load
                enforceMax(fieldId, "max_" + i);
            }
        });

        // Initial MID calculation
        calculateMid(stu.id, stu.dept);
    });

    // 🔥 Also listen on MAX fields change
    fieldIndices.forEach(i => {
        let maxEl = document.getElementById("max_" + i);
        if (maxEl) {
            maxEl.addEventListener("input", function () {
                // re-check all students for this column when max changes
                students.forEach(stu => {
                    enforceMax(stu.id + "_" + i, "max_" + i);
                    calculateMid(stu.id, stu.dept);
                });
            });
        }
    });
});
</script>
<script>
const colors = [
	"linear-gradient(to right, #f8f9fa, #d0e7ff)",    // light grey -> soft blue
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
    "linear-gradient(to right, #a8edea, #fed6e3)"    // soft peach
];

let index = 0;

function changeBackground() {
    document.body.style.background = colors[index];
    index = (index + 1) % colors.length;
}

// Change background every 3 seconds
setInterval(changeBackground, 3000);
</script>

