package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Booking;

public class BookingDAO {

    public List<Booking> getAllBookings() {
        List<Booking> bookingsList = new ArrayList<>();
        String sql = "SELECT * FROM booking";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));
                b.setUserEmail(rs.getString("customer_email"));
                b.setVehicleId(rs.getInt("vehicle_id"));
                b.setPickupDate(rs.getString("pickup_date"));
                b.setReturnDate(rs.getString("return_date"));
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setStatus(rs.getString("status"));
                bookingsList.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingsList;
    }

    public List<Booking> getBookingsByUser(String email) {
        List<Booking> userBookings = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE customer_email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserEmail(rs.getString("customer_email"));
                    b.setVehicleId(rs.getInt("vehicle_id"));
                    b.setPickupDate(rs.getString("pickup_date"));
                    b.setReturnDate(rs.getString("return_date"));
                    b.setPickupLocation(rs.getString("pickup_location"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    userBookings.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userBookings;
    }

    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM booking WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserEmail(rs.getString("customer_email"));
                    b.setVehicleId(rs.getInt("vehicle_id"));
                    b.setPickupDate(rs.getString("pickup_date"));
                    b.setReturnDate(rs.getString("return_date"));
                    b.setPickupLocation(rs.getString("pickup_location"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addBooking(Booking booking) {
        String sql = "INSERT INTO booking (customer_email, vehicle_id, pickup_date, return_date, pickup_location, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, booking.getUserEmail());
            ps.setInt(2, booking.getVehicleId());
            ps.setString(3, booking.getPickupDate());
            ps.setString(4, booking.getReturnDate());
            ps.setString(5, booking.getPickupLocation());
            ps.setDouble(6, booking.getTotalPrice());
            ps.setString(7, (booking.getStatus() == null || booking.getStatus().isEmpty()) ? "pending" : booking.getStatus().toLowerCase());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        booking.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE booking SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.toLowerCase());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
