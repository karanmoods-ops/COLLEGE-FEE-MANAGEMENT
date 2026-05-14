 package com.model;
  
 import com.model.FeePayment;
 import com.model.DBConnection;
 import java.sql.*;
 import java.util.ArrayList;
 import java.util.List;

 public class FeePaymentDAO {

     // ------------------- Standard Add (uses AUTO_INCREMENT) -------------------
     public boolean addPayment(FeePayment payment) {
         String sql = "INSERT INTO FeePayments (StudentID, StudentName, PaymentDate, DueDate, Amount, Status) VALUES (?,?,?,?,?,?)";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setInt(1, payment.getStudentId());
             ps.setString(2, payment.getStudentName());
             ps.setDate(3, payment.getPaymentDate());
             ps.setDate(4, payment.getDueDate());
             ps.setDouble(5, payment.getAmount());
             ps.setString(6, payment.getStatus());
             return ps.executeUpdate() > 0;
         } catch (SQLException e) {
             e.printStackTrace();
             return false;
         }
     }

     // ------------------- Add with explicit ID (fills gaps) -------------------
     public boolean addPaymentWithID(FeePayment payment) {
         Connection conn = null;
         boolean inserted = false;
         try {
             conn = DBConnection.getConnection();
             String sql = "INSERT INTO FeePayments (PaymentID, StudentID, StudentName, PaymentDate, DueDate, Amount, Status) VALUES (?,?,?,?,?,?,?)";
             try (PreparedStatement ps = conn.prepareStatement(sql)) {
                 ps.setInt(1, payment.getPaymentId());
                 ps.setInt(2, payment.getStudentId());
                 ps.setString(3, payment.getStudentName());
                 ps.setDate(4, payment.getPaymentDate());
                 ps.setDate(5, payment.getDueDate());
                 ps.setDouble(6, payment.getAmount());
                 ps.setString(7, payment.getStatus());
                 inserted = ps.executeUpdate() > 0;
             }
             
             if (inserted) {
                 try (Statement stmt = conn.createStatement()) {
                     ResultSet rs = stmt.executeQuery("SELECT MAX(PaymentID) + 1 FROM FeePayments");
                     if (rs.next()) {
                         int nextId = rs.getInt(1);
                         stmt.executeUpdate("ALTER TABLE FeePayments AUTO_INCREMENT = " + nextId);
                     }
                 } catch (SQLException resetEx) {
                     System.err.println("AUTO_INCREMENT reset failed after insert (ignored): " + resetEx.getMessage());
                 }
             }
             return inserted;
         } catch (SQLException e) {
             e.printStackTrace();
             return false;
         } finally {
             if (conn != null) {
                 try { conn.close(); } catch (SQLException ignore) {}
             }
         }
     }

     // ------------------- Update Payment -------------------
     public boolean updatePayment(FeePayment payment) {
         String sql = "UPDATE FeePayments SET StudentID=?, StudentName=?, PaymentDate=?, DueDate=?, Amount=?, Status=? WHERE PaymentID=?";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setInt(1, payment.getStudentId());
             ps.setString(2, payment.getStudentName());
             ps.setDate(3, payment.getPaymentDate());
             ps.setDate(4, payment.getDueDate());
             ps.setDouble(5, payment.getAmount());
             ps.setString(6, payment.getStatus());
             ps.setInt(7, payment.getPaymentId());
             return ps.executeUpdate() > 0;
         } catch (SQLException e) {
             e.printStackTrace();
             return false;
         }
     }

     // ------------------- Delete Payment (safe version with AUTO_INCREMENT reset) -------------------
     public boolean deletePayment(int paymentId) {
         Connection conn = null;
         boolean deleted = false;
         try {
             conn = DBConnection.getConnection();
             String sql = "DELETE FROM FeePayments WHERE PaymentID=?";
             try (PreparedStatement ps = conn.prepareStatement(sql)) {
                 ps.setInt(1, paymentId);
                 deleted = ps.executeUpdate() > 0;
             }
             
             if (deleted) {
                 try (Statement stmt = conn.createStatement()) {
                     ResultSet rs = stmt.executeQuery("SELECT IFNULL(MAX(PaymentID), 0) + 1 FROM FeePayments");
                     if (rs.next()) {
                         int nextId = rs.getInt(1);
                         stmt.executeUpdate("ALTER TABLE FeePayments AUTO_INCREMENT = " + nextId);
                     }
                 } catch (SQLException resetEx) {
                     System.err.println("AUTO_INCREMENT reset failed after delete (ignored): " + resetEx.getMessage());
                 }
             }
             return deleted;
         } catch (SQLException e) {
             e.printStackTrace();
             return false;
         } finally {
             if (conn != null) {
                 try { conn.close(); } catch (SQLException ignore) {}
             }
         }
     }

     // ------------------- Get Payment by ID -------------------
     public FeePayment getPaymentById(int id) {
         String sql = "SELECT * FROM FeePayments WHERE PaymentID=?";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setInt(1, id);
             ResultSet rs = ps.executeQuery();
             if (rs.next()) {
                 return new FeePayment(
                     rs.getInt("PaymentID"),
                     rs.getInt("StudentID"),
                     rs.getString("StudentName"),
                     rs.getDate("PaymentDate"),
                     rs.getDate("DueDate"),
                     rs.getDouble("Amount"),
                     rs.getString("Status")
                 );
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
         return null;
     }

     // ------------------- Get All Payments -------------------
     public List<FeePayment> getAllPayments() {
         List<FeePayment> list = new ArrayList<>();
         String sql = "SELECT * FROM FeePayments ORDER BY PaymentID";
         try (Connection conn = DBConnection.getConnection();
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery(sql)) {
             while (rs.next()) {
                 list.add(new FeePayment(
                     rs.getInt("PaymentID"),
                     rs.getInt("StudentID"),
                     rs.getString("StudentName"),
                     rs.getDate("PaymentDate"),
                     rs.getDate("DueDate"),
                     rs.getDouble("Amount"),
                     rs.getString("Status")
                 ));
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
         return list;
     }

     // ------------------- Overdue Payments -------------------
     public List<FeePayment> getOverduePayments() {
         List<FeePayment> list = new ArrayList<>();
         String sql = "SELECT * FROM FeePayments WHERE Status='Overdue' OR (DueDate < CURDATE() AND Status != 'Paid')";
         try (Connection conn = DBConnection.getConnection();
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery(sql)) {
             while (rs.next()) {
                 list.add(new FeePayment(
                     rs.getInt("PaymentID"),
                     rs.getInt("StudentID"),
                     rs.getString("StudentName"),
                     rs.getDate("PaymentDate"),
                     rs.getDate("DueDate"),
                     rs.getDouble("Amount"),
                     rs.getString("Status")
                 ));
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
         return list;
     }

     // ------------------- Students who have NEVER been marked as PAID -------------------
     // Date range parameters are kept for signature compatibility but are not used in the query
     public List<FeePayment> getStudentsNotPaidInPeriod(Date start, Date end) {
         List<FeePayment> list = new ArrayList<>();
         // Excludes any student who has ever had a record with Status = 'Paid'
         String sql = "SELECT DISTINCT StudentID, StudentName, DueDate, Amount " +
                      "FROM FeePayments " +
                      "WHERE StudentID NOT IN (SELECT DISTINCT StudentID FROM FeePayments WHERE Status = 'Paid')";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ResultSet rs = ps.executeQuery();
             while (rs.next()) {
                 FeePayment p = new FeePayment();
                 p.setStudentId(rs.getInt("StudentID"));
                 p.setStudentName(rs.getString("StudentName"));
                 p.setDueDate(rs.getDate("DueDate"));
                 p.setAmount(rs.getDouble("Amount"));
                 p.setStatus("Not Paid");
                 list.add(p);
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
         return list;
     }

     // ------------------- Total collection in a date range -------------------
     public double getTotalCollection(Date start, Date end) {
         double total = 0;
         String sql = "SELECT SUM(Amount) AS total FROM FeePayments WHERE PaymentDate BETWEEN ? AND ? AND Status='Paid'";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setDate(1, start);
             ps.setDate(2, end);
             ResultSet rs = ps.executeQuery();
             if (rs.next()) {
                 total = rs.getDouble("total");
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
         return total;
     }

     // ------------------- Late Fee Incrementor -------------------
     public boolean applyLateFeeIncrement(double percentage) {
         String sql = "UPDATE FeePayments SET Amount = Amount + (Amount * ? / 100), Status = 'Overdue' WHERE Status='Overdue' OR (DueDate < CURDATE() AND Status != 'Paid')";
         try (Connection conn = DBConnection.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setDouble(1, percentage);
             return ps.executeUpdate() > 0;
         } catch (SQLException e) {
             e.printStackTrace();
             return false;
         }
     }
 }