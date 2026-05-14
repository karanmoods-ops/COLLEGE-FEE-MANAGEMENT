 package com.model;
 import com.model.FeePaymentDAO;
 import com.model.FeePayment;
 import com.model.DBConnection;
 import javax.servlet.ServletException;
 import javax.servlet.annotation.WebServlet;
 import javax.servlet.http.HttpServlet;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;
 import java.io.IOException;
 import java.sql.Connection;
 import java.sql.PreparedStatement;
 import java.sql.ResultSet;
 import java.sql.SQLException;
 import java.sql.Date;

 @WebServlet("/AddFeePaymentServlet")
 public class AddFeePaymentServlet extends HttpServlet {

     // Helper method to find the smallest unused PaymentID (fills gaps)
     private int getNextAvailableID() throws SQLException {
         // Find the smallest missing ID
         String gapSql = "SELECT MIN(t1.PaymentID + 1) AS nextID " +
                         "FROM FeePayments t1 " +
                         "LEFT JOIN FeePayments t2 ON t1.PaymentID + 1 = t2.PaymentID " +
                         "WHERE t2.PaymentID IS NULL";
         
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(gapSql);
              ResultSet rs = ps.executeQuery()) {
             if (rs.next() && rs.getInt("nextID") > 0) {
                 return rs.getInt("nextID");
             }
         }
         
         // If no gap, get max ID + 1
         String maxSql = "SELECT IFNULL(MAX(PaymentID), 0) + 1 AS nextID FROM FeePayments";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(maxSql);
              ResultSet rs = ps.executeQuery()) {
             if (rs.next()) {
                 return rs.getInt("nextID");
             }
         }
         return 1; // fallback if table is empty
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
         
         String message = "";
         String error = "";
         
         try {
             // Retrieve form parameters
             int studentId = Integer.parseInt(request.getParameter("studentId"));
             String studentName = request.getParameter("studentName");
             
             Date paymentDate = null;
             String paymentDateStr = request.getParameter("paymentDate");
             if (paymentDateStr != null && !paymentDateStr.trim().isEmpty()) {
                 paymentDate = Date.valueOf(paymentDateStr);
             }
             
             Date dueDate = Date.valueOf(request.getParameter("dueDate"));
             double amount = Double.parseDouble(request.getParameter("amount"));
             String status = request.getParameter("status");
             
             // Get the next available ID (smallest unused)
             int nextId = getNextAvailableID();
             
             // Create payment object with the explicit ID
             FeePayment payment = new FeePayment(nextId, studentId, studentName, 
                                                 paymentDate, dueDate, amount, status);
             FeePaymentDAO dao = new FeePaymentDAO();
             
             boolean inserted = dao.addPaymentWithID(payment);
             
             if (inserted) {
                 message = "✅ Payment added successfully! Payment ID = " + nextId;
             } else {
                 error = "❌ Failed to add payment. Please try again.";
             }
         } catch (NumberFormatException e) {
             error = "❌ Invalid number format. Please check Student ID and Amount.";
         } catch (IllegalArgumentException e) {
             error = "❌ Invalid date format. Please use YYYY-MM-DD.";
         } catch (Exception e) {
             e.printStackTrace();
             error = "❌ An unexpected error occurred: " + e.getMessage();
         }
         
         request.setAttribute("message", message);
         request.setAttribute("error", error);
         request.getRequestDispatcher("feepaymentadd.jsp").forward(request, response);
     }
     
     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
         // Redirect GET requests to the add form
         response.sendRedirect("feepaymentadd.jsp");
     }
 }