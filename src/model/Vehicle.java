package model;

import java.io.Serializable;

public class Vehicle implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String brand;
    private String model;
    private String category; // "Car", "Van", "Motorbike", "Scooter", "Bus", "Lorry", "Truck", "Boat"
    private double pricePerDay;
    private String transmission; // "Automatic", "Manual"
    private String fuel; // "Petrol", "Diesel", "Electric", "Hybrid"
    private int seats;
    private String image; // file path e.g. "assets/images/car.jpg"
    private double rating;
    private String description;
    private String status; // "available", "rented", "maintenance"
    private int year;

    public Vehicle() {
    }

    public Vehicle(int id, String brand, String model, String category, double pricePerDay, 
                   String transmission, String fuel, int seats, String image, double rating, 
                   String description, String status, int year) {
        this.id = id;
        this.brand = brand;
        this.model = model;
        this.category = category;
        this.pricePerDay = pricePerDay;
        this.transmission = transmission;
        this.fuel = fuel;
        this.seats = seats;
        this.image = image;
        this.rating = rating;
        this.description = description;
        this.status = status;
        this.year = year;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public String getFuel() {
        return fuel;
    }

    public void setFuel(String fuel) {
        this.fuel = fuel;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }
}
