# 🌌 Promptore

> **A living archive of human imagination** — *discover, collect, and remix powerful AI prompts.*

Promptore is a premium, atmospheric prompt-sharing platform designed for writers, coders, worldbuilders, and dreamers. Pair-styled with rich dark hues, subtle neon glows, and vintage light-parchment modes, transforming prompt discovery into an experience of uncovering forgotten transmissions, forbidden archives, and machine dreams.

---

## 🏛️ Platforms & Stacks

Promptore is engineered across two modular, high-fidelity stacks:

### 1. 📱 Mobile Platform (Flutter)
A beautiful, highly animated mobile application leveraging GoRouter, Riverpod, and Hive.
* **Core Folder:** [`lib/`](file:///c:/Users/rishad/Desktop/Promptore/lib)
* **Setup:**
  ```bash
  flutter pub get
  flutter run
  ```

### 2. 🌌 Web Platform (React + Vite SPA)
An extremely fast, native, fully web-accessible React single-page application built to match our premium three-column desktop mockup layout.
* **Core Folder:** [`promptore_web/`](file:///c:/Users/rishad/Desktop/Promptore/promptore_web)
* **Setup:**
  ```bash
  cd promptore_web
  npm install
  npm run dev
  ```
  Open 👉 [http://localhost:5173/](http://localhost:5173/) to explore.

---

## ✨ Features

### 📡 Telemetry Feed
* **Atmospheric Feed:** Explore prompts designed to evoke wonder, from philosophical AI personas to cinematic image prompts.
* **Impact Scores & Echoes:** Interact with prompts through "Echoes" (likes), "Archives" (saves), and "Remixes".
* **Dynamic Time Widget:** Displays system visual clocks, reactively adapting status subtitles dynamically depending on the hour of the day.
* **Telemetry Activity Log:** A cinematic terminal outputting real-time system activities like echo transmissions, theme adjustments, and creator follows.

### 🏛️ Collections & Curation Volumes
* **Custom Archives:** Save your favorite prompt discoveries into custom collections.
* **Volumes Overlays:** Read curation manuscripts inside beautifully designed collection detail drawers with zero-latency load states.

---

## 🛠️ Web Architecture Details

* **Visual Theme Adaptation:** Supports dark (Obsidian) and light (Parchment) variables mapped natively using dynamic HSL configurations.
* **Web Accessibility (A11y):** Native semantic buttons, gold `:focus-visible` outline offsets, key event handlers (`Enter`/`Space`), and detailed screen reader `aria-label` elements.
* **Build tool:** Vite 8.0 with Hot Module Replacement (HMR).
