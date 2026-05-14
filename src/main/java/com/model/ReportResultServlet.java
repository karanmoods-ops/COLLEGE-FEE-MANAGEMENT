package com.model;
import com.model.FeePaymentDAO;
import com.model.FeePayment;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/ReportResultServlet")
public class ReportResultServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        FeePaymentDAO dao = new FeePaymentDAO();
        
        try {
            if ("overdue".equals(reportType)) {
                List<FeePayment> overdueList = dao.getOverduePayments();
                request.setAttribute("reportData", overdueList);
                request.setAttribute("title", "🔴 Overdue Payments");
                request.setAttribute("hasData", true);
                
            } else if ("notPaid".equals(reportType)) {
                String start = request.getParameter("startDate");
                String end = request.getParameter("endDate");
                if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
                    request.setAttribute("error", "Please provide both start and end dates.");
                    request.getRequestDispatcher("report_form.jsp").forward(request, response);
                    return;
                }
                Date startDate = Date.valueOf(start);
                Date endDate = Date.valueOf(end);
                List<FeePayment> notPaidList = dao.getStudentsNotPaidInPeriod(startDate, endDate);
                request.setAttribute("reportData", notPaidList);
                request.setAttribute("title", "⚠️ Students not paid (" + start + " to " + end + ")");
                request.setAttribute("hasData", true);
                
            } else if ("collection".equals(reportType)) {
                String start = request.getParameter("startDate");
                String end = request.getParameter("endDate");
                if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
                    request.setAttribute("error", "Please provide both start and end dates.");
                    request.getRequestDispatcher("report_form.jsp").forward(request, response);
                    return;
                }
                Date startDate = Date.valueOf(start);
                Date endDate = Date.valueOf(end);
                double total = dao.getTotalCollection(startDate, endDate);
                request.setAttribute("totalCollection", total);
                request.setAttribute("title", "💰 Total Collection (" + start + " to " + end + ")");
                request.setAttribute("hasData", true);
            } else {
                request.setAttribute("error", "Invalid report type.");
                request.getRequestDispatcher("report_form.jsp").forward(request, response);
                return;
            }
            
            // Forward to the cool JSP
            request.getRequestDispatcher("report_result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("report_form.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("ReportCriteriaServlet");
    }
}