 package com.model;

import com.model.FeePaymentDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteFee")
public class DeleteFeePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        int id = Integer.parseInt(req.getParameter("studentID"));

        FeePaymentDAO dao = new FeePaymentDAO();
        boolean result = dao.deletePayment(id);

        res.getWriter().println(result ? "Deleted Successfully" : "Delete Failed");
    }
}