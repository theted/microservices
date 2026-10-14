// The relay: pick a random language, hand it the current number, trust (but
// verify) its answer, repeat until 1. Seeds stay below 10,000 so no value ever
// exceeds 27,114,424, which keeps every 32-bit language in the game.

const MAX_SEED = 9999;
const REQUEST_TIMEOUT_MS = 12_000;
const RETRY_DOWN_AFTER_MS = 20_000;
const PAUSE_BETWEEN_CHAINS_MS = 1500;
const LOG_LIMIT = 80;
const MARGIN = { top: 24, right: 24, bottom: 28, left: 44 };

const step = (n) => (n % 2 === 0 ? n / 2 : 3 * n + 1);
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const format = new Intl.NumberFormat("en").format;
const compact = new Intl.NumberFormat("en", { notation: "compact" }).format;
const $ = (id) => document.getElementById(id);

const state = {
  services: [],
  byId: new Map(),
  stats: new Map(), // id -> { hops, totalMs, deaths, lies, downUntil }
  chain: [], // [{ n, id, ms, claimed }]; the seed has no id
  chainNo: 0,
  finished: 0,
  longest: null, // { seed, steps }
  lastId: null,
  paused: false,
  delay: 400,
  hover: null, // index into chain, or null
  filter: "",
};

// Small DOM helper: el("li", { class: "x" }, "text", childNode)
function el(tag, attrs = {}, ...children) {
  const node = document.createElement(tag);
  for (const [key, value] of Object.entries(attrs)) node.setAttribute(key, value);
  node.append(...children);
  return node;
}

function svg(tag, attrs = {}, text) {
  const node = document.createElementNS("http://www.w3.org/2000/svg", tag);
  for (const [key, value] of Object.entries(attrs)) node.setAttribute(key, value);
  if (text !== undefined) node.textContent = text;
  return node;
}

// --- The relay ----------------------------------------------------------------

function startChain() {
  const seed = 1 + Math.floor(Math.random() * MAX_SEED);
  state.chain = [{ n: seed }];
  state.chainNo += 1;
  state.hover = null;
  logLine("start", `🎲 seed ${format(seed)}`);
}

function finishChain() {
  const seed = state.chain[0].n;
  const steps = state.chain.length - 1;
  const peak = peakOf(state.chain);
  const hops = new Map();
  for (const { id } of state.chain.slice(1)) hops.set(id, (hops.get(id) ?? 0) + 1);
  const [mvp, mvpHops] = [...hops].sort((a, b) => b[1] - a[1])[0] ?? [];

  state.finished += 1;
  if (!state.longest || steps > state.longest.steps) state.longest = { seed, steps };
  logLine(
    "finish",
    `🏁 ${format(seed)} fell to 1 in ${steps} steps, peaking at ${format(peak.n)}`,
    ...(mvp ? [". MVP: ", langButton(mvp), ` (${mvpHops} hops)`] : []),
  );
}

function pickService() {
  const now = Date.now();
  const up = state.services.filter((s) => state.stats.get(s.id).downUntil <= now);
  const fresh = up.filter((s) => s.id !== state.lastId);
  const pool = fresh.length ? fresh : up;
  return pool[Math.floor(Math.random() * pool.length)];
}

async function ask(service, n) {
  const started = performance.now();
  try {
    const response = await fetch(`/svc/${service.id}/?n=${n}`, {
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
    });
    const body = await response.text();
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const answer = Number(body.match(/-?\d+/g)?.at(-1));
    if (!Number.isSafeInteger(answer)) throw new Error(`no number in "${body.trim().slice(0, 40)}"`);
    return { answer, ms: performance.now() - started };
  } catch (error) {
    return { error: error.name === "TimeoutError" ? "timed out" : error.message };
  }
}

async function relay() {
  for (;;) {
    while (state.paused) await sleep(150);

    const current = state.chain.at(-1).n;
    if (current === 1) {
      finishChain();
      render();
      await sleep(PAUSE_BETWEEN_CHAINS_MS);
      startChain();
      render();
      continue;
    }

    const service = pickService();
    if (!service) {
      await sleep(1000); // everyone is down; wait for a retry window
      continue;
    }

    const chainNo = state.chainNo;
    const result = await ask(service, current);
    if (chainNo !== state.chainNo) continue; // reseeded while we waited

    const stats = state.stats.get(service.id);
    state.lastId = service.id;

    if (result.error) {
      stats.deaths += 1;
      stats.downUntil = Date.now() + RETRY_DOWN_AFTER_MS;
      logLine("bad", "💀 ", langButton(service.id), ` is down (${result.error})`);
      render();
      await sleep(150);
      continue;
    }

    const expected = step(current);
    stats.hops += 1;
    stats.totalMs += result.ms;
    const hop = { n: expected, id: service.id, ms: result.ms };
    if (result.answer !== expected) {
      stats.lies += 1;
      hop.claimed = result.answer;
      logLine(
        "bad",
        "🚨 ",
        langButton(service.id),
        ` lied! ${format(current)} → ${format(result.answer)}, should be ${format(expected)}`,
      );
    } else {
      logHop(current, hop);
    }
    state.chain.push(hop);
    render();
    await sleep(state.delay);
  }
}

// --- Rendering ----------------------------------------------------------------

const nameOf = (id) => state.byId.get(id)?.name ?? id;
const kindOf = (id) => (id ? (state.byId.get(id).native ? "native" : "shim") : "seed");
const badgeOf = (id) => (state.byId.get(id).native ? "🏅" : "🩹");
const xMaxOf = (chain) => Math.max(chain.length - 1, 30);
const peakOf = (chain) => chain.reduce((best, p) => (p.n > best.n ? p : best), chain[0]);
const langButton = (id, label = nameOf(id)) =>
  el("button", { type: "button", class: "lang", "data-source": id, title: "Show the source" }, label);

function logHop(from, hop) {
  logLine(
    "",
    `${format(from)} `,
    el("span", { class: "by" }, "─", langButton(hop.id), "→"),
    ` ${format(hop.n)} `,
    el("span", { class: "ms" }, `${Math.round(hop.ms)} ms`),
  );
}

function logLine(kind, ...content) {
  const log = $("log");
  const item = el("li", kind ? { class: kind } : {}, ...content);
  log.prepend(item);
  while (log.children.length > LOG_LIMIT) log.lastChild.remove();
}

function render() {
  renderTiles();
  renderBoard();
  renderChart();
}

function renderTiles() {
  const chain = state.chain;
  const last = chain.at(-1);
  const peak = peakOf(chain);
  $("current").textContent = format(last.n);
  $("last-hop").replaceChildren(
    ...(last.id ? ["from ", langButton(last.id), `, ${Math.round(last.ms)} ms`] : ["fresh seed"]),
  );
  $("seed").textContent = format(chain[0].n);
  $("steps").textContent = `step ${chain.length - 1}`;
  $("peak").textContent = format(peak.n);
  $("peak-by").replaceChildren(...(peak.id ? ["by ", langButton(peak.id)] : ["the seed itself"]));
  $("chains").textContent = format(state.finished);
  $("longest").textContent = state.longest
    ? `longest: ${format(state.longest.seed)}, ${state.longest.steps} steps`
    : " ";
}

function renderBoard() {
  const avg = (s) => (s.hops ? s.totalMs / s.hops : Infinity);
  const filter = state.filter.toLowerCase();
  const rows = state.services
    .filter((service) => !filter || `${service.name} ${service.tier}`.toLowerCase().includes(filter))
    .sort((a, b) => {
      const sa = state.stats.get(a.id);
      const sb = state.stats.get(b.id);
      return avg(sa) - avg(sb) || sb.hops - sa.hops || a.name.localeCompare(b.name);
    });
  const now = Date.now();
  $("board").replaceChildren(
    ...rows.map((service) => {
      const s = state.stats.get(service.id);
      const down = s.downUntil > now;
      return el(
        "tr",
        down ? { class: "down" } : {},
        el("td", {}, langButton(service.id, `${badgeOf(service.id)} ${service.name}`)),
        el("td", { class: "tier" }, service.tier),
        el("td", { class: "num" }, format(s.hops)),
        el("td", { class: "num" }, s.hops ? `${Math.round(avg(s))} ms` : "–"),
        el("td", { class: "num" }, down ? `${s.deaths} now` : String(s.deaths)),
        el("td", { class: "num" }, String(s.lies)),
      );
    }),
  );
}

function renderChart() {
  const plot = $("plot");
  const chain = state.chain;
  const width = plot.clientWidth;
  const height = plot.clientHeight;
  const margin = MARGIN;
  const innerW = width - margin.left - margin.right;
  const innerH = height - margin.top - margin.bottom;

  const xMax = xMaxOf(chain);
  const yMax = Math.max(10, peakOf(chain).n * 1.6);
  const logMax = Math.log10(yMax);
  const x = (i) => margin.left + (i / xMax) * innerW;
  const y = (v) => margin.top + (1 - Math.log10(v) / logMax) * innerH;

  const nodes = [];

  // Grid: powers of ten up the side, a handful of step counts along the bottom.
  for (let p = 0; 10 ** p <= yMax; p++) {
    const gy = y(10 ** p);
    nodes.push(svg("line", { class: p === 0 ? "baseline" : "grid", x1: margin.left, x2: width - margin.right, y1: gy, y2: gy }));
    nodes.push(svg("text", { class: "tick", x: margin.left - 8, y: gy + 4, "text-anchor": "end" }, compact(10 ** p)));
  }
  const every = [5, 10, 20, 25, 50, 100, 200].find((s) => xMax / s <= 8) ?? 500;
  for (let i = 0; i <= xMax; i += every) {
    nodes.push(svg("text", { class: "tick", x: x(i), y: height - 8, "text-anchor": "middle" }, String(i)));
  }

  const points = chain.map((p, i) => `${x(i).toFixed(1)},${y(p.n).toFixed(1)}`);
  nodes.push(svg("polyline", { class: "line", points: points.join(" ") }));

  chain.forEach((p, i) => {
    const kind = kindOf(p.id) + (p.claimed !== undefined ? " lied" : "");
    nodes.push(svg("circle", { class: `dot ${kind}`, cx: x(i), cy: y(p.n), r: 4 }));
  });

  // Direct labels: only the peak and the newest point.
  const peakIndex = chain.indexOf(peakOf(chain));
  const lastIndex = chain.length - 1;
  const labels = new Map();
  labels.set(peakIndex, `peak ${format(chain[peakIndex].n)}${chain[peakIndex].id ? ` · ${nameOf(chain[peakIndex].id)}` : ""}`);
  if (lastIndex !== peakIndex) {
    labels.set(lastIndex, chain[lastIndex].id ? nameOf(chain[lastIndex].id) : `seed ${format(chain[0].n)}`);
  }
  for (const [i, text] of labels) {
    const anchor = x(i) > width - 140 ? "end" : x(i) < margin.left + 60 ? "start" : "middle";
    nodes.push(svg("text", { class: "label", x: x(i), y: y(chain[i].n) - 12, "text-anchor": anchor }, text));
  }

  // Crosshair and focus ring for the hovered (or keyboard-selected) point.
  const tooltip = $("tooltip");
  if (state.hover !== null && state.hover < chain.length) {
    const i = state.hover;
    const p = chain[i];
    nodes.push(svg("line", { class: "crosshair", x1: x(i), x2: x(i), y1: margin.top, y2: height - margin.bottom }));
    nodes.push(svg("circle", { class: "focus-ring", cx: x(i), cy: y(p.n), r: 7 }));

    const who = p.id
      ? `${badgeOf(p.id)} ${nameOf(p.id)} · ${Math.round(p.ms)} ms`
      : "the seed";
    tooltip.replaceChildren(
      el("span", { class: "muted" }, `step ${i}`),
      el("strong", {}, format(p.n)),
      el("span", {}, who),
      ...(p.claimed !== undefined ? [el("div", { class: "muted" }, `🚨 claimed ${format(p.claimed)}`)] : []),
    );
    tooltip.hidden = false;
    const flip = x(i) + 12 + tooltip.offsetWidth > width;
    tooltip.style.left = `${Math.max(flip ? x(i) - tooltip.offsetWidth - 12 : x(i) + 12, 0)}px`;
    tooltip.style.top = `${Math.max(y(p.n) - tooltip.offsetHeight - 12, 0)}px`;
  } else {
    tooltip.hidden = true;
  }

  plot.setAttribute("viewBox", `0 0 ${width} ${height}`);
  plot.replaceChildren(...nodes);
}

function nearestIndex(event) {
  const rect = $("plot").getBoundingClientRect();
  const innerW = rect.width - MARGIN.left - MARGIN.right;
  const i = Math.round(((event.clientX - rect.left - MARGIN.left) / innerW) * xMaxOf(state.chain));
  return Math.min(Math.max(i, 0), state.chain.length - 1);
}

// --- Source viewer ------------------------------------------------------------

const HLJS = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0";
// Languages for the files around the main source; the main file uses services.json's hl.
const HL_BY_FILE = [
  [/^Dockerfile$/, "dockerfile"],
  [/\.(sh|bash)$|^serve$/, "bash"],
  [/\.js$/, "javascript"],
  [/\.(cs|fs|vb)proj$/, "xml"],
  [/\.json$/, "json"],
];
const grammars = new Map(); // language -> Promise<boolean>
const viewer = { service: null, files: [], active: 0, token: 0 };

// highlight.js comes from a CDN with the common grammars; the rest load on demand.
function loadGrammar(language) {
  if (!window.hljs) return Promise.resolve(false);
  if (hljs.getLanguage(language)) return Promise.resolve(true);
  if (!grammars.has(language)) {
    grammars.set(
      language,
      new Promise((resolve) => {
        const script = el("script", { src: `${HLJS}/languages/${language}.min.js` });
        script.onload = () => resolve(Boolean(hljs.getLanguage(language)));
        script.onerror = () => resolve(false);
        document.head.append(script);
      }),
    );
  }
  return grammars.get(language);
}

async function sourceFiles(service) {
  const listing = await (await fetch(`/src/services/${service.id}/`)).json();
  const names = listing.filter((entry) => entry.type === "file").map((entry) => entry.name);
  const others = names.filter((name) => name !== service.source && name !== "Dockerfile").sort();
  const files = [service.source, ...others, ...(names.includes("Dockerfile") ? ["Dockerfile"] : [])].map(
    (name) => ({ name, path: `services/${service.id}/${name}` }),
  );
  if (!service.native) files.push({ name: "shim/handle.sh", path: "shim/handle.sh" });
  return files;
}

async function openSource(id) {
  const service = state.byId.get(id);
  if (!service) return;
  viewer.service = service;
  viewer.files = [{ name: service.source, path: `services/${id}/${service.source}` }];
  $("source-title").textContent = `${badgeOf(id)} ${service.name}`;
  $("source-meta").textContent =
    `${service.tier} · ${service.native ? "serves HTTP itself" : "HTTP through the shim"} · ${service.blurb}`;
  showFile(0);
  const dialog = $("source");
  if (!dialog.open) dialog.showModal();
  try {
    const files = await sourceFiles(service);
    if (viewer.service === service) {
      viewer.files = files;
      renderTabs();
    }
  } catch {
    // The main file is all we can show; the tab already holds it.
  }
}

function renderTabs() {
  $("source-tabs").replaceChildren(
    ...viewer.files.map((file, i) => {
      const tab = el("button", { type: "button", role: "tab", class: "tab", "aria-selected": String(i === viewer.active) }, file.name);
      tab.addEventListener("click", () => showFile(i));
      return tab;
    }),
  );
}

async function showFile(index) {
  viewer.active = index;
  renderTabs();
  const file = viewer.files[index];
  const token = ++viewer.token;
  const code = $("source-code");
  code.className = "";
  code.textContent = "Loading…";
  $("source-gutter").textContent = "";

  let text;
  try {
    const response = await fetch(`/src/${file.path.split("/").map(encodeURIComponent).join("/")}`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    text = (await response.text()).replace(/\n$/, "");
  } catch {
    if (token === viewer.token) code.textContent = `Couldn't load ${file.name}.`;
    return;
  }
  const basename = file.name.split("/").pop();
  const language = index === 0 ? viewer.service.hl : HL_BY_FILE.find(([pattern]) => pattern.test(basename))?.[1];
  const highlighted = language ? await loadGrammar(language) : false;
  if (token !== viewer.token) return;

  $("source-gutter").textContent = text.split("\n").map((_, i) => i + 1).join("\n");
  if (basename.endsWith(".ws")) {
    code.className = "whitespace";
    code.innerHTML = visibleWhitespace(text);
  } else if (highlighted) {
    code.innerHTML = hljs.highlight(text, { language, ignoreIllegals: true }).value;
  } else {
    code.textContent = text;
  }
  $("source-body").scrollTo(0, 0);
}

// In Whitespace the blank characters are the program, so draw them.
function visibleWhitespace(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/ /g, '<span class="ws">·</span>')
    .replace(/\t/g, '<span class="ws">→</span>')
    .replace(/\n/g, '<span class="ws">↵</span>\n');
}

// --- Wiring -------------------------------------------------------------------

function wireControls() {
  const toggle = $("toggle");
  toggle.addEventListener("click", () => {
    state.paused = !state.paused;
    toggle.textContent = state.paused ? "Resume" : "Pause";
  });

  $("reseed").addEventListener("click", () => {
    startChain();
    render();
  });

  const delay = $("delay");
  try {
    const saved = localStorage.getItem("hailstone.delay");
    if (saved !== null) delay.value = saved;
  } catch {}
  const applyDelay = () => {
    state.delay = Number(delay.value);
    $("delay-out").textContent = `${state.delay} ms`;
    try {
      localStorage.setItem("hailstone.delay", delay.value);
    } catch {}
  };
  delay.addEventListener("input", applyDelay);
  applyDelay();

  const plot = $("plot");
  plot.addEventListener("pointermove", (event) => {
    state.hover = nearestIndex(event);
    renderChart();
  });
  plot.addEventListener("pointerleave", () => {
    state.hover = null;
    renderChart();
  });
  plot.addEventListener("click", (event) => {
    const id = state.chain[nearestIndex(event)]?.id;
    if (id) openSource(id);
  });
  plot.addEventListener("keydown", (event) => {
    const last = state.chain.length - 1;
    const moves = { ArrowLeft: -1, ArrowRight: 1, Home: -Infinity, End: Infinity };
    if (event.key === "Escape") state.hover = null;
    else if (event.key === "Enter" && state.chain[state.hover]?.id) return openSource(state.chain[state.hover].id);
    else if (event.key in moves) {
      const from = state.hover ?? last;
      state.hover = Math.min(Math.max(from + moves[event.key], 0), last);
    } else return;
    event.preventDefault();
    renderChart();
  });
  plot.addEventListener("blur", () => {
    state.hover = null;
    renderChart();
  });
  new ResizeObserver(() => renderChart()).observe(plot);

  $("filter").addEventListener("input", (event) => {
    state.filter = event.target.value;
    renderBoard();
  });

  // Any language name on the page opens its source.
  document.addEventListener("click", (event) => {
    const button = event.target.closest("[data-source]");
    if (button) openSource(button.dataset.source);
  });
  const dialog = $("source");
  dialog.addEventListener("click", (event) => {
    if (event.target === dialog) dialog.close(); // a click on the backdrop
  });
}

async function main() {
  state.services = await (await fetch("services.json")).json();
  for (const service of state.services) {
    state.byId.set(service.id, service);
    state.stats.set(service.id, { hops: 0, totalMs: 0, deaths: 0, lies: 0, downUntil: 0 });
  }
  $("language-count").textContent = String(state.services.length);
  wireControls();
  startChain();
  render();
  relay();
}

main();
