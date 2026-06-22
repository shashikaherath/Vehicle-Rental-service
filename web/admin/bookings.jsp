<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Vehicle" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    BookingDAO bookingDAO = new BookingDAO();
    VehicleDAO vehicleDAO = new VehicleDAO();
    UserDAO userDAO       = new UserDAO();
    List<Booking> bookings = bookingDAO.getAllBookings();

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");

    // Filter params
    String filterStatus = request.getParameter("status");
    String filterQ      = request.getParameter("q");
    if (filterStatus == null) filterStatus = "";
    if (filterQ      == null) filterQ      = "";

    List<Booking> filtered = new java.util.ArrayList<>();
    for (Booking b : bookings) {
        boolean statusMatch = filterStatus.isEmpty() || b.getStatus().equalsIgnoreCase(filterStatus);
        Vehicle v = vehicleDAO.getVehicleById(b.getVehicleId());
        String vName = (v != null) ? v.getBrand() + " " + v.getModel() : "";
        User u = userDAO.getUserByEmail(b.getUserEmail());
        String uName = (u != null) ? u.getName() : b.getUserEmail();
        boolean qMatch = filterQ.isEmpty()
            || vName.toLowerCase().contains(filterQ.toLowerCase())
            || uName.toLowerCase().contains(filterQ.toLowerCase())
            || String.valueOf(b.getId()).contains(filterQ);
        if (statusMatch && qMatch) filtered.add(b);
    }

    int pendingCount = 0;
    for (Booking b : bookings) { if ("pending".equalsIgnoreCase(b.getStatus())) pendingCount++; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bookings | EliteDrive Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="css/admin.css" rel="stylesheet">
</head>
<body>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="admin-sidebar" id="adminSidebar">
  <a class="sidebar-brand" href="index.jsp">
    <div class="sidebar-brand-icon"><i class="bi bi-speedometer2"></i></div>
    <div><div class="sidebar-brand-text">EliteDrive</div></div>
    <span class="sidebar-brand-badge ms-auto">Admin</span>
  </a>
  <nav class="sidebar-nav">
    <div class="sidebar-section-label">Main</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin"><a href="index.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>Dashboard</a></li>
      <li class="nav-item-admin"><a href="vehicles.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-car-front-fill"></i></span>Vehicles</a></li>
      <li class="nav-item-admin"><a href="bookings.jsp" class="nav-link-admin active"><span class="nav-icon"><i class="bi bi-calendar-check-fill"></i></span>Bookings<span class="nav-badge"><%= pendingCount %></span></a></li>
      <li class="nav-item-admin"><a href="customers.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-people-fill"></i></span>Customers</a></li>
    </ul>
    <div class="sidebar-section-label">Reports</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin"><a href="reports.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-bar-chart-fill"></i></span>Reports</a></li>
    </ul>
    <div class="sidebar-section-label">Settings</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin"><a href="#" class="nav-link-admin" onclick="showAdminToast('Settings coming soon!','info');return false;"><span class="nav-icon"><i class="bi bi-gear-fill"></i></span>Settings</a></li>
      <li class="nav-item-admin"><a href="../logout" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-box-arrow-left"></i></span>Logout</a></li>
    </ul>
  </nav>
  <div class="sidebar-footer">
    <div class="sidebar-user">
      <div class="sidebar-avatar">AD</div>
      <div class="sidebar-user-info">
        <div class="sidebar-user-name">Admin User</div>
        <div class="sidebar-user-role">Super Administrator</div>
      </div>
    </div>
  </div>
</aside>

<div class="admin-main">
  <div class="admin-topbar">
    <button class="sidebar-toggle" id="sidebarToggleTop"><i class="bi bi-list"></i></button>
    <div>
      <div class="topbar-page-title">Bookings Management</div>
      <div class="topbar-breadcrumb"><a href="index.jsp">Home</a> / Bookings</div>
    </div>
    <div class="topbar-actions ms-auto">
      <button class="topbar-btn" id="topbarBell" title="Notifications">
        <i class="bi bi-bell"></i>
        <% if (pendingCount > 0) { %><span class="topbar-notification-dot"></span><% } %>
      </button>
    </div>
  </div>

  <div class="admin-content">

    <% if (successMsg != null) { %>
    <div class="alert alert-success alert-dismissible fade show">
      <i class="bi bi-check-circle-fill me-2"></i><%= successMsg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMsg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Page Header -->
    <div class="page-header">
      <div>
        <h1 class="page-header-title">All Bookings</h1>
        <p class="page-header-subtitle"><%= filtered.size() %> of <%= bookings.size() %> bookings shown · <%= pendingCount %> pending approval</p>
      </div>
    </div>

    <!-- Filters -->
    <div class="admin-card mb-4">
      <form method="get" action="bookings.jsp" class="d-flex flex-wrap gap-3 align-items-end" style="padding:20px;">
        <div style="flex:1;min-width:200px;">
          <label class="form-label text-secondary small">Search</label>
          <input type="text" name="q" value="<%= filterQ %>" class="form-control form-control-sm"
                 style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);"
                 placeholder="ID, customer, or vehicle...">
        </div>
        <div>
          <label class="form-label text-secondary small">Status</label>
          <select name="status" class="form-select form-select-sm"
                  style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);">
            <option value="">All Status</option>
            <% for (String st : new String[]{"pending","active","approved","completed","cancelled"}) { %>
            <option value="<%= st %>" <%= filterStatus.equalsIgnoreCase(st) ? "selected" : "" %>><%= st.substring(0,1).toUpperCase() + st.substring(1) %></option>
            <% } %>
          </select>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn-admin-primary" style="padding:6px 16px;font-size:0.82rem;"><i class="bi bi-search"></i> Filter</button>
          <a href="bookings.jsp" class="btn-admin-outline" style="padding:6px 16px;font-size:0.82rem;">Reset</a>
        </div>
      </form>
    </div>

    <!-- Bookings Table -->
    <div class="admin-card">
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Booking ID</th>
              <th>Customer</th>
              <th>Vehicle</th>
              <th>Dates</th>
              <th>Pickup</th>
              <th>Amount</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% if (filtered.isEmpty()) { %>
            <tr>
              <td colspan="8" style="text-align:center;padding:40px;color:var(--text-secondary);">
                <i class="bi bi-calendar-x" style="font-size:2rem;display:block;margin-bottom:8px;"></i>
                No bookings match your criteria.
              </td>
            </tr>
            <% } %>
            <% for (int i = filtered.size() - 1; i >= 0; i--) {
               Booking b = filtered.get(i);
               Vehicle v = vehicleDAO.getVehicleById(b.getVehicleId());
               String vName = (v != null) ? v.getBrand() + " " + v.getModel() : "Unknown Vehicle";
               User u = userDAO.getUserByEmail(b.getUserEmail());
               String uName = (u != null) ? u.getName() : b.getUserEmail();
               String st = b.getStatus();
            %>
            <tr>
              <td><span style="font-weight:600;color:var(--accent-primary)">#BK-<%= b.getId() %></span></td>
              <td>
                <div style="font-weight:600;color:var(--text-primary)"><%= uName %></div>
                <div style="font-size:0.72rem;color:var(--text-secondary)"><%= b.getUserEmail() %></div>
              </td>
              <td style="font-weight:500;color:var(--text-primary)"><%= vName %></td>
              <td style="font-size:0.8rem;color:var(--text-secondary)">
                <%= b.getPickupDate() %><br><small>→</small> <%= b.getReturnDate() %>
              </td>
              <td style="font-size:0.8rem;"><%= b.getPickupLocation() %></td>
              <td><span style="font-weight:700;color:var(--accent-green)">$<%= String.format("%,.2f", b.getTotalPrice()) %></span></td>
              <td><span class="status-badge status-<%= st %>"><%= st.substring(0,1).toUpperCase() + st.substring(1) %></span></td>
              <td>
                <div class="d-flex gap-1 flex-wrap">
                  <% if ("pending".equalsIgnoreCase(st)) { %>
                  <form method="post" action="../booking" style="display:inline;">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                    <input type="hidden" name="status" value="approved">
                    <button type="submit" class="btn-admin-primary" style="padding:3px 10px;font-size:0.75rem;background:var(--accent-green);" title="Approve">
                      <i class="bi bi-check-lg"></i>
                    </button>
                  </form>
                  <form method="post" action="../booking" style="display:inline;">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                    <input type="hidden" name="status" value="cancelled">
                    <button type="submit" class="btn-admin-outline" style="padding:3px 10px;font-size:0.75rem;border-color:#ef4444;color:#ef4444;" title="Cancel">
                      <i class="bi bi-x-lg"></i>
                    </button>
                  </form>
                  <% } else if ("active".equalsIgnoreCase(st) || "approved".equalsIgnoreCase(st)) { %>
                  <form method="post" action="../booking" style="display:inline;">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                    <input type="hidden" name="status" value="completed">
                    <button type="submit" class="btn-admin-primary" style="padding:3px 10px;font-size:0.75rem;" title="Mark Complete">
                      <i class="bi bi-flag-fill"></i>
                    </button>
                  </form>
                  <% } else { %>
                  <span style="font-size:0.75rem;color:var(--text-secondary);">—</span>
                  <% } %>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<div id="adminToastWrap" class="admin-toast-wrap"></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin.js"></script>
</body>
</html>
