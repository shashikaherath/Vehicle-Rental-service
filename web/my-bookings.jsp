<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Vehicle" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Booking> myBookings = (List<Booking>) request.getAttribute("myBookings");
    if (myBookings == null) myBookings = new java.util.ArrayList<>();

    VehicleDAO vehicleDAO = new VehicleDAO();

    String successMsg = (String) session.getAttribute("successMsg");
    session.removeAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Bookings | EliteDrive</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="assets/css/style.css" rel="stylesheet">
  <style>
    .bookings-page { padding-top: 110px; min-height: 100vh; background: var(--bg-primary); }
    .booking-card {
      background: var(--bg-secondary);
      border: 1px solid var(--border-glass);
      border-radius: 16px;
      padding: 24px;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .booking-card:hover {
      transform: translateY(-3px);
      box-shadow: 0 12px 40px rgba(0,0,0,0.3);
    }
    .booking-vehicle-img {
      width: 100px;
      height: 68px;
      object-fit: cover;
      border-radius: 10px;
      flex-shrink: 0;
    }
    .status-pill {
      display: inline-block;
      padding: 4px 14px;
      border-radius: 50px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }
    .status-pill.pending   { background: rgba(251,191,36,0.15); color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
    .status-pill.approved  { background: rgba(34,197,94,0.15);  color: #22c55e; border: 1px solid rgba(34,197,94,0.3); }
    .status-pill.active    { background: rgba(99,102,241,0.15); color: #818cf8; border: 1px solid rgba(99,102,241,0.3); }
    .status-pill.completed { background: rgba(14,165,233,0.15); color: #38bdf8; border: 1px solid rgba(14,165,233,0.3); }
    .status-pill.cancelled { background: rgba(239,68,68,0.15);  color: #f87171; border: 1px solid rgba(239,68,68,0.3); }
    .empty-state {
      text-align: center;
      padding: 80px 20px;
      color: var(--text-secondary);
    }
    .empty-state i { font-size: 4rem; margin-bottom: 20px; display: block; opacity: 0.4; }
    .meta-label { font-size: 0.72rem; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 2px; }
    .meta-value { font-size: 0.88rem; color: var(--text-primary); font-weight: 500; }
  </style>
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <main class="bookings-page">
    <div class="container py-4">

      <!-- Page Header -->
      <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
          <h1 class="section-title-gradient fw-bold mb-1" style="font-size:1.9rem;">My Bookings</h1>
          <p class="text-secondary mb-0">Welcome back, <strong class="text-white"><%= currentUser.getName() %></strong> — here are all your rental bookings.</p>
        </div>
        <a href="vehicles.jsp" class="btn btn-premium-primary px-4">
          <i class="bi bi-plus-lg me-2"></i>New Booking
        </a>
      </div>

      <% if (successMsg != null) { %>
      <div class="alert alert-success alert-dismissible fade show mb-4">
        <i class="bi bi-check-circle-fill me-2"></i><%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% } %>

      <% if (errorMsg != null) { %>
      <div class="alert alert-danger alert-dismissible fade show mb-4">
        <i class="bi bi-x-circle-fill me-2"></i><%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% } %>

      <% if (myBookings.isEmpty()) { %>
      <div class="booking-card empty-state">
        <i class="bi bi-calendar-x"></i>
        <h4 class="text-white mb-2">No bookings yet</h4>
        <p class="mb-4">You haven't made any vehicle bookings yet. Browse our premium fleet to get started!</p>
        <a href="vehicles.jsp" class="btn btn-premium-primary px-5">Browse Vehicles</a>
      </div>
      <% } else { %>

      <!-- Summary badges -->
      <div class="d-flex gap-3 flex-wrap mb-4">
        <%
          long pendingCnt   = myBookings.stream().filter(b -> "pending".equalsIgnoreCase(b.getStatus())).count();
          long activeCnt    = myBookings.stream().filter(b -> "active".equalsIgnoreCase(b.getStatus()) || "approved".equalsIgnoreCase(b.getStatus())).count();
          long completedCnt = myBookings.stream().filter(b -> "completed".equalsIgnoreCase(b.getStatus())).count();
        %>
        <span class="status-pill pending"><i class="bi bi-hourglass-split me-1"></i><%= pendingCnt %> Pending</span>
        <span class="status-pill active"><i class="bi bi-check-circle me-1"></i><%= activeCnt %> Active / Approved</span>
        <span class="status-pill completed"><i class="bi bi-flag-fill me-1"></i><%= completedCnt %> Completed</span>
        <span class="text-secondary small ms-auto align-self-center"><%= myBookings.size() %> booking(s) total</span>
      </div>

      <div class="d-flex flex-column gap-3">
        <% for (int i = myBookings.size() - 1; i >= 0; i--) {
             Booking b = myBookings.get(i);
             Vehicle v = vehicleDAO.getVehicleById(b.getVehicleId());
             String vName  = (v != null) ? v.getBrand() + " " + v.getModel() : "Unknown Vehicle";
             String vImg   = (v != null) ? v.getImage()  : "assets/images/car.jpg";
             String vCat   = (v != null) ? v.getCategory() : "";
             String st     = b.getStatus() != null ? b.getStatus().toLowerCase() : "pending";
             String stLabel = st.substring(0,1).toUpperCase() + st.substring(1);
        %>
        <div class="booking-card">
          <div class="d-flex gap-3 align-items-start flex-wrap">
            <!-- Vehicle thumbnail -->
            <img src="<%= vImg %>" alt="<%= vName %>" class="booking-vehicle-img">

            <!-- Main info -->
            <div class="flex-grow-1">
              <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                <div>
                  <h5 class="text-white fw-bold mb-1"><%= vName %></h5>
                  <% if (!vCat.isEmpty()) { %>
                  <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-2 py-1 rounded small text-uppercase"><%= vCat %></span>
                  <% } %>
                </div>
                <div class="d-flex align-items-center gap-2">
                  <span class="status-pill <%= st %>"><%= stLabel %></span>
                  <span class="text-secondary small">#BK-<%= b.getId() %></span>
                </div>
              </div>

              <div class="row g-3">
                <div class="col-6 col-md-3">
                  <div class="meta-label"><i class="bi bi-calendar-event me-1"></i>Pickup Date</div>
                  <div class="meta-value"><%= b.getPickupDate() %></div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="meta-label"><i class="bi bi-calendar-check me-1"></i>Return Date</div>
                  <div class="meta-value"><%= b.getReturnDate() %></div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="meta-label"><i class="bi bi-geo-alt me-1"></i>Pickup Location</div>
                  <div class="meta-value"><%= b.getPickupLocation() %></div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="meta-label"><i class="bi bi-cash-coin me-1"></i>Total Amount</div>
                  <div class="meta-value text-info fw-bold" style="font-size:1rem;">$<%= String.format("%,.2f", b.getTotalPrice()) %></div>
                </div>
              </div>
            </div>
          </div>

          <% if ("pending".equalsIgnoreCase(st)) { %>
          <div class="mt-3 pt-3 border-top border-secondary border-opacity-10">
            <div class="alert alert-warning bg-warning bg-opacity-10 border-warning border-opacity-20 text-warning small p-2 mb-0 d-inline-flex align-items-center gap-2">
              <i class="bi bi-hourglass-split"></i>
              Your booking is under review. Our team will confirm it shortly.
            </div>
          </div>
          <% } else if ("approved".equalsIgnoreCase(st) || "active".equalsIgnoreCase(st)) { %>
          <div class="mt-3 pt-3 border-top border-secondary border-opacity-10">
            <div class="alert alert-success bg-success bg-opacity-10 border-success border-opacity-20 text-success small p-2 mb-0 d-inline-flex align-items-center gap-2">
              <i class="bi bi-check-circle-fill"></i>
              Booking confirmed! Please bring a valid ID and payment at pickup.
            </div>
          </div>
          <% } else if ("cancelled".equalsIgnoreCase(st)) { %>
          <div class="mt-3 pt-3 border-top border-secondary border-opacity-10">
            <div class="alert alert-danger bg-danger bg-opacity-10 border-danger border-opacity-20 text-danger small p-2 mb-0 d-inline-flex align-items-center gap-2">
              <i class="bi bi-x-circle-fill"></i>
              This booking was cancelled. <a href="vehicles.jsp" class="text-danger ms-2 fw-bold">Book again?</a>
            </div>
          </div>
          <% } %>
        </div>
        <% } %>
      </div>

      <% } %>
    </div>
  </main>

  <%@ include file="footer.jsp" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
