<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.FeePaymentDAO, com.model.FeePayment" %>
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

    String idParam = request.getParameter("id");
    FeePayment payment = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            payment = new FeePaymentDAO().getPaymentById(Integer.parseInt(idParam));
        } catch (Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Payment | College Fee System</title>
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

        .glass-card {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 2rem;
            padding: 2rem;
            box-shadow: 0 20px 35px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(59, 130, 246, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-card:hover {
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

        .info-badge {
            background: #EFF6FF;
            border-radius: 2rem;
            padding: 0.5rem 1rem;
            display: inline-block;
            margin-bottom: 1.5rem;
            font-size: 0.85rem;
            color: #1E3A8A;
            border: 1px solid #BFDBFE;
            font-weight: 500;
        }

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

        .btn-group {
            display: flex;
            gap: 1rem;
            margin: 2rem 0 1rem;
            flex-wrap: wrap;
        }

        /* supercool professional buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            padding: 0.7rem 1.5rem;
            border-radius: 2rem;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.2);
            position: relative;
            overflow: hidden;
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

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(90deg, #1D4ED8, #2563EB);
        }

        .btn-success {
            background: linear-gradient(90deg, #059669, #10B981);
            box-shadow: 0 4px 8px rgba(5, 150, 105, 0.2);
        }
        .btn-success:hover {
            background: linear-gradient(90deg, #047857, #059669);
            box-shadow: 0 8px 20px rgba(5, 150, 105, 0.3);
        }

        .btn-secondary {
            background: #F1F5F9;
            color: #1E293B;
            box-shadow: none;
            border: 1px solid #CBD5E1;
        }
        .btn-secondary:hover {
            background: #E2E8F0;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .alert {
            margin-top: 1rem;
            padding: 0.8rem;
            border-radius: 1rem;
            background: #F8FAFC;
        }
        .alert-success {
            border-left: 4px solid #10B981;
            color: #065F46;
        }
        .alert-error {
            border-left: 4px solid #EF4444;
            color: #991B1B;
        }
        .alert-info {
            border-left: 4px solid #F59E0B;
            color: #78350F;
        }

        .load-section {
            background: #F8FAFC;
            border-radius: 1rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            display: flex;
            gap: 0.5rem;
            align-items: flex-end;
        }

        .load-section input { margin-bottom: 0; flex: 1; }
        .load-section .btn { margin: 0; padding: 0.7rem 1rem; }

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
</head>
<body>
<div class="glass-card">
    <h2><i class="fas fa-edit"></i> Update Fee Payment</h2>

    <!-- If no payment loaded, show a search box -->
    <% if (payment == null) { %>
        <div class="info-badge"><i class="fas fa-search"></i> Please enter Payment ID to edit</div>
        <form action="feepaymentupdate.jsp" method="get" class="load-section">
            <input type="number" name="id" placeholder="Payment ID" required>
            <button type="submit" class="btn btn-secondary"><i class="fas fa-arrow-right"></i> Load</button>
        </form>
        <% if (idParam != null && !idParam.trim().isEmpty()) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> No payment found with ID <%= idParam %>. Try again.</div>
        <% } %>
        <div class="btn-group">
            <a href="DisplayFeePaymentsServlet" class="btn btn-secondary"><i class="fas fa-table"></i> View All Payments</a>
            <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home"></i> Dashboard</a>
        </div>
    <% } else { %>
        <!-- Payment loaded: show editable form -->
        <div class="info-badge"><i class="fas fa-check-circle"></i> Editing Payment #<%= payment.getPaymentId() %> (Student: <%= payment.getStudentName() %>)</div>
        <form action="UpdateFeePaymentServlet" method="post">
            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">

            <label><i class="fas fa-id-badge"></i> Student ID</label>
            <input type="number" name="studentId" value="<%= payment.getStudentId() %>" required>

            <label><i class="fas fa-user-graduate"></i> Student Name</label>
            <input type="text" name="studentName" value="<%= payment.getStudentName() %>" required>

            <label><i class="fas fa-calendar-check"></i> Payment Date</label>
            <input type="date" name="paymentDate" value="<%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "" %>">

            <label><i class="fas fa-calendar-day"></i> Due Date</label>
            <input type="date" name="dueDate" value="<%= payment.getDueDate() %>" required>

            <label><i class="fas fa-rupee-sign"></i> Amount (₹)</label>
            <input type="number" step="0.01" name="amount" value="<%= payment.getAmount() %>" required>

            <label><i class="fas fa-tag"></i> Status</label>
            <select name="status">
                <option value="Paid" <%= "Paid".equals(payment.getStatus()) ? "selected" : "" %>>✅ Paid</option>
                <option value="Pending" <%= "Pending".equals(payment.getStatus()) ? "selected" : "" %>>⏳ Pending</option>
                <option value="Overdue" <%= "Overdue".equals(payment.getStatus()) ? "selected" : "" %>>⚠️ Overdue</option>
            </select>

            <div class="btn-group">
                <button type="submit" class="btn btn-success"><i class="fas fa-save"></i> Update Payment</button>
                <a href="feepaymentupdate.jsp" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
            </div>
        </form>

        <div class="btn-group">
            <a href="DisplayFeePaymentsServlet" class="btn btn-secondary"><i class="fas fa-eye"></i> View All</a>
            <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home"></i> Dashboard</a>
        </div>
    <% } %>

    <!-- Display any message from servlet (if forwarded) -->
    <% 
        String msg = (String) request.getAttribute("message");
        String err = (String) request.getAttribute("error");
        if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= msg %></div>
    <% } else if (err != null && !err.isEmpty()) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= err %></div>
    <% } %>
</div>
</body>
</html>