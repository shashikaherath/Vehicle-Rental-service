package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null) {
            email = email.trim();
        }

        // 1. Authenticate credentials
        User user = userDAO.authenticate(email, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            
            if ("ADMIN".equals(user.getRole())) {
                session.setAttribute("adminUser", user);
                // Redirect admin to dashboard
                response.sendRedirect("admin/index.jsp");
            } else {
                session.setAttribute("currentUser", user);
                // If user was trying to book a vehicle before login, send them back
                Integer pendingVehicleId = (Integer) session.getAttribute("pendingVehicleId");
                if (pendingVehicleId != null) {
                    session.removeAttribute("pendingVehicleId");
                    response.sendRedirect("booking.jsp?vehicleId=" + pendingVehicleId);
                } else {
                    // Redirect customer to homepage
                    response.sendRedirect("index.jsp");
                }
            }
        } else {
            // Authentication failed
            request.setAttribute("errorMsg", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
