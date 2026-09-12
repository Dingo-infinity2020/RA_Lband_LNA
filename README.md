# RA_Lband_LNA

Low-cost, room-temperature **1.05–1.55 GHz radio-astronomy LNA** reference design based on the Qorvo **QPL9547TR7**.

## Current release

**RA-LNA-L1 V1.0D — prototype manufacturing candidate (2026-09-12)**

> **Do not fabricate V1.0C.** V1.0D supersedes it after a JLC CAM/layer audit and a source-level electrical-connectivity audit.

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

V1.0C used ambiguous generic Gerber filenames and JLC rendered its copper files as miscellaneous layers (`杂层`). V1.0D now uses JLC/Protel extensions (`.GTL/.G2L/.G3L/.GBL/.../.XLN`) **and Gerber X2 `TF.FileFunction` attributes**.

The audit also found and fixed two actual V1.0C copper-continuity defects:

1. a 0.10 mm gap between the VIN5 bus and J3 +5 V pad;
2. a 0.10 mm gap between the VIN5 bus and the C8 VIN pad.

V1.0D additionally gives every top SMA ground land a direct plane-transfer via and grounds QPL9547 pins 3/4/5/8 locally, matching Qorvo evaluation-board practice.

The generator now hard-fails on disconnected non-GND nets or top-side GND islands without a plane-transfer via.

## Before ordering

The V1.0D Gerber ZIP is the fabrication authority. In the JLC viewer, confirm **four recognized copper layers**: top, inner-1, inner-2, bottom. If any copper is shown only as `杂层`, Mechanical, or Unknown, **stop and do not order**.

Also confirm the live 50 Ω impedance calculation, CAM/DFM, U1 pin-1 orientation, and the two U1 via-in-pad holes before payment.

## Repository layout

- `source/` — reproducible geometry/release generators
- `manufacturing/V1.0D/` — order-ready Gerbers, BOM/CPL and layer map
- `docs/` — design, audit and test documentation
- `eda/eagle/` — editable transfer files (not fabrication authority)
- `tools/` — release verification and measurement utilities
- `releases/` — complete engineering-package ZIP

See `docs/V1.0C_AUDIT_FINDINGS.md` and `manufacturing/V1.0D/LAYER_MAP.md` first.
