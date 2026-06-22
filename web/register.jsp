<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register | EliteDrive</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <!-- Register Form Section -->
  <main class="auth-container mt-5">
    <div class="container d-flex justify-content-center">
      <div class="card card-premium auth-card p-4 p-md-5 shadow-lg" style="max-width: 500px; width: 100%;">
        <div class="text-center mb-4">
          <h2 class="section-title-gradient fw-bold">Create Account</h2>
          <p class="text-secondary small mt-1">Sign up to unlock and book luxury vehicles.</p>
        </div>

        <!-- Error notification -->
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-20 small mb-4 py-2" role="alert">
                <i class="bi bi-x-circle-fill me-2 text-danger"></i><%= errorMsg %>
            </div>
        <% } %>

        <form action="register" method="POST" onsubmit="return validateForm();">
          <div class="mb-3">
            <label for="reg-name" class="form-label text-secondary small">Full Name *</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-person"></i>
              </span>
              <input type="text" name="name" id="reg-name" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="John Doe" required>
            </div>
          </div>

          <div class="mb-3">
            <label for="reg-email" class="form-label text-secondary small">Email Address *</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-envelope"></i>
              </span>
              <input type="email" name="email" id="reg-email" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="john@example.com" required>
            </div>
          </div>

          <div class="mb-3">
            <label for="reg-phone" class="form-label text-secondary small">Phone Number</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-telephone"></i>
              </span>
              <input type="tel" name="phone" id="reg-phone" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="+94 77 123 4567">
            </div>
          </div>

          <div class="mb-3">
            <label for="reg-password" class="form-label text-secondary small">Password *</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-lock"></i>
              </span>
              <input type="password" name="password" id="reg-password" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="••••••••" required>
            </div>
          </div>

          <div class="mb-4">
            <label for="reg-confirm" class="form-label text-secondary small">Confirm Password *</label>
            <div class="input-group">
              <span class="input-group-text bg-transparent border-end-0 border-glass text-secondary" style="border-radius: 12px 0 0 12px;">
                <i class="bi bi-lock-fill"></i>
              </span>
              <input type="password" id="reg-confirm" class="form-control form-control-premium border-start-0" style="border-radius: 0 12px 12px 0;" placeholder="••••••••" required>
            </div>
            <div id="passwordError" class="text-danger small mt-2" style="display:none;">Passwords do not match.</div>
          </div>

          <button type="submit" class="btn btn-premium-primary w-100 py-3 mb-3">
            <i class="bi bi-person-check me-2"></i> Register Account
          </button>

          <p class="text-center text-secondary small mb-0">
            Already have an account? <a href="login.jsp" class="text-info text-decoration-none fw-semibold">Log in here</a>
          </p>
        </form>
      </div>
    </div>
  </main>

  <%@ include file="footer.jsp" %>

  <!-- Bootstrap 5 Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
      function validateForm() {
          const pass = document.getElementById("reg-password").value;
          const confirm = document.getElementById("reg-confirm").value;
          const errDiv = document.getElementById("passwordError");

          if (pass !== confirm) {
              errDiv.style.display = "block";
              return false;
          }
          errDiv.style.display = "none";
          return true;
      }
  </script>
</body>
</html>
