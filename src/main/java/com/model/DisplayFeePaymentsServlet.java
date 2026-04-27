 package com.model;

import com.model.FeePaymentDAO;
import com.model.FeePayment;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/displayFees")
public class DisplayFeePaymentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        FeePaymentDAO dao = new FeePaymentDAO();
        List<FeePayment> list = dao.getAllPayments();

        res.setContentType("text/html");

        for (FeePayment f : list) {
            res.getWriter().println(
                f.getStudentID() + " " +
                f.getStudentName() + " " +
                f.getAmount() + " " +
                f.getPaymentDate() + "<br>"
            );
        }
    }
}