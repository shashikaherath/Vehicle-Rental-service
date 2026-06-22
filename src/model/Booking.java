package model;

import java.io.Serializable;

public class Booking implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String userEmail;
    private int vehicleId;
    private String pickupDate;
    private String returnDate;
    private String pickupLocation;
    private double totalPrice;
    private String status; // "pending", "approved", "rejected", "active", "completed", "cancelled"

    public Booking() {
    }

    public Booking(int id, String userEmail, int vehicleId, String pickupDate, String returnDate, 
                   String pickupLocation, double totalPrice, String status) {
        this.id = id;
        this.userEmail = userEmail;
        this.vehicleId = vehicleId;
        this.pickupDate = pickupDate;
        this.returnDate = returnDate;
        this.pickupLocation = pickupLocation;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(String pickupDate) {
        this.pickupDate = pickupDate;
    }

    public String getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(String returnDate) {
        this.returnDate = returnDate;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
