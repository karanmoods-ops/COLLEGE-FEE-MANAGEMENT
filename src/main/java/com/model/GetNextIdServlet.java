package com.model;

import com.model.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/GetNextIdServlet")
public class GetNextIdServlet extends HttpServlet {

    private int getNextAvailableID() throws SQLException {
        // Find the smallest missing PaymentID
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
        // If no gap, return max ID + 1
        String maxSql = "SELECT IFNULL(MAX(PaymentID), 0) + 1 FROM FeePayments";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(maxSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int nextId = getNextAvailableID();
            out.print("{\"nextId\": " + nextId + "}");
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"error\": \"Unable to fetch next ID\"}");
        }
        out.flush();
    }
}
  