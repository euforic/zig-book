// ============================================================
// Framework: router, renderer, sidebar, TOC, search, theme
// ============================================================

const FLAT = [];
PARTS.forEach(function(p){
  p.chapters.forEach(function(c){
    FLAT.push(Object.assign({}, c, { part: p.title || '' }));
  });
});

function getCurrentSlug() {
  return (location.hash || '#cover').slice(1).split('/')[0];
}

function findChapter(slug) {
  return FLAT.find(function(c){ return c.slug === slug; }) || FLAT[0];
}

function renderSidebar() {
  const sb = document.getElementById('sidebar');
  const current = getCurrentSlug();
  let chapterNum = 0;
  let html = '';
  PARTS.forEach(function(part){
    if (!part.title) {
      // cover / unlabeled
      part.chapters.forEach(function(c){
        if (c.hidden) return;
        const active = c.slug === current ? ' active' : '';
        html += '<a href="#' + c.slug + '" class="sb-chapter' + active + '">' + c.title + '</a>';
      });
      return;
    }
    html += '<div class="sb-part">';
    html += '<div class="sb-part-title">' + part.title + '</div>';
    part.chapters.forEach(function(c){
      if (c.hidden) return;
      chapterNum++;
      const active = c.slug === current ? ' active' : '';
      const num = String(chapterNum).padStart(2, '0');
      html += '<a href="#' + c.slug + '" class="sb-chapter' + active + '">';
      html += '<span class="sb-chapter-num">' + num + '</span>' + c.title;
      html += '</a>';
    });
    html += '</div>';
  });
  sb.innerHTML = html;

  // Scroll active item into view (mobile)
  const active = sb.querySelector('.sb-chapter.active');
  if (active && active.scrollIntoView) {
    active.scrollIntoView({ block: 'nearest', behavior: 'instant' });
  }
}

function renderChapter() {
  const slug = getCurrentSlug();
  const ch = findChapter(slug);
  const inner = document.getElementById('contentInner');
  let html = '';

  if (!ch.hidden) {
    if (ch.part) {
      html += '<div class="chapter-meta"><span class="chapter-meta-tag">' + ch.part + '</span></div>';
    }
    html += '<h1 class="chapter-title">' + ch.title + '</h1>';
    if (ch.subtitle) html += '<p class="chapter-subtitle">' + ch.subtitle + '</p>';
    html += '<hr class="chapter-divider">';
  }
  html += ch.body;

  // Prev / next
  const idx = FLAT.indexOf(ch);
  let prev = null, next = null;
  for (let i = idx - 1; i >= 0; i--) { if (!FLAT[i].hidden) { prev = FLAT[i]; break; } }
  for (let i = idx + 1; i < FLAT.length; i++) { if (!FLAT[i].hidden) { next = FLAT[i]; break; } }

  if (!ch.hidden) {
    html += '<nav class="chapter-nav">';
    if (prev) {
      html += '<a class="prev" href="#' + prev.slug + '">';
      html += '<div class="chapter-nav-dir">← Previous</div>';
      html += '<div class="chapter-nav-title">' + prev.title + '</div></a>';
    } else {
      html += '<div></div>';
    }
    if (next) {
      html += '<a class="next" href="#' + next.slug + '">';
      html += '<div class="chapter-nav-dir">Next →</div>';
      html += '<div class="chapter-nav-title">' + next.title + '</div></a>';
    } else {
      html += '<div></div>';
    }
    html += '</nav>';
  }

  inner.innerHTML = html;
  window.scrollTo(0, 0);

  renderTOC();
  renderSidebar();
  document.title = ch.title + ' — The Zig Book';

  // Close mobile sidebar after navigation
  document.getElementById('sidebar').classList.remove('open');
  const backdrop = document.getElementById('sbBackdrop');
  if (backdrop) backdrop.classList.remove('active');
}

function renderTOC() {
  const toc = document.getElementById('toc');
  if (!toc) return;
  const headings = document.querySelectorAll('.content h2, .content h3');
  if (headings.length < 2) {
    toc.innerHTML = '';
    return;
  }
  let html = '<div class="toc-title">On this page</div><ul class="toc-list">';
  headings.forEach(function(h){
    const slug = h.textContent.toLowerCase()
      .replace(/§/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
    h.id = slug;
    const cls = h.tagName === 'H3' ? ' class="toc-h3"' : '';
    html += '<li><a href="javascript:void(0)" data-target="' + slug + '"' + cls + '>';
    html += h.textContent.replace(/§/g, '').trim();
    html += '</a></li>';
  });
  html += '</ul>';
  toc.innerHTML = html;

  // Attach handlers
  toc.querySelectorAll('a[data-target]').forEach(function(a){
    a.addEventListener('click', function(e){
      e.preventDefault();
      const el = document.getElementById(a.getAttribute('data-target'));
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  });

  // Scroll-spy
  setupScrollSpy(toc);
}

function setupScrollSpy(toc) {
  const links = toc.querySelectorAll('a[data-target]');
  if (!links.length) return;
  const targets = Array.from(links).map(function(a){
    return document.getElementById(a.getAttribute('data-target'));
  });

  function update() {
    let activeIdx = 0;
    const offset = 80;
    for (let i = 0; i < targets.length; i++) {
      if (targets[i] && targets[i].getBoundingClientRect().top <= offset) {
        activeIdx = i;
      }
    }
    links.forEach(function(l, i){
      if (i === activeIdx) l.classList.add('active');
      else l.classList.remove('active');
    });
  }

  let ticking = false;
  window.removeEventListener('scroll', window._spyHandler);
  window._spyHandler = function(){
    if (!ticking) {
      window.requestAnimationFrame(function(){
        update();
        ticking = false;
      });
      ticking = true;
    }
  };
  window.addEventListener('scroll', window._spyHandler, { passive: true });
  update();
}

// ============================================================
// Theme toggle
// ============================================================

function setTheme(t) {
  document.documentElement.setAttribute('data-theme', t);
  try { localStorage.setItem('zigbook-theme', t); } catch(e){}
  const moon = document.getElementById('iconMoon');
  const sun = document.getElementById('iconSun');
  if (moon) moon.style.display = (t === 'dark') ? 'block' : 'none';
  if (sun) sun.style.display = (t === 'light') ? 'block' : 'none';
}

function initTheme() {
  let saved = 'dark';
  try { saved = localStorage.getItem('zigbook-theme') || 'dark'; } catch(e){}
  setTheme(saved);
  const btn = document.getElementById('themeToggle');
  if (btn) {
    btn.addEventListener('click', function(){
      const cur = document.documentElement.getAttribute('data-theme');
      setTheme(cur === 'dark' ? 'light' : 'dark');
    });
  }
}

// ============================================================
// Search
// ============================================================

function buildSearchIndex() {
  return FLAT.filter(function(c){ return !c.hidden; }).map(function(c){
    const plain = (c.title + ' ' + (c.subtitle || '') + ' ' + c.body.replace(/<[^>]+>/g, ' '))
      .replace(/\s+/g, ' ')
      .toLowerCase();
    return {
      slug: c.slug,
      title: c.title,
      subtitle: c.subtitle || '',
      part: c.part || '',
      text: plain
    };
  });
}

let SEARCH_IDX = null;

function search(query) {
  if (!SEARCH_IDX) SEARCH_IDX = buildSearchIndex();
  const q = query.toLowerCase().trim();
  if (q.length < 2) return [];
  const tokens = q.split(/\s+/);
  const scored = [];
  SEARCH_IDX.forEach(function(c){
    let score = 0;
    tokens.forEach(function(t){
      if (c.title.toLowerCase().includes(t)) score += 10;
      if (c.subtitle.toLowerCase().includes(t)) score += 4;
      const idx = c.text.indexOf(t);
      if (idx >= 0) score += 1;
    });
    if (score > 0) {
      // Build snippet around the first hit in body text
      const firstIdx = c.text.indexOf(tokens[0]);
      let snippet = '';
      if (firstIdx >= 0) {
        const start = Math.max(0, firstIdx - 40);
        const end = Math.min(c.text.length, firstIdx + 80);
        snippet = (start > 0 ? '…' : '') + c.text.slice(start, end) + (end < c.text.length ? '…' : '');
        tokens.forEach(function(t){
          const re = new RegExp('(' + t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
          snippet = snippet.replace(re, '<mark>$1</mark>');
        });
      }
      scored.push({ chapter: c, score: score, snippet: snippet });
    }
  });
  scored.sort(function(a, b){ return b.score - a.score; });
  return scored.slice(0, 8);
}

function initSearch() {
  const input = document.getElementById('searchInput');
  const results = document.getElementById('searchResults');
  if (!input || !results) return;

  let debounce = null;
  input.addEventListener('input', function(){
    if (debounce) clearTimeout(debounce);
    debounce = setTimeout(function(){
      const q = input.value.trim();
      if (q.length < 2) {
        results.classList.remove('active');
        results.innerHTML = '';
        return;
      }
      const hits = search(q);
      if (!hits.length) {
        results.innerHTML = '<div class="search-result"><div class="search-result-title">No matches</div></div>';
        results.classList.add('active');
        return;
      }
      let html = '';
      hits.forEach(function(h){
        html += '<a class="search-result" href="#' + h.chapter.slug + '">';
        html += '<div class="search-result-title">' + h.chapter.title + '</div>';
        if (h.chapter.part) html += '<div class="search-result-part">' + h.chapter.part + '</div>';
        if (h.snippet) html += '<div class="search-result-snippet">' + h.snippet + '</div>';
        html += '</a>';
      });
      results.innerHTML = html;
      results.classList.add('active');

      // Click closes the dropdown
      results.querySelectorAll('a.search-result').forEach(function(a){
        a.addEventListener('click', function(){
          results.classList.remove('active');
          input.value = '';
        });
      });
    }, 80);
  });

  document.addEventListener('click', function(e){
    if (!e.target.closest('.search-wrap')) {
      results.classList.remove('active');
    }
  });

  document.addEventListener('keydown', function(e){
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
      e.preventDefault();
      input.focus();
      input.select();
    } else if (e.key === 'Escape') {
      results.classList.remove('active');
      input.blur();
    }
  });
}

// ============================================================
// Copy-code buttons
// ============================================================

function copyCode(btn) {
  const codeEl = btn.closest('.code-block').querySelector('code');
  if (!codeEl) return;
  const text = codeEl.innerText;
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(function(){
      flashCopied(btn);
    }).catch(function(){
      legacyCopy(text, btn);
    });
  } else {
    legacyCopy(text, btn);
  }
}

function legacyCopy(text, btn) {
  const ta = document.createElement('textarea');
  ta.value = text;
  ta.style.position = 'fixed';
  ta.style.left = '-9999px';
  document.body.appendChild(ta);
  ta.select();
  try { document.execCommand('copy'); flashCopied(btn); } catch(e){}
  document.body.removeChild(ta);
}

function flashCopied(btn) {
  const original = btn.textContent;
  btn.textContent = 'Copied';
  btn.classList.add('copied');
  setTimeout(function(){
    btn.textContent = original;
    btn.classList.remove('copied');
  }, 1500);
}

// ============================================================
// Mobile menu
// ============================================================

function initMobileMenu() {
  const toggle = document.getElementById('menuToggle');
  const sidebar = document.getElementById('sidebar');
  const backdrop = document.getElementById('sbBackdrop');
  if (!toggle || !sidebar) return;

  toggle.addEventListener('click', function(){
    sidebar.classList.toggle('open');
    if (backdrop) backdrop.classList.toggle('active');
  });
  if (backdrop) {
    backdrop.addEventListener('click', function(){
      sidebar.classList.remove('open');
      backdrop.classList.remove('active');
    });
  }
}

// ============================================================
// Boot
// ============================================================

window.addEventListener('hashchange', renderChapter);

document.addEventListener('DOMContentLoaded', function(){
  initTheme();
  initMobileMenu();
  initSearch();
  renderChapter();
});

// If DOM is already ready, boot immediately
if (document.readyState === 'interactive' || document.readyState === 'complete') {
  initTheme();
  initMobileMenu();
  initSearch();
  renderChapter();
}
