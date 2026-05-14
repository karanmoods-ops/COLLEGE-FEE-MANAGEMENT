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
    <title>Late Fee Incrementor | College Fee System</title>
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

        .warning-box {
            background: #FFFBEB;
            border-left: 4px solid #F59E0B;
            padding: 1rem;
            border-radius: 1rem;
            margin: 1rem 0;
            color: #78350F;
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

        /* supercool professional button */
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
            margin: 1rem 0 0.5rem;
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

        .msg {
            margin-top: 1rem;
            padding: 0.8rem;
            border-radius: 1rem;
            background: #F0FDF4;
            border-left: 4px solid #10B981;
            color: #065F46;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748B;
            text-decoration: none;
            margin-top: 1rem;
            transition: 0.2s;
        }

        .back-link:hover {
            color: #3B82F6;
            transform: translateX(-3px);
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
    <h2><i class="fas fa-bolt"></i> Late Fee Incrementor</h2>
    <div class="warning-box">
        <i class="fas fa-exclamation-triangle"></i> Increase overdue payments by a percentage.
    </div>
    <form action="IncrementFeeServlet" method="post">
        <label><i class="fas fa-percent"></i> Increment Percentage</label>
        <input type="number" step="0.1" name="percentage" placeholder="Enter percentage (e.g., 5)" required>
        <button type="submit" class="btn"><i class="fas fa-chart-line"></i> Apply Increment</button>
    </form>
    <% if(request.getAttribute("message") != null) { %>
        <div class="msg">
            <i class="fas fa-check-circle"></i> <%= request.getAttribute("message") %>
        </div>
    <% } %>
    <a href="index.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
</div>
</body>
</html>