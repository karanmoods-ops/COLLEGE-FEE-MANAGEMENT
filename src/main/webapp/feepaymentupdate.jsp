 <!DOCTYPE html>
<html>
<head>
    <title>Update Fee</title>
</head>

<body style="margin:0; background:linear-gradient(135deg,#a18cd1,#fbc2eb); height:100vh; display:flex; justify-content:center; align-items:center;">

<div style="text-align:center; background:rgba(255,255,255,0.25); padding:40px; border-radius:20px;">

    <h2> Update Fee</h2>

    <form action="updateFee" method="post">

        <input name="studentID" placeholder="Student ID"
        style="padding:10px; margin:5px; width:200px;"><br>

        <input name="studentName" placeholder="Student Name"
        style="padding:10px; margin:5px; width:200px;"><br>

        <input name="amount" placeholder="Amount"
        style="padding:10px; margin:5px; width:200px;"><br>

        <input type="date" name="paymentDate"
        style="padding:10px; margin:5px; width:200px;"><br><br>

        <button type="submit"
        style="padding:10px 25px; background:#00b894; color:white; border:none; border-radius:20px;">
        Update
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