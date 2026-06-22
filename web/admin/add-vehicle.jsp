<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Vehicle" %>
<%@ page import="dao.VehicleDAO" %>
<%
    // Auth Check
    User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    VehicleDAO vehicleDAO = new VehicleDAO();

    // Edit mode: check if editing existing vehicle
    String editParam = request.getParameter("edit");
    Vehicle editVehicle = null;
    boolean isEdit = false;
    if (editParam != null && !editParam.isEmpty()) {
        try {
            int editId = Integer.parseInt(editParam);
            editVehicle = vehicleDAO.getVehicleById(editId);
            isEdit = (editVehicle != null);
        } catch (NumberFormatException e) { /* ignore */ }
    }

    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("errorMsg");

    String[] categories     = {"Car","Van","Motorbike","Scooter","Bus","Lorry","Truck","Boat"};
    String[] transmissions  = {"Automatic","Manual"};
    String[] fuels          = {"Petrol","Diesel","Electric","Hybrid"};
    String[] statuses       = {"available","rented","maintenance"};

    // Helper to check selection
    String brand       = isEdit ? editVehicle.getBrand()        : "";
    String model2      = isEdit ? editVehicle.getModel()        : "";
    String category    = isEdit ? editVehicle.getCategory()     : "Car";
    String transmission= isEdit ? editVehicle.getTransmission() : "Automatic";
    String fuel        = isEdit ? editVehicle.getFuel()         : "Petrol";
    String status      = isEdit ? editVehicle.getStatus()       : "available";
    String description = isEdit ? editVehicle.getDescription()  : "";
    String image       = isEdit ? editVehicle.getImage()        : "";
    double price       = isEdit ? editVehicle.getPricePerDay()  : 0.0;
    double rating      = isEdit ? editVehicle.getRating()       : 5.0;
    int    seats       = isEdit ? editVehicle.getSeats()        : 2;
    int    year        = isEdit ? editVehicle.getYear()         : 2024;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= isEdit ? "Edit Vehicle" : "Add Vehicle" %> | EliteDrive Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="css/admin.css" rel="stylesheet">
  <style>
    .form-group { margin-bottom:20px; }
    .form-label-admin { font-size:0.82rem;font-weight:600;color:var(--text-secondary);margin-bottom:6px;display:block;text-transform:uppercase;letter-spacing:0.05em; }
    .form-ctrl {
      width:100%;padding:10px 14px;
      background:var(--bg-hover);border:1px solid var(--border-color);
      color:var(--text-primary);border-radius:8px;font-size:0.9rem;
      transition:border-color .2s,box-shadow .2s;
    }
    .form-ctrl:focus { outline:none;border-color:var(--accent-primary);box-shadow:0 0 0 3px rgba(99,102,241,.2); }
    .form-ctrl option { background:var(--bg-card); }
    .section-divider { border-top:1px solid var(--border-color);margin:28px 0; }
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
      <li class="nav-item-admin"><a href="vehicles.jsp" class="nav-link-admin active"><span class="nav-icon"><i class="bi bi-car-front-fill"></i></span>Vehicles</a></li>
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

<div class="admin-main">
  <div class="admin-topbar">
    <button class="sidebar-toggle" id="sidebarToggleTop"><i class="bi bi-list"></i></button>
    <div>
      <div class="topbar-page-title"><%= isEdit ? "Edit Vehicle" : "Add New Vehicle" %></div>
      <div class="topbar-breadcrumb"><a href="index.jsp">Home</a> / <a href="vehicles.jsp">Vehicles</a> / <%= isEdit ? "Edit" : "Add" %></div>
    </div>
    <div class="topbar-actions ms-auto">
      <a href="vehicles.jsp" class="btn-admin-outline"><i class="bi bi-arrow-left"></i> Back to Fleet</a>
    </div>
  </div>

  <div class="admin-content">

    <% if (errorMsg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMsg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="page-header">
      <div>
        <h1 class="page-header-title"><%= isEdit ? "Edit Vehicle #" + editVehicle.getId() : "Add New Vehicle" %></h1>
        <p class="page-header-subtitle"><%= isEdit ? "Update the details for " + brand + " " + model2 : "Fill in the details to add a new vehicle to the fleet." %></p>
      </div>
    </div>

    <form method="post" action="../vehicle" id="vehicleForm">
      <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
      <% if (isEdit) { %>
      <input type="hidden" name="vehicleId" value="<%= editVehicle.getId() %>">
      <% } %>

      <div class="row g-4">

        <!-- Left Column -->
        <div class="col-lg-8">
          <div class="admin-card" style="padding:28px;">

            <div style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
              <i class="bi bi-info-circle-fill me-2" style="color:var(--accent-primary)"></i>Basic Information
            </div>

            <div class="row g-3">
              <div class="col-sm-6 form-group">
                <label class="form-label-admin">Brand *</label>
                <input type="text" name="brand" class="form-ctrl" required value="<%= brand %>"
                       placeholder="e.g. Toyota, BMW...">
              </div>
              <div class="col-sm-6 form-group">
                <label class="form-label-admin">Model *</label>
                <input type="text" name="model" class="form-ctrl" required value="<%= model2 %>"
                       placeholder="e.g. Corolla, Spectre S...">
              </div>
              <div class="col-sm-6 form-group">
                <label class="form-label-admin">Category *</label>
                <select name="category" class="form-ctrl">
                  <% for (String cat : categories) { %>
                  <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>><%= cat %></option>
                  <% } %>
                </select>
              </div>
              <div class="col-sm-6 form-group">
                <label class="form-label-admin">Year *</label>
                <input type="number" name="year" class="form-ctrl" min="2000" max="2025" value="<%= year %>" required>
              </div>
              <div class="col-12 form-group">
                <label class="form-label-admin">Description</label>
                <textarea name="description" class="form-ctrl" rows="3"
                          placeholder="Short description of the vehicle..."><%= description %></textarea>
              </div>
            </div>

            <div class="section-divider"></div>
            <div style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
              <i class="bi bi-sliders me-2" style="color:var(--accent-secondary)"></i>Specifications
            </div>

            <div class="row g-3">
              <div class="col-sm-4 form-group">
                <label class="form-label-admin">Transmission</label>
                <select name="transmission" class="form-ctrl">
                  <% for (String tr : transmissions) { %>
                  <option value="<%= tr %>" <%= tr.equals(transmission) ? "selected" : "" %>><%= tr %></option>
                  <% } %>
                </select>
              </div>
              <div class="col-sm-4 form-group">
                <label class="form-label-admin">Fuel Type</label>
                <select name="fuel" class="form-ctrl">
                  <% for (String f : fuels) { %>
                  <option value="<%= f %>" <%= f.equals(fuel) ? "selected" : "" %>><%= f %></option>
                  <% } %>
                </select>
              </div>
              <div class="col-sm-4 form-group">
                <label class="form-label-admin">Seats *</label>
                <input type="number" name="seats" class="form-ctrl" min="1" max="60" value="<%= seats %>" required>
              </div>
            </div>

            <div class="section-divider"></div>
            <div style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
              <i class="bi bi-image me-2" style="color:var(--accent-orange)"></i>Media
            </div>
            <div class="form-group">
              <label class="form-label-admin">Image Path</label>
              <input type="text" name="image" class="form-ctrl" value="<%= image %>"
                     placeholder="e.g. assets/images/car.jpg">
              <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:5px;">
                Leave blank to use category default. Paths are relative to the web root.
              </div>
            </div>

          </div>
        </div>

        <!-- Right Column -->
        <div class="col-lg-4">
          <div class="admin-card" style="padding:28px;margin-bottom:16px;">
            <div style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
              <i class="bi bi-tag-fill me-2" style="color:var(--accent-green)"></i>Pricing & Status
            </div>
            <div class="form-group">
              <label class="form-label-admin">Price per Day (USD) *</label>
              <input type="number" name="pricePerDay" class="form-ctrl" step="0.01" min="0"
                     value="<%= price %>" required placeholder="e.g. 150.00">
            </div>
            <div class="form-group">
              <label class="form-label-admin">Rating (0.0 – 5.0)</label>
              <input type="number" name="rating" class="form-ctrl" step="0.01" min="0" max="5"
                     value="<%= rating %>" placeholder="e.g. 4.80">
            </div>
            <div class="form-group">
              <label class="form-label-admin">Availability Status</label>
              <select name="status" class="form-ctrl">
                <% for (String st : statuses) { %>
                <option value="<%= st %>" <%= st.equals(status) ? "selected" : "" %>><%= st.substring(0,1).toUpperCase() + st.substring(1) %></option>
                <% } %>
              </select>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="admin-card" style="padding:20px;">
            <div class="d-grid gap-2">
              <button type="submit" class="btn-admin-primary" style="justify-content:center;padding:12px;">
                <i class="bi bi-<%= isEdit ? "save" : "plus-circle" %>-fill"></i>
                <%= isEdit ? "Save Changes" : "Add Vehicle" %>
              </button>
              <a href="vehicles.jsp" class="btn-admin-outline" style="text-align:center;padding:10px;">
                Cancel
              </a>
              <% if (isEdit) { %>
              <button type="button" onclick="confirmDelete(<%= editVehicle.getId() %>, '<%= brand %> <%= model2 %>')"
                      class="btn-admin-outline" style="border-color:#ef4444;color:#ef4444;text-align:center;padding:10px;">
                <i class="bi bi-trash-fill"></i> Delete Vehicle
              </button>
              <% } %>
            </div>
          </div>
        </div>
      </div>

    </form>

  </div>
</div>

<!-- Delete Confirm Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="background:var(--bg-card);border:1px solid var(--border-color);color:var(--text-primary);">
      <div class="modal-header" style="border-color:var(--border-color);">
        <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Delete Vehicle</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">Are you sure you want to delete <strong id="deleteVehicleName"></strong>?</div>
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
