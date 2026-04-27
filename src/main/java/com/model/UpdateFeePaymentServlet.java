 package com.model;

import com.model.FeePaymentDAO;
import com.model.FeePayment;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/updateFee")
public class UpdateFeePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        try {
            FeePayment f = new FeePayment();
            f.setStudentID(Integer.parseInt(req.getParameter("studentID")));
            f.setStudentName(req.getParameter("studentName"));
            f.setAmount(Double.parseDouble(req.getParameter("amount")));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            f.setPaymentDate(sdf.parse(req.getParameter("paymentDate")));

            FeePaymentDAO dao = new FeePaymentDAO();
            boolean result = dao.updatePayment(f);

            res.getWriter().println(result ? "Updated Successfully" : "Update Failed");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}