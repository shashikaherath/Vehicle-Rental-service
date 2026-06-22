// Details Page JS

document.addEventListener("DOMContentLoaded", () => {
  if (typeof vehicles === "undefined") {
    console.error("Vehicle data is not loaded.");
    return;
  }

  // Get DOM containers
  const loadingContainer = document.getElementById("details-loading-container");
  const mainContent = document.getElementById("details-main-content");
  
  // Parse URL ID
  const params = new URLSearchParams(window.location.search);
  const carId = parseInt(params.get("id"), 10);

  if (isNaN(carId)) {
    renderErrorState("No vehicle ID specified.");
    return;
  }

  // Find matching car
  const car = vehicles.find(v => v.id === carId);
  if (!car) {
    renderErrorState("We couldn't find the vehicle you're looking for.");
    return;
  }

  // Populating values
  document.getElementById("breadcrumb-car-name").textContent = `${car.brand} ${car.model}`;
  
  const imgElement = document.getElementById("detail-image");
  imgElement.src = car.image;
  imgElement.alt = `${car.brand} ${car.model}`;

  document.getElementById("detail-category").textContent = car.category;
  document.getElementById("detail-rating").textContent = car.rating;
  document.getElementById("detail-title").textContent = `${car.brand} ${car.model}`;
  document.getElementById("detail-description").textContent = car.description;
  
  document.getElementById("spec-transmission").textContent = car.transmission;
  document.getElementById("spec-fuel").textContent = car.fuel;
  document.getElementById("spec-seats").textContent = `${car.seats} Seats`;
  document.getElementById("spec-price-rank").textContent = car.pricePerDay > 200 ? "Exclusive" : "Standard";
  
  document.getElementById("detail-price").textContent = `$${car.pricePerDay}`;

  // Populating Features Checklist
  const featuresList = document.getElementById("detail-features-list");
  featuresList.innerHTML = car.features.map(feat => `
    <div class="col-sm-6">
      <div class="d-flex align-items-center gap-2 text-white-50 small mb-2">
        <i class="bi bi-check-lg text-info"></i>
        <span>${feat}</span>
      </div>
    </div>
  `).join("");

  // Reveal UI and hide loading spinner
  loadingContainer.classList.add("d-none");
  mainContent.classList.remove("d-none");

  // Handle Book Now Click
  const bookBtn = document.getElementById("btn-book-now");
  if (bookBtn) {
    bookBtn.addEventListener("click", () => {
      const currentUserJson = localStorage.getItem("currentUser");
      
      if (!currentUserJson) {
        if (typeof showToast === "function") {
          showToast("Please log in to make a booking.", "error");
        }
        setTimeout(() => {
          // Redirect to login page
          window.location.href = `login.html`;
        }, 1500);
      } else {
        // Direct to Booking form with ID
        window.location.href = `booking.html?id=${car.id}`;
      }
    });
  }

  // Error state helper
  function renderErrorState(message) {
    loadingContainer.innerHTML = `
      <div class="glass-panel p-5 text-center my-4">
        <i class="bi bi-exclamation-triangle-fill text-danger display-3 mb-3"></i>
        <h3 class="text-white fw-bold">Vehicle Not Found</h3>
        <p class="text-secondary small mb-4">${message}</p>
        <a href="listing.html" class="btn btn-premium-primary"><i class="bi bi-arrow-left me-2"></i> Back to Fleet</a>
      </div>
    `;
  }
});
