# RA-LNA-L1

Compact L-band LNA PCB based on QPL9547, with fabrication files, editable transfer sources, audits and pre-fabrication CST screening gates.

## Current fabrication baseline

V1.0F PCB geometry is visually frozen after JLC 3-D review. Fabrication remains temporarily **on hold** until the focused pre-fabrication simulation gates are completed and reviewed.

The CST screening sequence is:

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
- **G3: PASS** — 38 bricks, 6 vias, seven lumped elements and two ports survive two clean close/reopen cycles; L1/C5/C3/C4/R3/C8/R4 gaps and the R4 branch were verified.
- **G4: SOURCE PREPARATION AUTHORIZED ONLY** — prepare and statically audit a replay-safe passive four-port full-board Structure Macro under `docs/NEXT_ACTION_CST_G4_PREP_20260913.md`; do not run it in CST until reviewer approval.
- **All solver execution remains prohibited** until a later explicit authorization.

Accepted reports:

- `reports/cst_build_only/G0/20260913_130311/`
- `reports/cst_build_only/G1/20260913_140307/`
- `reports/cst_build_only/G2/20260913_142924/`
- `reports/cst_build_only/G3/20260913_150740/`

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
- `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas` — replay-safe G3 macro
- `manufacturing/RA-LNA-L1_V1.0D_main_Gerbers.zip` — retained superseded fabrication source
- `docs/` — audit, JLC review and pre-fabrication simulation plan
- `reports/cst_build_only/` — CST build-only evidence and replay-integrity reports
- `eda/eagle/` — editable transfer files retained as provenance; not fabrication authority
- `tools/` — measurement utilities

Read `docs/SILKSCREEN_AUDIT_V1.0F.md`, `docs/PREFAB_SIMULATION_GATE_PLAN.md`, and the latest `docs/NEXT_ACTION_CST_*` file before ordering or advancing the CST gates.
