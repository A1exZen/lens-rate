# OCR Price Scanning — How It Works

How LensRate reads prices from the camera. This documents the **current rules**;
keep it in sync with [`lib/core/utils/price_parser.dart`](../lib/core/utils/price_parser.dart)
and [`lib/presentation/camera/`](../lib/presentation/camera/).

## Is it free? Does it need internet?

**Yes, free. No internet needed for recognition.** Text recognition uses Google
**ML Kit Text Recognition v2**, which runs **fully on-device**. Photos never leave
the phone — no servers, no API keys, no quotas. Internet is only used to fetch
exchange rates (and those are cached for offline use).

## Pipeline (tap-to-scan)

1. Point the camera and tap the round **Scan** button.
2. `CameraController.takePicture()` captures a still at `ResolutionPreset.veryHigh`
   (higher resolution = sharper text = better recognition) and the frame freezes.
3. ML Kit recognises text lines and their bounding boxes on the still.
4. Each **line** of text is run through `PriceParser` to extract numbers.
5. Each number is converted from its source currency to your target currency.
6. The most price-like results are shown as floating pills over the tag.
7. Tap **Scan** again (the refresh icon) to return to the live preview.

## Number detection rules

A number is extracted by this regex (simplified):

```
grouped thousands (needs a separator):  123[ .,]456[.,]78
   — or —
a plain run of digits:                  1500  or  19.99
```

Rules:

- **Any number > 0 counts as a possible price** — with or without decimals, with
  or without a currency symbol. (e.g. `1500`, `19.99`, `€5`, `1 234,56` all match.)
- **Zero is ignored.**
- **Decimal vs thousands separators** are inferred: when both `.` and `,` appear,
  the **rightmost** one is the decimal point (`1.234,56` → 1234.56;
  `1,234.56` → 1234.56). A lone `,`/`.` with ≤2 trailing digits is treated as a
  decimal, otherwise as a thousands separator.

## Currency resolution (source currency)

For each detected number, the source currency is decided in this order:

1. **A currency symbol anywhere on the same line** → mapped to an ISO code:
   `$`→USD, `€`→EUR, `£`→GBP, `¥`→JPY, `₽`→RUB, `zł`→PLN, `₴`→UAH, `₩`→KRW,
   `₹`→INR, `฿`→THB, `₺`→TRY.
2. **A 3-letter ISO code on the line** (e.g. `100 PLN`), if it's a known currency.
3. **Otherwise → the "From (tag)" currency you selected** in the camera top bar.

> This is why setting **From** correctly matters: many price tags show no symbol,
> so the app falls back to your selected source currency.

## Ranking & limits

When several numbers are found, they're ranked so the real price wins:

1. Has an explicit currency cue (symbol/ISO) — highest priority
2. Has a decimal part (looks like a price with cents)
3. Larger amount

At most **3 pills** are shown at once (docs §14.1) to avoid clutter.

## Overlay positioning

ML Kit returns boxes in **image-pixel** coordinates. The frozen still is shown
with `BoxFit.cover`, so the overlay replicates that transform (scale + centre
offset) to place each pill. Pills:

- sit just above the tag (or below if there's no room);
- are confined to a **safe band** that excludes the top bar and bottom controls,
  so they never overlap the UI chrome;
- are de-collided — a pill that would overlap an already-placed one is nudged down.

The camera screen runs in **immersive full-screen** mode (system status/nav bars
hidden) so the preview is edge-to-edge with no cut-outs.

## Known limitations / future work

- **Orientation:** mapping assumes the captured image and ML Kit agree on
  orientation (true for normal portrait captures). Unusual EXIF orientations
  could offset pills.
- **Live overlay (P1):** currently tap-to-scan only. A continuous `startImageStream`
  mode is the planned upgrade (docs §3.1, §6.3).
- **Ambiguous symbols:** `$` always resolves to USD, `¥` to JPY — set **From**
  manually for CAD/AUD/CNY etc.
- **Stylised / blurry tags** may not recognise; use the manual converter as a
  fallback (docs §7).
