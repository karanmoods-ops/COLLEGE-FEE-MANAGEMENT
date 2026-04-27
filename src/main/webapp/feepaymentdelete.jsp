 <!DOCTYPE html>
<html>
<head>
    <title>Delete Fee</title>
</head>

<body style="margin:0; background:linear-gradient(135deg,#ff6b6b,#feca57); height:100vh; display:flex; justify-content:center; align-items:center;">

<div style="text-align:center; background:rgba(255,255,255,0.25); padding:40px; border-radius:20px;">

    <h2> Delete Fee</h2>

    <form action="deleteFee" method="post">

        <input name="studentID" placeholder="Student ID"
        style="padding:10px; margin:5px; width:200px;"><br><br>

        <button type="submit"
        style="padding:10px 25px; background:#d63031; color:white; border:none; border-radius:20px;">
        Delete
        </button>

    </form>

    <br>
    <a href="index.jsp"
       style="text-decoration:none; padding:10px 20px; background:#333; color:white; border-radius:20px;">
        Back
    </a>

</div>

</body>
</html>