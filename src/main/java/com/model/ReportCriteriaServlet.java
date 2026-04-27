 package com.model;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/reportCriteria")
public class ReportCriteriaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String type = req.getParameter("type");

        if ("overdue".equals(type)) {
            res.getWriter().println("Overdue students report generated");
        } else if ("notpaid".equals(type)) {
            res.getWriter().println("Not paid students report generated");
        } else {
            res.getWriter().println("Total collection report generated");
        }
    }
}