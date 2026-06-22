package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Vehicle;

public class VehicleDAO {

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehiclesList = new ArrayList<>();
        String sql = "SELECT * FROM vehicle";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setId(rs.getInt("id"));
                v.setBrand(rs.getString("brand"));
                v.setModel(rs.getString("model"));
                v.setCategory(rs.getString("category"));
                v.setPricePerDay(rs.getDouble("price_per_day"));
                v.setTransmission(rs.getString("transmission"));
                v.setFuel(rs.getString("fuel"));
                v.setSeats(rs.getInt("seats"));
                v.setImage(rs.getString("image"));
                v.setRating(rs.getDouble("rating"));
                v.setDescription(rs.getString("description"));
                v.setStatus(rs.getString("status"));
                v.setYear(rs.getInt("year"));
                vehiclesList.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vehiclesList;
    }

    public Vehicle getVehicleById(int id) {
        String sql = "SELECT * FROM vehicle WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setId(rs.getInt("id"));
                    v.setBrand(rs.getString("brand"));
                    v.setModel(rs.getString("model"));
                    v.setCategory(rs.getString("category"));
                    v.setPricePerDay(rs.getDouble("price_per_day"));
                    v.setTransmission(rs.getString("transmission"));
                    v.setFuel(rs.getString("fuel"));
                    v.setSeats(rs.getInt("seats"));
                    v.setImage(rs.getString("image"));
                    v.setRating(rs.getDouble("rating"));
                    v.setDescription(rs.getString("description"));
                    v.setStatus(rs.getString("status"));
                    v.setYear(rs.getInt("year"));
                    return v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO vehicle (brand, model, category, price_per_day, transmission, fuel, seats, image, rating, description, status, year) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, vehicle.getBrand());
            ps.setString(2, vehicle.getModel());
            ps.setString(3, vehicle.getCategory());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setString(5, vehicle.getTransmission());
            ps.setString(6, vehicle.getFuel());
            ps.setInt(7, vehicle.getSeats());
            ps.setString(8, (vehicle.getImage() == null || vehicle.getImage().isEmpty()) ? "assets/images/car.jpg" : vehicle.getImage());
            ps.setDouble(9, (vehicle.getRating() == 0.0) ? 5.0 : vehicle.getRating());
            ps.setString(10, vehicle.getDescription());
            ps.setString(11, vehicle.getStatus());
            ps.setInt(12, vehicle.getYear());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        vehicle.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE vehicle SET brand = ?, model = ?, category = ?, price_per_day = ?, transmission = ?, fuel = ?, seats = ?, image = ?, rating = ?, description = ?, status = ?, year = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, vehicle.getBrand());
            ps.setString(2, vehicle.getModel());
            ps.setString(3, vehicle.getCategory());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setString(5, vehicle.getTransmission());
            ps.setString(6, vehicle.getFuel());
            ps.setInt(7, vehicle.getSeats());
            ps.setString(8, (vehicle.getImage() == null || vehicle.getImage().isEmpty()) ? "assets/images/car.jpg" : vehicle.getImage());
            ps.setDouble(9, (vehicle.getRating() == 0.0) ? 4.8 : vehicle.getRating());
            ps.setString(10, vehicle.getDescription());
            ps.setString(11, vehicle.getStatus());
            ps.setInt(12, vehicle.getYear());
            ps.setInt(13, vehicle.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteVehicle(int id) {
        String sql = "DELETE FROM vehicle WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
