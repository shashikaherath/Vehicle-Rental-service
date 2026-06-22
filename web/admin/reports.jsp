<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.Booking" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    VehicleDAO vehicleDAO = new VehicleDAO();
    UserDAO userDAO       = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();

    List<Vehicle> vehicles = vehicleDAO.getAllVehicles();
    List<Booking> bookings = bookingDAO.getAllBookings();
    List<User> allUsers    = userDAO.getAllUsers();

    int totalVehicles = vehicles.size();
    int totalBookings = bookings.size();
    int totalCustomers = 0;
    for (User u : allUsers) if ("CUSTOMER".equalsIgnoreCase(u.getRole())) totalCustomers++;

    double totalRevenue = 0, pendingRevenue = 0;
    int pendingCount = 0, activeCount = 0, completedCount = 0, cancelledCount = 0;
    for (Booking b : bookings) {
        switch (b.getStatus().toLowerCase()) {
            case "approved": case "active": case "completed":
                totalRevenue += b.getTotalPrice(); break;
        }
        switch (b.getStatus().toLowerCase()) {
            case "pending":   pendingCount++;   break;
            case "active":    activeCount++;    break;
            case "completed": completedCount++; break;
            case "cancelled": cancelledCount++; break;
        }
    }

    // Category breakdown
    Map<String, int[]> catStats = new LinkedHashMap<>();
    for (String cat : new String[]{"Car","Van","Motorbike","Scooter","Bus","Lorry","Truck","Boat"}) {
        catStats.put(cat, new int[]{0, 0}); // [total, rented]
    }
    for (Vehicle v : vehicles) {
        int[] arr = catStats.get(v.getCategory());
        if (arr != null) {
            arr[0]++;
            if ("rented".equalsIgnoreCase(v.getStatus())) arr[1]++;
        }
    }

    // Top vehicles by booking count
    Map<Integer, Integer> vehicleBookingCount = new java.util.HashMap<>();
    for (Booking b : bookings) {
        vehicleBookingCount.merge(b.getVehicleId(), 1, Integer::sum);
    }
    List<Map.Entry<Integer, Integer>> topVehicles = new java.util.ArrayList<>(vehicleBookingCount.entrySet());
    topVehicles.sort((a, b2) -> b2.getValue() - a.getValue());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports | EliteDrive Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="css/admin.css" rel="stylesheet">
  <style>
    .report-kpi { display:flex;flex-direction:column;gap:4px;padding:22px 24px;border-radius:12px;background:var(--bg-card);border:1px solid var(--border-color); }
    .report-kpi-value { font-size:2rem;font-weight:800;color:var(--text-primary);line-height:1; }
    .report-kpi-label { font-size:0.8rem;color:var(--text-secondary);font-weight:500; }
    .bar-row { display:flex;align-items:center;gap:12px;margin-bottom:12px; }
    .bar-label { width:90px;font-size:0.78rem;color:var(--text-secondary);flex-shrink:0; }
    .bar-track { flex:1;height:8px;background:var(--bg-hover);border-radius:4px;overflow:hidden; }
    .bar-fill  { height:100%;border-radius:4px;background:var(--accent-primary);transition:width .6s ease; }
    .bar-count { font-size:0.8rem;font-weight:700;color:var(--text-primary);width:40px;text-align:right;flex-shrink:0; }
    .donut-wrap { display:flex;align-items:center;justify-content:center;gap:32px;flex-wrap:wrap;padding:24px; }
    .donut-legend { display:flex;flex-direction:column;gap:10px; }
    .legend-item { display:flex;align-items:center;gap:8px;font-size:0.82rem; }
    .legend-dot { width:10px;height:10px;border-radius:50%;flex-shrink:0; }
  </style>
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
      <li class="nav-item-admin"><a href="customers.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-people-fill"></i></span>Customers</a></li>
    </ul>
    <div class="sidebar-section-label">Reports</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin"><a href="reports.jsp" class="nav-link-admin active"><span class="nav-icon"><i class="bi bi-bar-chart-fill"></i></span>Reports</a></li>
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
      <div class="topbar-page-title">Analytics & Reports</div>
      <div class="topbar-breadcrumb"><a href="index.jsp">Home</a> / Reports</div>
    </div>
    <div class="topbar-actions ms-auto">
      <button class="btn-admin-outline" onclick="showAdminToast('Report exported!','success')">
        <i class="bi bi-download"></i> Export
      </button>
    </div>
  </div>

  <div class="admin-content">

    <div class="page-header">
      <div>
        <h1 class="page-header-title">Business Reports</h1>
        <p class="page-header-subtitle">Fleet performance metrics and revenue overview</p>
      </div>
    </div>

    <!-- KPI Row -->
    <div class="row g-4 mb-4">
      <div class="col-sm-6 col-lg-3">
        <div class="report-kpi">
          <div class="report-kpi-value" style="color:var(--accent-primary)">$<%= String.format("%,d", (int)totalRevenue) %></div>
          <div class="report-kpi-label"><i class="bi bi-currency-dollar me-1"></i>Total Revenue</div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="report-kpi">
          <div class="report-kpi-value" style="color:var(--accent-green)"><%= totalBookings %></div>
          <div class="report-kpi-label"><i class="bi bi-calendar-check me-1"></i>Total Bookings</div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="report-kpi">
          <div class="report-kpi-value" style="color:#06b6d4"><%= totalCustomers %></div>
          <div class="report-kpi-label"><i class="bi bi-people me-1"></i>Customers</div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="report-kpi">
          <div class="report-kpi-value" style="color:#f59e0b"><%= totalVehicles %></div>
          <div class="report-kpi-label"><i class="bi bi-car-front me-1"></i>Fleet Size</div>
        </div>
      </div>
    </div>

    <div class="row g-4 mb-4">

      <!-- Booking Status Breakdown -->
      <div class="col-lg-5">
        <div class="admin-card h-100">
          <div class="admin-card-header">
            <div>
              <div class="admin-card-title">Booking Status Distribution</div>
              <div class="admin-card-subtitle">Breakdown of all <%= totalBookings %> bookings</div>
            </div>
          </div>
          <div style="padding:24px;">
            <%
              int[] statusNums = {pendingCount, activeCount, completedCount, cancelledCount};
              String[] statusLabels = {"Pending","Active","Completed","Cancelled"};
              String[] statusColors = {"#f59e0b","#6366f1","#10b981","#ef4444"};
              int maxStatus = 1;
              for (int n : statusNums) if (n > maxStatus) maxStatus = n;
            %>
            <% for (int i = 0; i < statusLabels.length; i++) { %>
            <div class="bar-row">
              <div class="bar-label"><%= statusLabels[i] %></div>
              <div class="bar-track">
                <div class="bar-fill" style="width:<%= totalBookings > 0 ? (statusNums[i] * 100 / totalBookings) : 0 %>%;background:<%= statusColors[i] %>;"></div>
              </div>
              <div class="bar-count" style="color:<%= statusColors[i] %>"><%= statusNums[i] %></div>
            </div>
            <% } %>
            <div style="border-top:1px solid var(--border-color);margin-top:16px;padding-top:16px;">
              <% if (totalBookings > 0) { %>
              <div style="font-size:0.8rem;color:var(--text-secondary);">
                Completion Rate: <span style="color:var(--accent-green);font-weight:700;"><%= (completedCount * 100 / totalBookings) %>%</span>
                &nbsp;·&nbsp; Cancellation Rate: <span style="color:#ef4444;font-weight:700;"><%= (cancelledCount * 100 / totalBookings) %>%</span>
              </div>
              <% } %>
            </div>
          </div>
        </div>
      </div>

      <!-- Category breakdown -->
      <div class="col-lg-7">
        <div class="admin-card h-100">
          <div class="admin-card-header">
            <div>
              <div class="admin-card-title">Fleet by Category</div>
              <div class="admin-card-subtitle">Availability and utilisation per vehicle type</div>
            </div>
          </div>
          <div class="admin-table-wrap">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Category</th>
                  <th>Total</th>
                  <th>Available</th>
                  <th>Rented</th>
                  <th>Occupancy</th>
                </tr>
              </thead>
              <tbody>
                <% for (Map.Entry<String, int[]> entry : catStats.entrySet()) {
                   int[] arr = entry.getValue();
                   if (arr[0] == 0) continue;
                   int avail = arr[0] - arr[1];
                   int pct   = arr[0] > 0 ? arr[1] * 100 / arr[0] : 0;
                %>
                <tr>
                  <td><span style="background:rgba(99,102,241,0.15);color:#818cf8;padding:3px 10px;border-radius:12px;font-size:0.78rem;font-weight:600;"><%= entry.getKey() %></span></td>
                  <td style="font-weight:700;"><%= arr[0] %></td>
                  <td><span class="status-badge status-available"><%= avail %></span></td>
                  <td><span class="status-badge status-rented"><%= arr[1] %></span></td>
                  <td>
                    <div style="display:flex;align-items:center;gap:8px;">
                      <div style="flex:1;height:5px;background:var(--bg-hover);border-radius:3px;overflow:hidden;min-width:60px;">
                        <div style="height:100%;width:<%= pct %>%;background:var(--accent-primary);"></div>
                      </div>
                      <span style="font-size:0.78rem;font-weight:600;color:var(--text-primary);"><%= pct %>%</span>
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

    <!-- Top Vehicles -->
    <div class="admin-card mb-4">
      <div class="admin-card-header">
        <div>
          <div class="admin-card-title">Most Booked Vehicles</div>
          <div class="admin-card-subtitle">Top vehicles ranked by booking frequency</div>
        </div>
      </div>
      <div style="padding:24px;">
        <% int topMax = topVehicles.isEmpty() ? 1 : topVehicles.get(0).getValue();
           int topLimit = Math.min(8, topVehicles.size());
           for (int i = 0; i < topLimit; i++) {
               Map.Entry<Integer, Integer> entry = topVehicles.get(i);
               Vehicle tv = vehicleDAO.getVehicleById(entry.getKey());
               String tvName = (tv != null) ? tv.getBrand() + " " + tv.getModel() : "Vehicle #" + entry.getKey();
               int pct = entry.getValue() * 100 / topMax;
        %>
        <div class="bar-row">
          <div class="bar-label" style="width:180px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:var(--text-primary);font-weight:500;">
            <%= (i+1) %>. <%= tvName %>
          </div>
          <div class="bar-track">
            <div class="bar-fill" style="width:<%= pct %>%;background:linear-gradient(90deg,var(--accent-primary),var(--accent-secondary));"></div>
          </div>
          <div class="bar-count"><%= entry.getValue() %> <span style="font-weight:400;color:var(--text-secondary);font-size:0.72rem;">bookings</span></div>
        </div>
        <% } %>
        <% if (topVehicles.isEmpty()) { %>
        <div style="text-align:center;padding:40px;color:var(--text-secondary);">No booking data yet.</div>
        <% } %>
      </div>
    </div>

  </div>
</div>

<div id="adminToastWrap" class="admin-toast-wrap"></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin.js"></script>
</body>
</html>
