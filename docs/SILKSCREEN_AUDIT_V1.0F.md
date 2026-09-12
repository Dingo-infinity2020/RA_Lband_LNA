# V1.0F silkscreen audit — 2026-09-12

## Trigger

JLC 3D preview of V1.0E confirmed the two unwanted SMA-land drill hits had been removed, but also made the top legend easier to inspect. The white rectangular legend outline around the LNA section crosses/encroaches on an exposed SMT solder-land region on the output side, and the circular U1 pin-1 legend marker is too close to/over an exposed pad.

## Decision

Do not rely on JLC CAM to clip legend ink away from soldermask openings. Remove the problematic legend geometry at source.

## V1.0F change scope

**Top silkscreen only.** V1.0F removes:

1. the rectangular shield-can/keepout outline spanning x=5.1..12.6 mm and y=5.2..14.0 mm;
2. the circular U1 pin-1 legend marker centered near x=6.65 mm, y=9.90 mm.

The IN arrow, OUT arrow, and +5 V polarity mark remain.

No changes are made to top copper, inner planes, bottom copper, soldermask, paste, board outline, drill file, component placement, BOM, or RF/bias geometry relative to V1.0E.

## Manufacturing status

V1.0F supersedes V1.0E for first fabrication. Re-upload the V1.0F Gerber ZIP to JLC and confirm in the 3D preview that:

- the two deleted SMA-land holes remain absent;
- no white top-silkscreen line or marker lies over any exposed SMT pad;
- RF and bias copper are visually unchanged from V1.0E.
