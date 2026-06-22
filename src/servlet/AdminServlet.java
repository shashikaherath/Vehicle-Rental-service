package servlet;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AdminServlet — handles admin-only vehicle CRUD operations:
 *   POST /vehicle?action=add        → add new vehicle
 *   POST /vehicle?action=update     → update existing vehicle
 *   POST /vehicle?action=delete     → delete vehicle
 */
public class AdminServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);

        // Admin-only guard
        User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
        if (admin == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":    handleAdd(req, resp, session);    break;
            case "update": handleUpdate(req, resp, session); break;
            case "delete": handleDelete(req, resp, session); break;
            default:
                resp.sendRedirect("admin/vehicles.jsp");
        }
    }

    // ── ADD ────────────────────────────────────────────────────────────────────
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            Vehicle v = buildVehicleFromRequest(req, 0);
            vehicleDAO.addVehicle(v);
            session.setAttribute("successMsg", "Vehicle '" + v.getBrand() + " " + v.getModel() + "' added successfully!");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Failed to add vehicle: " + e.getMessage());
        }
        resp.sendRedirect("admin/vehicles.jsp");
    }

    // ── UPDATE ─────────────────────────────────────────────────────────────────
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            String idParam = req.getParameter("vehicleId");
            int id = Integer.parseInt(idParam);
            Vehicle existing = vehicleDAO.getVehicleById(id);
            if (existing == null) {
                session.setAttribute("errorMsg", "Vehicle not found.");
                resp.sendRedirect("admin/vehicles.jsp");
                return;
            }
            Vehicle v = buildVehicleFromRequest(req, id);
            vehicleDAO.updateVehicle(v);
            session.setAttribute("successMsg", "Vehicle updated successfully.");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Failed to update vehicle: " + e.getMessage());
        }
        resp.sendRedirect("admin/vehicles.jsp");
    }

    // ── DELETE ─────────────────────────────────────────────────────────────────
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("vehicleId"));
            boolean deleted = vehicleDAO.deleteVehicle(id);
            if (deleted) {
                session.setAttribute("successMsg", "Vehicle #" + id + " deleted successfully.");
            } else {
                session.setAttribute("errorMsg", "Vehicle not found or already deleted.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Error deleting vehicle: " + e.getMessage());
        }
        resp.sendRedirect("admin/vehicles.jsp");
    }

    // ── Helper ─────────────────────────────────────────────────────────────────
    private Vehicle buildVehicleFromRequest(HttpServletRequest req, int id) {
        Vehicle v = new Vehicle();
        v.setId(id);
        v.setBrand(safe(req.getParameter("brand")));
        v.setModel(safe(req.getParameter("model")));
        v.setCategory(safe(req.getParameter("category")));
        v.setTransmission(safe(req.getParameter("transmission")));
        v.setFuel(safe(req.getParameter("fuel")));
        v.setStatus(safe(req.getParameter("status")));
        v.setDescription(safe(req.getParameter("description")));
        v.setImage(safe(req.getParameter("image")));

        String priceStr = req.getParameter("pricePerDay");
        v.setPricePerDay(priceStr != null && !priceStr.isEmpty() ? Double.parseDouble(priceStr) : 0.0);

        String ratingStr = req.getParameter("rating");
        v.setRating(ratingStr != null && !ratingStr.isEmpty() ? Double.parseDouble(ratingStr) : 5.0);

        String seatsStr = req.getParameter("seats");
        v.setSeats(seatsStr != null && !seatsStr.isEmpty() ? Integer.parseInt(seatsStr) : 2);

        String yearStr = req.getParameter("year");
        v.setYear(yearStr != null && !yearStr.isEmpty() ? Integer.parseInt(yearStr) : 2024);

        return v;
    }

    private String safe(String s) {
        return (s != null) ? s.trim() : "";
    }
}
