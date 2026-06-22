package servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.VehicleDAO;
import model.Vehicle;

/**
 * VehicleServlet — GET /vehicles
 * Loads all vehicles from the database and forwards to the customer vehicle listing JSP.
 * Supports optional query filters: ?category=Car&fuel=Petrol&q=searchterm
 */
public class VehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read optional filter params
        String filterCategory = request.getParameter("category");
        String filterFuel     = request.getParameter("fuel");
        String filterQ        = request.getParameter("q");
        String filterMinPrice = request.getParameter("minPrice");
        String filterMaxPrice = request.getParameter("maxPrice");

        List<Vehicle> allVehicles = vehicleDAO.getAllVehicles();
        List<Vehicle> filtered = new java.util.ArrayList<>();

        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE;
        try { if (filterMinPrice != null && !filterMinPrice.isEmpty()) minPrice = Double.parseDouble(filterMinPrice); } catch (NumberFormatException ignored) {}
        try { if (filterMaxPrice != null && !filterMaxPrice.isEmpty()) maxPrice = Double.parseDouble(filterMaxPrice); } catch (NumberFormatException ignored) {}

        for (Vehicle v : allVehicles) {
            boolean catMatch   = (filterCategory == null || filterCategory.isEmpty()) || v.getCategory().equalsIgnoreCase(filterCategory);
            boolean fuelMatch  = (filterFuel     == null || filterFuel.isEmpty())     || v.getFuel().equalsIgnoreCase(filterFuel);
            boolean qMatch     = (filterQ        == null || filterQ.isEmpty())        || (v.getBrand() + " " + v.getModel()).toLowerCase().contains(filterQ.toLowerCase());
            boolean priceMatch = v.getPricePerDay() >= minPrice && v.getPricePerDay() <= maxPrice;
            if (catMatch && fuelMatch && qMatch && priceMatch) {
                filtered.add(v);
            }
        }

        // Pass filtered vehicle list and a specific vehicle (for detail view)
        request.setAttribute("vehicles", filtered);
        request.setAttribute("allVehicles", allVehicles);

        // Check if a specific vehicleId was requested (for detail view)
        String vehicleIdParam = request.getParameter("id");
        if (vehicleIdParam != null && !vehicleIdParam.isEmpty()) {
            try {
                int vehicleId = Integer.parseInt(vehicleIdParam);
                Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
                request.setAttribute("vehicle", vehicle);
            } catch (NumberFormatException ignored) {}
        }

        request.getRequestDispatcher("vehicles.jsp").forward(request, response);
    }
}
