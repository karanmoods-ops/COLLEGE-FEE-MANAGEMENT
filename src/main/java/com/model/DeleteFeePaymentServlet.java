package com.model; 
import com.model.FeePaymentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteFeePaymentServlet")
public class DeleteFeePaymentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String message = "";
        String error = "";
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                FeePaymentDAO dao = new FeePaymentDAO();
                boolean deleted = dao.deletePayment(id);
                
                // Important: dao.deletePayment(id) returns true if a row was deleted
                if (deleted) {
                    message = "✅ Payment ID " + id + " deleted successfully.";
                    System.out.println("Delete success for ID: " + id);
                } else {
                    error = "❌ Payment ID " + id + " not found or could not be deleted.";
                    System.out.println("Delete failed for ID: " + id);
                }
            } catch (NumberFormatException e) {
                error = "❌ Invalid Payment ID format.";
            } catch (Exception e) {
                e.printStackTrace();
                error = "❌ Error: " + e.getMessage();
            }
        } else {
            error = "❌ No Payment ID provided.";
        }
        
        // Store attributes and forward to JSP
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("feepaymentdelete.jsp").forward(request, response);
    }
}