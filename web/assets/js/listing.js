// Listing Page JS

document.addEventListener("DOMContentLoaded", () => {
  if (typeof vehicles === "undefined") {
    console.error("Vehicle data is not loaded.");
    return;
  }

  // Get DOM elements
  const gridContainer = document.getElementById("vehicles-list-grid");
  const searchInput = document.getElementById("filter-search");
  const categoryCheckboxes = document.querySelectorAll(".filter-category");
  const priceSlider = document.getElementById("filter-price");
  const priceDisplay = document.getElementById("price-display");
  const sortSelect = document.getElementById("filter-sort");
  const resultsCount = document.getElementById("results-count");
  const resetBtn = document.getElementById("btn-reset-filters");

  // Parse URL Parameters on Init
  parseUrlParams();
  
  // Render Initial Grid
  renderListings();

  // Attach Event Listeners
  searchInput.addEventListener("input", renderListings);
  
  categoryCheckboxes.forEach(cb => {
    cb.addEventListener("change", renderListings);
  });

  priceSlider.addEventListener("input", (e) => {
    priceDisplay.textContent = `$${e.target.value}`;
    renderListings();
  });

  sortSelect.addEventListener("change", renderListings);
  
  resetBtn.addEventListener("click", () => {
    searchInput.value = "";
    categoryCheckboxes.forEach(cb => cb.checked = false);
    priceSlider.value = 500;
    priceDisplay.textContent = "$500";
    sortSelect.value = "default";
    renderListings();
  });

  // URL Parsing Helper
  function parseUrlParams() {
    const params = new URLSearchParams(window.location.search);
    
    // 1. Category Filter from URL
    const categoryParam = params.get("category");
    if (categoryParam) {
      categoryCheckboxes.forEach(cb => {
        if (cb.value.toLowerCase() === categoryParam.toLowerCase()) {
          cb.checked = true;
        }
      });
    }

    // 2. Budget Limit Filter from URL
    const budgetParam = params.get("budget");
    if (budgetParam) {
      const budgetValue = parseInt(budgetParam, 10);
      if (!isNaN(budgetValue)) {
        priceSlider.value = budgetValue;
        priceDisplay.textContent = `$${budgetValue}`;
      }
    }
  }

  // Filtering & Sorting & Rendering logic
  function renderListings() {
    const searchVal = searchInput.value.trim().toLowerCase();
    const checkedCategories = Array.from(categoryCheckboxes)
                                   .filter(cb => cb.checked)
                                   .map(cb => cb.value);
    const maxPrice = parseInt(priceSlider.value, 10);
    const sortVal = sortSelect.value;

    // Filter logic
    let filtered = vehicles.filter(car => {
      // Search match (brand or model or category)
      const matchesSearch = !searchVal || 
        car.brand.toLowerCase().includes(searchVal) || 
        car.model.toLowerCase().includes(searchVal) ||
        car.category.toLowerCase().includes(searchVal);

      // Category match
      const matchesCategory = checkedCategories.length === 0 || 
        checkedCategories.includes(car.category);

      // Budget limit match
      const matchesPrice = car.pricePerDay <= maxPrice;

      return matchesSearch && matchesCategory && matchesPrice;
    });

    // Sorting logic
    if (sortVal === "price-asc") {
      filtered.sort((a, b) => a.pricePerDay - b.pricePerDay);
    } else if (sortVal === "price-desc") {
      filtered.sort((a, b) => b.pricePerDay - a.pricePerDay);
    } else if (sortVal === "rating") {
      filtered.sort((a, b) => b.rating - a.rating);
    }

    // Update count
    resultsCount.textContent = filtered.length;

    // Render HTML
    if (filtered.length === 0) {
      gridContainer.innerHTML = `
        <div class="col-12">
          <div class="glass-panel p-5 text-center my-4">
            <i class="bi bi-exclamation-triangle text-info display-4 mb-3"></i>
            <h4 class="text-white fw-bold">No Vehicles Found</h4>
            <p class="text-secondary small mb-0">Try expanding your budget search, unchecking category filters, or using different keywords.</p>
          </div>
        </div>
      `;
      return;
    }

    gridContainer.innerHTML = filtered.map(car => {
      // Build features string (limit to top 2 features for card brevity)
      const topFeatures = car.features.slice(0, 2).join(" • ");
      
      return `
        <div class="col-md-6 col-lg-4">
          <div class="card card-premium h-100 shadow-sm">
            <div class="card-img-container">
              <span class="badge-category">${car.category}</span>
              <img src="${car.image}" class="card-img-top" alt="${car.brand} ${car.model}">
            </div>
            <div class="card-body p-4 d-flex flex-column">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h4 class="card-title fw-bold text-white mb-0 h5">${car.brand} ${car.model}</h4>
                <div class="text-warning small"><i class="bi bi-star-fill"></i> ${car.rating}</div>
              </div>
              <p class="text-secondary small mb-3 flex-grow-1">
                ${car.description.substring(0, 85)}...
              </p>
              <div class="text-info small mb-3 font-weight-500">
                <i class="bi bi-check2-circle me-1"></i> ${topFeatures}
              </div>
              <div class="d-flex gap-2 mb-4 flex-wrap">
                <span class="spec-badge"><i class="bi bi-gear-fill"></i> ${car.transmission.substring(0,4)}</span>
                <span class="spec-badge"><i class="bi bi-fuel-pump-fill"></i> ${car.fuel}</span>
                <span class="spec-badge"><i class="bi bi-people-fill"></i> ${car.seats} Seats</span>
              </div>
              <div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-10 pt-3">
                <div>
                  <span class="text-info fw-bold h4">$${car.pricePerDay}</span>
                  <span class="text-muted small">/ day</span>
                </div>
                <a href="details.html?id=${car.id}" class="btn btn-premium-outline btn-sm">View Details</a>
              </div>
            </div>
          </div>
        </div>
      `;
    }).join("");
  }
});
