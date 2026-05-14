 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.FeePayment" %>
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

    List<FeePayment> list = (List<FeePayment>) request.getAttribute("paymentList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Payments | College Fee System</title>
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

        .glass {
            max-width: 1300px;
            margin: 0 auto;
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
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .badge {
            background: #EFF6FF;
            display: inline-block;
            padding: 0.3rem 1rem;
            border-radius: 2rem;
            margin-bottom: 1rem;
            color: #1E3A8A;
            border: 1px solid #BFDBFE;
            font-weight: 500;
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
            padding: 0.8rem;
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

        /* action buttons */
        .btn-sm {
            padding: 0.3rem 0.8rem;
            border-radius: 2rem;
            text-decoration: none;
            font-size: 0.8rem;
            margin: 0 3px;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: all 0.2s;
        }
        .btn-edit {
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
        }
        .btn-edit:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        }
        .btn-del {
            background: linear-gradient(90deg, #DC2626, #EF4444);
            color: white;
        }
        .btn-del:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.3);
        }

        .info {
            background: #FFFBEB;
            border-left: 4px solid #F59E0B;
            padding: 1rem;
            border-radius: 1rem;
            margin: 1rem 0;
            color: #78350F;
        }

        .info a {
            color: #2563EB;
            text-decoration: none;
            font-weight: 500;
        }
        .info a:hover {
            text-decoration: underline;
        }

        /* supercool professional buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            color: white;
            padding: 0.5rem 1.2rem;
            border-radius: 2rem;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.25s ease;
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.2);
            position: relative;
            overflow: hidden;
            margin-top: 0.5rem;
            margin-right: 1rem;
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

        .btn-add {
            background: linear-gradient(90deg, #059669, #10B981);
            box-shadow: 0 4px 8px rgba(5, 150, 105, 0.2);
        }
        .btn-add:hover {
            background: linear-gradient(90deg, #047857, #059669);
            box-shadow: 0 8px 20px rgba(5, 150, 105, 0.3);
        }

        /* scrollbar */
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

        @media (max-width: 768px) {
            th, td { padding: 0.5rem; font-size: 0.8rem; }
            .btn-sm { padding: 0.2rem 0.5rem; font-size: 0.7rem; }
        }
    </style>
</head>
<body>
<div class="glass">
    <h2><i class="fas fa-table-list"></i> All Fee Payments</h2>
    <div class="badge"><i class="fas fa-database"></i> Total: <%= (list != null) ? list.size() : 0 %></div>

    <% if (list == null || list.isEmpty()) { %>
        <div class="info">
            <i class="fas fa-info-circle"></i> No records found. <a href="feepaymentadd.jsp">Add one now</a>
        </div>
    <% } else { %>
        <div style="overflow-x: auto;">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-id-card"></i> Student ID</th>
                        <th><i class="fas fa-user"></i> Name</th>
                        <th><i class="fas fa-calendar-alt"></i> Payment Date</th>
                        <th><i class="fas fa-hourglass-end"></i> Due Date</th>
                        <th><i class="fas fa-money-bill-wave"></i> Amount</th>
                        <th><i class="fas fa-flag"></i> Status</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (FeePayment p : list) { 
                    String statusColor = "";
                    if ("Paid".equals(p.getStatus())) statusColor = "#10B981";
                    else if ("Overdue".equals(p.getStatus())) statusColor = "#EF4444";
                    else statusColor = "#F59E0B";
                %>
                    <tr>
                        <td><%= p.getPaymentId() %></td>
                        <td><%= p.getStudentId() %></td>
                        <td><%= p.getStudentName() %></td>
                        <td><%= (p.getPaymentDate() != null) ? p.getPaymentDate() : "—" %></td>
                        <td><%= p.getDueDate() %></td>
                        <td>₹ <%= String.format("%,.2f", p.getAmount()) %></td>
                        <td style="color: <%= statusColor %>; font-weight: bold;">
                            <%= p.getStatus() %>
                        </td>
                        <td>
                            <a href="feepaymentupdate.jsp?id=<%= p.getPaymentId() %>" class="btn-sm btn-edit"><i class="fas fa-edit"></i> Edit</a>
                            <a href="feepaymentdelete.jsp?id=<%= p.getPaymentId() %>" class="btn-sm btn-del" onclick="return confirm('Delete payment #<%= p.getPaymentId() %>? This action cannot be undone.');"><i class="fas fa-trash-alt"></i> Del</a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

    <div style="margin-top: 1.5rem;">
        <a href="index.jsp" class="btn"><i class="fas fa-home"></i> Dashboard</a>
        <a href="feepaymentadd.jsp" class="btn btn-add"><i class="fas fa-plus"></i> Add New Payment</a>
    </div>
</div>
</body>
</html>