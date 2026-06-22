// Booking Page JS

document.addEventListener("DOMContentLoaded", () => {
  if (typeof vehicles === "undefined") {
    console.error("Vehicle data is not loaded.");
    return;
  }

  // Get DOM containers
  const loadingContainer = document.getElementById("booking-loading-container");
  const mainContent = document.getElementById("booking-main-content");
  
  // 1. Session Auth Guard
  const currentUserJson = localStorage.getItem("currentUser");
  if (!currentUserJson) {
    if (typeof showToast === "function") {
      showToast("Access Denied. Redirecting to Login...", "error");
    }
    setTimeout(() => {
      window.location.href = "login.html";
    }, 1500);
    return;
  }

  const currentUser = JSON.parse(currentUserJson);

  // 2. Parse Vehicle ID
  const params = new URLSearchParams(window.location.search);
  const carId = parseInt(params.get("id"), 10);

  if (isNaN(carId)) {
    if (typeof showToast === "function") {
      showToast("Invalid booking request. Redirecting...", "error");
    }
    setTimeout(() => {
      window.location.href = "listing.html";
    }, 1500);
    return;
  }

  // Find matching car
  const car = vehicles.find(v => v.id === carId);
  if (!car) {
    if (typeof showToast === "function") {
      showToast("Vehicle not found. Redirecting...", "error");
    }
    setTimeout(() => {
      window.location.href = "listing.html";
    }, 1500);
    return;
  }

  // 3. Populate Driver & Vehicle Info
  document.getElementById("driver-name").value = currentUser.name;
  document.getElementById("driver-phone").value = currentUser.phone || "+1 (555) 123-4567";

  document.getElementById("booking-card-category").textContent = car.category;
  
  const imgElement = document.getElementById("booking-card-image");
  imgElement.src = car.image;
  imgElement.alt = `${car.brand} ${car.model}`;

  document.getElementById("booking-card-title").textContent = `${car.brand} ${car.model}`;
  document.getElementById("booking-card-rating").textContent = car.rating;
  document.getElementById("booking-card-rate").textContent = `$${car.pricePerDay}/day`;

  // Initialize date fields (Minimum pickup date is today)
  const pickupInput = document.getElementById("booking-pickup-date");
  const returnInput = document.getElementById("booking-return-date");
  
  // Set date limits
  const todayStr = "2026-06-20";
  pickupInput.min = todayStr;
  returnInput.min = todayStr;

  // Reveal UI and hide loading spinner
  loadingContainer.classList.add("d-none");
  mainContent.classList.remove("d-none");

  // 4. Live Billing Calculations
  function calculateTotal() {
    const pickupDateVal = pickupInput.value;
    const returnDateVal = returnInput.value;

    if (!pickupDateVal || !returnDateVal) {
      resetBillingDetails();
      return;
    }

    const pickupDate = new Date(pickupDateVal);
    const returnDate = new Date(returnDateVal);

    if (returnDate < pickupDate) {
      document.getElementById("booking-return-date").classList.add("is-invalid");
      document.getElementById("return-date-feedback").textContent = "Return date cannot be before pickup date.";
      resetBillingDetails();
      return;
    } else {
      document.getElementById("booking-return-date").classList.remove("is-invalid");
    }

    // Calculate diff in days
    const diffTime = Math.abs(returnDate - pickupDate);
    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays === 0) diffDays = 1; // Minimum 1-day rental

    // Financial formulas
    const subtotal = diffDays * car.pricePerDay;
    const tax = subtotal * 0.10; // 10% tax rate
    const total = subtotal + tax;

    // Inject to DOM
    document.getElementById("billing-days").textContent = `${diffDays} ${diffDays === 1 ? 'day' : 'days'}`;
    document.getElementById("billing-subtotal").textContent = `$${subtotal.toFixed(2)}`;
    document.getElementById("billing-tax").textContent = `$${tax.toFixed(2)}`;
    document.getElementById("billing-total").textContent = `$${total.toFixed(2)}`;
  }

  function resetBillingDetails() {
    document.getElementById("billing-days").textContent = "0 days";
    document.getElementById("billing-subtotal").textContent = "$0.00";
    document.getElementById("billing-tax").textContent = "$0.00";
    document.getElementById("billing-total").textContent = "$0.00";
  }

  // Bind calculation events
  pickupInput.addEventListener("change", () => {
    // When pickup changes, update return date minimum constraint
    if (pickupInput.value) {
      returnInput.min = pickupInput.value;
    }
    calculateTotal();
  });
  returnInput.addEventListener("change", calculateTotal);

  // 5. Form Submit Handler
  const bookingForm = document.getElementById("booking-form");
  bookingForm.addEventListener("submit", (e) => {
    e.preventDefault();

    const locationVal = document.getElementById("booking-location").value;
    const pickupVal = pickupInput.value;
    const returnVal = returnInput.value;
    const commentsVal = document.getElementById("booking-comments").value;

    let isValid = true;

    // Validation
    if (!locationVal) {
      document.getElementById("booking-location").classList.add("is-invalid");
      isValid = false;
    } else {
      document.getElementById("booking-location").classList.remove("is-invalid");
    }

    if (!pickupVal) {
      pickupInput.classList.add("is-invalid");
      isValid = false;
    } else {
      pickupInput.classList.remove("is-invalid");
    }

    if (!returnVal) {
      returnInput.classList.add("is-invalid");
      isValid = false;
    } else {
      const returnDate = new Date(returnVal);
      const pickupDate = new Date(pickupVal);
      if (pickupVal && returnDate < pickupDate) {
        returnInput.classList.add("is-invalid");
        isValid = false;
      } else {
        returnInput.classList.remove("is-invalid");
      }
    }

    if (!isValid) return;

    // Double check dates to get valid duration count
    const pickupDate = new Date(pickupVal);
    const returnDate = new Date(returnVal);
    const diffTime = Math.abs(returnDate - pickupDate);
    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays === 0) diffDays = 1;

    const subtotal = diffDays * car.pricePerDay;
    const tax = subtotal * 0.10;
    const total = subtotal + tax;

    // Create Simulated Booking Record
    const newBooking = {
      bookingId: "BK-" + Math.floor(100000 + Math.random() * 900000),
      userEmail: currentUser.email,
      vehicleId: car.id,
      vehicleName: `${car.brand} ${car.model}`,
      image: car.image,
      pickupLocation: locationVal,
      pickupDate: pickupVal,
      returnDate: returnVal,
      totalPrice: total.toFixed(2),
      status: "Confirmed",
      comments: commentsVal,
      createdAt: new Date().toISOString().split("T")[0]
    };

    // Save Booking via EliteStore (shared with admin dashboard)
    EliteStore.addBooking(newBooking);

    if (typeof showToast === "function") {
      showToast("Booking authorized! Booking reference: " + newBooking.bookingId, "success");
    }

    setTimeout(() => {
      // Redirect to Booking History
      window.location.href = "my-bookings.html";
    }, 1500);
  });
});
