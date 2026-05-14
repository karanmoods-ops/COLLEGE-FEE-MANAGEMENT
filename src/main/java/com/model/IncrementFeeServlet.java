package com.model;
import com.model.FeePaymentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/IncrementFeeServlet")
public class IncrementFeeServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String percentageParam = request.getParameter("percentage");
        String message;
        
        try {
            if (percentageParam == null || percentageParam.trim().isEmpty()) {
                message = "❌ Please enter a valid percentage.";
            } else {
                double percentage = Double.parseDouble(percentageParam);
                FeePaymentDAO dao = new FeePaymentDAO();
                boolean updated = dao.applyLateFeeIncrement(percentage);
                if (updated) {
                    message = "✅ Late fee increased by " + percentage + "% on all overdue payments.";
                } else {
                    message = "⚠️ No overdue payments found or update failed.";
                }
            }
        } catch (NumberFormatException e) {
            message = "❌ Invalid percentage. Please enter a number.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error applying increment: " + e.getMessage();
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("incrementor.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If accessed via GET, just show the incrementor form
        request.getRequestDispatcher("incrementor.jsp").forward(request, response);
    }
}