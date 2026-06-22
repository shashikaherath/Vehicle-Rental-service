<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.Booking" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.List" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    VehicleDAO vehicleDAO = new VehicleDAO();
    UserDAO userDAO = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();

    int totalVehicles = vehicleDAO.getAllVehicles().size();
    
    // Count customers (excluding admin)
    int totalCustomers = 0;
    for (User u : userDAO.getAllUsers()) {
        if ("CUSTOMER".equalsIgnoreCase(u.getRole())) {
            totalCustomers++;
        }
    }

    List<Booking> bookings = bookingDAO.getAllBookings();
    int totalBookings = bookings.size();

    double totalRevenue = 0.0;
    int pendingCount = 0;
    int activeCount = 0;
    int completedCount = 0;
    for (Booking b : bookings) {
        if ("approved".equalsIgnoreCase(b.getStatus()) || "completed".equalsIgnoreCase(b.getStatus()) || "active".equalsIgnoreCase(b.getStatus())) {
            totalRevenue += b.getTotalPrice();
        }
        if ("pending".equalsIgnoreCase(b.getStatus())) {
            pendingCount++;
        } else if ("active".equalsIgnoreCase(b.getStatus())) {
            activeCount++;
        } else if ("completed".equalsIgnoreCase(b.getStatus())) {
            completedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard | EliteDrive Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="css/admin.css" rel="stylesheet">
</head>
<body>

<!-- Sidebar Overlay (mobile) -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- ═══ SIDEBAR ══════════════════════════════════════════ -->
<aside class="admin-sidebar" id="adminSidebar">
  <!-- Brand -->
  <a class="sidebar-brand" href="index.jsp">
    <div class="sidebar-brand-icon"><i class="bi bi-speedometer2"></i></div>
    <div>
      <div class="sidebar-brand-text">EliteDrive</div>
    </div>
    <span class="sidebar-brand-badge ms-auto">Admin</span>
  </a>

  <!-- Navigation -->
  <nav class="sidebar-nav">
    <div class="sidebar-section-label">Main</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin">
        <a href="index.jsp" class="nav-link-admin active">
          <span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>
          Dashboard
        </a>
      </li>
      <li class="nav-item-admin">
        <a href="vehicles.jsp" class="nav-link-admin">
          <span class="nav-icon"><i class="bi bi-car-front-fill"></i></span>
          Vehicles
          <span class="nav-badge"><%= totalVehicles %></span>
        </a>
      </li>
      <li class="nav-item-admin">
        <a href="bookings.jsp" class="nav-link-admin">
          <span class="nav-icon"><i class="bi bi-calendar-check-fill"></i></span>
          Bookings
          <span class="nav-badge"><%= pendingCount %></span>
        </a>
      </li>
      <li class="nav-item-admin">
        <a href="customers.jsp" class="nav-link-admin">
          <span class="nav-icon"><i class="bi bi-people-fill"></i></span>
          Customers
        </a>
      </li>
    </ul>

    <div class="sidebar-section-label">Reports</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin">
        <a href="reports.jsp" class="nav-link-admin">
          <span class="nav-icon"><i class="bi bi-bar-chart-fill"></i></span>
          Reports
        </a>
      </li>
    </ul>

    <div class="sidebar-section-label">Settings</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin">
        <a href="#" class="nav-link-admin" onclick="showAdminToast('Settings coming soon!','info');return false;">
          <span class="nav-icon"><i class="bi bi-gear-fill"></i></span>
          Settings
        </a>
      </li>
      <li class="nav-item-admin">
        <a href="../logout" class="nav-link-admin">
          <span class="nav-icon"><i class="bi bi-box-arrow-left"></i></span>
          Logout
        </a>
      </li>
    </ul>
  </nav>

  <!-- User -->
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

<!-- ═══ MAIN CONTENT ═══════════════════════════════════════ -->
<div class="admin-main">

  <!-- Topbar -->
  <div class="admin-topbar">
    <button class="sidebar-toggle" id="sidebarToggleTop"><i class="bi bi-list"></i></button>
    <div>
      <div class="topbar-page-title">Dashboard</div>
      <div class="topbar-breadcrumb">
        <a href="index.jsp">Home</a> / Overview
      </div>
    </div>
    <div class="topbar-actions ms-auto">
      <button class="topbar-btn" id="topbarBell" title="Notifications">
        <i class="bi bi-bell"></i>
        <span class="topbar-notification-dot"></span>
      </button>
    </div>
  </div>

  <!-- Content -->
  <div class="admin-content">

    <!-- Page Header -->
    <div class="page-header">
      <div>
        <h1 class="page-header-title">Welcome back, Admin 👋</h1>
        <p class="page-header-subtitle">Here's what's happening across your fleet today.</p>
      </div>
      <div class="d-flex gap-2 flex-wrap">
        <button class="btn-admin-outline" onclick="showAdminToast('Report exported!','success')">
          <i class="bi bi-download"></i> Export Report
        </button>
        <a href="add-vehicle.jsp" class="btn-admin-primary">
          <i class="bi bi-plus-lg"></i> Add Vehicle
        </a>
      </div>
    </div>

    <!-- ── Stat Cards ─────────────────────────────────── -->
    <div class="row g-4 mb-4">
      <!-- Total Vehicles -->
      <div class="col-sm-6 col-xl-3">
        <div class="stat-card" style="--stat-color:#6366f1;--stat-rgb:99,102,241">
          <div class="stat-header">
            <div class="stat-icon"><i class="bi bi-car-front-fill"></i></div>
            <div class="stat-trend up"><i class="bi bi-arrow-up-short"></i>+3</div>
          </div>
          <div class="stat-value" data-target="<%= totalVehicles %>"><%= totalVehicles %></div>
          <div class="stat-label">Total Vehicles</div>
          <div class="stat-sub"><%= activeCount %> active · <%= completedCount %> completed</div>
        </div>
      </div>

      <!-- Total Customers -->
      <div class="col-sm-6 col-xl-3">
        <div class="stat-card" style="--stat-color:#06b6d4;--stat-rgb:6,182,212">
          <div class="stat-header">
            <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
            <div class="stat-trend up"><i class="bi bi-arrow-up-short"></i>+11</div>
          </div>
          <div class="stat-value" data-target="<%= totalCustomers %>"><%= totalCustomers %></div>
          <div class="stat-label">Total Customers</div>
          <div class="stat-sub">Active members catalog</div>
        </div>
      </div>

      <!-- Total Bookings -->
      <div class="col-sm-6 col-xl-3">
        <div class="stat-card" style="--stat-color:#10b981;--stat-rgb:16,185,129">
          <div class="stat-header">
            <div class="stat-icon"><i class="bi bi-calendar-check-fill"></i></div>
            <div class="stat-trend up"><i class="bi bi-arrow-up-short"></i>+7</div>
          </div>
          <div class="stat-value" data-target="<%= totalBookings %>"><%= totalBookings %></div>
          <div class="stat-label">Total Bookings</div>
          <div class="stat-sub"><%= pendingCount %> pending approval</div>
        </div>
      </div>

      <!-- Revenue -->
      <div class="col-sm-6 col-xl-3">
        <div class="stat-card" style="--stat-color:#f59e0b;--stat-rgb:245,158,11">
          <div class="stat-header">
            <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
            <div class="stat-trend up"><i class="bi bi-arrow-up-short"></i>+12%</div>
          </div>
          <div class="stat-value" data-target="<%= (int)totalRevenue %>" data-prefix="$">$<%= String.format("%,d", (int)totalRevenue) %></div>
          <div class="stat-label">Total Revenue</div>
          <div class="stat-sub">Earned from confirmed rides</div>
        </div>
      </div>
    </div>

    <!-- ── Row 2: Revenue Chart + Recent Bookings ────────────── -->
    <div class="row g-4 mb-4">
      <!-- Mini monthly revenue display -->
      <div class="col-lg-5">
        <div class="admin-card h-100">
          <div class="admin-card-header">
            <div>
              <div class="admin-card-title">Fleet Breakdown</div>
              <div class="admin-card-subtitle">Occupancy and category density</div>
            </div>
          </div>
          <div style="padding:24px; display:flex; flex-direction:column; gap:16px;">
            <div>
              <div class="d-flex justify-content-between mb-1" style="font-size:0.8rem">
                <span class="text-secondary">Cars</span>
                <span class="text-white fw-bold">2 / 2</span>
              </div>
              <div style="height:6px;background:var(--bg-hover);border-radius:3px;overflow:hidden;"><div style="height:100%;width:100%;background:var(--accent-primary)"></div></div>
            </div>
            <div>
              <div class="d-flex justify-content-between mb-1" style="font-size:0.8rem">
                <span class="text-secondary">Vans</span>
                <span class="text-white fw-bold">1 / 2</span>
              </div>
              <div style="height:6px;background:var(--bg-hover);border-radius:3px;overflow:hidden;"><div style="height:100%;width:50%;background:var(--accent-secondary)"></div></div>
            </div>
            <div>
              <div class="d-flex justify-content-between mb-1" style="font-size:0.8rem">
                <span class="text-secondary">Motorbikes</span>
                <span class="text-white fw-bold">2 / 2</span>
              </div>
              <div style="height:6px;background:var(--bg-hover);border-radius:3px;overflow:hidden;"><div style="height:100%;width:100%;background:var(--accent-orange)"></div></div>
            </div>
            <div>
              <div class="d-flex justify-content-between mb-1" style="font-size:0.8rem">
                <span class="text-secondary">Boats</span>
                <span class="text-white fw-bold">2 / 2</span>
              </div>
              <div style="height:6px;background:var(--bg-hover);border-radius:3px;overflow:hidden;"><div style="height:100%;width:100%;background:var(--accent-green)"></div></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Bookings table -->
      <div class="col-lg-7">
        <div class="admin-card h-100">
          <div class="admin-card-header">
            <div>
              <div class="admin-card-title">Recent Bookings</div>
              <div class="admin-card-subtitle">Latest rental transactions and status</div>
            </div>
            <a href="bookings.jsp" class="btn-admin-primary" style="padding:7px 14px;font-size:0.8rem;">
              <i class="bi bi-calendar-check"></i> View All
            </a>
          </div>
          <div class="admin-table-wrap">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Booking ID</th>
                  <th>Customer</th>
                  <th>Vehicle</th>
                  <th>Amount</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <%
                    // Get latest 5 bookings
                    int count = 0;
                    for (int i = bookings.size() - 1; i >= 0 && count < 5; i--) {
                        Booking b = bookings.get(i);
                        Vehicle v = vehicleDAO.getVehicleById(b.getVehicleId());
                        String vName = (v != null) ? v.getBrand() + " " + v.getModel() : "Unknown Vehicle";
                        
                        // Look up user name
                        User customerUser = userDAO.getUserByEmail(b.getUserEmail());
                        String customerName = (customerUser != null) ? customerUser.getName() : b.getUserEmail();
                        
                        count++;
                %>
                <tr>
                  <td><span style="font-weight:600;color:var(--accent-primary)">#BK-<%= b.getId() %></span></td>
                  <td><%= customerName %></td>
                  <td><%= vName %></td>
                  <td><span style="font-weight:700;color:var(--accent-green)">$<%= String.format("%,.2f", b.getTotalPrice()) %></span></td>
                  <td><span class="status-badge status-<%= b.getStatus() %>"><%= b.getStatus().substring(0, 1).toUpperCase() + b.getStatus().substring(1) %></span></td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

  </div><!-- /admin-content -->
</div><!-- /admin-main -->

<div id="adminToastWrap" class="admin-toast-wrap"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin.js"></script>
</body>
</html>
