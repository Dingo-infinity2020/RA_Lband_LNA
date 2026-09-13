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

### Current CST blocker / next action

G0 geometry and ports built correctly in-session, but the first saved projects failed persistence on reopen:

- ordinary VBA-editor execution did not create replayable modeling history for ports/lumped objects;
- the first Structure-Macro attempt recorded history, but replay failed because private helper-sub calls were stored verbatim and could not be resolved on reopen.

Therefore **G1–G4 and every solver remain on HOLD** until G0 proves clean save/reopen persistence.

Use the reviewer-supplied flat Structure Macro:

`source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas`

and follow:

`docs/NEXT_ACTION_CST_G0_REPLAY_SAFE_20260913.md`

The G0 acceptance test requires two clean close/reopen cycles with both ports present and no history-replay error.

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
- `source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas` — current replay-safe G0 candidate macro
- `manufacturing/RA-LNA-L1_V1.0D_main_Gerbers.zip` — retained superseded fabrication source
- `docs/` — audit, JLC review and pre-fabrication simulation plan
- `eda/eagle/` — editable transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities

Read `docs/SILKSCREEN_AUDIT_V1.0F.md`, `docs/PREFAB_SIMULATION_GATE_PLAN.md`, and `docs/NEXT_ACTION_CST_G0_REPLAY_SAFE_20260913.md` before ordering or advancing the CST gates.
