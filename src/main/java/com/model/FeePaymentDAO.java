package com.model;

import java.sql.*;
import java.util.*;
import com.model.FeePayment;

public class FeePaymentDAO {

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/college_fee_db",
            "root",
            "password"
        );
    }

    public boolean addPayment(FeePayment f) {
        try {
            Connection con = getConnection();
            String sql = "INSERT INTO fee_payment(studentID, studentName, amount, paymentDate) VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, f.getStudentID());
            ps.setString(2, f.getStudentName());
            ps.setDouble(3, f.getAmount());
            ps.setDate(4, new java.sql.Date(f.getPaymentDate().getTime()));

            int i = ps.executeUpdate();
            return i > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePayment(FeePayment f) {
        try {
            Connection con = getConnection();
            String sql = "UPDATE fee_payment SET studentName=?, amount=?, paymentDate=? WHERE studentID=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, f.getStudentName());
            ps.setDouble(2, f.getAmount());
            ps.setDate(3, new java.sql.Date(f.getPaymentDate().getTime()));
            ps.setInt(4, f.getStudentID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePayment(int studentID) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM fee_payment WHERE studentID=?"
            );
            ps.setInt(1, studentID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<FeePayment> getAllPayments() {
        List<FeePayment> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM fee_payment");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                FeePayment f = new FeePayment();
                f.setStudentID(rs.getInt("studentID"));
                f.setStudentName(rs.getString("studentName"));
                f.setAmount(rs.getDouble("amount"));
                f.setPaymentDate(rs.getDate("paymentDate"));
                list.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
