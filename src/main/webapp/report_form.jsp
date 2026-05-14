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
    <title>Generate Reports | College Fee System</title>
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
            max-width: 650px;
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
            font-size: 2rem;
            background: linear-gradient(120deg, #1E3A8A, #3B82F6, #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .sub {
            color: #4B5563;
            border-left: 3px solid #3B82F6;
            padding-left: 1rem;
            margin-bottom: 2rem;
            font-size: 0.9rem;
        }

        .radio-group {
            background: #F8FAFC;
            border-radius: 1.2rem;
            padding: 1rem;
            margin: 1rem 0;
            transition: all 0.25s ease;
            cursor: pointer;
            border: 1px solid #E2E8F0;
        }

        .radio-group:hover {
            background: #EFF6FF;
            border-color: #3B82F6;
            transform: translateX(5px);
        }

        .radio-group input {
            margin-right: 1rem;
            transform: scale(1.2);
            accent-color: #3B82F6;
        }

        .radio-group label {
            color: #1E293B;
            font-weight: 500;
            font-size: 1.1rem;
            cursor: pointer;
        }

        .date-range {
            background: #F8FAFC;
            border-radius: 1.2rem;
            padding: 1.2rem;
            margin: 1rem 0;
            display: none;
            border-left: 4px solid #3B82F6;
        }

        .date-range label {
            display: block;
            color: #334155;
            margin: 0.5rem 0 0.2rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .date-range input {
            width: 100%;
            padding: 0.7rem;
            background: white;
            border: 1px solid #CBD5E1;
            border-radius: 1rem;
            color: #0F172A;
            font-size: 1rem;
            transition: 0.2s;
        }

        .date-range input:focus {
            outline: none;
            border-color: #3B82F6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        .help-text {
            font-size: 0.75rem;
            color: #64748B;
            margin-top: 0.5rem;
        }

        /* Supercool professional buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            padding: 0.9rem 1.8rem;
            border-radius: 2rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            font-size: 1rem;
            width: 100%;
            letter-spacing: 0.3px;
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

        .btn-secondary {
            background: #F1F5F9;
            color: #1E293B;
            box-shadow: none;
            margin-top: 0.5rem;
            text-decoration: none;
            text-align: center;
            border: 1px solid #CBD5E1;
        }

        .btn-secondary:hover {
            background: #E2E8F0;
            border-color: #3B82F6;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .error-msg {
            background: #FEF2F2;
            border-left: 4px solid #EF4444;
            padding: 0.8rem;
            border-radius: 1rem;
            color: #991B1B;
            margin-top: 1rem;
        }

        @media (max-width: 550px) {
            .glass-card { padding: 1.5rem; }
            h2 { font-size: 1.5rem; }
        }

        /* custom scroll */
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
        function toggleDateRange() {
            let radios = document.querySelectorAll('input[name="reportType"]');
            let dateDiv = document.getElementById('dateRangeDiv');
            let selected = null;
            for (let radio of radios) {
                if (radio.checked) {
                    selected = radio.value;
                    break;
                }
            }
            if (selected === 'notPaid' || selected === 'collection') {
                dateDiv.style.display = 'block';
            } else {
                dateDiv.style.display = 'none';
            }
        }

        function validateForm() {
            let radios = document.querySelectorAll('input[name="reportType"]');
            let selected = false;
            for (let radio of radios) {
                if (radio.checked) {
                    selected = true;
                    break;
                }
            }
            if (!selected) {
                alert("❌ Please select a report type.");
                return false;
            }
            let selectedVal = document.querySelector('input[name="reportType"]:checked').value;
            if (selectedVal === 'notPaid' || selectedVal === 'collection') {
                let start = document.getElementById('startDate').value;
                let end = document.getElementById('endDate').value;
                if (!start || !end) {
                    alert("⚠️ Please provide both start and end dates.");
                    return false;
                }
                if (new Date(start) > new Date(end)) {
                    alert("📅 Start date cannot be after end date.");
                    return false;
                }
            }
            return true;
        }
    </script>
</head>
<body>
<div class="glass-card">
    <h2><i class="fas fa-chart-pie"></i> Generate Reports</h2>
    <div class="sub"><i class="fas fa-database"></i> Choose a report type to analyse fee data</div>

    <form action="ReportResultServlet" method="post" onsubmit="return validateForm();">
        <div class="radio-group" onclick="this.querySelector('input').click();">
            <input type="radio" name="reportType" value="overdue" id="overdue" onclick="toggleDateRange()">
            <label for="overdue"><i class="fas fa-exclamation-triangle" style="color:#DC2626;"></i> 🔴 Students with Overdue Payments</label>
        </div>

        <div class="radio-group" onclick="this.querySelector('input').click();">
            <input type="radio" name="reportType" value="notPaid" id="notPaid" onclick="toggleDateRange()">
            <label for="notPaid"><i class="fas fa-clock" style="color:#D97706;"></i> ⚠️ Students Who Haven't Paid in a Period</label>
        </div>

        <div class="radio-group" onclick="this.querySelector('input').click();">
            <input type="radio" name="reportType" value="collection" id="collection" onclick="toggleDateRange()">
            <label for="collection"><i class="fas fa-coins" style="color:#059669;"></i> 💰 Total Fee Collection (Date Range)</label>
        </div>

        <div id="dateRangeDiv" class="date-range">
            <label><i class="fas fa-calendar-alt"></i> Start Date</label>
            <input type="date" id="startDate" name="startDate">
            <label><i class="fas fa-calendar-check"></i> End Date</label>
            <input type="date" id="endDate" name="endDate">
            <div class="help-text">
                <i class="fas fa-info-circle"></i> For "not paid": shows students with no payment between these dates.<br>
                For "collection": sums paid fees within the range.
            </div>
        </div>

        <button type="submit" class="btn"><i class="fas fa-chart-line"></i> Generate Report</button>
        <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </form>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
    <% } %>
</div>

<script>
    window.onload = function() {
        toggleDateRange();
    };
</script>
</body>
</html>