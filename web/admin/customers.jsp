<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Booking" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.List" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    UserDAO userDAO       = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();
    List<User> allUsers   = userDAO.getAllUsers();

    // Build customer list (exclude admins)
    List<User> customers = new java.util.ArrayList<>();
    for (User u : allUsers) {
        if ("CUSTOMER".equalsIgnoreCase(u.getRole())) customers.add(u);
    }

    String filterQ = request.getParameter("q");
    if (filterQ == null) filterQ = "";

    List<User> filtered = new java.util.ArrayList<>();
    for (User u : customers) {
        boolean match = filterQ.isEmpty()
            || u.getName().toLowerCase().contains(filterQ.toLowerCase())
            || u.getEmail().toLowerCase().contains(filterQ.toLowerCase());
        if (match) filtered.add(u);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customers | EliteDrive Admin</title>
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
      <li class="nav-item-admin"><a href="bookings.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-calendar-check-fill"></i></span>Bookings</a></li>
      <li class="nav-item-admin"><a href="customers.jsp" class="nav-link-admin active"><span class="nav-icon"><i class="bi bi-people-fill"></i></span>Customers<span class="nav-badge"><%= customers.size() %></span></a></li>
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
      <div class="topbar-page-title">Customer Management</div>
      <div class="topbar-breadcrumb"><a href="index.jsp">Home</a> / Customers</div>
    </div>
  </div>

  <div class="admin-content">

    <div class="page-header">
      <div>
        <h1 class="page-header-title">Registered Customers</h1>
        <p class="page-header-subtitle"><%= filtered.size() %> of <%= customers.size() %> customers shown</p>
      </div>
    </div>

    <!-- Search -->
    <div class="admin-card mb-4">
      <form method="get" action="customers.jsp" class="d-flex gap-3 align-items-end" style="padding:20px;">
        <div style="flex:1;max-width:400px;">
          <label class="form-label text-secondary small">Search Customers</label>
          <input type="text" name="q" value="<%= filterQ %>" class="form-control form-control-sm"
                 style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);"
                 placeholder="Name or email...">
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn-admin-primary" style="padding:6px 16px;font-size:0.82rem;"><i class="bi bi-search"></i> Search</button>
          <a href="customers.jsp" class="btn-admin-outline" style="padding:6px 16px;font-size:0.82rem;">Reset</a>
        </div>
      </form>
    </div>

    <!-- Customers Table -->
    <div class="admin-card">
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Customer</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Bookings</th>
              <th>Total Spent</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <% if (filtered.isEmpty()) { %>
            <tr>
              <td colspan="7" style="text-align:center;padding:40px;color:var(--text-secondary);">
                <i class="bi bi-person-x" style="font-size:2rem;display:block;margin-bottom:8px;"></i>
                No customers found.
              </td>
            </tr>
            <% } %>
            <% for (User u : filtered) {
               List<Booking> userBookings = bookingDAO.getBookingsByUser(u.getEmail());
               double totalSpent = 0;
               for (Booking b : userBookings) {
                   if (!"cancelled".equalsIgnoreCase(b.getStatus())) totalSpent += b.getTotalPrice();
               }
               String initials = u.getName().length() >= 2 ? u.getName().substring(0,2).toUpperCase() : u.getName().toUpperCase();
            %>
            <tr>
              <td><span style="font-weight:600;color:var(--accent-primary)">#<%= u.getId() %></span></td>
              <td>
                <div class="d-flex align-items-center gap-2">
                  <div style="width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--accent-primary),var(--accent-secondary));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.78rem;flex-shrink:0;">
                    <%= initials %>
                  </div>
                  <div>
                    <div style="font-weight:600;color:var(--text-primary)"><%= u.getName() %></div>
                    <div style="font-size:0.72rem;color:var(--text-secondary)">Customer</div>
                  </div>
                </div>
              </td>
              <td style="color:var(--text-secondary);font-size:0.85rem;"><%= u.getEmail() %></td>
              <td style="color:var(--text-secondary);font-size:0.85rem;"><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
              <td>
                <div style="text-align:center;">
                  <span style="font-weight:700;color:var(--text-primary)"><%= userBookings.size() %></span>
                  <div style="font-size:0.72rem;color:var(--text-secondary)">trips</div>
                </div>
              </td>
              <td><span style="font-weight:700;color:var(--accent-green)">$<%= String.format("%,.2f", totalSpent) %></span></td>
              <td><span class="status-badge status-available">Active</span></td>
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
