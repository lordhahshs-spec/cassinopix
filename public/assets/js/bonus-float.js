/* Botão flutuante de bônus (giros da roleta + free spins) — canto inferior esquerdo */
(function () {
  if (window.__bonusFloat) return;
  window.__bonusFloat = true;

  var SVG = {
    gift: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 12v10H4V12"/><path d="M2 7h20v5H2z"/><path d="M12 22V7"/><path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/></svg>',
    wheel: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2a10 10 0 1 0 0 20a10 10 0 1 0 0-20z"/><path d="M12 2v20"/><path d="M2 12h20"/><path d="M4.93 4.93l14.14 14.14"/><path d="M19.07 4.93L4.93 19.07"/></svg>',
    play: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2a10 10 0 1 0 0 20a10 10 0 1 0 0-20z"/><path d="M10 8l6 4-6 4z"/></svg>',
    close: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg>'
  };
  var state = { spins: 0, free: [], open: false };
  var btn, badge, panel;

  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function brl(v) { return 'R$ ' + Number(v || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
  function token() { try { return localStorage.getItem('token'); } catch (e) { return null; } }
  function go(path) {
    close();
    try {
      var root = document.querySelector('[data-v-app]') || document.getElementById('EclipeGaming');
      var app = root && root.__vue_app__;
      var router = app && app.config.globalProperties.$router;
      if (router) { router.push(path); return; }
    } catch (e) {}
    location.href = path;
  }

  function build() {
    btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'bf-btn';
    btn.setAttribute('aria-label', 'Meus bônus');
    btn.innerHTML = SVG.gift + '<span class="bf-badge">0</span>';
    badge = btn.querySelector('.bf-badge');
    btn.addEventListener('click', function () { state.open ? close() : openPanel(); });

    panel = document.createElement('div');
    panel.className = 'bf-panel';
    panel.setAttribute('role', 'dialog');
    document.body.appendChild(btn);
    document.body.appendChild(panel);
    document.addEventListener('click', function (e) {
      if (state.open && !panel.contains(e.target) && !btn.contains(e.target)) close();
    });
  }

  function count() {
    return state.spins + state.free.reduce(function (a, f) { return a + (f.remaining || 0); }, 0);
  }

  function render() {
    var n = count();
    var hidden = !token() || n <= 0 || /^\/games\/play\//.test(location.pathname);
    btn.style.display = hidden ? 'none' : '';
    if (hidden) close();
    badge.textContent = n > 99 ? '99+' : n;

    var rows = '';
    if (state.spins > 0) {
      rows += '<div class="bf-row"><div class="bf-ico">' + SVG.wheel + '</div><div class="bf-t"><b>Roleta do Pix</b><span>' +
        state.spins + ' giro' + (state.spins > 1 ? 's' : '') + ' disponíve' + (state.spins > 1 ? 'is' : 'l') +
        '</span></div><button type="button" class="bf-go" data-go="/promotions">Girar</button></div>';
    }
    state.free.forEach(function (f) {
      var exp = f.expires_at ? new Date(f.expires_at) : null;
      rows += '<div class="bf-row"><div class="bf-ico">' + SVG.play + '</div><div class="bf-t"><b>' + esc(f.game_name || f.game_code) +
        '</b><span>' + f.remaining + ' free spin' + (f.remaining > 1 ? 's' : '') + (f.bet ? ' de ' + brl(f.bet) : '') +
        (exp && !isNaN(exp) ? ' · até ' + exp.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' }) : '') +
        '</span></div>' + (f.game_id ? '<button type="button" class="bf-go" data-go="/games/play/' + encodeURIComponent(f.game_id) + '/' + encodeURIComponent(f.game_code) + '">Jogar</button>' : '') + '</div>';
    });
    panel.innerHTML = '<div class="bf-head"><b>Meus bônus</b><button type="button" class="bf-x" aria-label="Fechar">' + SVG.close + '</button></div>' + rows;
    panel.querySelector('.bf-x').addEventListener('click', close);
    Array.prototype.forEach.call(panel.querySelectorAll('[data-go]'), function (b) {
      b.addEventListener('click', function () { go(b.getAttribute('data-go')); });
    });
  }

  function openPanel() { state.open = true; panel.classList.add('show'); btn.classList.add('on'); }
  function close() { state.open = false; if (panel) panel.classList.remove('show'); if (btn) btn.classList.remove('on'); }

  var busy = false;
  function load() {
    var t = token();
    if (!t) { state.spins = 0; state.free = []; render(); return; }
    if (busy) return;
    busy = true;
    fetch('/api/roulette', { headers: { Accept: 'application/json', Authorization: 'Bearer ' + t } })
      .then(function (r) { return r.ok ? r.json() : null; })
      .then(function (d) {
        if (d) { state.spins = d.spins || 0; state.free = d.free_spins || []; }
        render();
      })
      .catch(function () {})
      .then(function () { busy = false; });
  }

  function start() {
    build();
    load();
    setInterval(load, 60000);
    window.addEventListener('wallet:refresh', function () { setTimeout(load, 800); });
    window.addEventListener('storage', function (e) { if (e.key === 'token') load(); });
    // troca de página no app (SPA)
    var last = location.pathname;
    setInterval(function () { if (location.pathname !== last) { last = location.pathname; render(); load(); } }, 700);
  }

  document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', start) : start();
})();
