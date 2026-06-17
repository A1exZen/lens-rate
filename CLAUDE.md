# LensRate — Project Guide for Claude

LensRate is a minimal AR currency converter (Flutter, iOS + Android). Point the
camera at a price tag → see the converted price overlaid; plus a manual converter
and offline cached rates.

## ⭐ Source of truth: `docs/docs.md`

`docs/docs.md` is the **authoritative spec** (PRD + Design System + Code
Standards). Always follow it. Proposing a better approach is allowed when
justified — but **whenever code diverges from the docs, update `docs/docs.md`
first** so the documentation never drifts out of date. Treat this as a hard rule.

## Architecture (docs §6, §24)

Clean Architecture, dependencies point inward only:
- `lib/core/` — constants (design tokens), theme, router, extensions, utils
- `lib/domain/` — entities, use cases, repository interfaces (pure Dart)
- `lib/data/` — repository impls, remote API, local cache (Hive + prefs)
- `lib/presentation/<feature>/` — screens, Riverpod providers, widgets
- `lib/shared/widgets/` — cross-feature widgets

State: **Riverpod 3.x + codegen** (`@riverpod`) and **Freezed 3.x** for immutable
state. Run the generator whenever you touch an annotated file.

**Localization (en / ru, default ru):** all user-facing strings live in
`lib/l10n/app_en.arb` + `app_ru.arb` (gen-l10n). Use `AppL10n.of(context).key`
— never hardcode UI text. Language is user-switchable in Settings and persists.

## Agreed deviations from docs (already reflected in docs.md)

- **Build order:** Converter first, Camera/OCR last (was §8 camera-first).
- **Camera MVP:** tap-to-scan first; continuous live overlay is a P1 upgrade.
- **Rate API:** keyless `https://open.er-api.com/v6/latest/USD` (no key/signup).
- **Versions:** Riverpod 3.x / Freezed 3.x (docs originally said Riverpod 2.x).

## Commands

```bash
dart run build_runner watch    # keep running while editing annotated files
flutter analyze                # must be clean before considering work done
flutter test                   # unit + widget tests
flutter run                    # camera features require a REAL device
```

Generated files are `*.g.dart` / `*.freezed.dart` — never edit by hand.
