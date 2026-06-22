<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.VehicleDAO" %>
<%@ page import="model.Vehicle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    VehicleDAO vehicleDAO = new VehicleDAO();
    
    // Check if we should render Detail View instead of Listing Catalog
    String detailsIdStr = request.getParameter("id");
    Vehicle detailVehicle = null;
    if (detailsIdStr != null && !detailsIdStr.isEmpty()) {
        try {
            detailVehicle = vehicleDAO.getVehicleById(Integer.parseInt(detailsIdStr));
        } catch(NumberFormatException e) {
            // ignore
        }
    }

    // Listing Filter parameters
    String selectedCategory = request.getParameter("category");
    String maxBudgetStr = request.getParameter("budget");
    double maxBudget = 500.0;
    if (maxBudgetStr != null && !maxBudgetStr.isEmpty()) {
        try {
            maxBudget = Double.parseDouble(maxBudgetStr);
        } catch(NumberFormatException e) {
            // ignore
        }
    }

    List<Vehicle> allVehicles = vehicleDAO.getAllVehicles();
    List<Vehicle> filteredVehicles = new ArrayList<>();
    for (Vehicle v : allVehicles) {
        boolean matchCat = (selectedCategory == null || selectedCategory.isEmpty() || v.getCategory().equalsIgnoreCase(selectedCategory));
        boolean matchPrice = (v.getPricePerDay() <= maxBudget);
        if (matchCat && matchPrice) {
            filteredVehicles.add(v);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= (detailVehicle != null) ? detailVehicle.getBrand() + " " + detailVehicle.getModel() : "Explore Vehicles" %> | EliteDrive</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <% if (detailVehicle != null) { %>
    <!-- ═══ DETAILED VIEW PAGE ═══ -->
    <main class="py-5 mt-5" style="background: var(--bg-primary);">
      <div class="container py-4 mt-3">
        <div class="row g-5">
          <!-- Image -->
          <div class="col-lg-6">
            <div class="card card-premium overflow-hidden border border-secondary border-opacity-10">
              <img src="<%= detailVehicle.getImage() %>" class="img-fluid" alt="<%= detailVehicle.getBrand() %> <%= detailVehicle.getModel() %>" style="width: 100%; object-fit: cover;">
            </div>
          </div>
          <!-- Vehicle details -->
          <div class="col-lg-6">
            <div class="d-flex align-items-center gap-2 mb-2">
              <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-3 py-1.5 rounded-pill text-uppercase fw-semibold"><%= detailVehicle.getCategory() %></span>
              <span class="text-warning small"><i class="bi bi-star-fill"></i> <%= detailVehicle.getRating() %></span>
            </div>
            <h1 class="display-5 fw-bold text-white mb-3"><%= detailVehicle.getBrand() %> <%= detailVehicle.getModel() %></h1>
            <h3 class="text-info fw-bold mb-4">$<%= (int)detailVehicle.getPricePerDay() %> <span class="fs-5 text-muted fw-normal">/ day</span></h3>

            <p class="text-secondary mb-4 fs-6 leading-relaxed">
              <%= detailVehicle.getDescription() %>
            </p>

            <div class="row g-3 mb-5">
              <div class="col-6 col-sm-4">
                <div class="spec-badge py-3 text-center d-block">
                  <i class="bi bi-gear-fill text-info fs-4 d-block mb-1"></i>
                  <span class="text-muted small">Transmission</span>
                  <div class="text-white fw-bold"><%= detailVehicle.getTransmission() %></div>
                </div>
              </div>
              <div class="col-6 col-sm-4">
                <div class="spec-badge py-3 text-center d-block">
                  <i class="bi bi-fuel-pump-fill text-info fs-4 d-block mb-1"></i>
                  <span class="text-muted small">Fuel Type</span>
                  <div class="text-white fw-bold"><%= detailVehicle.getFuel() %></div>
                </div>
              </div>
              <div class="col-6 col-sm-4">
                <div class="spec-badge py-3 text-center d-block">
                  <i class="bi bi-people-fill text-info fs-4 d-block mb-1"></i>
                  <span class="text-muted small">Seats</span>
                  <div class="text-white fw-bold"><%= detailVehicle.getSeats() %> Persons</div>
                </div>
              </div>
            </div>

            <div class="d-flex gap-3 flex-wrap">
              <a href="booking.jsp?vehicleId=<%= detailVehicle.getId() %>" class="btn btn-premium-primary px-5 py-3">Book This Ride Now</a>
              <a href="vehicles.jsp" class="btn btn-premium-outline px-4 py-3"><i class="bi bi-arrow-left me-2"></i> Back to Listing</a>
            </div>
          </div>
        </div>
      </div>
    </main>
  <% } else { %>
    <!-- ═══ CATALOG LISTING PAGE ═══ -->
    <header class="py-5 mt-5" style="background: linear-gradient(180deg, rgba(99, 102, 241, 0.05) 0%, var(--bg-primary) 100%);">
      <div class="container py-4 mt-3">
        <h1 class="section-title-gradient fw-bold display-5">Explore Our Premium Fleet</h1>
        <p class="text-secondary mb-0">Choose from cars, vans, motorbikes, scooters, buses, lorries, trucks, and boats — one fleet for every journey.</p>
      </div>
    </header>

    <main class="container py-5">
      <div class="row g-4">
        <!-- Sidebar Filters -->
        <div class="col-lg-3">
          <div class="card card-premium p-4 sticky-top" style="top: 100px;">
            <h4 class="fw-bold text-white mb-4">Filter Options</h4>
            <form action="vehicles.jsp" method="GET">
              <!-- Category -->
              <div class="mb-4">
                <label class="form-label text-secondary small">Vehicle Category</label>
                <select name="category" class="form-select form-control-premium">
                  <option value="" <%= (selectedCategory==null || selectedCategory.isEmpty()) ? "selected" : "" %>>All Types</option>
                  <option value="Car" <%= "Car".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Cars</option>
                  <option value="Van" <%= "Van".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Vans</option>
                  <option value="Motorbike" <%= "Motorbike".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Motorbikes</option>
                  <option value="Scooter" <%= "Scooter".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Scooters</option>
                  <option value="Bus" <%= "Bus".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Buses</option>
                  <option value="Lorry" <%= "Lorry".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Lorries</option>
                  <option value="Truck" <%= "Truck".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Trucks</option>
                  <option value="Boat" <%= "Boat".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Boats</option>
                </select>
              </div>

              <!-- Budget -->
              <div class="mb-4">
                <label class="form-label text-secondary small">Max Price Per Day: $<span id="budgetValue"><%= (int)maxBudget %></span></label>
                <input type="range" name="budget" class="form-range" min="30" max="500" step="10" value="<%= (int)maxBudget %>" oninput="document.getElementById('budgetValue').textContent=this.value">
              </div>

              <button type="submit" class="btn btn-premium-primary w-100 py-2.5 mb-2">Apply Filters</button>
              <a href="vehicles.jsp" class="btn btn-premium-outline w-100 py-2.5">Clear All</a>
            </form>
          </div>
        </div>

        <!-- Grid Listings -->
        <div class="col-lg-9">
          <% if (filteredVehicles.isEmpty()) { %>
            <div class="text-center py-5">
              <i class="bi bi-exclamation-circle text-muted display-4 mb-3 d-block"></i>
              <h4 class="text-secondary fw-semibold">No vehicles match your criteria.</h4>
              <p class="text-muted small">Try adjusting your filters or search options.</p>
            </div>
          <% } else { %>
            <div class="row g-4">
              <% for (Vehicle v : filteredVehicles) { %>
                <div class="col-md-6 col-xl-4">
                  <div class="card card-premium h-100">
                    <div class="card-img-container">
                      <span class="badge-category"><%= v.getCategory() %></span>
                      <img src="<%= v.getImage() %>" class="card-img-top" alt="<%= v.getBrand() %> <%= v.getModel() %>">
                    </div>
                    <div class="card-body p-4 d-flex flex-column">
                      <div class="d-flex justify-content-between align-items-center mb-2">
                        <h4 class="card-title fw-bold text-white mb-0 h6"><%= v.getBrand() %> <%= v.getModel() %></h4>
                        <div class="text-warning small"><i class="bi bi-star-fill"></i> <%= v.getRating() %></div>
                      </div>
                      <p class="text-secondary small mb-4 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                        <%= v.getDescription() %>
                      </p>
                      <div class="d-flex gap-2 mb-4 flex-wrap">
                        <span class="spec-badge"><i class="bi bi-gear-fill"></i> <%= v.getTransmission() %></span>
                        <span class="spec-badge"><i class="bi bi-people-fill"></i> <%= v.getSeats() %> Seats</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-10 pt-3">
                        <div>
                          <span class="text-info fw-bold h5">$<%= (int)v.getPricePerDay() %></span>
                          <span class="text-muted small">/ day</span>
                        </div>
                        <a href="vehicles.jsp?id=<%= v.getId() %>" class="btn btn-premium-outline btn-sm">View Details</a>
                      </div>
                    </div>
                  </div>
                </div>
              <% } %>
            </div>
          <% } %>
        </div>
      </div>
    </main>
  <% } %>

  <%@ include file="footer.jsp" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
