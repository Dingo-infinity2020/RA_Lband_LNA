# G1 Build-Only Report — replay-safe structure-macro validation (PASS)

Run ID: `20260913_140307` (G1 replay-safe re-run, flattened Structure Macro V2)

## Status
FINAL_STATUS=CST_G1_REPLAY_SAFE_BUILD_ONLY_PASS
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> Two full close/reopen cycles were verified: geometry (31 bricks + 7 vias), materials,
> history, `C1_100pF` lumped element and both discrete ports survive with no history-replay
> error. No solver, sweep, optimizer or mesh adaptation was started. This run follows the
> reviewer instruction in `docs/NEXT_ACTION_CST_G1_REPLAY_SAFE_20260913.md`.

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F
- Gate macro source: `source/cst/G1_REPLAY_SAFE_STRUCTURE_V2.bas` (authoritative, as provided)
- Introducing commit: `888c3a97669039ff38b1784e65575cb6833d3319` ("Add replay-safe flattened CST G1 structure macro")
- Macro actually executed: exact contents of the above file, retained here as `MACRO_USED.bas`
  - macro file SHA256: `c73bcd285919069d936fccf99f6414ea5bd8a684121e533d3133319aeb4a19a3`
  - **no local edit was made to the authoritative macro** (pasted verbatim)
- CST version/build: CST Studio Suite 2022 (Version 2022.5 — Jun 03 2022, per `Model.mod` header)
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 14:03–14:18 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G1_INPUT_REPLAYSAFE_V2.cst`
- Execution method: fresh empty MWS project created via the GUI; macro created with
  `Macros → Make VBA Macro` and marked **Structure Macro**; executed via `Macros → Run Macro`
  (not the ordinary VBA editor run path)

## Structure-macro confirmation
- Executed as a Structure Macro: **YES** (`Macros → Make VBA Macro…`, "Structure Macro" selected).
- Local edits to the authoritative macro: **NONE**.
- No project-creation command, helper subs, loops, `MsgBox` or solver-start command (flat macro).

## Build result (pre-save counts)
- Macro completed: YES
- CST project created/saved: YES — new file `RA_LNA_G1_INPUT_REPLAYSAFE_V2.cst`
- Brick solids: **31** — PCB: CORE, PP_BOTTOM, PP_TOP (3); Planes: L2_GND, L3_GND, L4_GND (3);
  Top: J1_SIG, J1_TAPER_0…J1_TAPER_15 (16), J1_GND_LO, J1_GND_HI, RF_IN_1, C1_PAD1, C1_PAD2,
  RF_IN_2, U1_PIN2_PAD, U1_EP (25). Verified by expanded tree (screenshots 08/09) and by
  `Model.mod` content (`J1_TAPER_` appears 16×, `C1_PAD` 2×).
- Via cylinders: **7** — J1_V1…J1_V4 (4), U1_GND34, U1_EP_A, U1_EP_B (2× 0.30 mm).
- Lumped elements: **1** — `C1_100pF` (RLCSerial, C = 100e-12 F, R = L = 0) under
  `Lumped Elements → Lumped`.
- Discrete ports: **2** — `port1` at (0.25, 9) (left SMA-side reference),
  `port2` at (6.50, 9) (U1 input reference); both S-parameter, 50 Ω, trace→L2 GND.
- Frequency range configured: 0.5–3.0 GHz (present in saved `Model.mod` header:
  `'# frequency range: fmin = 0.5 fmax = 3.0`)
- Solver started: NO. No result data exists (build only).

## Geometry / topology checks
- `J1_SIG` 0–3.81 mm + 16-step taper `J1_TAPER_0…15` from 1.20 mm down to `trace_w` (0.1565 mm),
  narrowing monotonically toward the microstrip end; all 16 taper bricks exist (screenshots 08/09).
- `J1_GND_LO` (y 4.85–7.55) and `J1_GND_HI` (y 10.45–13.15) launch ground clamps;
  `J1_V1…V4` ground vias at (1.1, 7.9), (1.1, 10.1), (2.4, 7.9), (2.4, 10.1), Ø 0.35 mm.
- `RF_IN_1` (4.35–4.40) feeds `C1_PAD1` (4.40–4.95); `C1_PAD2` (5.25–5.80) feeds `RF_IN_2`
  (5.35–6.285) and `U1_PIN2_PAD` (6.285–6.715).
- **C1 pad gap**: `C1_PAD1` ends at x = 4.95, `C1_PAD2` starts at x = 5.25 → 0.30 mm open gap,
  bridged only by the lumped `C1_100pF` (P1 4.95 → P2 5.25 at y = 9, z = cu_top). No copper
  short between the pads — visually confirmed (screenshot 02/03).
- `U1_EP` ground paddle (6.81–7.59 × 7.95–9.55) with two Ø 0.30 mm vias `U1_EP_A`/`U1_EP_B`;
  `U1_GND34` via at (5.65, 8.25).
- Materials: `FR4_RA_LNA` (er=4.1, tanD=0.018), `PEC`, `Vacuum`.
- Boundaries: all six faces "expanded open".
- Verified visually after build, after reopen #1 and after reopen #2.

## Port checks
| Port | Type | P1 | P2 | Intended reference | Visual sanity |
|---|---|---|---|---|---|
| `port1` | Discrete port, S-parameter, 50 Ω | (0.25, 9, cu_top) | (0.25, 9, z_l2_top) | L2 ground plane | red marker "1" visible at left launch |
| `port2` | Discrete port, S-parameter, 50 Ω | (6.50, 9, cu_top) | (6.50, 9, z_l2_top) | L2 ground plane | red marker "2" visible at U1 input |

Both ports are present in the tree and visible in the 3D view before save and after both reopens.

## Reopen-integrity checks
### Reopen #1 (after full close)
- No `Processing history information` error.
- 31 brick solids remain (tree: PCB/Planes/Top/Vias components present; Vias shows all 7).
- 7 via cylinders remain.
- `C1_100pF` remains (Lumped Elements → Lumped → C1_100pF) — **lumped count = 1**.
- Both ports remain — **port count = 2**.
- Materials (`FR4_RA_LNA`, `PEC`, `Vacuum`) remain; frequency range remains 0.5–3.0 GHz.
- History block `execute macro: RA_LNA_G1_REPLAYSAFE_V2` present and replayable.

### Reopen #2 (after full close, no mutation)
- No history error.
- `C1_100pF` present — **lumped count = 1**.
- Both ports present — **port count = 2**.
- Geometry tree present (Components: PCB/Planes/Top/Vias; Materials).
- `.cst` and `Model.mod` modification times unchanged (14:12:45 / 14:12:44) — the verification
  did not mutate the evidence project.

## Warnings / errors
- None. No history replay error on either reopen; Messages pane free of errors.

## Compatibility patches
NONE. The macro was used exactly as provided.

## Offline integrity check (project closed, non-destructive file inspection)
- `RA_LNA_G1_INPUT_REPLAYSAFE_V2.cst`: size **49,644 B**, SHA256
  `c65b2b739f287e46b4c8af9c9dbc2a506f078e559938e643a00b1f5fdd3192e2`
- `Model/3D/Model.mod`: size **12,893 B**
- `Model/3D/Model.dsn`: `Number of ports: 2`
- `Model.mod` contains **zero** occurrences of: `SetCommonUnitsAndMaterials`, `BuildStack`,
  `AddBrickPEC`, `AddDiscretePortToL2`, `SetOpenBoundaries`, `Sub Main`, `MsgBox`
- `Model.mod` command counts: `J1_TAPER_` 16, `C1_PAD` 2, `C1_100pF` 1, `PortNumber "1"` 1,
  `PortNumber "2"` 1, frequency range fmin 0.5 / fmax 3.0
- Project also stores the macro source: `RA_LNA_G1_REPLAYSAFE_V2.mcs` (13,817 B)

## Visual evidence
- `SCREENSHOT_01_BUILT_OVERVIEW.png` — built model overview before save (whole board, both ports)
- `SCREENSHOT_02_INPUT_LAUNCH_CLOSEUP.png` — close-up of the left launch / taper / C1 / port area
- `SCREENSHOT_03_C1_LUMPED_AND_PORTS.png` — C1 area with the `C1_100pF` lumped marker and both ports; tree shows `Lumped Elements → Lumped → C1_100pF`
- `SCREENSHOT_04_HISTORY_BEFORE_SAVE.png` — History List with the single `execute macro: …` block before save
- `SCREENSHOT_05_REOPEN1_TREE_PORTS_LUMPED.png` — after reopen #1: full tree with `C1_100pF` and `port1`/`port2`
- `SCREENSHOT_06_REOPEN1_HISTORY_NO_ERROR.png` — after reopen #1: history block present, no error dialog
- `SCREENSHOT_07_REOPEN2_TREE_PORTS_LUMPED.png` — after reopen #2: `C1_100pF` and both ports intact
- `SCREENSHOT_08_TAPERS_TREE_PART1.png` / `SCREENSHOT_09_TAPERS_TREE_PART2.png` — expanded Top component showing all 16 taper bricks
- `SCREENSHOT_10_VIAS_7_TREE.png` — expanded Vias component showing all 7 via cylinders

## Reviewer questions / uncertainties
1. Confirm that the flat Structure-Macro pattern is accepted for G1 (first lumped-element gate)
   and can be promoted to G2–G4.
2. Confirm the C1 pad-gap representation (0.30 mm gap bridged only by the ideal lumped capacitor)
   matches the intended reference-plane modeling for this gate.

## Conclusion
All G1 replay-safe acceptance checks passed. `FINAL_STATUS=CST_G1_REPLAY_SAFE_BUILD_ONLY_PASS`.
This gate is ready for remote review. Per instruction, no further gate (G2–G4) was started and
no solver was authorized.
