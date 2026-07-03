<%@ page import="model.User" %>
<%
    User navCurrentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    User navAdminUser = (session != null) ? (User) session.getAttribute("adminUser") : null;
%>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-premium fixed-top">
  <div class="container">
    <a class="navbar-brand navbar-brand-premium d-flex align-items-center gap-2" href="index.jsp">
      <i class="bi bi-speedometer2 text-info"></i>
      <span>EliteDrive</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
        <li class="nav-item">
          <a class="nav-link nav-link-premium" href="index.jsp">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link nav-link-premium" href="vehicles.jsp">Vehicles</a>
        </li>
        <li class="nav-item">
          <a class="nav-link nav-link-premium" href="about.jsp">About Us</a>
        </li>
        <li class="nav-item">
          <a class="nav-link nav-link-premium" href="contact.jsp">Contact</a>
        </li>
      </ul>
      <ul class="navbar-nav align-items-lg-center ms-lg-2">
        <% if (navAdminUser != null) { %>
          <li class="nav-item">
            <a class="nav-link nav-link-premium" href="admin/index.jsp">Admin Panel</a>
          </li>
          <li class="nav-item d-flex align-items-center ms-lg-3 mt-2 mt-lg-0">
            <span class="text-white me-3 font-weight-500">Hello, <%= navAdminUser.getName() %></span>
            <a href="logout" class="btn btn-premium-outline py-2 px-3 text-decoration-none">Logout</a>
          </li>
        <% } else if (navCurrentUser != null) { %>
          <li class="nav-item">
            <a class="nav-link nav-link-premium" href="my-bookings">My Bookings</a>
          </li>
          <li class="nav-item d-flex align-items-center ms-lg-3 mt-2 mt-lg-0">
            <span class="text-white me-3 font-weight-500">Hello, <%= navCurrentUser.getName() %></span>
            <a href="logout" class="btn btn-premium-outline py-2 px-3 text-decoration-none">Logout</a>
          </li>
        <% } else { %>
          <li class="nav-item">
            <a class="nav-link nav-link-premium" href="login.jsp">Login</a>
          </li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>
