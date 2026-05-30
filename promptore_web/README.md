# 🌌 Promptore Web Application

> **A native, premium React + Vite SPA built to unleash the ultimate web performance for Promptore.**

Welcome to the web architecture of Promptore! Migrating from Flutter for Web to this React + Vite single-page application guarantees near-instantaneous page loads, fluid scrolling transitions, and standard-compliant web accessibility.

---

## 🎨 Design Systems & Theme

The React web application is built strictly around the **3-Column Mockup Layout**:
1. **Left Sidebar (240px):** Logo, interactive navigations, visual theme triggers, and live clock telemetry status.
2. **Center Column (1fr):** Main content feed, header search bars, hero blocks, category grid elements, curations volumes, and remix editors.
3. **Right Column (320px):** Curated quotes, top categories index, and trending prompts scoreboard.

### Themes
We support dynamic HSL-based dark/light visual modes, mapping:
* **Obsidian Mode (Dark):** Pitch space-dark backdrop (`hsl(220, 25%, 7%)`) and gold highlight markers.
* **Parchment Mode (Light):** Immersive, high-fidelity light sepia backdrop (`hsl(40, 24%, 90%)`) that feels like a vintage paper manuscript.

---

## ⚡ Accessibility (A11y) & Telemetry Features

* **Visual Focus Rings:** Built elegant keyboard focus indicators using the golden accent theme color (`*:focus-visible`).
* **Keyboard Event Handlers:** Enabled keyboard listeners (`Enter`/`Space`) for custom clickable grid cells and tiles.
* **Screen Reader Metadata:** Injected robust `aria-label` tags on all icon-only buttons (Likes, bookmarks, compose, themes).
* **Live System Clock:** Built a reactive system clock that fetches the user's local browser time dynamically, adjusting subtitles depending on the hours of the day (e.g. "Keep creating" vs. "Infinite paths await").
* **Archival Transmissions Log:** An automated telemetry log that captures visual themes, prompt echoes, archives, follows, and compositions in real-time.

---

## 🚀 Getting Started

Ensure you have [Node.js](https://nodejs.org) installed on your machine.

### Installation & Run

1. **Navigate to the web workspace:**
   ```bash
   cd promptore_web
   ```

2. **Install all packages:**
   ```bash
   npm install
   ```

3. **Spin up local dev server (with HMR):**
   ```bash
   npm run dev
   ```
   Open 👉 [http://localhost:5173/](http://localhost:5173/) to see the dashboard.

4. **Production Build:**
   ```bash
   npm run build
   ```
