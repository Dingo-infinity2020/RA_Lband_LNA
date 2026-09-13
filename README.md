# RA_Lband_LNA

Low-cost, room-temperature **1.05–1.55 GHz radio-astronomy LNA** reference design based on the Qorvo **QPL9547TR7**.

## Current release

**RA-LNA-L1 V1.0F — geometry frozen / pre-fabrication simulation hold (2026-09-13)**

> **Do not fabricate V1.0C, V1.0D, or V1.0E.** V1.0F supersedes them. V1.0F geometry is visually frozen, but first fabrication is temporarily held until the focused CST pre-fabrication gates are reviewed.

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

## Pre-fabrication simulation hold

Before first payment/order, run the focused CST build/review sequence:

- G0: CST 2022 VBA/API preflight;
- G1: input SMA/PCB launch + C1 + U1 input reference plane;
- G2: U1 output + bias loading + C2 + long output line + output launch;
- G3: choke/decoupling/VIN isolation and resonance screen;
- G4: passive full-board direct input/output coupling screen.

The first pass is deliberately **BUILD ONLY**: no solver, optimizer or automated parameter sweep until each model builds cleanly and the geometry/ports are visually accepted. See `docs/PREFAB_SIMULATION_GATE_PLAN.md`.

### Current CST gate status

The original save/reopen persistence issue has been resolved with flattened CST Structure Macros.

- **G0: PASS** — geometry + two discrete ports survive two clean close/reopen cycles with replayable history and no solver run.
- **G1: PASS** — 31 bricks, 7 vias, one lumped capacitor and two ports survive two clean close/reopen cycles; the 16-step input taper and C1 copper gap were verified.
- **G2: PASS** — 58 bricks, 24 vias, seven lumped elements and two ports survive two clean close/reopen cycles; the output launch, C2, ground fence and bias-network gaps were verified.
- **G3: AUTHORIZED FOR BUILD-ONLY VALIDATION** — use `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas` and `docs/NEXT_ACTION_CST_G3_REPLAY_SAFE_20260913.md`.
- **G4: HOLD**.
- **All solver execution remains prohibited** until a later explicit authorization.

Accepted reports:

- `reports/cst_build_only/G0/20260913_130311/`
- `reports/cst_build_only/G1/20260913_140307/`
- `reports/cst_build_only/G2/20260913_142924/`

## Before ordering

After the pre-fabrication simulation gate passes, re-confirm:

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
- `source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas` — replay-safe G0 macro
- `source/cst/G1_REPLAY_SAFE_STRUCTURE_V2.bas` — replay-safe G1 macro
- `source/cst/G2_REPLAY_SAFE_STRUCTURE_V2.bas` — replay-safe G2 macro
- `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas` — replay-safe G3 candidate macro
- `manufacturing/RA-LNA-L1_V1.0D_main_Gerbers.zip` — retained superseded fabrication source
- `docs/` — audit, JLC review and pre-fabrication simulation plan
- `reports/cst_build_only/` — CST build-only evidence and replay-integrity reports
- `eda/eagle/` — editable transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities

Read `docs/SILKSCREEN_AUDIT_V1.0F.md`, `docs/PREFAB_SIMULATION_GATE_PLAN.md`, and the latest `docs/NEXT_ACTION_CST_*` file before ordering or advancing the CST gates.
