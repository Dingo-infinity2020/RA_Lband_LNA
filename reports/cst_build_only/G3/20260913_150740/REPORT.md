# G3 Build-Only Report — replay-safe structure-macro validation (PASS)

Run ID: `20260913_150740` (G3 replay-safe re-run, flattened Structure Macro V2)

## Status
FINAL_STATUS=CST_G3_REPLAY_SAFE_BUILD_ONLY_PASS
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> Two full close/reopen cycles were verified: all geometry (38 bricks + 6 vias), materials,
> history, all seven lumped elements and both discrete ports survive with no history-replay
> error. No solver, sweep, optimizer or mesh adaptation was started. This run follows the
> reviewer instruction in `docs/NEXT_ACTION_CST_G3_REPLAY_SAFE_20260913.md`.

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F (geometry frozen)
- Gate macro source: `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas` (authoritative, as provided)
- Introducing commit: `7a9ec7414c1df88e4f4d058ac5a401e0a8a3edc7` ("Add replay-safe flattened CST G3 structure macro")
- Macro actually executed: exact contents of the above file, retained here as `MACRO_USED.bas`
  - macro file SHA256: `09d8d6a7afec6e1fca560056090e84b35754db34a35853ecf12a084d2a50277b`
  - **no local edit was made to the authoritative macro** (pasted verbatim)
- CST version/build: CST Studio Suite 2022 (Version 2022.5 — Jun 03 2022, per `Model.mod` header)
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 15:07–15:17 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G3_BIAS_REPLAYSAFE_V2.cst`
- Execution method: fresh empty MWS project created via the GUI; macro created with
  `Macros → Make VBA Macro` and marked **Structure Macro**; executed via `Macros → Run Macro`
  (not the ordinary VBA editor run path)

## Structure-macro confirmation
- Executed as a Structure Macro: **YES** (`Macros → Make VBA Macro…`, "Structure Macro" selected).
- Local edits to the authoritative macro: **NONE**.
- No project-creation command, helper subs, loops, `MsgBox` or solver-start command (flat macro).

## Build result (pre-save counts)
- Macro completed: YES
- CST project created/saved: YES — new file `RA_LNA_G3_BIAS_REPLAYSAFE_V2.cst`
- Brick solids: **38** (verified by expanded tree and `Model.mod`: `With Brick` count = 38)
- Via cylinders: **6** (verified by expanded Vias tree and `Model.mod`: `With Cylinder` count = 6):
  C5_GND_VIA, C3_GND_VIA, C4_GND_VIA, C8_GND_VIA, J3_GND_V1, J3_GND_V2
- Lumped elements: **7** (`Model.mod`: `With LumpedElement` count = 7):
  1. `L1_18nH`
  2. `C5_CAP`
  3. `C3_CAP`
  4. `C4_CAP`
  5. `R3_0R`
  6. `C8_10uF`
  7. `R4_3k32`
- Discrete ports: **2** (verified in tree and `Model.mod`):
  - `port1` at P1 (7.90, 9, cu_top) → P2 (7.90, 9, z_l2_top) — RF_OUT_VDD / U1 Pin-7 reference
  - `port2` at P1 (17.0, 15.1, cu_top) → P2 (17.0, 15.1, z_l2_top) — VIN5 / J3 +5 V reference
  - both S-parameter type, 50 Ω
- Frequency range configured: 0.5–3.0 GHz (`Model.mod`: `fmin = 0.5 fmax = 3.0`)
- Solver started: NO. No result data exists (build only).

## Copper-gap status (visual + `Model.mod` cross-check)
| Element | Gap status | Bridged only by |
|---|---|---|
| `L1_18nH` (L1_PAD_RF ↔ L1_PAD_VDD) | open, no copper short | `L1_18nH` |
| `C5_CAP` (VDD_LOCAL ↔ C5_GND) | open, no copper short | `C5_CAP` |
| `C3_CAP` (VDD_LOCAL ↔ C3_GND) | open, no copper short | `C3_CAP` |
| `C4_CAP` (VDD_LOCAL ↔ C4_GND) | open, no copper short | `C4_CAP` |
| `R3_0R` (R3_PAD1 ↔ R3_PAD2) | open, no copper short | `R3_0R` |
| `C8_10uF` (VIN pad ↔ GND pad) | open, no copper short | `C8_10uF` |
| `R4_3k32` (R4_PAD_LO ↔ R4_PAD_HI) | open, no copper short | `R4_3k32` |

## R4 branch topology
- `U1_PIN1_PAD → R4_STUB → R4_PAD_LO` is visibly connected (screenshot 05).
- `R4_PAD_HI` overlaps/connects the `VDD_LOCAL` bus as intended.
- `R4_3k32` bridges only the R4 lower/upper pad gap.
- VIN path: `VIN_H`/`VIN_V`/`J3_5V` continuous; `J3_GND` and both J3 ground vias (`J3_GND_V1`,
  `J3_GND_V2`) exist.
- Materials: `FR4_RA_LNA` (er=4.1, tanD=0.018), `PEC`, `Vacuum` — all present.

## Port checks
| Port | Type | P1 | Reference | Visual sanity |
|---|---|---|---|---|
| `port1` | Discrete port, S-parameter, 50 Ω | (7.90, 9, cu_top) | RF_OUT_VDD / U1 Pin-7 | red marker "1" visible at the RF_OUT node |
| `port2` | Discrete port, S-parameter, 50 Ω | (17.0, 15.1, cu_top) | VIN5 / J3 +5 V | red marker "2" visible at the VIN5/J3 node |

Both ports are present in the tree and visible in the 3D view before save and after both reopens.

## Reopen-integrity checks
### Reopen #1 (after full close)
- No `Processing history information` error.
- 38 brick solids remain (tree: PCB/Planes/Top/Vias components present).
- 6 via cylinders remain.
- All **7** lumped elements remain (lumped count = 7).
- Both ports remain (port count = 2).
- Materials and frequency range remain; history block `execute macro: RA_LNA_G3_REPLAYSAFE_V2`
  present and replayable.

### Reopen #2 (after full close, no mutation)
- No history error.
- All 7 lumped elements present (lumped count = 7).
- Both ports present (port count = 2).
- Geometry tree present (Components: PCB/Planes/Top/Vias; Materials).
- `.cst` and `Model.mod` modification times unchanged (15:14:52) — the verification did not
  mutate the evidence project.

## Warnings / errors
- None. No history replay error on either reopen; Messages pane free of errors.

## Compatibility patches
NONE. The macro was used exactly as provided.

## Offline integrity check (project closed, non-destructive file inspection)
- `RA_LNA_G3_BIAS_REPLAYSAFE_V2.cst`: size **55,917 B**, SHA256
  `097a33792f2b26e4067f659987fae7af1331aadf14865a4e1ab8f0f619dfe086`
- `Model/3D/Model.mod`: size **17,006 B**
- `Model/3D/Model.dsn`: `Number of ports: 2`
- `Model.mod` contains **zero** occurrences of: `SetCommonUnitsAndMaterials`, `BuildStack`,
  `Sub Main`, `MsgBox`
- `Model.mod` native-command counts: `With Brick` 38, `With Cylinder` 6, `With LumpedElement` 7,
  all seven lumped names exactly 1× each, `C2_100pF` 0 (correct for G3 — output path removed),
  `PortNumber "1"` 1, `PortNumber "2"` 1, frequency range fmin 0.5 / fmax 3.0

## Visual evidence
- `SCREENSHOT_01_BUILT_OVERVIEW.png` — built model overview before save (whole bias-network board, both ports)
- `SCREENSHOT_02_RF_OUT_L1_CLOSEUP.png` — RF_OUT_VDD node, port1, L1 structure and decoupling area
- `SCREENSHOT_03_DECOUPLING_AND_R3.png` — C5/C3/C4 decoupling caps and R3_0R link
- `SCREENSHOT_04_C8_VIN_J3_CLOSEUP.png` — C8_10uF pads, VIN bus, port2 and J3 area
- `SCREENSHOT_05_R4_BRANCH_CLOSEUP.png` — R4_3k32 branch (U1 Pin-1 side → VDD_LOCAL) and L1_18nH marker
- `SCREENSHOT_06_LUMPED_PORTS_TREE.png` — Lumped tree (7 elements) + Ports tree (port1/port2)
- `SCREENSHOT_07_HISTORY_BEFORE_SAVE.png` — History List with the single `execute macro: …` block before save
- `SCREENSHOT_08_REOPEN1_TREE_PORTS_LUMPED.png` — after reopen #1: all 7 lumped elements and both ports
- `SCREENSHOT_09_REOPEN1_HISTORY_NO_ERROR.png` — after reopen #1: history block present, no error dialog
- `SCREENSHOT_10_REOPEN2_TREE_PORTS_LUMPED.png` — after reopen #2: all 7 lumped elements and both ports intact
- `SCREENSHOT_11_VIAS_6_TREE.png` — expanded Vias tree showing all 6 via cylinders

## Modeling note
G3 still uses idealized/simple lumped screening values. Per reviewer note this does not block the
build-only persistence/topology gate; a G3 build-only PASS is not an RF-performance PASS. The later
G3 solver stage requires a separate reviewer decision on parasitic-aware RLC or vendor S-parameter
models for C3/C4/C5/C8.

## Reviewer questions / uncertainties
1. Confirm the flat Structure-Macro pattern is accepted for G3 (bias-only topology, ports directly at RF_OUT_VDD and VIN5/J3).
2. Confirm the R4 branch representation (R4_3k32 bridging only the pad gap, R4_PAD_HI overlapping VDD_LOCAL) matches the intended topology.

## Conclusion
All G3 replay-safe acceptance checks passed. `FINAL_STATUS=CST_G3_REPLAY_SAFE_BUILD_ONLY_PASS`.
This gate is ready for remote review. Per instruction, no further gate (G4) was started and
no solver was authorized.
