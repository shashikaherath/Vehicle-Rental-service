// Shared Application JavaScript

document.addEventListener("DOMContentLoaded", () => {
  initNavbarScroll();
  updateNavbarAuth();
  highlightActiveLink();
});

// 1. Dynamic Navbar Scroll Effect
function initNavbarScroll() {
  const navbar = document.querySelector(".navbar-premium");
  if (navbar) {
    window.addEventListener("scroll", () => {
      if (window.scrollY > 50) {
        navbar.classList.add("scrolled");
      } else {
        navbar.classList.remove("scrolled");
      }
    });
  }
}

// 2. Authentication State and Navbar Update
function updateNavbarAuth() {
  const currentUserJson = localStorage.getItem("currentUser");
  const authContainer = document.getElementById("navbar-auth-section");

  if (!authContainer) return;

  if (currentUserJson) {
    const currentUser = JSON.parse(currentUserJson);
    authContainer.innerHTML = `
      <li class="nav-item">
        <a class="nav-link nav-link-premium" href="my-bookings.html">My Bookings</a>
      </li>
      <li class="nav-item d-flex align-items-center ms-lg-3 mt-2 mt-lg-0">
        <span class="text-white me-3 font-weight-500">Hello, ${currentUser.name}</span>
        <button onclick="handleLogout()" class="btn btn-premium-outline py-2 px-3">Logout</button>
      </li>
    `;
  } else {
    authContainer.innerHTML = `
      <li class="nav-item">
        <a class="nav-link nav-link-premium" href="login.html">Login</a>
      </li>
    `;
  }
}

// 3. Handle Logout Action
function handleLogout() {
  localStorage.removeItem("currentUser");
  showToast("Logged out successfully!", "info");
  setTimeout(() => {
    window.location.href = "index.html";
  }, 1000);
}

// 4. Highlight Active Navigation Links
function highlightActiveLink() {
  const currentPath = window.location.pathname.split("/").pop();
  const navLinks = document.querySelectorAll(".nav-link-premium");

  navLinks.forEach(link => {
    const linkPath = link.getAttribute("href");
    if (currentPath === linkPath || (currentPath === "" && linkPath === "index.html")) {
      link.classList.add("active");
    } else {
      link.classList.remove("active");
    }
  });
}

// 5. Toast Notification Helper
function showToast(message, type = "success") {
  // Ensure the toast container exists
  let toastContainer = document.getElementById("toast-container-custom");
  if (!toastContainer) {
    toastContainer = document.createElement("div");
    toastContainer.id = "toast-container-custom";
    toastContainer.className = "toast-container-custom";
    document.body.appendChild(toastContainer);
  }

  // Create unique Toast Element
  const toastId = "toast_" + Date.now();
  const toastHtml = `
    <div id="${toastId}" class="toast toast-premium show" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="4000">
      <div class="toast-header bg-transparent border-bottom-0 text-white d-flex justify-content-between align-items-center">
        <strong class="me-auto d-flex align-items-center gap-2">
          <span class="spinner-grow spinner-grow-sm text-${type === "success" ? "info" : "danger"}" role="status" aria-hidden="true"></span>
          ${type === "success" ? "Success" : type === "error" ? "Error" : "Notification"}
        </strong>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
      <div class="toast-body text-white-50">
        ${message}
      </div>
    </div>
  `;

  toastContainer.insertAdjacentHTML("beforeend", toastHtml);

  // Remove toast after delay
  const toastElement = document.getElementById(toastId);
  setTimeout(() => {
    if (toastElement) {
      toastElement.classList.add("fade");
      setTimeout(() => toastElement.remove(), 500);
    }
  }, 4000);
}

// Global exposure for event handlers in HTML
window.handleLogout = handleLogout;
window.showToast = showToast;
window.updateNavbarAuth = updateNavbarAuth;
