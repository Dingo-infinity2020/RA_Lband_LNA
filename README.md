# RA_Lband_LNA

Low-cost, room-temperature **1.05–1.55 GHz radio-astronomy LNA** reference design based on the Qorvo **QPL9547TR7**.

## Current release

**RA-LNA-L1 V1.0D — prototype manufacturing candidate (2026-09-12)**

> **Do not fabricate V1.0C.** V1.0D supersedes it after review of the JLC viewer screenshot and an independent top-copper connectivity audit.

### Target

- Band: 1.05–1.55 GHz
- Supply: 5 V
- Nominal device current: ~65 mA
- Board gain acceptance: >20 dB across band
- Board NF acceptance at 25 °C: <0.50 dB
- 4-layer JLC04161H-3313 baseline
- QPL9547TR7 / LCSC C5367093
- RF Solutions CON-SMA-EDGE-S / JLC C5356059

## V1.0D critical fixes

The JLC screenshot showed the V1.0C copper files being interpreted as miscellaneous layers (`杂层`). Review confirmed that the SMT pads and RF routing were in the intended front-copper file; the immediate display problem was ambiguous Gerber naming/metadata. V1.0D now uses JLC/Protel extensions (`.GTL/.G2L/.G3L/.GBL/.../.XLN`) and Gerber X2 `TF.FileFunction` attributes.

The same audit found two real V1.0C top-copper opens on the +5 V `VIN5` net:

1. 0.10 mm gap between the VIN5 vertical bus and the J3 +5 V pad;
2. 0.10 mm gap between the VIN5 neck and the C8 VIN pad.

V1.0D fixes both gaps and adds a dedicated plane-transfer via for the previously via-less J1 upper SMA ground land.

QPL9547 pins 3/4/5/8 are internally NC per Qorvo and may be left floating or grounded. V1.0D does not rely on pins 5/8 for grounding; the exposed backside paddle remains the required RF/DC ground and keeps its two dedicated via-in-pad holes.

## Before ordering

The V1.0D Gerber ZIP is the fabrication authority. In the JLC viewer, confirm **four recognized copper layers**: Top, Inner1, Inner2, Bottom. If any copper is still shown only as `杂层`, Mechanical, or Unknown, **stop and do not order**.

Also confirm the live 50 Ω impedance calculation, CAM/DFM, U1 pin-1 orientation, and the two U1 via-in-pad holes before payment.

## Repository layout

- `source/` — V1.0D manufacturing rebuild/patch script
- `manufacturing/V1.0D/` — order-ready layer files, BOM/CPL and layer map
- `docs/` — audit findings
- `eda/eagle/` — editable V1.0C transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities
- `simulation/cst/` — SMA-launch surrogate model
- `mechanical/enclosure/` — shield-box prototype

See `docs/V1.0C_AUDIT_FINDINGS.md` and `manufacturing/V1.0D/LAYER_MAP.md` first.
