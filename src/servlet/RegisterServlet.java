package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;

public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (name != null) name = name.trim();
        if (email != null) email = email.trim();
        if (phone != null) phone = phone.trim();

        // Basic inputs check
        if (name == null || name.isEmpty() || email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMsg", "Please fill in all required fields.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(0, name, email, phone, password, "CUSTOMER");
        boolean isSuccess = userDAO.register(newUser);

        if (isSuccess) {
            // Registration successful - redirect to login page
            request.setAttribute("successMsg", "Registration successful! Please log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Duplicate email error
            request.setAttribute("errorMsg", "An account with this email already exists.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
