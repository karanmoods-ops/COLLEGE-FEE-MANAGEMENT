package com.model;
import com.model.FeePaymentDAO;
import com.model.FeePayment;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DisplayFeePaymentsServlet")
public class DisplayFeePaymentsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        FeePaymentDAO dao = new FeePaymentDAO();
        List<FeePayment> payments = dao.getAllPayments();
        request.setAttribute("paymentList", payments);
        request.getRequestDispatcher("feepaymentdisplay.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simply forward to doGet
        doGet(request, response);
    }
}