<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Vehicle" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="java.util.List" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    VehicleDAO vehicleDAO = new VehicleDAO();
    List<Vehicle> vehicles = vehicleDAO.getAllVehicles();

    // Handle success/error messages from servlet
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");

    // Filter
    String filterCat    = request.getParameter("category");
    String filterStatus = request.getParameter("status");
    String filterQ      = request.getParameter("q");
    if (filterCat    == null) filterCat    = "";
    if (filterStatus == null) filterStatus = "";
    if (filterQ      == null) filterQ      = "";

    List<Vehicle> filtered = new java.util.ArrayList<>();
    for (Vehicle v : vehicles) {
        boolean catMatch    = filterCat.isEmpty()    || v.getCategory().equalsIgnoreCase(filterCat);
        boolean statusMatch = filterStatus.isEmpty() || v.getStatus().equalsIgnoreCase(filterStatus);
        boolean qMatch      = filterQ.isEmpty()      || (v.getBrand() + " " + v.getModel()).toLowerCase().contains(filterQ.toLowerCase());
        if (catMatch && statusMatch && qMatch) filtered.add(v);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vehicles | EliteDrive Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="css/admin.css" rel="stylesheet">
</head>
<body>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- ═══ SIDEBAR ══════════════════════════════════════════ -->
<aside class="admin-sidebar" id="adminSidebar">
  <a class="sidebar-brand" href="index.jsp">
    <div class="sidebar-brand-icon"><i class="bi bi-speedometer2"></i></div>
    <div>
      <div class="sidebar-brand-text">EliteDrive</div>
    </div>
    <span class="sidebar-brand-badge ms-auto">Admin</span>
  </a>
  <nav class="sidebar-nav">
    <div class="sidebar-section-label">Main</div>
    <ul class="list-unstyled mb-0">
      <li class="nav-item-admin"><a href="index.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>Dashboard</a></li>
      <li class="nav-item-admin"><a href="vehicles.jsp" class="nav-link-admin active"><span class="nav-icon"><i class="bi bi-car-front-fill"></i></span>Vehicles<span class="nav-badge"><%= vehicles.size() %></span></a></li>
      <li class="nav-item-admin"><a href="bookings.jsp" class="nav-link-admin"><span class="nav-icon"><i class="bi bi-calendar-check-fill"></i></span>Bookings</a></li>
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

<!-- ═══ MAIN CONTENT ═══════════════════════════════════════ -->
<div class="admin-main">
  <div class="admin-topbar">
    <button class="sidebar-toggle" id="sidebarToggleTop"><i class="bi bi-list"></i></button>
    <div>
      <div class="topbar-page-title">Fleet Management</div>
      <div class="topbar-breadcrumb"><a href="index.jsp">Home</a> / Vehicles</div>
    </div>
    <div class="topbar-actions ms-auto">
      <a href="add-vehicle.jsp" class="btn-admin-primary"><i class="bi bi-plus-lg"></i> Add Vehicle</a>
    </div>
  </div>

  <div class="admin-content">

    <!-- Flash Messages -->
    <% if (successMsg != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="bi bi-check-circle-fill me-2"></i><%= successMsg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMsg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Page Header -->
    <div class="page-header">
      <div>
        <h1 class="page-header-title">Vehicle Fleet</h1>
        <p class="page-header-subtitle"><%= filtered.size() %> of <%= vehicles.size() %> vehicles shown</p>
      </div>
      <a href="add-vehicle.jsp" class="btn-admin-primary"><i class="bi bi-plus-lg"></i> Add Vehicle</a>
    </div>

    <!-- Filters -->
    <div class="admin-card mb-4">
      <form method="get" action="vehicles.jsp" class="d-flex flex-wrap gap-3 align-items-end" style="padding:20px;">
        <div style="flex:1;min-width:180px;">
          <label class="form-label text-secondary small">Search</label>
          <input type="text" name="q" value="<%= filterQ %>" class="form-control form-control-sm"
                 style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);"
                 placeholder="Brand or model...">
        </div>
        <div>
          <label class="form-label text-secondary small">Category</label>
          <select name="category" class="form-select form-select-sm"
                  style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);">
            <option value="">All Categories</option>
            <% for (String cat : new String[]{"Car","Van","Motorbike","Scooter","Bus","Lorry","Truck","Boat"}) { %>
            <option value="<%= cat %>" <%= filterCat.equalsIgnoreCase(cat) ? "selected" : "" %>><%= cat %></option>
            <% } %>
          </select>
        </div>
        <div>
          <label class="form-label text-secondary small">Status</label>
          <select name="status" class="form-select form-select-sm"
                  style="background:var(--bg-hover);border-color:var(--border-color);color:var(--text-primary);">
            <option value="">All Status</option>
            <% for (String st : new String[]{"available","rented","maintenance"}) { %>
            <option value="<%= st %>" <%= filterStatus.equalsIgnoreCase(st) ? "selected" : "" %>><%= st.substring(0,1).toUpperCase() + st.substring(1) %></option>
            <% } %>
          </select>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn-admin-primary" style="padding:6px 16px;font-size:0.82rem;"><i class="bi bi-search"></i> Filter</button>
          <a href="vehicles.jsp" class="btn-admin-outline" style="padding:6px 16px;font-size:0.82rem;">Reset</a>
        </div>
      </form>
    </div>

    <!-- Vehicles Table -->
    <div class="admin-card">
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Vehicle</th>
              <th>Category</th>
              <th>Fuel / Trans.</th>
              <th>Seats</th>
              <th>Price/Day</th>
              <th>Rating</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% if (filtered.isEmpty()) { %>
            <tr>
              <td colspan="9" style="text-align:center;padding:40px;color:var(--text-secondary);">
                <i class="bi bi-car-front" style="font-size:2rem;display:block;margin-bottom:8px;"></i>
                No vehicles found matching your criteria.
              </td>
            </tr>
            <% } %>
            <% for (Vehicle v : filtered) { %>
            <tr>
              <td><span style="font-weight:600;color:var(--accent-primary)">#<%= v.getId() %></span></td>
              <td>
                <div style="font-weight:600;color:var(--text-primary)"><%= v.getBrand() %> <%= v.getModel() %></div>
                <div style="font-size:0.75rem;color:var(--text-secondary)"><%= v.getYear() %></div>
              </td>
              <td><span style="background:rgba(99,102,241,0.15);color:#818cf8;padding:3px 10px;border-radius:12px;font-size:0.78rem;font-weight:600;"><%= v.getCategory() %></span></td>
              <td>
                <div style="font-size:0.82rem;color:var(--text-primary)"><%= v.getFuel() %></div>
                <div style="font-size:0.75rem;color:var(--text-secondary)"><%= v.getTransmission() %></div>
              </td>
              <td style="text-align:center;"><%= v.getSeats() %></td>
              <td><span style="font-weight:700;color:var(--accent-green)">$<%= String.format("%.0f", v.getPricePerDay()) %></span></td>
              <td>
                <span style="color:#f59e0b;"><i class="bi bi-star-fill"></i></span>
                <span style="font-size:0.82rem;font-weight:600;color:var(--text-primary);"><%= v.getRating() %></span>
              </td>
              <td>
                <% String st = v.getStatus(); %>
                <span class="status-badge status-<%= st %>"><%= st.substring(0,1).toUpperCase() + st.substring(1) %></span>
              </td>
              <td>
                <div class="d-flex gap-2">
                  <a href="add-vehicle.jsp?edit=<%= v.getId() %>" class="btn-admin-outline" style="padding:4px 10px;font-size:0.78rem;" title="Edit">
                    <i class="bi bi-pencil-fill"></i>
                  </a>
                  <button class="btn-admin-outline" style="padding:4px 10px;font-size:0.78rem;border-color:#ef4444;color:#ef4444;"
                          onclick="confirmDelete(<%= v.getId() %>, '<%= v.getBrand() %> <%= v.getModel() %>')" title="Delete">
                    <i class="bi bi-trash-fill"></i>
                  </button>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div><!-- /admin-content -->
</div><!-- /admin-main -->

<!-- Delete Confirm Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="background:var(--bg-card);border:1px solid var(--border-color);color:var(--text-primary);">
      <div class="modal-header" style="border-color:var(--border-color);">
        <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Delete Vehicle</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        Are you sure you want to delete <strong id="deleteVehicleName"></strong>? This action cannot be undone.
      </div>
      <div class="modal-footer" style="border-color:var(--border-color);">
        <button class="btn-admin-outline" data-bs-dismiss="modal">Cancel</button>
        <form id="deleteForm" method="post" action="../vehicle">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="vehicleId" id="deleteVehicleId">
          <button type="submit" class="btn-admin-primary" style="background:#ef4444;">Delete</button>
        </form>
      </div>
    </div>
  </div>
</div>

<div id="adminToastWrap" class="admin-toast-wrap"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin.js"></script>
<script>
function confirmDelete(id, name) {
  document.getElementById('deleteVehicleName').textContent = name;
  document.getElementById('deleteVehicleId').value = id;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
</body>
</html>
