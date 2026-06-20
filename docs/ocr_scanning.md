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

> **Two modes.** **Tap-to-scan** (default) is below. **Live scan** is an optional
> mode toggled in **Settings → Camera**: frames stream through OCR continuously
> (throttled ~700 ms) and pills float over the *live* preview — no tap, no freeze.
> It uses a lighter resolution for real-time speed and is best on printed tags.
> Tap-to-scan remains the reliable baseline.
>
> **Live stabilisation** (`LiveStabilizer`) keeps the overlay calm. Per-frame OCR
> of the same tag jitters (500 → 5.00 → 600), so live shows **one** pill — the
> most central price — and *locks* it: the first detection appears immediately,
> but switching to a different value needs it seen **2 frames in a row** (one-off
> misreads are ignored). When detections stop, the last pill lingers ~1.5 s
> before clearing, so a brief miss doesn't blink it and you can steady the device.

1. Point the camera at the price, then tap the round **Scan** button.
2. `CameraController.takePicture()` captures a still at `ResolutionPreset.veryHigh`
   (higher resolution = sharper text = better recognition) and the frame freezes.
3. ML Kit recognises text lines and their bounding boxes on the still.
4. Each **line** of text is run through `PriceParser` to extract numbers. The
   pill is anchored to the **numeric word boxes** of the line (union of elements
   containing a digit), not the whole line, so it sits on the price itself.
5. Each number is converted from its source currency to your target currency.
6. The most price-like results — ranked by **nearness to the frame centre**, plus
   currency/decimal boosts — are shown as floating pills over the tag.
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

**Noise filtering** (only when the line has *no* currency cue — a cue overrides
these, so `199₽/кг` stays a price):

- A number **immediately followed by a measurement unit** is dropped as a spec,
  not a price: `kg, g, ml, l, m, cm, mm, шт, г, кг, мл, л, м, см, мм, %`. The unit
  must be a whole token, so `100 грн` (UAH) is *not* mistaken for `100 г` (grams).
- A **long uninterrupted digit run (≥ 7 digits)** with no decimal is dropped as a
  barcode / SKU.

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

When several numbers are found, each gets a score and the highest win:

```
score = (1 − distanceToFrameCentre) × 4   // nearness to the aim reticle dominates
      + 3  if it has a currency cue (symbol/ISO)
      + 2  if it has a decimal part (cents)
```

So the price under the centre reticle is preferred; a currency cue or cents break
ties. Distance is normalised by the image diagonal (0 = dead centre, 1 = corner).

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
- **Live scan (experimental):** opt-in via Settings → Camera. Uses
  `startImageStream` with throttled OCR over the live preview. Coordinate
  alignment relies on the device held upright (back camera); odd orientations may
  offset pills. Handwriting and stylised tags stay unreliable in either mode.
- **Ambiguous symbols:** `$` always resolves to USD, `¥` to JPY — set **From**
  manually for CAD/AUD/CNY etc.
- **Stylised / blurry tags** may not recognise; use the manual converter as a
  fallback (docs §7).
