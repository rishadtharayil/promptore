# 🌌 Promptore

> **A living archive of human imagination** — *discover, collect, and remix powerful AI prompts.*

Promptore is a premium, atmospheric prompt-sharing platform designed for writers, coders, worldbuilders, and dreamers. Built with Flutter, it is styled with rich dark hues, subtle neon glows, and vintage grain overlays, transforming prompt discovery into an experience of uncovering forgotten transmissions, forbidden archives, and machine dreams.

---

## ✨ Features

### 📡 The Feed
* **Atmospheric Feed:** Explore prompts designed to evoke wonder, from philosophical AI personas to cinematic image prompts.
* **Impact Scores & Echoes:** Interact with prompts through "Echoes" (likes), "Archives" (saves), and "Remixes".
* **Diverse Categories:** Navigate through carefully tagged sections:
  * 🎭 **Character:** Poetic AI personas (e.g., *The Machine That Dreams In Rain*, *The Fallen Idealist*).
  * 🗺️ **Worldbuilding:** Deep, immersive settings.
  * 🖼️ **Image:** High-fidelity generation prompts (Kodak, cinematic autumns).
  * 💻 **Coding:** Blunt systems architects, brutal developers.
  * 🌀 **Simulation & Philosophy:** Stream-of-consciousness simulators, alternate-history oracles.

### 🏛️ Collections & Archiving
* **Custom Archives:** Save your favorite prompt discoveries into custom collections.
* **Interactive Bottom Sheets:** Seamlessly create new collections and add prompts on the fly.
* **Detailed Collection Views:** Organize by themes like *Atmospheric Persona*, *Creative Worldbuilding*, or *Coding & Logic*.

### ⚡ Remixing & Customization
* **Prompt Editor:** Take an existing prompt and adapt it to your unique context.
* **Remix Screen:** Tweak the core elements and variables to build new variants while preserving credit to the original creator.

### 📜 Premium Immersive UI/UX
* **Glow Containers & Dividers:** Micro-interactions built with custom glowing borders, soft shadows, and deep atmospheric color schemes.
* **Typewriter Prompt Reader:** Read and copy prompt contents through a highly interactive, simulated terminal-like typewriter screen.
* **Smooth & Highly Performant Animations:** Integrated with `flutter_animate` for organic, fluid transitions between states, with capped staggered delays for buttery-smooth list scrolling.

---

## 🛠️ Tech Stack & Architecture

Promptore is designed with a **Feature-First Architecture** to ensure high scalability, modularity, and clean separation of concerns.

* **Core Platform:** [Flutter SDK](https://flutter.dev) (v3.12+) & Dart
* **State Management:** [Riverpod](https://riverpod.dev) — reliable, declarative, and easily testable global state
* **Navigation:** [GoRouter](https://pub.dev/packages/go_router) — declarative routing with deep-link support
* **Local Storage:** [Hive](https://pub.dev/packages/hive) — ultra-fast local NoSQL database
* **Typography:** [Google Fonts](https://pub.dev/packages/google_fonts) — customized atmospheric font pairings
* **Animations:** [Flutter Animate](https://pub.dev/packages/flutter_animate) — smooth micro-animations and fading transitions

---

## 📂 Project Structure

```yaml
lib/
├── main.dart                      # App entry point
├── shell/
│   └── main_shell.dart            # Atmospheric responsive shell with custom navigation
└── core/
    ├── data/
    │   └── mock_data.dart         # Rich, immersive mock database (Seed Users, Prompts, Collections)
    ├── models/
    │   └── models.dart            # Clean, immutable Dart models for Prompts, Users, & Collections
    ├── providers/
    │   └── theme_provider.dart    # Theme controller
    ├── router/
    │   └── app_router.dart        # Unified GoRouter configuration
    ├── theme/
    │   ├── colors.dart            # Obsidian backgrounds, spectral amber, static grays
    │   ├── dimensions.dart        # Geometric responsive spacing scale
    │   ├── promptore_theme.dart   # System-wide dark & atmospheric theme mappings
    │   └── typography.dart        # Customized modern text styles
    └── widgets/
        ├── atmospheric_divider.dart # Custom subtle glowing line dividers
        ├── glow_container.dart      # Glow-bordered layouts
        └── fade_in_widget.dart      # Organic entry transitions
└── features/
    ├── onboarding/                # Cinematic entrance & setup
    ├── feed/                      # Core prompt discoverability & feed cards
    ├── explore/                   # Category grids & trending indexes
    ├── search/                    # Live tagging, keywords, & author lookups
    ├── compose/                   # Editor & new prompt builder
    ├── remix/                     # Forking & tweaking engine
    ├── collections/               # Personal archives & collection management
    ├── prompt_reader/             # Immersive typewriter terminal reader
    └── profile/                   # User identities & custom moods
```

---

## 🚀 Getting Started

Follow these instructions to set up and run Promptore on your local machine.

### Prerequisites
Make sure you have Flutter installed. You can verify your environment by running:
```bash
flutter doctor
```

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/rishadtharayil/promptore.git
   cd promptore
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   # Run on any connected device/emulator
   flutter run
   
   # Or run directly on Web for high-fidelity browser testing
   flutter run -d chrome
   ```

---

## 🎨 Visual Identity

Promptore's design is heavily inspired by atmospheric sci-fi, cyberpunk archives, and terminal aesthetics:
* **The Backgrounds:** Deep space Obsidian (`0xFF0A0A0C`) and Coal (`0xFF111114`) hues to eliminate eye strain.
* **The Accent Glow:** Spectral Amber (`0xFFD48C46`), Cosmic Turquoise (`0xFF46B3D4`), and Static Gray (`0xFF788290`) for tactile highlights.
* **Typography:** Inter for clean, geometric structure, paired with a custom terminal-esque mono typeface for code and raw prompts.
