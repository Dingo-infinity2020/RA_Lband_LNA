# RA_Lband_LNA

Low-cost, room-temperature **1.05–1.55 GHz radio-astronomy LNA** reference design based on the Qorvo **QPL9547TR7**.

## Current release

**RA-LNA-L1 V1.0F — prototype manufacturing candidate (2026-09-12)**

> **Do not fabricate V1.0C, V1.0D, or V1.0E.** V1.0F supersedes them for first fabrication.

### Target

- Band: 1.05–1.55 GHz
- Supply: 5 V
- Nominal device current: ~65 mA
- Board gain acceptance: >20 dB across band
- Board NF acceptance at 25 °C: <0.50 dB
- 4-layer JLC04161H-3313 baseline
- QPL9547TR7 / LCSC C5367093
- RF Solutions CON-SMA-EDGE-S / JLC C5356059

## Release history / critical fixes

V1.0D fixed V1.0C layer-recognition issues, two real +5 V copper opens, and an SMA ground-plane transfer issue. V1.0E then removed two mechanically unnecessary plated GND stitching vias that intersected exposed lower SMA ground solder lands.

JLC 3D review of V1.0E confirmed those SMA-land holes were gone, but also exposed a separate assembly-quality issue: the top silkscreen rectangular outline crossed/encroached on an SMT solder-land region, and the circular U1 pin-1 silkscreen marker sat too close to/over an exposed pad.

**V1.0F changes top silkscreen only.** It removes the rectangular outline and the U1 circular marker. The IN/OUT arrows and +5 V polarity mark remain. Copper, mask, paste, drill, stack-up, BOM, CPL and RF/bias geometry are unchanged from V1.0E.

QPL9547 backside paddle remains the required RF/DC ground and keeps its two intentional 0.30 mm via-in-pad holes; these are unrelated to the deleted SMA stitching vias.

## Before ordering

Upload the V1.0F Gerber ZIP to JLC and confirm:

1. four copper layers are recognized as Top / Inner1 / Inner2 / Bottom;
2. isolated Top view shows the complete RF and bias network;
3. Inner1 and Inner2 are solid GND planes;
4. Bottom has no RF signal routing;
5. the two former SMA solder-land drill hits remain absent;
6. no top-silkscreen feature overlaps an exposed SMT solder pad;
7. live 50 Ω impedance, CAM/DFM, BOM/CPL, U1 pin-1 orientation and U1 via-in-pad process are reviewed before payment.

## Repository layout

- `source/build_v1_0e.py` — derives V1.0E from V1.0D
- `source/build_v1_0f.py` — derives V1.0F from V1.0E and performs a silkscreen-only cleanup
- `manufacturing/RA-LNA-L1_V1.0D_main_Gerbers.zip` — retained superseded fabrication source
- `docs/` — audit and JLC review findings
- `eda/eagle/` — editable transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities
- `simulation/cst/` — SMA-launch surrogate model
- `mechanical/enclosure/` — shield-box prototype

Read `docs/SILKSCREEN_AUDIT_V1.0F.md` before ordering.
