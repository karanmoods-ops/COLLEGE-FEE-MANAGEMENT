 package com.model;

import java.util.Date;

public class FeePayment {
    private int id;
    private int studentID;
    private String studentName;
    private double amount;
    private Date paymentDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentID() { return studentID; }
    public void setStudentID(int studentID) { this.studentID = studentID; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
}