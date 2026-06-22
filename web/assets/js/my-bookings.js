// My Bookings Page JS

document.addEventListener("DOMContentLoaded", () => {
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

  // DOM elements
  const loadingContainer = document.getElementById("bookings-loading-container");
  const mainContent = document.getElementById("bookings-main-content");
  const tableWrapper = document.getElementById("table-wrapper");
  const tbody = document.getElementById("bookings-tbody");
  const emptyState = document.getElementById("bookings-empty-state");

  // Cancellation Modal Setup
  const cancelModalEl = document.getElementById("cancelModal");
  const cancelModal = new bootstrap.Modal(cancelModalEl);
  const confirmCancelBtn = document.getElementById("confirm-cancel-btn");
  const modalVehicleName = document.getElementById("modal-vehicle-name");
  let activeBookingIdToCancel = null;

  // Render Table
  renderBookingsTable();

  // Reveal UI and hide loading spinner
  loadingContainer.classList.add("d-none");
  mainContent.classList.remove("d-none");

  // Render Logic
  function renderBookingsTable() {
    let bookings = [];
    if (localStorage.getItem("bookings")) {
      bookings = JSON.parse(localStorage.getItem("bookings"));
    }

    // Filter to current user
    const userBookings = bookings.filter(b => b.userEmail === currentUser.email);

    if (userBookings.length === 0) {
      tableWrapper.classList.add("d-none");
      emptyState.classList.remove("d-none");
      return;
    }

    tableWrapper.classList.remove("d-none");
    emptyState.classList.add("d-none");

    tbody.innerHTML = userBookings.map(b => {
      const isConfirmed = b.status === "Confirmed";
      
      const badgeClass = isConfirmed 
        ? "bg-success bg-opacity-10 text-success border border-success border-opacity-25" 
        : "bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25";
      
      const actionButtonHtml = isConfirmed
        ? `<button class="btn btn-danger btn-sm py-2 px-3 fw-semibold border-0 rounded-8 btn-cancel-trigger" data-id="${b.bookingId}" data-name="${b.vehicleName}">Cancel</button>`
        : `<button class="btn btn-secondary btn-sm py-2 px-3 fw-semibold border-0 rounded-8" disabled>Cancelled</button>`;

      return `
        <tr>
          <td>
            <span class="text-white fw-bold">${b.bookingId}</span>
            <div class="text-muted small" style="font-size: 0.75rem;">Created: ${b.createdAt || 'N/A'}</div>
          </td>
          <td>
            <div class="d-flex align-items-center gap-3">
              <img src="${b.image}" alt="${b.vehicleName}" style="width: 60px; height: 40px; object-fit: cover; border-radius: 6px; border: 1px solid var(--border-glass);">
              <span class="text-white fw-semibold">${b.vehicleName}</span>
            </div>
          </td>
          <td class="text-white-50 small">${b.pickupLocation}</td>
          <td>
            <div class="text-white font-weight-500 small">${b.pickupDate}</div>
            <div class="text-secondary small" style="font-size: 0.75rem;">to ${b.returnDate}</div>
          </td>
          <td class="text-info fw-bold">$${b.totalPrice}</td>
          <td>
            <span class="badge ${badgeClass} px-3 py-2 rounded-pill small">${b.status}</span>
          </td>
          <td class="text-end">
            ${actionButtonHtml}
          </td>
        </tr>
      `;
    }).join("");

    // Bind Event Listeners for Cancel Buttons
    document.querySelectorAll(".btn-cancel-trigger").forEach(btn => {
      btn.addEventListener("click", (e) => {
        activeBookingIdToCancel = btn.getAttribute("data-id");
        modalVehicleName.textContent = btn.getAttribute("data-name");
        cancelModal.show();
      });
    });
  }

  // Handle Confirmed Cancellation
  confirmCancelBtn.addEventListener("click", () => {
    if (!activeBookingIdToCancel) return;

    let bookings = JSON.parse(localStorage.getItem("bookings"));
    
    // Find and update status to 'Cancelled'
    bookings = bookings.map(b => {
      if (b.bookingId === activeBookingIdToCancel && b.userEmail === currentUser.email) {
        return { ...b, status: "Cancelled" };
      }
      return b;
    });

    localStorage.setItem("bookings", JSON.stringify(bookings));
    
    // Re-render
    renderBookingsTable();

    // Close Modal and notify
    cancelModal.hide();
    if (typeof showToast === "function") {
      showToast("Booking cancelled successfully.", "success");
    }

    activeBookingIdToCancel = null;
  });
});
