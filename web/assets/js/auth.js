// Authentication JS (Login and Register handlers)

document.addEventListener("DOMContentLoaded", () => {
  const loginForm = document.getElementById("login-form");
  const registerForm = document.getElementById("register-form");

  // Initialize simulated database in localStorage if empty
  if (!localStorage.getItem("registeredUsers")) {
    localStorage.setItem("registeredUsers", JSON.stringify([]));
  }

  // Handle Login Submission
  if (loginForm) {
    loginForm.addEventListener("submit", (e) => {
      e.preventDefault();
      
      const email = document.getElementById("login-email").value.trim();
      const password = document.getElementById("login-password").value;

      let isValid = true;

      // Basic Bootstrap validation styling
      if (!email || !validateEmail(email)) {
        document.getElementById("login-email").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("login-email").classList.remove("is-invalid");
      }

      if (!password) {
        document.getElementById("login-password").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("login-password").classList.remove("is-invalid");
      }

      if (!isValid) return;

      // Admin check
      if (email === "admin@elitedrive.com" && password === "admin123") {
        localStorage.setItem("isAdminLoggedIn", "true");
        if (typeof showToast === "function") {
          showToast("Welcome back, Administrator!", "success");
        }
        setTimeout(() => {
          window.location.href = "admin/index.html";
        }, 1500);
        return;
      }

      // Simulated Authentication check
      const users = JSON.parse(localStorage.getItem("registeredUsers"));
      const user = users.find(u => u.email === email && u.password === password);

      if (user) {
        // Successful login
        localStorage.setItem("currentUser", JSON.stringify({
          name: user.name,
          email: user.email,
          phone: user.phone
        }));

        if (typeof showToast === "function") {
          showToast(`Welcome back, ${user.name}!`, "success");
        }

        setTimeout(() => {
          // Redirect to my-bookings page or homepage
          window.location.href = "index.html";
        }, 1500);
      } else {
        // Failed login
        if (typeof showToast === "function") {
          showToast("Invalid email or password.", "error");
        }
        document.getElementById("login-email").classList.add("is-invalid");
        document.getElementById("login-password").classList.add("is-invalid");
      }
    });
  }

  // Handle Register Submission
  if (registerForm) {
    registerForm.addEventListener("submit", (e) => {
      e.preventDefault();

      const name = document.getElementById("reg-name").value.trim();
      const email = document.getElementById("reg-email").value.trim();
      const phone = document.getElementById("reg-phone").value.trim();
      const password = document.getElementById("reg-password").value;
      const confirmPassword = document.getElementById("reg-confirm").value;

      let isValid = true;

      if (!name) {
        document.getElementById("reg-name").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("reg-name").classList.remove("is-invalid");
      }

      if (!email || !validateEmail(email)) {
        document.getElementById("reg-email").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("reg-email").classList.remove("is-invalid");
      }

      if (!phone) {
        document.getElementById("reg-phone").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("reg-phone").classList.remove("is-invalid");
      }

      if (!password || password.length < 6) {
        document.getElementById("reg-password").classList.add("is-invalid");
        isValid = false;
      } else {
        document.getElementById("reg-password").classList.remove("is-invalid");
      }

      const confirmFeedback = document.getElementById("confirm-feedback");
      if (!confirmPassword) {
        document.getElementById("reg-confirm").classList.add("is-invalid");
        confirmFeedback.textContent = "Please confirm your password.";
        isValid = false;
      } else if (password !== confirmPassword) {
        document.getElementById("reg-confirm").classList.add("is-invalid");
        confirmFeedback.textContent = "Passwords do not match.";
        isValid = false;
      } else {
        document.getElementById("reg-confirm").classList.remove("is-invalid");
      }

      if (!isValid) return;

      const users = JSON.parse(localStorage.getItem("registeredUsers"));
      
      // Check if user already exists
      if (users.some(u => u.email === email)) {
        if (typeof showToast === "function") {
          showToast("A user with this email already exists.", "error");
        }
        document.getElementById("reg-email").classList.add("is-invalid");
        return;
      }

      // Save user to simulated DB
      users.push({ name, email, phone, password });
      localStorage.setItem("registeredUsers", JSON.stringify(users));

      if (typeof showToast === "function") {
        showToast("Registration successful! Redirecting to login...", "success");
      }

      setTimeout(() => {
        window.location.href = "login.html";
      }, 1500);
    });
  }
});

// Helper: Email format regex check
function validateEmail(email) {
  const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(String(email).toLowerCase());
}
