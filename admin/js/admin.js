/* =========================================================
   EliteDrive Admin Panel — admin.js (shared)
   ========================================================= */

/* ── Auth Guard ───────────────────────────────────────── */
if (localStorage.getItem('isAdminLoggedIn') !== 'true') {
  window.location.href = 'login.html';
}

/* ── Sidebar Toggle ───────────────────────────────────── */
const sidebar  = document.getElementById('adminSidebar');
const overlay  = document.getElementById('sidebarOverlay');
const toggleBtns = document.querySelectorAll('.sidebar-toggle');

toggleBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    sidebar.classList.toggle('open');
    overlay.classList.toggle('visible');
  });
});

if (overlay) {
  overlay.addEventListener('click', () => {
    sidebar.classList.remove('open');
    overlay.classList.remove('visible');
  });
}

/* ── Active Nav Link ──────────────────────────────────── */
const currentPage = window.location.pathname.split('/').pop();
document.querySelectorAll('.nav-link-admin').forEach(link => {
  const href = link.getAttribute('href');
  if (href && href === currentPage) link.classList.add('active');
});

/* ── Toast Notifications ──────────────────────────────── */
function showAdminToast(message, type = 'success', duration = 3500) {
  const wrap = document.getElementById('adminToastWrap') || (() => {
    const w = document.createElement('div');
    w.id = 'adminToastWrap';
    w.className = 'admin-toast-wrap';
    document.body.appendChild(w);
    return w;
  })();

  const icons = { success: 'bi-check-circle-fill', error: 'bi-x-circle-fill', warning: 'bi-exclamation-triangle-fill', info: 'bi-info-circle-fill' };
  const colors = { success: '#10b981', error: '#ef4444', warning: '#f59e0b', info: '#06b6d4' };

  const toast = document.createElement('div');
  toast.className = `admin-toast ${type !== 'success' ? type : ''}`;
  toast.innerHTML = `
    <i class="bi ${icons[type] || icons.success}" style="color:${colors[type]};font-size:1.1rem;flex-shrink:0"></i>
    <span>${message}</span>
    <button onclick="this.parentElement.remove()" style="margin-left:auto;background:transparent;border:none;color:#94a3b8;cursor:pointer;font-size:1rem;">&times;</button>
  `;
  wrap.appendChild(toast);
  setTimeout(() => { toast.style.opacity = '0'; toast.style.transform = 'translateX(100%)'; toast.style.transition = 'all 0.3s'; setTimeout(() => toast.remove(), 300); }, duration);
}

/* ── Confirm Dialog ───────────────────────────────────── */
function adminConfirm(message, onConfirm) {
  const modal = document.getElementById('confirmModal');
  if (!modal) return;
  document.getElementById('confirmMessage').textContent = message;
  const bsModal = new bootstrap.Modal(modal);
  bsModal.show();
  const btn = document.getElementById('confirmOkBtn');
  const newBtn = btn.cloneNode(true);
  btn.parentNode.replaceChild(newBtn, btn);
  newBtn.addEventListener('click', () => { bsModal.hide(); onConfirm(); });
}

/* ── Generic Delete Handler ───────────────────────────── */
function handleDelete(btn, rowSelector, itemLabel) {
  adminConfirm(`Delete ${itemLabel}? This action cannot be undone.`, () => {
    const row = btn.closest(rowSelector);
    row.style.transition = 'all 0.3s';
    row.style.opacity = '0';
    row.style.transform = 'translateX(-20px)';
    setTimeout(() => row.remove(), 300);
    showAdminToast(`${itemLabel} deleted successfully.`, 'success');
    updateRowCount();
  });
}

/* ── Row Count Update ─────────────────────────────────── */
function updateRowCount() {
  const countEl = document.getElementById('tableRowCount');
  if (countEl) {
    const visible = document.querySelectorAll('.data-row:not([style*="display: none"])').length;
    countEl.textContent = visible;
  }
}

/* ── Table Search ─────────────────────────────────────── */
function initTableSearch(inputId, tableBodyId) {
  const input = document.getElementById(inputId);
  const tbody = document.getElementById(tableBodyId);
  if (!input || !tbody) return;

  input.addEventListener('input', () => {
    const q = input.value.trim().toLowerCase();
    tbody.querySelectorAll('tr.data-row').forEach(row => {
      const text = row.textContent.toLowerCase();
      row.style.display = text.includes(q) ? '' : 'none';
    });
    updateRowCount();
  });
}

/* ── Topbar Global Search ─────────────────────────────── */
const topSearch = document.getElementById('topbarSearch');
if (topSearch) {
  topSearch.addEventListener('keydown', e => {
    if (e.key === 'Enter' && topSearch.value.trim()) {
      showAdminToast(`Searching for "${topSearch.value}"...`, 'info', 2000);
    }
  });
}

/* ── Filter Select ────────────────────────────────────── */
function initFilterSelect(selectId, tableBodyId, colIndex) {
  const sel = document.getElementById(selectId);
  const tbody = document.getElementById(tableBodyId);
  if (!sel || !tbody) return;

  sel.addEventListener('change', () => {
    const val = sel.value.toLowerCase();
    tbody.querySelectorAll('tr.data-row').forEach(row => {
      const cell = row.querySelectorAll('td')[colIndex];
      if (!cell) return;
      const text = cell.textContent.toLowerCase();
      row.style.display = (!val || text.includes(val)) ? '' : 'none';
    });
    updateRowCount();
  });
}

/* ── Charts: mini sparklines ──────────────────────────── */
function renderSparkBars() {
  document.querySelectorAll('.stat-bars').forEach(container => {
    const bars = container.querySelectorAll('.stat-bar');
    const heights = Array.from({ length: bars.length }, () => Math.floor(Math.random() * 60) + 20);
    const max = Math.max(...heights);
    bars.forEach((bar, i) => {
      bar.style.height = `${(heights[i] / max) * 100}%`;
    });
    bars[bars.length - 1].classList.add('active');
  });
}

/* ── Animated Counters ────────────────────────────────── */
function animateCounter(el) {
  const target = parseInt(el.dataset.target || el.textContent.replace(/[^0-9]/g, ''), 10);
  if (isNaN(target)) return;
  const prefix = el.dataset.prefix || '';
  const suffix = el.dataset.suffix || '';
  const duration = 1200;
  const step = target / (duration / 16);
  let current = 0;
  const timer = setInterval(() => {
    current = Math.min(current + step, target);
    el.textContent = prefix + Math.floor(current).toLocaleString() + suffix;
    if (current >= target) clearInterval(timer);
  }, 16);
}

/* ── Booking Approve / Reject ─────────────────────────── */
function handleBookingAction(btn, action) {
  const row = btn.closest('tr.data-row');
  const badge = row.querySelector('.status-badge');
  const actionBtns = row.querySelectorAll('.action-btns .btn-icon');

  if (action === 'approve') {
    badge.className = 'status-badge status-approved';
    badge.innerHTML = `<span></span>Approved`;
    showAdminToast('Booking approved successfully.', 'success');
  } else {
    badge.className = 'status-badge status-rejected';
    badge.innerHTML = `<span></span>Rejected`;
    showAdminToast('Booking rejected.', 'error');
  }
  actionBtns.forEach(b => { b.disabled = true; b.style.opacity = '0.35'; b.style.pointerEvents = 'none'; });
}

/* ── Init ─────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  renderSparkBars();

  // Animate counters on dashboard
  document.querySelectorAll('.stat-value[data-target]').forEach(el => animateCounter(el));

  // Auto-init search + filter if present
  initTableSearch('tableSearchInput', 'mainTableBody');
  initFilterSelect('tableFilterSelect', 'mainTableBody', 3);

  updateRowCount();

  /* Approve buttons */
  document.querySelectorAll('.btn-approve').forEach(btn => {
    btn.addEventListener('click', () => handleBookingAction(btn, 'approve'));
  });

  /* Reject buttons */
  document.querySelectorAll('.btn-reject').forEach(btn => {
    btn.addEventListener('click', () => handleBookingAction(btn, 'reject'));
  });

  /* Delete buttons */
  document.querySelectorAll('.btn-delete-row').forEach(btn => {
    btn.addEventListener('click', () => {
      const label = btn.dataset.label || 'Item';
      handleDelete(btn, 'tr', label);
    });
  });

  /* Revenue chart bars */
  const revBars = document.querySelectorAll('.rev-bar');
  if (revBars.length) {
    const vals = [55, 70, 45, 80, 65, 90, 75, 85, 60, 95, 70, 100];
    revBars.forEach((bar, i) => {
      bar.style.height = `${vals[i % vals.length]}%`;
    });
  }

  /* Notifications bell */
  const bell = document.getElementById('topbarBell');
  if (bell) {
    bell.addEventListener('click', () => showAdminToast('3 new booking requests pending approval.', 'info'));
  }

  /* Logout listener */
  document.querySelectorAll('.admin-logout-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      localStorage.removeItem('isAdminLoggedIn');
      showAdminToast('Logging out...', 'info');
      setTimeout(() => {
        window.location.href = 'login.html?logout=true';
      }, 1000);
    });
  });
});
