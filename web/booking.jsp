<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>
<%
    // Ensure the customer is logged in to book
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String vehicleIdStr = request.getParameter("vehicleId");
    int vehicleId = 1;
    if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
        try {
            vehicleId = Integer.parseInt(vehicleIdStr);
        } catch(NumberFormatException e) {
            // ignore
        }
    }

    VehicleDAO vehicleDAO = new VehicleDAO();
    Vehicle selectedVehicle = vehicleDAO.getVehicleById(vehicleId);
    if (selectedVehicle == null) {
        selectedVehicle = vehicleDAO.getAllVehicles().get(0); // fallback to first
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Book <%= selectedVehicle.getBrand() %> <%= selectedVehicle.getModel() %> | EliteDrive</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <!-- Booking Form Container -->
  <main class="auth-container mt-5 py-5" style="background: var(--bg-primary);">
    <div class="container py-4 mt-3">
      <div class="row g-4">
        <!-- Selected Vehicle Summary card -->
        <div class="col-lg-5 order-lg-2">
          <div class="card card-premium p-4 shadow-lg sticky-top" style="top: 100px;">
            <h4 class="fw-bold text-white mb-3">Booking Summary</h4>
            <div class="d-flex gap-3 mb-4">
              <img src="<%= selectedVehicle.getImage() %>" alt="<%= selectedVehicle.getBrand() %>" style="width: 120px; height: 80px; object-fit: cover; border-radius: 8px;">
              <div>
                <h5 class="text-white fw-bold mb-1"><%= selectedVehicle.getBrand() %> <%= selectedVehicle.getModel() %></h5>
                <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-2.5 py-1 rounded text-uppercase small"><%= selectedVehicle.getCategory() %></span>
                <div class="text-warning small mt-1"><i class="bi bi-star-fill"></i> <%= selectedVehicle.getRating() %></div>
              </div>
            </div>
            <div class="border-top border-secondary border-opacity-10 pt-3">
              <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary small">Daily Rate</span>
                <span class="text-white fw-bold">$<%= (int)selectedVehicle.getPricePerDay() %></span>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary small">Rental Duration</span>
                <span class="text-white fw-bold" id="summaryDuration">0 Days</span>
              </div>
              <div class="d-flex justify-content-between border-top border-secondary border-opacity-15 pt-3 mb-0">
                <span class="text-white fw-bold">Estimated Total</span>
                <span class="text-info fw-extrabold h3 mb-0" id="summaryTotal">$0.00</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Booking details inputs form -->
        <div class="col-lg-7">
          <div class="card card-premium p-4 p-md-5 shadow-lg">
            <h2 class="section-title-gradient fw-bold mb-4">Confirm Rental Booking</h2>
            
            <form action="booking" method="POST">
              <input type="hidden" name="action" value="create">
              <input type="hidden" name="vehicleId" value="<%= selectedVehicle.getId() %>">

              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label text-secondary small">Pickup Date *</label>
                  <input type="date" name="pickupDate" id="pickupDate" class="form-control form-control-premium" required min="2026-06-20" onchange="calculateDuration()">
                </div>
                <div class="col-md-6">
                  <label class="form-label text-secondary small">Return Date *</label>
                  <input type="date" name="returnDate" id="returnDate" class="form-control form-control-premium" required min="2026-06-20" onchange="calculateDuration()">
                </div>
                <div class="col-12">
                  <label class="form-label text-secondary small">Pickup Location *</label>
                  <select name="pickupLocation" class="form-select form-control-premium" required>
                    <option value="Colombo Airport">Bandaranaike International Airport (CMB)</option>
                    <option value="Colombo Fort">Colombo Fort Railway Station</option>
                    <option value="Galle Face">Galle Face Green (Colombo 03)</option>
                    <option value="Kandy">Kandy Town (Central Province)</option>
                    <option value="Negombo">Negombo Beach Road</option>
                    <option value="Mirissa Marina">Mirissa Harbour Marina</option>
                  </select>
                </div>
              </div>

              <div class="alert alert-info bg-info bg-opacity-10 border-info border-opacity-20 text-secondary small mt-4 p-3 mb-4" role="alert">
                <i class="bi bi-info-circle-fill me-2 text-info"></i>No upfront payment required! You will settle charges in cash or credit card at the pickup counter.
              </div>

              <button type="submit" class="btn btn-premium-primary w-100 py-3">
                <i class="bi bi-calendar-check-fill me-2"></i> Book Ride Now
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="footer.jsp" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    const pricePerDay = <%= selectedVehicle.getPricePerDay() %>;

    function calculateDuration() {
        const startInput = document.getElementById("pickupDate").value;
        const endInput = document.getElementById("returnDate").value;
        const durationEl = document.getElementById("summaryDuration");
        const totalEl = document.getElementById("summaryTotal");

        if (startInput && endInput) {
            const start = new Date(startInput);
            const end = new Date(endInput);
            const diffTime = Math.abs(end - start);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) || 1; 

            if (end >= start) {
                durationEl.textContent = `${diffDays} Day(s)`;
                totalEl.textContent = `$${(diffDays * pricePerDay).toFixed(2)}`;
            } else {
                durationEl.textContent = "0 Days";
                totalEl.textContent = "$0.00";
            }
        }
    }
  </script>
</body>
</html>
