 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Force HTTP if accessed via HTTPS
    String scheme = request.getScheme();
    if ("https".equalsIgnoreCase(scheme)) {
        StringBuffer url = request.getRequestURL();
        String httpUrl = "http" + url.substring(5);
        String query = request.getQueryString();
        if (query != null) httpUrl += "?" + query;
        response.sendRedirect(httpUrl);
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Payment | College Fee System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #F0F9FF 0%, #E0F2FE 50%, #BAE6FD 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            position: relative;
        }

        /* subtle floating bubbles effect */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: radial-gradient(rgba(59, 130, 246, 0.1) 1px, transparent 1px);
            background-size: 40px 40px;
            pointer-events: none;
        }

        .glass {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 2rem;
            padding: 2rem;
            box-shadow: 0 20px 35px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(59, 130, 246, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass:hover {
            transform: translateY(-4px);
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15);
        }

        h2 {
            font-size: 1.8rem;
            background: linear-gradient(120deg, #1E3A8A, #3B82F6, #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        /* Professional ID box – royal blue accent */
        .id-box {
            background: #EFF6FF;
            border-radius: 1rem;
            padding: 0.6rem 1rem;
            margin-bottom: 1.5rem;
            display: inline-flex;
            align-items: baseline;
            gap: 0.5rem;
            border-left: 4px solid #3B82F6;
            font-size: 0.95rem;
            color: #1E293B;
        }
        .id-box i { color: #3B82F6; }
        .id-box strong { color: #2563EB; font-size: 1.3rem; margin-left: 0.3rem; }

        label {
            display: block;
            color: #334155;
            margin: 1rem 0 0.3rem;
            font-weight: 600;
        }

        input, select {
            width: 100%;
            padding: 0.8rem 1rem;
            background: #F8FAFC;
            border: 1px solid #CBD5E1;
            border-radius: 1rem;
            color: #0F172A;
            font-size: 1rem;
            transition: all 0.2s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #3B82F6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        /* Remove default placeholder for date inputs */
        input[type="date"]::-webkit-input-placeholder { color: transparent; }
        input[type="date"]::-moz-placeholder { color: transparent; }
        input[type="date"]:-ms-input-placeholder { color: transparent; }
        input[type="date"]::placeholder { color: transparent; }

        /* Style the date picker icon */
        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.4);
            cursor: pointer;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            width: 100%;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 2rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 1rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.2);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before { left: 100%; }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(90deg, #1D4ED8, #2563EB);
        }

        .success, .error {
            margin-top: 1rem;
            padding: 0.8rem;
            border-radius: 1rem;
            background: #F8FAFC;
        }
        .success { border-left: 4px solid #10B981; color: #065F46; }
        .error { border-left: 4px solid #EF4444; color: #991B1B; }

        .back {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748B;
            text-decoration: none;
            margin-top: 1rem;
            transition: 0.2s;
        }
        .back:hover { color: #3B82F6; transform: translateX(-3px); }

        /* custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #F1F5F9;
        }
        ::-webkit-scrollbar-thumb {
            background: #3B82F6;
            border-radius: 10px;
        }
    </style>
    <script>
        window.onload = function() {
            fetch('GetNextIdServlet')
                .then(response => response.json())
                .then(data => {
                    if (data.nextId) {
                        document.getElementById('nextIdDisplay').innerText = data.nextId;
                        document.getElementById('nextIdHidden').value = data.nextId;
                    } else {
                        document.getElementById('nextIdDisplay').innerText = '?';
                    }
                })
                .catch(() => document.getElementById('nextIdDisplay').innerText = '?');
        };
    </script>
</head>
<body>
<div class="glass">
    <h2><i class="fas fa-plus-circle"></i> New Fee Payment</h2>

    <!-- Professional ID display -->
    <div class="id-box">
        <i class="fas fa-hashtag"></i> Payment ID:
        <strong id="nextIdDisplay">...</strong>
    </div>
    <input type="hidden" id="nextIdHidden" name="nextId" value="">

    <form action="AddFeePaymentServlet" method="post">
        <label><i class="fas fa-id-badge"></i> Student ID</label>
        <input type="number" name="studentId" placeholder="e.g., 106" required>

        <label><i class="fas fa-user-graduate"></i> Student Name</label>
        <input type="text" name="studentName" placeholder="Full name" required>

        <label><i class="fas fa-calendar-alt"></i> Payment Date <span style="color:#64748B;">(leave blank if pending)</span></label>
        <input type="date" name="paymentDate" placeholder="yyyy-mm-dd">

        <label><i class="fas fa-calendar-day"></i> Due Date</label>
        <input type="date" name="dueDate" required>

        <label><i class="fas fa-rupee-sign"></i> Amount (₹)</label>
        <input type="number" step="0.01" name="amount" placeholder="e.g., 25000" required>

        <label><i class="fas fa-tag"></i> Status</label>
        <select name="status">
            <option value="Paid">✅ Paid</option>
            <option value="Pending">⏳ Pending</option>
            <option value="Overdue">⚠️ Overdue</option>
        </select>

        <button type="submit" class="btn"><i class="fas fa-save"></i> Save Payment</button>
    </form>

    <% if(request.getAttribute("message") != null) { %>
        <div class="success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("message") %></div>
    <% } %>
    <% if(request.getAttribute("error") != null) { %>
        <div class="error"><i class="fas fa-exclamation-triangle"></i> <%= request.getAttribute("error") %></div>
    <% } %>

    <a href="index.jsp" class="back"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
</div>
</body>
</html>