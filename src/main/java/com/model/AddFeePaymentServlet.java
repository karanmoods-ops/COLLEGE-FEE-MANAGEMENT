 package com.model;

import com.model.FeePaymentDAO;
import com.model.FeePayment;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/addFee")
public class AddFeePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        try {
            FeePayment f = new FeePayment();
            f.setStudentID(Integer.parseInt(req.getParameter("studentID")));
            f.setStudentName(req.getParameter("studentName"));
            f.setAmount(Double.parseDouble(req.getParameter("amount")));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            f.setPaymentDate(sdf.parse(req.getParameter("paymentDate")));

            FeePaymentDAO dao = new FeePaymentDAO();
            boolean result = dao.addPayment(f);

            if (result)
                res.sendRedirect("feepaymentdisplay.jsp");
            else
                res.getWriter().println("Insert Failed");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}