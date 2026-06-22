<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EliteDrive | Premium Vehicle Rental Service</title>
  <meta name="description" content="Rent your dream vehicle with EliteDrive. Discover premium luxury sedans, electric supercars, and family SUVs at unbeatable rates.">
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <!-- Hero Section -->
  <header class="hero-section">
    <div class="hero-overlay"></div>
    <div class="container position-relative z-1">
      <div class="row align-items-center">
        <div class="col-lg-6 mb-5 mb-lg-0">
          <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-3 py-2 rounded-pill mb-3 text-uppercase fw-semibold tracking-wider" style="font-size: 0.8rem;">
            Discover the Elite Experience
          </span>
          <h1 class="hero-title mb-4">Rent Your<br>Dream Vehicle</h1>
          <p class="hero-subtitle mb-4">
            Uncompromising quality, seamless booking, and a curated fleet of premium, high-performance vehicles waiting for your command.
          </p>
          <div class="d-flex gap-3 flex-wrap">
            <a href="vehicles.jsp" class="btn btn-premium-primary">Explore Fleet <i class="bi bi-arrow-right ms-2"></i></a>
            <a href="about.jsp" class="btn btn-premium-secondary">Learn More</a>
          </div>
        </div>
        <!-- Search widget -->
        <div class="col-lg-6 col-xl-5 offset-xl-1">
          <div class="card-premium p-4 shadow-lg">
            <h3 class="fw-bold mb-3 section-title-gradient h4">Find Your Perfect Drive</h3>
            <form id="hero-search-form" action="vehicles.jsp" method="GET">
              <div class="mb-3">
                <label class="form-label text-secondary small">Vehicle Category</label>
                <select name="category" class="form-select form-control-premium">
                  <option value="">All Vehicle Types</option>
                  <option value="Car">Cars</option>
                  <option value="Van">Vans</option>
                  <option value="Motorbike">Motorbikes</option>
                  <option value="Scooter">Scooters</option>
                  <option value="Bus">Buses</option>
                  <option value="Lorry">Lorries</option>
                  <option value="Truck">Trucks</option>
                  <option value="Boat">Boats</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label text-secondary small">Max Daily Budget ($)</label>
                <select name="budget" class="form-select form-control-premium">
                  <option value="">No Budget Limit</option>
                  <option value="50">Under $50/day</option>
                  <option value="150">Under $150/day</option>
                  <option value="300">Under $300/day</option>
                  <option value="500">Under $500/day</option>
                </select>
              </div>
              <div class="mb-4">
                <label class="form-label text-secondary small">Desired Rental Date</label>
                <input type="date" class="form-control form-control-premium" required min="2026-06-20">
              </div>
              <button type="submit" class="btn btn-premium-primary w-100 py-3">
                <i class="bi bi-search me-2"></i> Search Availability
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </header>

  <!-- Featured Vehicles Section -->
  <section class="py-5" style="background: var(--bg-primary);">
    <div class="container py-4">
      <div class="d-flex justify-content-between align-items-end mb-5">
        <div>
          <span class="text-info fw-bold text-uppercase small tracking-wider">Top Selections</span>
          <h2 class="section-title-gradient mb-0 h1 mt-1">Featured Vehicles</h2>
        </div>
        <a href="vehicles.jsp" class="btn btn-premium-outline">View All Fleet <i class="bi bi-arrow-right ms-1"></i></a>
      </div>

      <div class="row g-4" id="featured-vehicles-grid">
        <!-- Vehicle 1: Aether Spectre S (Car) -->
        <div class="col-md-6 col-lg-4">
          <div class="card card-premium h-100">
            <div class="card-img-container">
              <span class="badge-category">Car</span>
              <img src="assets/images/car.jpg" class="card-img-top" alt="Aether Spectre S">
            </div>
            <div class="card-body p-4 d-flex flex-column">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h4 class="card-title fw-bold text-white mb-0 h5">Aether Spectre S</h4>
                <div class="text-warning small"><i class="bi bi-star-fill"></i> 4.9</div>
              </div>
              <p class="text-secondary small mb-4 flex-grow-1">
                The Aether Spectre S defines modern executive luxury. Silent hybrid drive and hand-stitched leather details.
              </p>
              <div class="d-flex gap-2 mb-4 flex-wrap">
                <span class="spec-badge"><i class="bi bi-gear-fill"></i> Auto</span>
                <span class="spec-badge"><i class="bi bi-fuel-pump-fill"></i> Hybrid</span>
                <span class="spec-badge"><i class="bi bi-people-fill"></i> 5 Seats</span>
              </div>
              <div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-10 pt-3">
                <div>
                  <span class="text-info fw-bold h4">$250</span>
                  <span class="text-muted small">/ day</span>
                </div>
                <a href="vehicles.jsp?id=1" class="btn btn-premium-outline btn-sm">View Details</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Vehicle 2: ThunderRide Storm 750 (Motorbike) -->
        <div class="col-md-6 col-lg-4">
          <div class="card card-premium h-100">
            <div class="card-img-container">
              <span class="badge-category">Motorbike</span>
              <img src="assets/images/motorbike.jpg" class="card-img-top" alt="ThunderRide Storm 750">
            </div>
            <div class="card-body p-4 d-flex flex-column">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h4 class="card-title fw-bold text-white mb-0 h5">ThunderRide Storm 750</h4>
                <div class="text-warning small"><i class="bi bi-star-fill"></i> 4.85</div>
              </div>
              <p class="text-secondary small mb-4 flex-grow-1">
                A naked street bike with an aggressive parallel-twin engine and razor-sharp chassis for thrilling urban riding.
              </p>
              <div class="d-flex gap-2 mb-4 flex-wrap">
                <span class="spec-badge"><i class="bi bi-gear-fill"></i> Manual</span>
                <span class="spec-badge"><i class="bi bi-fuel-pump-fill"></i> Petrol</span>
                <span class="spec-badge"><i class="bi bi-people-fill"></i> 2 Seats</span>
              </div>
              <div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-10 pt-3">
                <div>
                  <span class="text-info fw-bold h4">$75</span>
                  <span class="text-muted small">/ day</span>
                </div>
                <a href="vehicles.jsp?id=5" class="btn btn-premium-outline btn-sm">View Details</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Vehicle 3: AquaLux Riviera 28 (Boat) -->
        <div class="col-md-6 col-lg-4">
          <div class="card card-premium h-100">
            <div class="card-img-container">
              <span class="badge-category">Boat</span>
              <img src="assets/images/boat.jpg" class="card-img-top" alt="AquaLux Riviera 28">
            </div>
            <div class="card-body p-4 d-flex flex-column">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h4 class="card-title fw-bold text-white mb-0 h5">AquaLux Riviera 28</h4>
                <div class="text-warning small"><i class="bi bi-star-fill"></i> 4.9</div>
              </div>
              <p class="text-secondary small mb-4 flex-grow-1">
                An elegant day cruiser with plush sun loungers, built-in cooler, and a powerful inboard engine.
              </p>
              <div class="d-flex gap-2 mb-4 flex-wrap">
                <span class="spec-badge"><i class="bi bi-fuel-pump-fill"></i> Petrol</span>
                <span class="spec-badge"><i class="bi bi-gear-fill"></i> Auto</span>
                <span class="spec-badge"><i class="bi bi-people-fill"></i> 8 Seats</span>
              </div>
              <div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-10 pt-3">
                <div>
                  <span class="text-info fw-bold h4">$450</span>
                  <span class="text-muted small">/ day</span>
                </div>
                <a href="vehicles.jsp?id=15" class="btn btn-premium-outline btn-sm">View Details</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Services Section -->
  <section class="py-5" style="background: var(--bg-secondary); border-top: 1px solid var(--border-glass);">
    <div class="container py-4">
      <div class="text-center mb-5">
        <span class="text-info fw-bold text-uppercase small tracking-wider">Our Services</span>
        <h2 class="section-title-gradient h1 mt-1">Why Choose EliteDrive</h2>
        <p class="text-secondary mx-auto mt-2" style="max-width: 600px;">
          We go beyond standard car rentals. Enjoy premium features and a custom customer service journey built for discerning drivers.
        </p>
      </div>

      <div class="row g-4">
        <!-- Service 1 -->
        <div class="col-md-6 col-lg-3">
          <div class="card card-premium service-card h-100">
            <div class="service-icon-wrapper">
              <i class="bi bi-shield-check"></i>
            </div>
            <h4 class="fw-bold text-white h5">Premium Insurance</h4>
            <p class="text-secondary small mb-0">
              Drive with total peace of mind. Every rental features comprehensive premium damage coverage with zero deductible.
            </p>
          </div>
        </div>

        <!-- Service 2 -->
        <div class="col-md-6 col-lg-3">
          <div class="card card-premium service-card h-100">
            <div class="service-icon-wrapper">
              <i class="bi bi-geo-alt"></i>
            </div>
            <h4 class="fw-bold text-white h5">Airport Delivery</h4>
            <p class="text-secondary small mb-0">
              Walk off your flight directly to your luxury vehicle. We deliver straight to terminal doors or private VIP lots.
            </p>
          </div>
        </div>

        <!-- Service 3 -->
        <div class="col-md-6 col-lg-3">
          <div class="card card-premium service-card h-100">
            <div class="service-icon-wrapper">
              <i class="bi bi-telephone-outbound"></i>
            </div>
            <h4 class="fw-bold text-white h5">24/7 Roadside Assist</h4>
            <p class="text-secondary small mb-0">
              No matter the hour, our roadside support squad is standing by to resolve mechanical issues or dispatch alternative cars.
            </p>
          </div>
        </div>

        <!-- Service 4 -->
        <div class="col-md-6 col-lg-3">
          <div class="card card-premium service-card h-100">
            <div class="service-icon-wrapper">
              <i class="bi bi-calendar-event"></i>
            </div>
            <h4 class="fw-bold text-white h5">Flexible Bookings</h4>
            <p class="text-secondary small mb-0">
              Plans change, and we understand. Enjoy penalty-free adjustments or cancellations up to 24 hours before your trip.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="footer.jsp" %>

  <!-- Bootstrap 5 Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <!-- Global App JS -->
  <script src="assets/js/app.js"></script>
</body>
</html>
