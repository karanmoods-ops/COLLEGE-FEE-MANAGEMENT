 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.FeePayment" %>
<%
    String scheme = request.getScheme();
    if ("https".equalsIgnoreCase(scheme)) {
        StringBuffer url = request.getRequestURL();
        String httpUrl = "http" + url.substring(5);
        String query = request.getQueryString();
        if (query != null) httpUrl += "?" + query;
        response.sendRedirect(httpUrl);
        return;
    }

    String title = (String) request.getAttribute("title");
    List<FeePayment> reportData = (List<FeePayment>) request.getAttribute("reportData");
    Double totalCollection = (Double) request.getAttribute("totalCollection");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fee Report | College System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

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

        .glass-panel {
            max-width: 1300px;
            margin: 0 auto;
            background: white;
            border-radius: 2rem;
            padding: 2rem;
            box-shadow: 0 20px 35px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(59, 130, 246, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-panel:hover {
            transform: translateY(-4px);
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15);
        }

        .report-header {
            background: linear-gradient(120deg, #1E3A8A, #3B82F6, #60A5FA);
            border-radius: 1.5rem;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 2rem;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .report-header h2 {
            color: white;
            font-size: 1.8rem;
            letter-spacing: -0.5px;
        }

        .report-header p {
            color: #E0E7FF;
        }

        .total-card {
            background: #F8FAFC;
            border-radius: 1.5rem;
            padding: 2rem;
            text-align: center;
            border: 1px solid #D1D5DB;
        }

        .total-amount {
            font-size: 3.2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #059669, #10B981);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
        }

        .chart-box {
            max-width: 500px;
            margin: 2rem auto;
            background: #F8FAFC;
            padding: 1rem;
            border-radius: 1rem;
            border: 1px solid #E2E8F0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 1.2rem;
            overflow: hidden;
            margin: 1rem 0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #E2E8F0;
            color: #1E293B;
        }

        th {
            background: #F8FAFC;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            color: #1E3A8A;
        }

        tr:hover td {
            background: #EFF6FF;
        }

        .status-pill {
            display: inline-block;
            padding: 0.25rem 0.9rem;
            border-radius: 2rem;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .status-overdue { background: #EF4444; color: white; }
        .status-paid { background: #10B981; color: white; }
        .status-pending { background: #F59E0B; color: white; }
        .status-notpaid { background: #6B7280; color: white; }  /* for "Not Paid" */

        .empty-state {
            text-align: center;
            padding: 3rem;
            background: #F8FAFC;
            border-radius: 1.5rem;
            color: #64748B;
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        /* supercool professional buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            padding: 0.7rem 1.6rem;
            border-radius: 2rem;
            text-decoration: none;
            font-weight: 600;
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

        .btn-print {
            background: #F1F5F9;
            color: #1E293B;
            box-shadow: none;
            border: 1px solid #CBD5E1;
        }
        .btn-print:hover {
            background: #E2E8F0;
            border-color: #3B82F6;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        @media (max-width: 700px) {
            .glass-panel { padding: 1rem; }
            th, td { padding: 0.5rem; font-size: 0.8rem; }
            .total-amount { font-size: 2rem; }
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
<div class="glass-panel">
    <div class="report-header">
        <h2><i class="fas fa-chart-line"></i> <%= title != null ? title : "Fee Analysis Report" %></h2>
        <p><i class="fas fa-calendar-alt"></i> <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %></p>
    </div>

    <%-- Total collection report --%>
    <% if (totalCollection != null) { %>
        <div class="total-card">
            <i class="fas fa-rupee-sign" style="font-size: 2.2rem; color: #059669;"></i>
            <div class="total-amount">₹ <%= String.format("%,.2f", totalCollection) %></div>
            <p style="margin-top: 0.5rem; color: #475569;"><i class="fas fa-clock"></i> Total collected in the selected range</p>
        </div>
        <div class="chart-box">
            <canvas id="collectionChart"></canvas>
        </div>
        <script>
            new Chart(document.getElementById('collectionChart'), {
                type: 'bar',
                data: {
                    labels: ['Total Collection'],
                    datasets: [{
                        label: 'Amount (₹)',
                        data: [<%= totalCollection %>],
                        backgroundColor: 'rgba(16, 185, 129, 0.7)',
                        borderColor: '#10B981',
                        borderWidth: 2,
                        borderRadius: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: { legend: { labels: { color: '#1E293B' } } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#E2E8F0' }, ticks: { color: '#1E293B' } },
                        x: { ticks: { color: '#1E293B' } }
                    }
                }
            });
        </script>
    <% } else if (reportData != null) { %>
        <% if (reportData.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-check-circle" style="font-size: 3rem; color: #10B981;"></i>
                <p style="margin-top: 1rem;">✨ No records match the criteria ✨</p>
            </div>
        <% } else { %>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fas fa-id-badge"></i> Student ID</th>
                            <th><i class="fas fa-user"></i> Student Name</th>
                            <th><i class="fas fa-calendar-day"></i> Due Date</th>
                            <th><i class="fas fa-money-bill-wave"></i> Amount</th>
                            <th><i class="fas fa-flag"></i> Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (FeePayment p : reportData) { 
                        String statusClass = "status-pending";
                        String statusText = p.getStatus() != null ? p.getStatus() : "Pending";
                        if ("Overdue".equalsIgnoreCase(statusText)) statusClass = "status-overdue";
                        else if ("Paid".equalsIgnoreCase(statusText)) statusClass = "status-paid";
                        else if ("Not Paid".equalsIgnoreCase(statusText)) statusClass = "status-notpaid";
                        else statusClass = "status-pending";
                    %>
                        <tr>
                            <td><%= p.getStudentId() %></td>
                            <td><%= p.getStudentName() %></td>
                            <td><%= p.getDueDate() %></td>
                            <td>₹ <%= String.format("%,.2f", p.getAmount()) %></td>
                            <td><span class="status-pill <%= statusClass %>"><%= statusText %></span></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <div style="margin-top: 1rem; text-align: right; color: #64748B;">
                <i class="fas fa-list"></i> Total records: <%= reportData.size() %>
            </div>
        <% } %>
    <% } else { %>
        <div class="empty-state">
            <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #F59E0B;"></i>
            <p style="margin-top: 1rem;">No report data. Please select a valid report type.</p>
        </div>
    <% } %>

    <div class="btn-group">
        <a href="ReportCriteriaServlet" class="btn"><i class="fas fa-chart-simple"></i> New Report</a>
        <a href="index.jsp" class="btn"><i class="fas fa-home"></i> Dashboard</a>
        <a href="javascript:window.print()" class="btn btn-print"><i class="fas fa-print"></i> Print</a>
    </div>
</div>
</body>
</html>