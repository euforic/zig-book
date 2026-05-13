// ================================================================
//  The Zig Book — runtime
//  Zig 0.16.0 (latest tagged release; April 2026)
// ================================================================

// ---------- Zig syntax highlighter ----------
const ZIG_KEYWORDS = new Set([
  'const','var','fn','pub','extern','export','comptime','inline','noinline',
  'threadlocal','packed','align','linksection','callconv','addrspace',
  'if','else','while','for','switch','return','break','continue','defer','errdefer',
  'unreachable','try','catch','orelse','and','or',
  'struct','enum','union','error','opaque',
  'test','usingnamespace','noalias','volatile','allowzero',
  'asm'
]);
const ZIG_VALUES = new Set(['true','false','null','undefined']);
const ZIG_TYPES = new Set([
  'i8','i16','i32','i64','i128','u8','u16','u32','u64','u128','isize','usize',
  'c_short','c_ushort','c_int','c_uint','c_long','c_ulong','c_longlong','c_ulonglong',
  'c_char','c_longdouble',
  'f16','f32','f64','f80','f128','bool','anyopaque','void','noreturn',
  'type','anyerror','comptime_int','comptime_float','anytype'
]);

function esc(s){ return s.replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

function highlightZig(code) {
  let out = '';
  let i = 0;
  const n = code.length;
  while (i < n) {
    const c = code[i];

    // line comments
    if (c === '/' && code[i+1] === '/') {
      let end = code.indexOf('\n', i);
      if (end === -1) end = n;
      out += `<span class="tok-com">${esc(code.slice(i, end))}</span>`;
      i = end; continue;
    }
    // multiline strings (\\... to end of line)
    if (c === '\\' && code[i+1] === '\\') {
      let end = code.indexOf('\n', i);
      if (end === -1) end = n;
      out += `<span class="tok-str">${esc(code.slice(i, end))}</span>`;
      i = end; continue;
    }
    // strings
    if (c === '"') {
      let j = i + 1;
      while (j < n && code[j] !== '"') {
        if (code[j] === '\\' && j+1 < n) j += 2;
        else j++;
      }
      j = Math.min(j + 1, n);
      out += `<span class="tok-str">${esc(code.slice(i, j))}</span>`;
      i = j; continue;
    }
    // char literal
    if (c === "'") {
      let j = i + 1;
      while (j < n && code[j] !== "'") {
        if (code[j] === '\\' && j+1 < n) j += 2;
        else j++;
      }
      j = Math.min(j + 1, n);
      out += `<span class="tok-str">${esc(code.slice(i, j))}</span>`;
      i = j; continue;
    }
    // builtins @name
    if (c === '@' && /[a-zA-Z_"]/.test(code[i+1] || '')) {
      // @"escaped identifier"
      if (code[i+1] === '"') {
        let j = i + 2;
        while (j < n && code[j] !== '"') j++;
        j++;
        out += `<span class="tok-bui">${esc(code.slice(i, j))}</span>`;
        i = j; continue;
      }
      let j = i + 1;
      while (j < n && /[a-zA-Z0-9_]/.test(code[j])) j++;
      out += `<span class="tok-bui">${esc(code.slice(i, j))}</span>`;
      i = j; continue;
    }
    // numbers
    if (/[0-9]/.test(c)) {
      let j = i;
      while (j < n && /[0-9a-fA-FxXoObB._]/.test(code[j])) j++;
      // exponent
      if (j < n && (code[j] === 'e' || code[j] === 'E' || code[j] === 'p' || code[j] === 'P')) {
        j++;
        if (j < n && (code[j] === '+' || code[j] === '-')) j++;
        while (j < n && /[0-9_]/.test(code[j])) j++;
      }
      out += `<span class="tok-num">${esc(code.slice(i, j))}</span>`;
      i = j; continue;
    }
    // identifiers
    if (/[a-zA-Z_]/.test(c)) {
      let j = i;
      while (j < n && /[a-zA-Z0-9_]/.test(code[j])) j++;
      const word = code.slice(i, j);
      let cls = null;
      if (ZIG_KEYWORDS.has(word)) cls = 'tok-kw';
      else if (ZIG_VALUES.has(word)) cls = 'tok-num';
      else if (ZIG_TYPES.has(word)) cls = 'tok-typ';
      else if (/^[A-Z]/.test(word)) cls = 'tok-typ';
      else if (code[j] === '(') cls = 'tok-fn';
      if (cls) out += `<span class="${cls}">${esc(word)}</span>`;
      else out += esc(word);
      i = j; continue;
    }
    out += esc(c);
    i++;
  }
  return out;
}

function highlightShell(code) {
  // Simple: lines starting with $ are commands, # are comments
  return code.split('\n').map(line => {
    if (/^\s*#/.test(line)) return `<span class="tok-com">${esc(line)}</span>`;
    const m = line.match(/^(\s*[$>]\s*)(.*)$/);
    if (m) return `<span class="tok-kw">${esc(m[1])}</span>${esc(m[2])}`;
    return esc(line);
  }).join('\n');
}

// ---------- helpers for content authoring ----------
function code(lang, src) {
  src = src.replace(/^\n+/, '').replace(/\s+$/, '');
  const hi = lang === 'zig' ? highlightZig(src)
           : lang === 'shell' || lang === 'bash' ? highlightShell(src)
           : esc(src);
  return `<div class="code-block">
    <div class="code-block-header">
      <span class="code-block-lang">${lang}</span>
      <button class="code-copy" onclick="copyCode(this)">Copy</button>
    </div>
    <pre><code>${hi}</code></pre>
  </div>`;
}
function callout(kind, title, body) {
  return `<div class="callout ${kind}"><div class="callout-title">${title}</div>${body}</div>`;
}

// Aliases for the content authoring below (keep markup compact)
const z = (s) => code('zig', s);
const sh = (s) => code('shell', s);
const note = (t, b) => callout('note', t, b);
const warn = (t, b) => callout('warning', t, b);
const tip  = (t, b) => callout('tip', t, b);
const danger = (t, b) => callout('danger', t, b);

// ================================================================
//  CHAPTERS
//  Each part has chapters with: slug, title, subtitle, body (HTML)
// ================================================================
