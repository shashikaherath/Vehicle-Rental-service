<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login | EliteDrive</title>
  <meta name="description" content="Access your EliteDrive account to book luxury cars and manage your current bookings.">
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <!-- Login Form Section -->
  <main class="auth-container mt-5">
    <div class="container d-flex justify-content-center">
      <div class="card card-premium auth-card p-4 p-md-5 shadow-lg">
        <div class="text-center mb-4">
          <h2 class="section-title-gradient fw-bold">Welcome Back</h2>
          <p class="text-secondary small mt-1">Access your account to book premium vehicles.</p>
        </div>

        <!-- Success/Error alert notifications -->
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            String successMsg = (String) request.getAttribute("successMsg");
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-20 small mb-4 py-2" role="alert">
                <i class="bi bi-x-circle-fill me-2 text-danger"></i><%= errorMsg %>
            </div>
        <% } %>
        <% if (successMsg != null) { %>
            <div class="alert alert-success border-0 text-white bg-success bg-opacity-20 small mb-4 py-2" role="alert">
                <i class="bi bi-check-circle-fill me-2 text-success"></i><%= successMsg %>
            </div>
        <% } %>

        <form action="login" method="POST" novalidate>
          <div class="mb-3">
            <label for="login-email" class="form-label text-secondary small">Email Address</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-envelope"></i>
              </span>
              <input type="email" name="email" id="login-email" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="name@example.com" required>
            </div>
          </div>

          <div class="mb-4">
            <label for="login-password" class="form-label text-secondary small">Password</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-lock"></i>
              </span>
              <input type="password" name="password" id="login-password" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="••••••••" required>
            </div>
          </div>

          <button type="submit" class="btn btn-premium-primary w-100 py-3 mb-3">
            <i class="bi bi-box-arrow-in-right me-2"></i> Log In
          </button>

          <p class="text-center text-secondary small mb-0">
            Don't have an account? <a href="register.jsp" class="text-info text-decoration-none fw-semibold">Register here</a>
          </p>
        </form>
      </div>
    </div>
  </main>

  <%@ include file="footer.jsp" %>

  <!-- Bootstrap 5 Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
