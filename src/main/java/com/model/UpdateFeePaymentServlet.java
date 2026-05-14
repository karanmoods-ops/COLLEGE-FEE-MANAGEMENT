package com.model;
import com.model.FeePaymentDAO;
import com.model.FeePayment;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/UpdateFeePaymentServlet")
public class UpdateFeePaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String studentName = request.getParameter("studentName");
        Date paymentDate = Date.valueOf(request.getParameter("paymentDate"));
        Date dueDate = Date.valueOf(request.getParameter("dueDate"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String status = request.getParameter("status");

        FeePayment payment = new FeePayment(paymentId, studentId, studentName, paymentDate, dueDate, amount, status);
        FeePaymentDAO dao = new FeePaymentDAO();
        dao.updatePayment(payment);
        response.sendRedirect("DisplayFeePaymentsServlet");
    }
}
 