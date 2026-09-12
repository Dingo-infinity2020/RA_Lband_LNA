# RA_Lband_LNA

Low-cost, room-temperature **1.05–1.55 GHz radio-astronomy LNA** reference design based on the Qorvo **QPL9547TR7**.

## Current release

**RA-LNA-L1 V1.0E — prototype manufacturing candidate (2026-09-12)**

> **Do not fabricate V1.0C or V1.0D.** V1.0E supersedes them for first fabrication.

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

V1.0D fixed the V1.0C JLC layer-recognition problem, two real +5 V copper opens, and an SMA ground-plane transfer issue. JLC isolated-layer review then confirmed Top/Inner1/Inner2/Bottom mapping and the intended signal/ground layer assignment.

The V1.0D 3D preview subsequently exposed one plated 0.35 mm GND stitching via sitting exactly on the exposed lower SMA ground solder-land boundary at each connector. Those vias were electrically valid but mechanically unnecessary and could promote solder wicking during connector soldering.

**V1.0E removes only those two drill hits.** RF signal copper, bias copper, component placement, stack-up and the surrounding GND via fence remain unchanged. An automated footprint-vs-drill check reports zero plated drill centers intersecting any exposed SMA solder land.

QPL9547 backside paddle remains the required RF/DC ground and keeps its two dedicated 0.30 mm via-in-pad holes; those are a separate intentional feature and still require the selected fill/cap process.

## Before ordering

Generate or use the V1.0E Gerber ZIP and re-upload it to JLC. Confirm:

1. four copper layers are recognized as Top / Inner1 / Inner2 / Bottom;
2. isolated Top view shows the complete RF and bias network;
3. Inner1 and Inner2 are solid GND planes;
4. Bottom has no RF signal routing;
5. the two black holes previously visible in the lower SMA ground solder lands are gone in 3D view;
6. live 50 Ω impedance, CAM/DFM, BOM/CPL, U1 pin-1 and U1 via-in-pad process are all reviewed before payment.

## Repository layout

- `source/build_v1_0e.py` — reproducibly derives V1.0E from the retained V1.0D Gerber ZIP
- `manufacturing/RA-LNA-L1_V1.0D_main_Gerbers.zip` — retained superseded fabrication source
- `manufacturing/V1.0E/` — current BOM/CPL/layer map
- `docs/` — audit and JLC review findings
- `eda/eagle/` — editable transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities
- `simulation/cst/` — SMA-launch surrogate model
- `mechanical/enclosure/` — shield-box prototype

Read `docs/SMA_VIA_AUDIT_V1.0E.md` before ordering.
