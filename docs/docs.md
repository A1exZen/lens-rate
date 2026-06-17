# 🟢 LENSRATE — Master Documentation

> *Смотри цену в своей валюте. Мгновенно. Удобно. Без лишних действий.*

**v1.0 · PRD + Design System + Flutter Code Standards**

---

## Содержание

| Часть | Что внутри | Разделы |
|-------|-----------|---------|
| **Part I** | Product Requirements — vision, features, architecture, timeline | § 1 – 8 |
| **Part II** | UI/UX Design System — colour, type, spacing, components, motion | § 10 – 18 |
| **Part III** | Flutter Code Standards — architecture, patterns, best practices | § 19 – 26 |

---

<br>

# PART I — Product Requirements
> *What we're building and why*

---

## 1. Product Overview

> **Vision**
> Point your camera at any price tag — see the converted price instantly, overlaid in real time.
> No taps. No switching apps. Just look and know.

LensRate is a minimal, fast AR currency converter for iOS and Android. The core experience is a live camera view that continuously recognises prices in any currency and overlays the converted amount directly on the price tag — like seeing the world in your own currency.

Beyond the camera, the app provides a clean manual converter and offline support via cached exchange rates. Future versions will extend to cryptocurrency pairs.

### 1.1 Problem Statement

Existing currency converters require the user to manually type a number, switch between apps, or perform multiple taps. In real-world shopping scenarios — markets, retail stores, cross-border e-commerce — this friction adds up constantly.

Google Lens partially solves OCR but requires copying text, leaving the converter, pasting, and interpreting a result. LensRate collapses this to zero taps.

### 1.2 Target Audience

- Travellers shopping in foreign countries
- Expats managing daily spending in a non-native currency
- Cross-border online shoppers (AliExpress, Amazon, EU stores)
- Anyone who regularly deals with multiple currencies

### 1.3 Platforms

- iOS 15+ — distributed via App Store
- Android 8.0+ — distributed via Google Play
- Single codebase via Flutter 3.x

---

## 2. Goals & Success Metrics

| Goal | Metric | MVP Target |
|------|--------|-----------|
| Fast recognition | Time from camera open to overlay | < 1.5 seconds |
| Accurate OCR | Price recognised correctly | > 90% in good lighting |
| Day-7 Retention | Users returning after Day 7 | > 35% |
| Crash-free rate | Sessions without crash | > 99.5% |
| App Store rating | Average rating at launch | ≥ 4.5 stars |

---

## 3. Feature Specification

**Priority scale:** `P0` = MVP blocker · `P1` = MVP nice-to-have · `P2` = Post-MVP

### 3.1 Camera & AR Mode (Core)

| Feature | Description | Priority |
|---------|-------------|----------|
| Live camera feed | Full-screen camera preview, portrait & landscape | `P0` |
| OCR — price detection | Detect numbers + currency symbols/codes using ML Kit Text Recognition v2 (on-device). MVP uses tap-to-scan; live streaming is the P1 upgrade below | `P0` |
| Tap-to-scan OCR | Tap the frame to capture a still, recognise prices on it, and show overlays. MVP entry point — simpler and more stable than per-frame streaming | `P0` |
| AR overlay | Converted price rendered directly on top of detected price tag using CustomPainter bounding box | `P0` |
| Auto currency detect | Infer source currency from symbol ($, €, £, ¥, zł, ₽) or ISO code | `P0` |
| Target currency select | User selects 'convert to' currency before opening camera | `P0` |
| Overlay styling | Clean pill/badge overlay: converted amount + currency code, semi-transparent background | `P0` |
| Live real-time overlay | Continuous per-frame OCR via `startImageStream` (no tap), overlay updates as the camera moves | `P1` |
| Multiple prices | Detect and overlay multiple prices visible in frame simultaneously | `P1` |
| Tap to freeze | Tap screen to freeze frame and examine overlays without motion blur | `P1` |
| Torch toggle | Enable device flashlight for low-light environments | `P1` |

### 3.2 Manual Converter

| Feature | Description | Priority |
|---------|-------------|----------|
| Amount input | Numeric keyboard, supports decimals | `P0` |
| From / To currency selector | Searchable list of all supported currencies with flag icons | `P0` |
| Swap currencies | One-tap swap of from/to with animation | `P0` |
| Live result | Converts as user types, no confirm button needed | `P0` |
| Recent pairs | Last 5 used currency pairs shown at top of selector | `P1` |
| Conversion history | List of last 20 manual conversions with timestamp | `P1` |

### 3.3 Exchange Rates

| Feature | Description | Priority |
|---------|-------------|----------|
| Rate source | open.er-api.com keyless endpoint (MVP); ExchangeRate-API free tier as keyed fallback | `P0` |
| Rate refresh | Fetch on app open if > 1 hour since last fetch | `P0` |
| Offline mode | Use last cached rates with 'Rates from [date/time]' indicator | `P0` |
| Supported currencies | All major ISO 4217 fiat currencies (minimum 30 at launch) | `P0` |
| Rate timestamp | Show when rates were last updated in UI | `P0` |
| Crypto (BTC, ETH) | Add crypto pairs via CoinGecko API | `P2` |

### 3.4 Settings

| Feature | Description | Priority |
|---------|-------------|----------|
| Default 'to' currency | Set once, persists across sessions | `P0` |
| Default 'from' currency | Optional, defaults to device locale | `P0` |
| Theme | Light / Dark / System (default Light) | `P1` |
| Language | UI language English / Русский (default Русский); persists | `P1` |
| Haptic feedback | Toggle vibration on price detection | `P1` |
| Rate provider | Switch between free rate sources | `P2` |

---

## 4. Screens & Navigation

> **Navigation Structure**
> Bottom Tab Bar → 2 main tabs: **[Camera]** · **[Converter]**
> Settings accessible via gear icon (top-right, persistent across tabs)
> Currency selector is a bottom sheet modal (shared between tabs)

### 4.1 Camera Screen

- Full-screen camera preview (edge-to-edge, no safe area padding on preview)
- Top bar: [From currency badge] → [Swap icon] → [To currency badge]
- AR overlays rendered as floating pills over detected prices
- Bottom bar: [Torch icon] | [Freeze/Unfreeze icon] | [Manual converter shortcut]
- Permission denied state: illustration + explanation + 'Open Settings' CTA
- No-rates state: offline banner at top, last cached date shown

### 4.2 Manual Converter Screen

- Large numeric input field at top
- From currency row: flag + code + chevron → opens currency selector
- Swap button (animated 180° rotation)
- To currency row: same pattern
- Result displayed large below, updates live
- Rate info line: `1 USD = 0.92 EUR · Updated 14 min ago`
- History section below fold (last 20 conversions, swipe to delete)

### 4.3 Currency Selector (Bottom Sheet)

- Search field at top (auto-focus on open)
- Recent currencies section (top 5)
- All currencies list: flag emoji + full name + ISO code
- Smooth keyboard avoidance

### 4.4 Settings Screen

- Default currencies section
- Appearance: theme toggle
- Data: rate source, last updated, force refresh button
- About: version, privacy policy, rate the app

---

## 5. MVP Scope

### ✅ In Scope — MVP

- Camera screen with live OCR + AR overlay
- Manual converter with live conversion
- All major fiat currencies (minimum 30)
- Offline mode with cached rates
- Default currency settings
- Light + Dark theme
- iOS + Android via Flutter

### ❌ Out of Scope — Post-MVP

- Cryptocurrency pairs (BTC, ETH, SOL, etc.)
- Bank-specific rates and fee calculation
- Home screen / lock screen widgets
- Apple Watch / Wear OS companion
- Budget tracker / trip spending mode
- Barcode / QR code scanning
- Social / share features

---

## 6. Technical Architecture

### 6.1 Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Framework | Flutter 3.x | Single codebase, iOS + Android |
| Language | Dart 3.x | Strong typing, async/await, null safety |
| Camera | camera (pub.dev) | Stream frames to ML Kit |
| OCR | google_mlkit_text_recognition | On-device, fast, no API calls |
| AR Overlay | CustomPainter + Stack widget | Bounding box from ML Kit result |
| Exchange Rates | http + open.er-api.com | Keyless free endpoint (no signup); ExchangeRate-API w/ key kept as fallback |
| Local Storage | shared_preferences + Hive | Prefs + rate cache / history (rates cached as JSON string, no TypeAdapters) |
| State Mgmt | Riverpod 3.x (codegen) | `@riverpod` providers, testable, scalable |
| Navigation | go_router | Declarative, deep-link ready |
| DI | Riverpod providers | No separate DI library needed |

### 6.2 Folder Structure

```
lib/
├── main.dart
├── app.dart                    # MaterialApp, theme, router setup
├── core/
│   ├── constants/              # app_colors.dart, app_text_styles.dart, app_spacing.dart
│   ├── extensions/             # string_ext.dart, double_ext.dart
│   ├── utils/                  # currency_formatter.dart, price_regex.dart
│   └── errors/                 # app_error.dart, failure.dart
├── data/
│   ├── models/                 # rate_model.dart, currency_model.dart
│   ├── repositories/           # rates_repository.dart, currency_repository.dart
│   └── sources/
│       ├── remote/             # rates_api.dart
│       └── local/              # rates_cache.dart, prefs_storage.dart
├── domain/
│   ├── entities/               # rate.dart, currency.dart, conversion.dart
│   └── usecases/               # convert_currency.dart, fetch_rates.dart
├── presentation/
│   ├── camera/
│   │   ├── camera_screen.dart
│   │   ├── camera_controller_provider.dart
│   │   ├── ocr_provider.dart
│   │   └── widgets/            # ar_overlay_painter.dart, currency_chip.dart
│   ├── converter/
│   │   ├── converter_screen.dart
│   │   ├── converter_provider.dart
│   │   └── widgets/            # swap_button.dart, currency_row.dart
│   ├── currency_selector/
│   │   ├── currency_selector_sheet.dart
│   │   └── currency_search_provider.dart
│   └── settings/
│       └── settings_screen.dart
└── shared/
    └── widgets/                # rate_info_line.dart, offline_banner.dart
```

### 6.3 Camera Pipeline

> **Detailed scanning rules:** see [`docs/ocr_scanning.md`](ocr_scanning.md) for
> the exact number-detection, currency-resolution and ranking rules.

**MVP — tap-to-scan with freeze frame** (simpler & avoids live preview-vs-photo
coordinate mismatch):

1. `camera` plugin opens `CameraController` in `ResolutionPreset.high`
2. User taps Scan → `takePicture()` captures a still and the frame is frozen
3. `InputImage.fromFilePath()` built from the captured file
4. `TextRecognizer.processImage()` runs on-device (ML Kit)
5. `PriceParser` applied to recognised text lines to find price + currency cue
6. Source currency auto-detected from symbol/ISO code; rate applied → converted
7. Bounding boxes mapped (BoxFit.cover transform) onto the frozen still and
   rendered as **positioned pill widgets** (`PriceOverlay`), not a CustomPainter —
   richer styling per §14.1 and easier text layout. Max 3 overlays.
8. Tap Scan again to return to live preview.

**EXIF / coordinate alignment:** `InputImage.fromFilePath()` and `Image.file`
both apply EXIF rotation, so bounding boxes and the displayed still are always
in display-space (portrait). `ui.instantiateImageCodec` is used to read the
saved image's logical size (`imageSize` passed to `PriceOverlay`). On some
Android builds the codec returns raw sensor dims (landscape) without EXIF
correction. Guard in `_decodeSize`: if `sensorOrientation` is 90 or 270 and
the decoded width > height, swap w/h so all three coordinate spaces agree.

**P1 upgrade — live overlay:** `startImageStream()` emits `CameraImage` ~every
100ms; same detection runs per frame with a CustomPainter for the bounding boxes.

```dart
// Price detection regex (PriceParser) — needs a currency cue (symbol or ISO)
RegExp(r'([$€£¥₽₴₩₹฿₺]|zł|R\$)?\s?(\d[\d.,\s]*)\s?([A-Z]{3})?');
```

### 6.4 Offline Strategy

- On successful fetch: cache full rates JSON + timestamp in Hive
- On app open: if cache age < 1h → use cache. If > 1h + online → fetch. If > 1h + offline → use cache + show warning
- Manual converter always works offline with cached rates
- Camera mode works offline with cached rates (overlay shows stale indicator)

---

## 7. Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| OCR fails on stylised/blurry price tags | 🔴 High | Fallback: manual entry; improve with user feedback data post-launch |
| ExchangeRate-API free tier limits hit | 🟡 Medium | Cache aggressively; add Open Exchange Rates as fallback |
| Flutter camera plugin instability | 🟡 Medium | Pin plugin version; integration test on real devices early |
| App Store rejection (camera permissions) | 🟢 Low | Follow Apple/Google privacy guidelines, clear permission rationale strings |
| Google Lens perceived as sufficient by users | 🔴 High | Position as dedicated tool: faster, no Google account, offline, privacy-first |

---

## 8. MVP Delivery Timeline

> **Build order note (v1.0 update):** the camera/OCR is the hardest, highest-risk
> part, so the MVP is built converter-first. The currency + rate infrastructure is
> proven on the simple converter screen before the camera pipeline is attempted.

| Sprint | Phase | Deliverables |
|--------|-------|-------------|
| **S1** | P0 | Project setup: deps, folder structure, design tokens, theme (light/dark), go_router 2-tab shell, permissions, CLAUDE.md |
| **S2** | P1 | Domain + data: currency catalog (30+), rates repository, keyless rate API, Hive cache, offline strategy, providers |
| **S3** | P2–P4 | Manual converter (live conversion), currency selector bottom sheet, settings (default currencies, theme persist, force refresh) |
| **S4** | P5 | Camera + OCR tap-to-scan on real device: preview, capture, price regex, currency auto-detect, AR overlay |
| **S5** | P6 | Polish: animations, empty/error/offline states, haptics, a11y; QA on real devices; store submission prep. Live-streaming OCR (P1) as stretch |

---

<br>

# PART II — UI/UX Design System
> *How it looks, feels, and moves*

---

## 10. Design Philosophy

> **Core Principle**
> LensRate is a tool, not an experience. It should feel invisible — the user thinks about the price, not the app.
> Every pixel on screen must earn its place. Anything that doesn't help the user understand the price must be removed.

### 10.1 Four Design Pillars

| Pillar | What it means | How we achieve it |
|--------|--------------|------------------|
| **Minimal** | Nothing unnecessary on screen | No decorative elements, no gradients for style, no icons without labels |
| **Instant** | User gets answer before they think to ask | AR overlay < 1.5s, live conversion as you type, no loading spinners where avoidable |
| **Trustworthy** | User always knows the rate is accurate | Rate timestamp always visible, source shown, stale rates clearly flagged |
| **Native** | Feels at home on iOS and Android | SF Pro on iOS, Roboto on Android; follow each platform's nav conventions |

### 10.2 Design Inspiration

The reference design (BYNvision) demonstrates the right direction: clean card-based overlays on the camera feed, green brand colour conveying trust and financial clarity, minimal chrome on the camera screen, and clear iconography with short labels. LensRate takes this foundation and makes it platform-agnostic and globally applicable.

---

## 11. Colour System

> **Colour Philosophy**
> Green is the primary colour — it communicates currency, trust, and positive action universally.
> The palette is intentionally restrained: one primary, one accent, neutrals, semantic colours only.
> Dark mode uses the same hues shifted to work on dark surfaces — not simply inverted.

### 11.1 Primary Palette

| Swatch | Name | Hex | Role | Usage |
|--------|------|-----|------|-------|
| 🟢 | Primary | `#16A34A` | Brand | Buttons, active tab, AR overlay accent, links |
| 🟩 | Primary Dark | `#15803D` | Brand pressed | Button pressed state, dark header elements |
| 🌿 | Primary Light | `#DCFCE7` | Brand tint | Selected state bg, chip backgrounds |
| 🍃 | Primary Bg | `#F0FDF4` | Brand surface | Info boxes, success backgrounds |
| 🔵 | Sky Accent | `#0EA5E9` | Secondary | Secondary actions, info highlights |
| 💙 | Accent Light | `#E0F2FE` | Accent tint | Accent surface, info banners |

### 11.2 Neutral Palette

| Swatch | Name | Hex | Role | Usage |
|--------|------|-----|------|-------|
| ⬛ | Slate 900 | `#0F172A` | Text primary | Headlines, important labels — Light mode |
| 🔲 | Slate 600 | `#475569` | Text secondary | Body text, descriptions |
| ◾ | Slate 400 | `#94A3B8` | Text muted | Captions, placeholders, disabled |
| ▫️ | Slate 200 | `#E2E8F0` | Border | Dividers, input borders, card strokes |
| ⬜ | Slate 50 | `#F8FAFC` | Surface | Card backgrounds, bottom sheets |
| 🔳 | White | `#FFFFFF` | Background | Screen background — Light mode |

### 11.3 Semantic Colours

| Swatch | Name | Hex | Role | Usage |
|--------|------|-----|------|-------|
| ✅ | Success | `#16A34A` | Positive | Rates loaded, conversion success |
| ⚠️ | Warning | `#F59E0B` | Caution | Stale rates (> 1h), slow connection |
| 🟡 | Warning Light | `#FEF3C7` | Warn bg | Warning banner background |
| ❌ | Error | `#EF4444` | Destructive | Failed fetch, OCR error state |
| 🔴 | Error Light | `#FEE2E2` | Error bg | Error banner background |

### 11.4 Dark Mode Tokens

| Token | Light | Dark |
|-------|-------|------|
| Background | `#FFFFFF` | `#0F172A` (Slate 900) |
| Surface | `#F8FAFC` | `#1E293B` (Slate 800) |
| Surface Raised | `#F1F5F9` | `#334155` (Slate 700) |
| Text Primary | `#0F172A` | `#F1F5F9` |
| Text Secondary | `#475569` | `#94A3B8` |
| Border | `#E2E8F0` | `#334155` |
| Primary | `#16A34A` | `#22C55E` (lighter for dark contrast) |
| AR Overlay BG | `rgba(0,0,0,0.62)` | `rgba(0,0,0,0.72)` |

---

## 12. Typography

> **Font Strategy**
> iOS: SF Pro Display / SF Pro Text — system font, renders crisp, no loading, feels native.
> Android: Roboto — Material Design standard, universally available.
> Numbers in results use tabular figures (`tnum`) for stable width as digits change.

### 12.1 Type Scale

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `display-xl` | 40sp | Bold 700 | 1.1 | Converted amount — Manual screen hero result |
| `display-lg` | 32sp | Bold 700 | 1.15 | AR overlay price — main converted number |
| `display-md` | 26sp | SemiBold 600 | 1.2 | Screen titles, large currency codes |
| `title-lg` | 20sp | SemiBold 600 | 1.3 | Section headers, modal titles |
| `title-md` | 17sp | Medium 500 | 1.35 | List item labels, tab bar labels |
| `body-lg` | 16sp | Regular 400 | 1.5 | Descriptions, body copy |
| `body-md` | 15sp | Regular 400 | 1.5 | Secondary descriptions |
| `label-md` | 13sp | Medium 500 | 1.4 | Chip labels, badge text, form hints |
| `caption` | 12sp | Regular 400 | 1.4 | Rate timestamps, footnotes, helper text |
| `micro` | 11sp | Regular 400 | 1.3 | Legal text, version numbers |

### 12.2 Number Formatting Rules

- Always use locale-aware number formatting: `1,234.56` (en) / `1 234,56` (ru/by)
- Show 2 decimal places for most currencies. 0 decimals for JPY, KRW, VND
- Prefix approximate conversions with `≈` symbol (rates are mid-market, not exact bank rate)
- Currency codes always uppercase, 3 letters: `USD`, `EUR`, `BYN`

---

## 13. Spacing & Layout

> **Base Unit:** All spacing uses a **4dp base unit**. All values are multiples of 4.
> This creates visual rhythm and makes spacing decisions fast and consistent.

| Token | Value | Usage |
|-------|-------|-------|
| `space-1` | 4dp | Icon internal padding, minimum touch target padding |
| `space-2` | 8dp | Between icon and label, between badge elements |
| `space-3` | 12dp | Chip padding, compact list item internal padding |
| `space-4` | 16dp | Standard content padding, card internal padding **[DEFAULT]** |
| `space-5` | 20dp | Between sections within a card |
| `space-6` | 24dp | Card-to-card gap, bottom sheet top padding |
| `space-8` | 32dp | Section spacing on screen |
| `space-12` | 48dp | Large vertical spacing between major sections |
| `space-16` | 64dp | Top/bottom screen margin on taller screens |

### 13.1 Grid & Safe Areas

- Horizontal margins: 16dp on phones, 24dp on tablets
- Camera screen: full bleed — zero horizontal margin on camera preview
- Bottom tab bar: respects system safe area inset (iPhone home indicator, Android nav bar)
- Touch targets: minimum **44×44dp** on all interactive elements (Apple HIG / Material 3)
- Bottom sheets: 16dp corner radius top, content starts 24dp from top handle

---

## 14. Component Specifications

### 14.1 AR Price Overlay

> Dark semi-transparent pill card floats over the camera feed.
> Shows detected original price (top, smaller) and converted price (bottom, large and prominent).
> Rounded corners (12dp) to feel non-intrusive. Entry: fade + scale. Exit: fade only.

| Property | Value | Notes |
|----------|-------|-------|
| Container shape | RoundedRect 12dp | Soft corners, feels like floating card |
| Background | `rgba(0, 0, 0, 0.65)` | Dark semi-transparent — readable on any scene |
| Backdrop blur | 8dp blur (if platform allows) | Frosted glass effect when supported |
| Original price | 13sp / Muted white `#94A3B8` | Smaller, secondary — source reference |
| Converted amount | 32sp Bold white | Dominant — this is what user came to see |
| Currency code | 17sp / Primary green | Coloured to brand, scannable |
| Rate line | caption 12sp / Muted | ≈ source, timestamp — trust signal |
| Entry animation | Fade in + scale `0.92→1.0` | 150ms ease-out |
| Exit animation | Fade out | 200ms ease-in |
| Max simultaneous | 3 overlays on screen | More = cluttered; defer off-screen ones |

### 14.2 Currency Selector Chip

- Pill shape, 6dp border radius, Surface background, 1dp border
- Content: flag emoji (22sp) + 3-letter code (15sp Medium) + chevron icon (16dp)
- Pressed state: Primary Light background (`#DCFCE7`)
- Animation: chevron rotates 180° when selector opens — 200ms ease

### 14.3 Swap Button

- Circular button, 44dp diameter, Surface background, 1dp border
- Icon: vertical double-arrow (↕), 20dp, Primary green
- Tap animation: icon rotates 180° over 250ms `cubic-bezier(0.34, 1.56, 0.64, 1)` — spring overshoot
- Haptic: medium impact on tap (if enabled)

### 14.4 Rate Info Line

- Format: `1 USD = 0.9184 EUR · Updated 6 min ago`
- Fresh (< 1h): Text Muted `#94A3B8`
- Stale (1–12h): Warning amber `#F59E0B` + warning icon
- Very stale (> 12h): Error red `#EF4444`
- Tap → force refresh (spinner in place of timestamp during fetch)

### 14.5 Bottom Tab Bar

- 2 tabs only: Camera (primary) and Converter
- Active tab: Primary green icon + label, filled icon variant
- Inactive tab: Muted grey icon + label, outlined icon variant
- No animation on tab switch — instant. Settings gear in top-right corner.

### 14.6 Bottom Sheet (Currency Selector)

- Handle bar: 4×32dp rounded pill, Border colour, centred at top
- Corner radius: 16dp top corners, square bottom (goes to screen edge)
- Search field: 12dp border radius, Surface background, autofocused on open
- List items: 56dp row height, flag (28sp) + full name (15sp) + ISO code (13sp Muted)
- Keyboard avoidance: sheet slides up with keyboard, smooth spring animation
- Dismiss: swipe down OR tap scrim — scrim fades in at 40% black

---

## 15. Screen Specifications

### 15.1 Camera Screen — Layer Model

```
Layer 4 ── Status indicators: online/offline dot + rate timestamp (top-right)
Layer 3 ── Bottom bar: transparent→rgba(0,0,0,0.55), 88dp, [Torch] [Freeze] [Converter]
Layer 2 ── Top bar: rgba(0,0,0,0.55)→transparent, 88dp, [From chip] [↔] [To chip]
Layer 1 ── AR overlays: CustomPainter at exact ML Kit bounding box positions
Layer 0 ── Camera preview: full screen, edge-to-edge, no safe area clipping
```

### 15.2 Manual Converter Screen

- Plain white/dark background — no cards, no shadows
- Amount input: `display-xl` 40sp, cursor blinking in Primary green
- From row: 56dp height, flag + name + amount + chevron
- Swap button: centred between rows, most prominent interactive element
- Result: `display-xl` 40sp, Primary green, `≈ 158.74 BYN`
- Rate info line: caption size, directly below result
- History: below fold, lazy scroll, 48dp rows, swipe to delete

### 15.3 Settings Screen

- Grouped list style (iOS) / Preference screen (Android)
- Sections: Default currencies | Appearance | Exchange Rates | About
- Theme: segmented control (Light / Dark / System)
- Rate timestamp inline as row value, `Updated 14 min ago` in Muted

---

## 16. Motion & Animation

> **Animation Principle**
> Animations communicate state change, not entertain. Every animation must have a purpose.
> Prefer physical easing: ease-out for entrances, ease-in for exits, spring for interactive.
> Never block the user waiting for an animation — they should be able to interact immediately.

### 16.1 Timing Reference

| Category | Duration | Curve | Usage |
|----------|----------|-------|-------|
| Instant | 0–100ms | Linear | Colour changes, icon state swaps |
| Fast | 150ms | ease-out | AR overlay entry, button press feedback |
| Standard | 200–250ms | ease-in-out | Swap animation, tab icon, chip state |
| Expressive | 300ms | spring (stiffness 300, damping 25) | Bottom sheet, swap button rotation |
| Slow | 400–500ms | ease-in-out | Screen transitions, large reveals |
| **NEVER exceed** | **500ms** | — | Any longer animation feels broken |

### 16.2 Animation Catalogue

| Element | Trigger | Animation | Duration / Curve |
|---------|---------|-----------|-----------------|
| AR overlay | Price detected | Fade in + scale `0.92→1.0` | 150ms ease-out |
| AR overlay | Price gone | Fade out | 200ms ease-in |
| Swap button icon | Tap | Rotate 180° (spring overshoot) | 250ms spring |
| Currency chip | Tap | Scale `0.95→1.0` on release | 100ms ease-out |
| Bottom sheet | Open | Slide up + scrim fade in | 300ms spring |
| Bottom sheet | Dismiss | Slide down + scrim fade out | 250ms ease-in |
| Tab switch | Tap tab | Icon: outlined→filled crossfade | 150ms ease |
| Chevron in chip | Selector opens | Rotate 180° | 200ms ease |
| Input result | Amount changes | Number fades to new value | 100ms ease |
| Error/warn banner | State change | Slide down from top | 300ms spring |

### 16.3 Haptic Feedback

| Event | Haptic Type |
|-------|-------------|
| Price detected by OCR (first detection) | Light impact — iOS: `.light` · Android: `HAPTIC_FEEDBACK_LIGHT` |
| Swap currencies | Medium impact — iOS: `.medium` · Android: `HAPTIC_FEEDBACK_MEDIUM` |
| Currency selected from list | Light impact |
| Rates refreshed successfully | Notification success — iOS: `UINotificationFeedbackGenerator .success` |
| Rate fetch failed | Notification error — iOS: `.error` · Android: `HAPTIC_FEEDBACK_HEAVY` |
| Freeze / Unfreeze camera | Rigid — iOS: `.rigid` · Android: `HAPTIC_FEEDBACK_MEDIUM` |

---

## 17. Accessibility

### 17.1 Contrast & Colour

- All text: WCAG AA minimum — **4.5:1** body text, **3:1** large text
- Primary green `#16A34A` on white: **4.58:1** — passes AA ✅
- White on AR overlay `rgba(0,0,0,0.65)`: passes AAA ✅
- Never use light green text on white — insufficient contrast ❌

### 17.2 Touch & Motor

- Minimum touch target: **44×44dp** everywhere — no exceptions
- Destructive actions (clear history): require confirmation dialog
- Every gesture has an alternative button — never gesture-only interactions

### 17.3 Screen Reader Labels

- Currency chips: `"Convert from [Currency Name], tap to change"`
- Swap button: `"Swap currencies"`
- Result field: `"Result: approximately [amount] [currency name]"`
- Rate line: `"[amount] [currency] equals [rate] [currency]. Rates updated [time] ago."`
- AR overlays: announce via accessibility announcements (not invisible element labels)

### 17.4 Reduce Motion

- AR overlay: fade only (no scale), 100ms
- Bottom sheet: slide only, no spring bounce
- Swap button: instant icon swap, no rotation
- All scale and rotation animations disabled when system Reduce Motion is on

---

## 18. Design QA Checklist

Before marking any screen design-complete, verify all items:

| # | Check | Pass Criteria |
|---|-------|--------------|
| 1 | Touch targets | ≥ 44×44dp on every interactive element |
| 2 | Colour contrast | WCAG AA pass on all text/background combinations |
| 3 | Dark mode | All screens correct in dark mode, no hardcoded colours |
| 4 | Offline state | App is usable with cached rates — no broken UI |
| 5 | Empty states | Every list/history has a designed empty state |
| 6 | Error states | Every fetch failure has a visible, actionable error state |
| 7 | Loading states | Every async operation shows progress |
| 8 | Camera permission denied | Full-screen designed state with clear CTA |
| 9 | Rate stale warning | Visible when last fetch > 1 hour ago |
| 10 | Number formatting | Locale-aware: decimal and thousands separators |
| 11 | Long currency names | No truncation on 375dp minimum width |
| 12 | Reduce Motion | All animations respect system setting |
| 13 | Screen reader | All interactive elements have descriptive labels |
| 14 | Landscape (camera) | AR overlays reposition correctly in landscape mode |

---

<br>

# PART III — Flutter Code Standards
> *Write code that's a pleasure to read six months later*

---

## 19. Core Principles

> **The Rule of Thumb**
> Code is written once but read many times. Optimise for the reader, not the writer.
> If you have to add a comment to explain what code does — consider renaming it instead.
> Prefer explicit over clever. Dart is expressive enough; you don't need to be.

| Principle | Meaning | Anti-pattern to avoid |
|-----------|---------|----------------------|
| **Readable** | Code reads like English — intentions are obvious | Abbreviations, cryptic one-liners, magic numbers |
| **Small** | Functions/widgets do ONE thing | God widgets with 300+ lines, functions with 5 responsibilities |
| **Testable** | Business logic lives outside widgets | API calls and business logic inside `build()` |
| **Consistent** | Same patterns throughout the codebase | Two different ways to handle errors in different files |
| **Typed** | Strong types everywhere, null safety fully leveraged | `dynamic`, `Object`, `var` where a concrete type is possible |

---

## 20. Naming Conventions

> **Naming Principle**
> Names should be so descriptive that comments are rarely needed.
> If you can't find a good name — the abstraction might be wrong.

| Category | Convention | Example |
|----------|-----------|---------|
| Classes / Widgets | `UpperCamelCase` | `CameraScreen`, `CurrencyChip`, `RateRepository` |
| Variables / Params | `lowerCamelCase` | `exchangeRate`, `fromCurrency`, `isLoading` |
| Constants | `lowerCamelCase` (Dart std) | `const defaultCurrency = 'USD'` |
| Private members | `_` prefix | `_controller`, `_isDisposed` |
| Files | `snake_case` | `camera_screen.dart`, `rate_repository.dart` |
| Folders | `snake_case` | `currency_selector/`, `shared/widgets/` |
| Booleans | `is/has/can/should` prefix | `isLoading`, `hasError`, `canSwap`, `shouldRefresh` |
| Async methods | Verb + noun | `fetchRates()`, `convertAmount()`, `clearHistory()` |
| Stream/notifier vars | Descriptive state name | `ratesAsync`, `cameraStateProvider` |

### 20.1 Widget Naming Rules

- **Screens:** `[Name]Screen` — `CameraScreen`, `ConverterScreen`, `SettingsScreen`
- **Reusable widgets:** `[Name]Widget` or just `[Name]` if obvious — `CurrencyChip`, `SwapButton`
- **Painters:** `[Name]Painter` — `ArOverlayPainter`
- **Providers:** `[name]Provider` or `[name]NotifierProvider` — `ratesProvider`, `converterNotifier`
- **State classes:** `[Name]State` — `ConverterState`, `CameraState`

### 20.2 What NOT to Name

```dart
// ❌ BAD — meaningless names
var data = fetchSomething();
void doStuff() {}
Widget buildUI() {}
class Manager {}

// ✅ GOOD — descriptive, explicit
final ExchangeRates rates = await fetchRates();
void convertAndUpdateResult() {}
Widget _buildCurrencyRow() {}
class RatesRepository {}
```

---

## 21. Widget Architecture

> **Widget Rule**
> Widgets are for UI only. Zero business logic, zero API calls, zero data transformation inside `build()`.
> If a widget does more than display state and delegate actions — split it.

### 21.1 Widget Size

- Aim for `build()` methods under **50 lines**. If longer — extract sub-widgets
- Each widget should be describable in one sentence. If you need "and" — split it
- Prefer composition over inheritance for widgets

### 21.2 `const` Everywhere

```dart
// ❌ BAD — rebuilds on every parent rebuild
Text('LensRate', style: TextStyle(fontSize: 24));

// ✅ GOOD — const, no unnecessary rebuilds
const Text('LensRate', style: TextStyle(fontSize: 24));

// Use const constructors whenever possible
const SizedBox(height: 16),
const Icon(Icons.camera_alt),
```

### 21.3 Extract Sub-widgets, Not Methods

```dart
// ❌ BAD — method widgets skip Flutter's optimisation
Widget _buildHeader() {
  return Row(children: [Text('Camera')]);
}

// ✅ GOOD — private class widget, can be const, can hold its own state
class _CameraHeader extends StatelessWidget {
  const _CameraHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Text('Camera')]);
  }
}
```

### 21.4 Stateless vs Stateful vs ConsumerWidget

```dart
// StatelessWidget — pure display, no state, no providers
class CurrencyBadge extends StatelessWidget { ... }

// ConsumerWidget (Riverpod) — reads providers, no local state
class RateInfoLine extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(ratesProvider);
    return rates.when(
      data: (r) => Text('1 USD = ${r.usd}'),
      loading: () => const _RateShimmer(),
      error: (e, _) => const _RateError(),
    );
  }
}

// StatefulWidget — only for local ephemeral UI state (animation, text input)
// Prefer ConsumerStatefulWidget when you also need providers
```

---

## 22. State Management with Riverpod

> **Riverpod Rule**
> All shared state lives in providers. Widgets only read and react.
> One provider = one responsibility. Don't put unrelated state in the same notifier.

### 22.1 Provider Types

| Provider Type | When to Use | Example |
|---------------|-------------|---------|
| `Provider` | Computed/derived value, no mutation | `currencyListProvider` — sorted list of currencies |
| `FutureProvider` | Single async operation | `ratesProvider` — fetch exchange rates once |
| `StreamProvider` | Ongoing async stream | `cameraStreamProvider` — camera image frames |
| `NotifierProvider` | Mutable state with methods | `converterNotifier` — from/to/amount/result |
| `AsyncNotifierProvider` | Mutable state that includes async operations | `ratesFetchNotifier` — fetch + cache + refresh |

### 22.2 Notifier Pattern

```dart
// ✅ Clean notifier — state is immutable, methods return void
@riverpod
class ConverterNotifier extends _$ConverterNotifier {
  @override
  ConverterState build() => const ConverterState.initial();

  void setAmount(String input) {
    final amount = double.tryParse(input) ?? 0;
    state = state.copyWith(amount: amount, result: _calculate(amount));
  }

  void swapCurrencies() {
    state = state.copyWith(
      from: state.to,
      to: state.from,
      result: _calculate(state.amount),
    );
  }

  double _calculate(double amount) {
    final rate = ref.read(ratesProvider).valueOrNull;
    if (rate == null || amount == 0) return 0;
    return amount * rate.getRate(state.from, state.to);
  }
}
```

### 22.3 State Classes — Always Immutable

```dart
// ✅ Use freezed or manual immutable state
@freezed
class ConverterState with _$ConverterState {
  const factory ConverterState({
    @Default('USD') String from,
    @Default('EUR') String to,
    @Default(0)     double amount,
    @Default(0)     double result,
  }) = _ConverterState;

  const factory ConverterState.initial() = _ConverterStateInitial;
}

// ❌ NEVER mutate state directly:
state.amount = 10;  // Won't work, and if it did — would be a bug
```

---

## 23. Dart Language Best Practices

### 23.1 Null Safety — Use It Fully

```dart
// ❌ BAD — nullable where it shouldn't be
String? currencyCode;  // always has a value, don't make it nullable
double? amount;        // default to 0, not null

// ✅ GOOD — non-nullable by default, nullable only when truly optional
String currencyCode = 'USD';
double amount = 0;
String? selectedBank;   // genuinely optional — user may not have picked one

// Use ! only when you KNOW it's non-null AND can explain why in a comment
final rate = _ratesCache!; // cache is always set before this path is reached
```

### 23.2 async / await — Never Forget Error Handling

```dart
// ❌ BAD — unhandled Future, swallowed errors
void refresh() {
  _repository.fetchRates();  // fire and forget — errors lost silently
}

// ✅ GOOD — always handle async properly
Future<void> refresh() async {
  try {
    final rates = await _repository.fetchRates();
    state = AsyncData(rates);
  } on RatesException catch (e) {
    state = AsyncError(e, StackTrace.current);
  }
}
```

### 23.3 Extensions — Keep Code Expressive

```dart
// Define once in core/extensions/
extension CurrencyFormatting on double {
  String toFormattedCurrency(String code, {int decimals = 2}) {
    return '${toStringAsFixed(decimals)} $code';
  }
}

extension StringCurrencyUtils on String {
  bool get isCurrencyCode => RegExp(r'^[A-Z]{3}$').hasMatch(this);
}

// Usage reads like English:
final display = 158.74.toFormattedCurrency('BYN');  // '158.74 BYN'
final valid = 'USD'.isCurrencyCode;                  // true
```

### 23.4 Prefer `final` and `const`

```dart
// ❌ BAD — mutable vars where immutability is possible
var currencies = <String>[];
var rate = 0.0;

// ✅ GOOD — final by default, var only when you NEED to reassign
final currencies = <String>[];  // list contents can change, reference cannot
final rate = fetchedRate;

// const for compile-time constants
const kDefaultCurrency = 'USD';
const kMaxOverlays = 3;
const kRateStaleDuration = Duration(hours: 1);
```

### 23.5 Error Handling with Sealed Classes

```dart
// Define failures as sealed classes — exhaustive handling at call site
sealed class RatesFailure {
  const RatesFailure();
}

class NetworkFailure extends RatesFailure {
  const NetworkFailure(this.message);
  final String message;
}

class CacheExpiredFailure extends RatesFailure {
  const CacheExpiredFailure();
}

// Call site — switch is exhaustive, compiler catches missing cases
switch (failure) {
  case NetworkFailure(:final message) => showError(message),
  case CacheExpiredFailure()          => showStaleWarning(),
}
```

---

## 24. Clean Architecture Rules

> **Dependency Rule**
> Dependencies point **INWARD** only.
> Presentation knows Domain. Domain knows nothing about Presentation or Data.
> Data implements Domain interfaces. Never import Presentation from Data.

### 24.1 Layer Responsibilities

| Layer | Responsibility | Must NOT contain |
|-------|--------------|-----------------|
| **Presentation** | Widgets, providers, UI state — receives data, sends user actions | Business logic, API calls, file I/O |
| **Domain** | Entities, use cases, repository interfaces — pure Dart, zero Flutter | Widget imports, HTTP, Hive, SharedPreferences |
| **Data** | Repository implementations, API clients, local storage adapters | Widget imports, UI state logic, navigation |

### 24.2 Repository Pattern

```dart
// domain/repositories/rates_repository.dart — abstract interface
abstract interface class RatesRepository {
  Future<ExchangeRates> fetchRates({required String baseCurrency});
  Future<ExchangeRates?> getCachedRates();
  Future<void> cacheRates(ExchangeRates rates);
}

// data/repositories/rates_repository_impl.dart — concrete implementation
class RatesRepositoryImpl implements RatesRepository {
  const RatesRepositoryImpl(this._api, this._cache);

  final RatesApi _api;
  final RatesCache _cache;

  @override
  Future<ExchangeRates> fetchRates({required String baseCurrency}) async {
    final dto = await _api.getRates(base: baseCurrency);
    return dto.toDomain();
  }
}
```

### 24.3 Use Cases — Single Responsibility

```dart
// domain/usecases/convert_currency.dart
class ConvertCurrency {
  const ConvertCurrency(this._ratesRepo);
  final RatesRepository _ratesRepo;

  Future<double> call({
    required double amount,
    required String from,
    required String to,
  }) async {
    final rates = await _ratesRepo.getCachedRates();
    if (rates == null) throw const CacheExpiredFailure();
    return amount * rates.getRate(from: from, to: to);
  }
}

// One use case = one action. Never combine unrelated operations.
```

---

## 25. Code Quality Rules

### 25.1 File Size Limits

- Files: **max 200 lines** — if longer, split into smaller files
- Functions/methods: **max 30 lines** — if longer, extract smaller functions
- `build()` methods: **max 50 lines** — extract sub-widgets beyond this
- **One public class/widget per file** — don't bundle unrelated classes

### 25.2 Comments Policy

```dart
// ❌ USELESS COMMENT — explains WHAT, not WHY (the code already shows what)
// Set amount to 0
amount = 0;

// ✅ USEFUL COMMENT — explains WHY (business logic not obvious from code)
// ML Kit returns bounding boxes in image coordinates (0,0 top-left),
// but Flutter paints in widget coordinates. Scale by previewSize ratio.
final scaleX = previewSize.width / imageSize.width;

// ✅ TODO comments always include context and owner:
// TODO(username): Replace with bank rate API when B2B partnership confirmed
```

### 25.3 Don't Repeat Yourself

```dart
// ❌ BAD — same colour defined in 3 places
Color(0xFF16A34A)  // in camera_screen.dart
Color(0xFF16A34A)  // in converter_screen.dart
Color(0xFF16A34A)  // in currency_chip.dart

// ✅ GOOD — single source of truth in core/constants/app_colors.dart
abstract final class AppColors {
  static const primary     = Color(0xFF16A34A);
  static const primaryDark = Color(0xFF15803D);
  static const surface     = Color(0xFFF8FAFC);
  // ... all tokens from Design System
}

// Usage:
color: AppColors.primary,
```

### 25.4 Performance Rules

- Never call `setState()` or `ref.invalidate()` inside `build()`
- Use `const` constructors wherever possible — prevents unnecessary rebuilds
- Avoid rebuilding the entire screen — use `Consumer` / `.select()` to watch only what you need
- **Dispose controllers:** `AnimationController`, `CameraController`, `TextEditingController`
- Use `ListView.builder()` for lists — never `ListView(children: [all items])`
- Avoid `Opacity` widget on complex trees — use `FadeTransition` (cheaper)

```dart
// ✅ Watch only the piece of state you need — avoids broad rebuilds
final isLoading = ref.watch(
  converterNotifier.select((s) => s.isLoading),
);

// ✅ Always dispose controllers
@override
void dispose() {
  _animController.dispose();
  _cameraController.dispose();
  super.dispose();
}
```

---

## 26. Code Review Checklist

Before submitting any PR, verify all items:

| # | Check | What to look for |
|---|-------|-----------------|
| 1 | No logic in `build()` | Business logic, API calls, data formatting belong in providers/use cases |
| 2 | `const` constructors used | Every widget instantiation that can be `const`, is `const` |
| 3 | Errors handled | Every async call has a `try/catch` or `.when()` with error case |
| 4 | Disposed properly | Every controller (camera, animation, text) disposed in `dispose()` |
| 5 | No hardcoded strings/colours | All colours from `AppColors`, all text styles from `AppTextStyles` |
| 6 | Named parameters used | Any function with 2+ same-type params uses named params |
| 7 | File size respected | No file over 200 lines; extract if needed |
| 8 | One class per file | Each `.dart` file exports one public class |
| 9 | Providers are focused | Each provider/notifier handles one piece of state |
| 10 | No `dynamic` types | No `dynamic`, `Object`, or untyped `var` where type is known |
| 11 | Comments explain WHY | Comments describe reason, not the obvious what |
| 12 | Tests for use cases | Every domain use case has at least one unit test |

---

*LensRate — Master Documentation · v1.0 · PRD + Design System + Flutter Code Standards*
