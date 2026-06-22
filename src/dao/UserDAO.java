package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO {
    private final CustomerDAO customerDAO = new CustomerDAO();

    public List<User> getAllUsers() {
        List<User> usersList = new ArrayList<>();
        
        // Fetch all admins
        String sqlAdmin = "SELECT * FROM admin";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAdmin);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole("ADMIN");
                usersList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fetch all customers
        usersList.addAll(customerDAO.getAllCustomers());
        
        return usersList;
    }

    public User authenticate(String email, String password) {
        if (email == null || password == null) {
            return null;
        }
        
        // 1. Try to authenticate as Customer
        User customer = customerDAO.authenticateCustomer(email, password);
        if (customer != null) {
            return customer;
        }

        // 2. Try to authenticate as Admin
        String sqlAdmin = "SELECT * FROM admin WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAdmin)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole("ADMIN");
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean register(User user) {
        return customerDAO.registerCustomer(user);
    }

    public User getUserByEmail(String email) {
        if (email == null) return null;

        // Try Customer first
        User customer = customerDAO.getCustomerByEmail(email);
        if (customer != null) {
            return customer;
        }

        // Try Admin
        String sqlAdmin = "SELECT * FROM admin WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAdmin)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole("ADMIN");
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public User getUserById(int id) {
        // Try Customer first
        User customer = customerDAO.getCustomerById(id);
        if (customer != null) {
            return customer;
        }

        // Try Admin
        String sqlAdmin = "SELECT * FROM admin WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAdmin)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole("ADMIN");
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
