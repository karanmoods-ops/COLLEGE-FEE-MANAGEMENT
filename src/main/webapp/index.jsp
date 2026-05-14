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
    <title>College Fee System | Dashboard</title>
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
            padding: 2rem 1rem;
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(0px);
            border-radius: 2rem;
            padding: 2rem;
            box-shadow: 0 20px 35px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(59, 130, 246, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .container:hover {
            transform: translateY(-4px);
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15);
        }

        /* header with blue gradient */
        h1 {
            font-size: 2.5rem;
            background: linear-gradient(120deg, #1E3A8A, #3B82F6, #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-block;
            margin-bottom: 0.5rem;
        }

        .sub {
            color: #4B5563;
            margin-bottom: 2rem;
            border-left: 4px solid #3B82F6;
            padding-left: 1rem;
            font-weight: 500;
        }

        /* professional button grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.8rem;
            margin: 2rem 0;
        }

        .card {
            background: white;
            border-radius: 1.5rem;
            padding: 1.8rem;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
        }

        .card:hover {
            transform: translateY(-8px);
            background: #FFFFFF;
            border-color: #3B82F6;
            box-shadow: 0 20px 30px -12px rgba(59, 130, 246, 0.25);
        }

        .card i {
            font-size: 2.5rem;
            color: #3B82F6;
            margin-bottom: 1rem;
        }

        .card h3 {
            color: #1E293B;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        /* supercool blue gradient buttons */
        .btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            border-radius: 2rem;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.25s ease;
            border: none;
            cursor: pointer;
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
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
            background: linear-gradient(90deg, #1D4ED8, #2563EB);
        }

        /* special button variants */
        .btn-danger {
            background: linear-gradient(90deg, #DC2626, #EF4444);
            box-shadow: 0 4px 8px rgba(220, 38, 38, 0.2);
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #B91C1C, #DC2626);
            box-shadow: 0 8px 20px rgba(220, 38, 38, 0.3);
        }

        .btn-success {
            background: linear-gradient(90deg, #059669, #10B981);
            box-shadow: 0 4px 8px rgba(5, 150, 105, 0.2);
        }
        .btn-success:hover {
            background: linear-gradient(90deg, #047857, #059669);
        }

        .btn-warning {
            background: linear-gradient(90deg, #D97706, #F59E0B);
            box-shadow: 0 4px 8px rgba(217, 119, 6, 0.2);
        }
        .btn-warning:hover {
            background: linear-gradient(90deg, #B45309, #D97706);
        }

        footer {
            text-align: center;
            margin-top: 2rem;
            color: #6B7280;
            font-size: 0.8rem;
        }

        /* custom scrollbar in blue */
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

        /* responsive */
        @media (max-width: 700px) {
            .container { padding: 1rem; }
            h1 { font-size: 1.8rem; }
            .grid { gap: 1rem; }
            .card { padding: 1rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fas fa-university"></i> College Fee Management</h1>
    <div class="sub"><i class="fas fa-calendar-alt"></i> <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></div>

    <div class="grid">
        <div class="card">
            <i class="fas fa-plus-circle"></i>
            <h3>Add Payment</h3>
            <a href="feepaymentadd.jsp" class="btn"><i class="fas fa-pen"></i> New Record</a>
        </div>
        <div class="card">
            <i class="fas fa-list-ul"></i>
            <h3>View All</h3>
            <a href="DisplayFeePaymentsServlet" class="btn"><i class="fas fa-table"></i> Display</a>
        </div>
        <div class="card">
            <i class="fas fa-edit"></i>
            <h3>Update</h3>
            <a href="feepaymentupdate.jsp" class="btn"><i class="fas fa-sync-alt"></i> Modify</a>
        </div>
        <div class="card">
            <i class="fas fa-trash-alt"></i>
            <h3>Delete</h3>
            <a href="feepaymentdelete.jsp" class="btn btn-danger"><i class="fas fa-times"></i> Remove</a>
        </div>
        <div class="card">
            <i class="fas fa-chart-line"></i>
            <h3>Reports</h3>
            <a href="ReportCriteriaServlet" class="btn btn-success"><i class="fas fa-file-alt"></i> Analytics</a>
        </div>
        <div class="card">
            <i class="fas fa-percent"></i>
            <h3>Late Fee Tool</h3>
            <a href="incrementor.jsp" class="btn btn-warning"><i class="fas fa-bolt"></i> Incrementor</a>
        </div>
    </div>

    <footer>
        <i class="fas fa-shield-alt"></i> Secure & Reliable | 
        <i class="fas fa-database"></i> MySQL Backend | 
        <i class="fas fa-chart-line"></i> Real‑time Updates
    </footer>
</div>
</body>
</html>