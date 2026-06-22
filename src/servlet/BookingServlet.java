package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.BookingDAO;
import dao.VehicleDAO;
import model.Booking;
import model.User;
import model.Vehicle;

/**
 * BookingServlet — handles booking-related POST actions.
 *   POST /booking?action=create       → customer submits a new booking
 *   POST /booking?action=updateStatus → admin changes booking status (approve/cancel/complete)
 */
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        if (action == null) action = "";

        // ── Admin: status update ──────────────────────────────────────────────
        if ("updateStatus".equalsIgnoreCase(action)) {
            User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
            if (admin == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");
                boolean ok = bookingDAO.updateStatus(bookingId, status);
                if (ok) {
                    session.setAttribute("successMsg", "Booking #" + bookingId + " status updated to '" + status + "'.");
                } else {
                    session.setAttribute("errorMsg", "Booking #" + bookingId + " not found.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Invalid booking ID.");
            }
            response.sendRedirect("admin/bookings.jsp");
            return;
        }

        // ── Customer: create new booking ──────────────────────────────────────
        if ("create".equalsIgnoreCase(action)) {
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                String pickupDate      = request.getParameter("pickupDate");
                String returnDate      = request.getParameter("returnDate");
                String pickupLocation  = request.getParameter("pickupLocation");

                Vehicle v = vehicleDAO.getVehicleById(vehicleId);
                double pricePerDay = (v != null) ? v.getPricePerDay() : 50.0;

                // Simple day-count calculation
                long days = 3; // default fallback
                try {
                    java.time.LocalDate pd = java.time.LocalDate.parse(pickupDate);
                    java.time.LocalDate rd = java.time.LocalDate.parse(returnDate);
                    long diff = java.time.temporal.ChronoUnit.DAYS.between(pd, rd);
                    if (diff > 0) days = diff;
                } catch (Exception ignored) {}

                double totalPrice = pricePerDay * days;

                Booking booking = new Booking(0, currentUser.getEmail(), vehicleId,
                        pickupDate, returnDate, pickupLocation, totalPrice, "pending");
                bookingDAO.addBooking(booking);

                session.setAttribute("successMsg", "Booking submitted! Our team will confirm shortly.");
                response.sendRedirect("booking.jsp?booked=true");
            } catch (Exception e) {
                session.setAttribute("errorMsg", "Failed to create booking: " + e.getMessage());
                response.sendRedirect("booking.jsp");
            }
            return;
        }

        // Fallback
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("vehicles.jsp");
    }
}
