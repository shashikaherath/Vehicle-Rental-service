/**
 * EliteDrive — Shared Data Store (store.js)
 * ──────────────────────────────────────────
 * All read/write operations for customers, bookings, and vehicle
 * status go through this module so the admin and customer pages
 * always share the same data from localStorage.
 */

const EliteStore = (() => {

  /* ── Keys ─────────────────────────────────────────────────── */
  const KEYS = {
    USERS    : 'registeredUsers',
    BOOKINGS : 'bookings',
    VEHICLES : 'vehicleStatuses',  // overrides for vehicle status
  };

  /* ── Seed default data on first load ─────────────────────── */
  function _seedDefaults() {
    // Seed pre-built customers only if store is completely empty
    if (!localStorage.getItem(KEYS.USERS)) {
      const seedUsers = [
        { id: 2,  name: 'Alexander Harris',  email: 'a.harris@email.com',       phone: '+1 555 0101',          joinDate: '2025-01-15' },
        { id: 3,  name: 'Marcus Lawson',     email: 'm.lawson@mail.com',         phone: '+1 555 0202',          joinDate: '2025-03-08' },
        { id: 4,  name: 'Sophia Reynolds',   email: 'sophia.r@webmail.com',      phone: '+44 7911 234567',      joinDate: '2025-05-22' },
        { id: 5,  name: 'Priya Sharma',      email: 'priya.s@inbox.com',         phone: '+91 98765 43210',      joinDate: '2026-01-10' },
        { id: 6,  name: 'James Kowalski',    email: 'j.kowalski@corp.net',       phone: '+49 151 23456789',     joinDate: '2025-11-03' },
        { id: 7,  name: 'Lena Torres',       email: 'lena.t@fastmail.com',       phone: '+34 612 345 678',      joinDate: '2025-07-19' },
        { id: 8,  name: 'Kwame Nkrumah',    email: 'k.nkrumah@global.org',      phone: '+233 20 123 4567',     joinDate: '2025-09-30' },
        { id: 9,  name: 'Rachel Moore',      email: 'rachel.m@outlook.com',      phone: '+1 555 0787',          joinDate: '2025-04-14' },
        { id: 10, name: 'Daniel Osei',       email: 'd.osei@proton.me',          phone: '+44 7700 900456',      joinDate: '2025-06-27' },
        { id: 11, name: 'Yuna Lee',          email: 'yuna.lee@connect.kr',       phone: '+82 10 1234 5678',     joinDate: '2025-08-05' },
        { id: 12, name: 'Ben Walsh',         email: 'ben.w@themail.co.uk',       phone: '+44 7800 123456',      joinDate: '2025-12-18' },
      ];
      // Store with password field for login compatibility
      const withPasswords = seedUsers.map(u => ({ ...u, password: 'password123' }));
      localStorage.setItem(KEYS.USERS, JSON.stringify(withPasswords));
    }

    // Seed sample bookings only if none exist
    if (!localStorage.getItem(KEYS.BOOKINGS)) {
      const seedBookings = [
        { bookingId: 'BK-1025', userEmail: 'a.harris@email.com',    vehicleId: 6,  vehicleName: 'IronHorse Cruiser Classic', pickupLocation: 'Colombo Airport', pickupDate: '2026-06-01', returnDate: '2026-06-05', totalPrice: '374.00',   status: 'Approved',   createdAt: '2026-05-28' },
        { bookingId: 'BK-1026', userEmail: 'sophia.r@webmail.com',  vehicleId: 2,  vehicleName: 'Apex Volante GTR',          pickupLocation: 'Galle Face',       pickupDate: '2026-06-08', returnDate: '2026-06-10', totalPrice: '704.00',   status: 'Cancelled',  createdAt: '2026-06-01' },
        { bookingId: 'BK-1027', userEmail: 'rachel.m@outlook.com',  vehicleId: 3,  vehicleName: 'TransPro Cargo Master',     pickupLocation: 'Kandy',            pickupDate: '2026-06-10', returnDate: '2026-06-12', totalPrice: '242.00',   status: 'Completed',  createdAt: '2026-06-05' },
        { bookingId: 'BK-1028', userEmail: 'yuna.lee@connect.kr',   vehicleId: 13, vehicleName: 'Vanguard Ranger Pro 4x4',  pickupLocation: 'Negombo',          pickupDate: '2026-06-15', returnDate: '2026-06-17', totalPrice: '385.00',   status: 'Completed',  createdAt: '2026-06-10' },
        { bookingId: 'BK-1029', userEmail: 'a.harris@email.com',    vehicleId: 1,  vehicleName: 'Aether Spectre S',          pickupLocation: 'Colombo Fort',     pickupDate: '2026-06-18', returnDate: '2026-06-21', totalPrice: '825.00',   status: 'Active',     createdAt: '2026-06-14' },
        { bookingId: 'BK-1032', userEmail: 'm.lawson@mail.com',      vehicleId: 5,  vehicleName: 'ThunderRide Storm 750',    pickupLocation: 'Bentota',          pickupDate: '2026-06-25', returnDate: '2026-06-28', totalPrice: '247.50',   status: 'Pending',    createdAt: '2026-06-20' },
        { bookingId: 'BK-1033', userEmail: 'priya.s@inbox.com',     vehicleId: 7,  vehicleName: 'Zephyr City Glide 125',    pickupLocation: 'Colombo Fort',     pickupDate: '2026-06-22', returnDate: '2026-06-25', totalPrice: '115.50',   status: 'Pending',    createdAt: '2026-06-20' },
        { bookingId: 'BK-1034', userEmail: 'j.kowalski@corp.net',   vehicleId: 15, vehicleName: 'AquaLux Riviera 28',       pickupLocation: 'Mirissa Marina',   pickupDate: '2026-06-27', returnDate: '2026-06-30', totalPrice: '1485.00',  status: 'Pending',    createdAt: '2026-06-20' },
      ];
      localStorage.setItem(KEYS.BOOKINGS, JSON.stringify(seedBookings));
    }
  }

  /* ── Users / Customers ────────────────────────────────────── */
  function getUsers() {
    return JSON.parse(localStorage.getItem(KEYS.USERS) || '[]');
  }

  function saveUsers(users) {
    localStorage.setItem(KEYS.USERS, JSON.stringify(users));
  }

  function addUser(user) {
    const users = getUsers();
    const exists = users.some(u => u.email.toLowerCase() === user.email.toLowerCase());
    if (exists) return false;
    user.id = Date.now();
    user.joinDate = new Date().toISOString().split('T')[0];
    users.push(user);
    saveUsers(users);
    return true;
  }

  function getUserByEmail(email) {
    return getUsers().find(u => u.email.toLowerCase() === email.toLowerCase()) || null;
  }

  /* ── Bookings ─────────────────────────────────────────────── */
  function getBookings() {
    return JSON.parse(localStorage.getItem(KEYS.BOOKINGS) || '[]');
  }

  function saveBookings(bookings) {
    localStorage.setItem(KEYS.BOOKINGS, JSON.stringify(bookings));
  }

  function addBooking(booking) {
    const bookings = getBookings();
    bookings.push(booking);
    saveBookings(bookings);
  }

  function updateBookingStatus(bookingId, newStatus) {
    const bookings = getBookings();
    const idx = bookings.findIndex(b => b.bookingId === bookingId);
    if (idx === -1) return false;
    bookings[idx].status = newStatus;
    saveBookings(bookings);
    return true;
  }

  function getBookingsByUser(email) {
    return getBookings().filter(b => b.userEmail.toLowerCase() === email.toLowerCase());
  }

  /* ── Stats helpers ────────────────────────────────────────── */
  function getStats() {
    const bookings = getBookings();
    const users    = getUsers();
    const customers = users.filter(u => !u.isAdmin);

    let pending = 0, approved = 0, active = 0, completed = 0, cancelled = 0, revenue = 0;
    bookings.forEach(b => {
      const s = (b.status || '').toLowerCase();
      if (s === 'pending')   pending++;
      if (s === 'approved')  { approved++; revenue += parseFloat(b.totalPrice || 0); }
      if (s === 'active')    { active++;   revenue += parseFloat(b.totalPrice || 0); }
      if (s === 'completed') { completed++; revenue += parseFloat(b.totalPrice || 0); }
      if (s === 'cancelled') cancelled++;
    });

    return {
      totalCustomers : customers.length,
      totalBookings  : bookings.length,
      pendingBookings: pending,
      approvedBookings: approved,
      activeBookings : active,
      completedBookings: completed,
      cancelledBookings: cancelled,
      totalRevenue   : revenue,
    };
  }

  /* ── Init ─────────────────────────────────────────────────── */
  _seedDefaults();

  return {
    getUsers, saveUsers, addUser, getUserByEmail,
    getBookings, saveBookings, addBooking, updateBookingStatus, getBookingsByUser,
    getStats,
    KEYS,
  };
})();
