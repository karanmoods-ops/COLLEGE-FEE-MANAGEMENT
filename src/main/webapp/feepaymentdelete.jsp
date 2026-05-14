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

    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String deleteId = request.getParameter("id");
    FeePaymentDAO dao = new FeePaymentDAO();
    String preloadName = "";

    // If deleteId is present but no confirm, try to load student name for confirmation
    if (deleteId != null && !deleteId.trim().isEmpty() && !"yes".equals(request.getParameter("confirm"))) {
        try {
            int id = Integer.parseInt(deleteId);
            FeePayment payment = dao.getPaymentById(id);
            if (payment != null) {
                preloadName = payment.getStudentName();
            }
        } catch (Exception e) { /* ignore */ }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Payment | College Fee System</title>
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

        .glass-card {
            max-width: 550px;
            width: 100%;
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
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .warning-icon {
            text-align: center;
            font-size: 3rem;
            color: #EF4444;
            margin-bottom: 0.5rem;
        }

        .info-text {
            color: #4B5563;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        label {
            display: block;
            color: #334155;
            margin: 1rem 0 0.3rem;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 0.8rem 1rem;
            background: #F8FAFC;
            border: 1px solid #CBD5E1;
            border-radius: 1rem;
            color: #0F172A;
            font-size: 1rem;
            transition: all 0.2s;
        }

        input:focus {
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
            justify-content: center;
        }

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
            transition: all 0.25s ease;
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

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(90deg, #1D4ED8, #2563EB);
        }

        .btn-danger {
            background: linear-gradient(90deg, #DC2626, #EF4444);
            box-shadow: 0 4px 8px rgba(220, 38, 38, 0.2);
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #B91C1C, #DC2626);
            box-shadow: 0 8px 20px rgba(220, 38, 38, 0.3);
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

        .confirm-box {
            background: #FFFBEB;
            border-radius: 1rem;
            padding: 1rem;
            margin: 1rem 0;
            text-align: center;
            border-left: 4px solid #F59E0B;
            color: #78350F;
        }

        hr {
            margin: 1rem 0;
            border-color: #E2E8F0;
        }

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
    <div class="warning-icon"><i class="fas fa-trash-alt"></i></div>
    <h2><i class="fas fa-skull-crosswalk"></i> Delete Payment Record</h2>
    <div class="info-text"><i class="fas fa-database"></i> Permanently remove a fee payment from the system.</div>

    <!-- Success message (from servlet) -->
    <% if (message != null && !message.isEmpty()) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <%= message %>
        </div>
        <div class="btn-group">
            <a href="DisplayFeePaymentsServlet" class="btn btn-secondary"><i class="fas fa-table"></i> View All</a>
            <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-home"></i> Dashboard</a>
            <a href="feepaymentdelete.jsp" class="btn btn-danger"><i class="fas fa-plus"></i> Delete Another</a>
        </div>

    <!-- Error message (from servlet) -->
    <% } else if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-triangle"></i> <%= error %>
        </div>
        <div class="btn-group">
            <a href="feepaymentdelete.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Try Again</a>
            <a href="DisplayFeePaymentsServlet" class="btn btn-secondary"><i class="fas fa-eye"></i> View Payments</a>
        </div>

    <!-- Confirmation box (when ID is provided but not yet confirmed) -->
    <% } else if (deleteId != null && !deleteId.trim().isEmpty() && !"yes".equals(request.getParameter("confirm"))) { 
        int id = Integer.parseInt(deleteId); %>
        <div class="confirm-box">
            <i class="fas fa-exclamation-circle" style="font-size: 2rem; color: #F59E0B;"></i>
            <p style="margin: 1rem 0; font-weight: bold;">Are you sure you want to delete Payment #<%= id %>?</p>
            <% if (!preloadName.isEmpty()) { %>
                <p>Student: <strong><%= preloadName %></strong></p>
            <% } %>
            <p style="color: #B45309; font-size: 0.8rem;">This action cannot be undone.</p>
            <div class="btn-group" style="justify-content: center;">
                <a href="DeleteFeePaymentServlet?id=<%= id %>&confirm=yes" class="btn btn-danger"><i class="fas fa-trash"></i> Yes, Delete</a>
                <a href="feepaymentdelete.jsp" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
            </div>
        </div>

    <!-- Default: show search form -->
    <% } else { %>
        <form action="DeleteFeePaymentServlet" method="get">
            <label><i class="fas fa-hashtag"></i> Payment ID to Delete</label>
            <input type="number" name="id" placeholder="Enter Payment ID" required autofocus>
            <div class="btn-group">
                <button type="submit" class="btn btn-danger"><i class="fas fa-search"></i> Find & Delete</button>
                <a href="DisplayFeePaymentsServlet" class="btn btn-secondary"><i class="fas fa-eye"></i> View All Payments</a>
            </div>
        </form>
        <hr>
        <div class="info-text" style="font-size: 0.8rem;">
            <i class="fas fa-info-circle"></i> Tip: Go to "View All Payments" to copy the Payment ID.
        </div>
    <% } %>
</div>
</body>
</html>