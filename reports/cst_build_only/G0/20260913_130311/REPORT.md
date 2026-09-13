# G0 Build-Only Report — replay-safe structure-macro validation (PASS)

Run ID: `20260913_130311` (G0 replay-safe re-run, flattened Structure Macro V2)

## Status
FINAL_STATUS=CST_G0_REPLAY_SAFE_BUILD_ONLY_PASS
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> Two full close/reopen cycles were verified: geometry, materials, history and both ports
> survive with no history-replay error. No solver, sweep, optimizer or mesh adaptation was
> started. This run follows the reviewer instruction in
> `docs/NEXT_ACTION_CST_G0_REPLAY_SAFE_20260913.md`.

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F
- Gate macro source: `source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas` (authoritative, as provided)
- Macro actually executed: exact contents of the above file, retained here as `MACRO_USED.bas`
  - macro file SHA256: `cbc7e0c3e3f91eef6a971a4768571e610d6bdddb6b3826b50686bb1ee807b74c`
  - repository commit that introduced the macro: `f848972ee33fa034f505e59fdc4710c16e79efc0`
  - **no local edit was made to the authoritative macro** (pasted verbatim, verified before running)
- CST version/build: CST Studio Suite 2022 (Version 2022.5 — Jun 03 2022, per `Model.mod` header)
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 13:03–13:18 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G0_PREFLIGHT_REPLAYSAFE_V2.cst`
- Execution method: fresh empty MWS project created via the GUI; macro created with
  `Macros → Make VBA Macro` and marked **Structure Macro**; executed via `Macros → Run Macro`
  (not the ordinary VBA editor run path)

## Structure-macro confirmation
- Executed as a Structure Macro: **YES** (`Macros → Make VBA Macro…`, "Structure Macro" selected).
- Local edits to the authoritative macro: **NONE**.
- `FileNew`/`NewMWS`, helper subs, loops and `MsgBox` are absent by design (flat macro, only
  native CST commands).

## Build result
- Macro completed: YES
- CST project created/saved: YES — new file `RA_LNA_G0_PREFLIGHT_REPLAYSAFE_V2.cst`
- Number of components: 3 (`PCB`, `Planes`, `Top`)
- Number of solids/sheets: 7 brick solids (CORE, PP_BOTTOM, PP_TOP, L2_GND, L3_GND, L4_GND, TRACE)
- Port count before save: **2** (`port1`, `port2`)
- Port count after reopen #1: **2**
- Port count after reopen #2: **2**
- Frequency range configured: 0.5–3.0 GHz (present in saved `Model.mod` header:
  `'# frequency range: fmin = 0.5 fmax = 3.0`)
- Solver started: NO

## Geometry / topology checks
- `PCB → PP_TOP`: FR4 brick, x 0–8, y 0–6 mm, z −h12…0
- `PCB → CORE`: FR4 brick, x 0–8, y 0–6 mm, z z_core_bot…z_l2_bot
- `PCB → PP_BOTTOM`: FR4 brick, x 0–8, y 0–6 mm, z z_bot_pp_bot…z_l3_bot
- `Planes → L2_GND`: PEC brick, x 0–8, y 0–6 mm, z z_l2_bot…z_l2_top
- `Planes → L3_GND`: PEC brick, x 0–8, y 0–6 mm, z z_l3_bot…z_l3_top
- `Planes → L4_GND`: PEC brick, x 0–8, y 0–6 mm, z z_bot_cu_min…z_bot_cu_max
- `Top → TRACE`: PEC brick, x 1–7, y 3−trace_w/2…3+trace_w/2, z 0…cu_top
- Materials: `FR4_RA_LNA` (er=4.1, tanD=0.018), `PEC`, `Vacuum`
- Lumped elements: none (as designed for G0)
- Boundaries: all six faces "expanded open"
- Verified visually after build, after reopen #1 and after reopen #2 — identical tree each time.

## Port checks
| Port | Type | P1 | P2 | Intended reference | Visual sanity |
|---|---|---|---|---|---|
| `port1` | Discrete port, S-parameter, 50 Ω | (1.2, 3, cu_top) | (1.2, 3, z_l2_top) | L2 ground plane | red marker "1" visible |
| `port2` | Discrete port, S-parameter, 50 Ω | (6.8, 3, cu_top) | (6.8, 3, z_l2_top) | L2 ground plane | red marker "2" visible |

Both ports are present in the tree and visible in the 3D view before save and after both reopens.

## Stack-up / materials
- JLC04161H-3313 baseline: L1 Cu 0.035 / 3313 0.0994 / L2 Cu 0.0152 / core 1.265 / L3 Cu 0.0152 /
  3313 0.0994 / L4 Cu 0.035 mm; `er=4.1`, `tanD=0.018`, `trace_w=0.1565 mm`
- Copper modeled as PEC in v0.1 (deliberate simplification per package README)

## History replay verification
- Before save: History List shows one block `execute macro: RA_LNA_G0_REPLAYSAFE_V2`. Opening
  the block ("Edit History List Item") shows the recorded commands are the flat native command
  sequence (StoreParameter ×16, Units, Material, `Solver.FrequencyRange "0.5","3.0"`, 7× Brick,
  2× DiscretePort, Boundary) — **no helper-sub names**.
- Reopen #1: project opened with **no** "Processing history information" error; history block
  present; both ports restored.
- Reopen #2: same result — ports and history intact.
- No warning/error dialog appeared during either reopen.

## Warnings / errors
- None. No history replay error on either reopen.

## Compatibility patches
NONE. The macro was used exactly as provided.

## Offline integrity check (project closed, non-destructive file inspection)
- `RA_LNA_G0_PREFLIGHT_REPLAYSAFE_V2.cst`: size **33,603 B**, SHA256
  `a8ef32026eba4d9c978893244638c6b15a4216f4cc4b2019e0f9702b79b88b04`
- `Model/3D/Model.mod`: size **4,345 B**
- `Model/3D/Model.dsn`: `Number of ports: 2`
- `Model.mod` contains **zero** occurrences of: `SetCommonUnitsAndMaterials`, `BuildStack`,
  `AddBrickPEC`, `AddDiscretePortToL2`, `SetOpenBoundaries`, `Sub Main`, `MsgBox`
- `.cst` and `Model.mod` modification times remained 13:14:52 across both reopen cycles —
  the verification did not mutate the evidence project.

## Visual evidence
- `SCREENSHOT_01_BUILT_OVERVIEW.png` — built model overview before save; Messages pane free of errors
- `SCREENSHOT_02_BUILT_PORTS_AND_TREE.png` — pre-save navigation tree: 7 solids, materials,
  `Ports → port1, port2`; both ports visible in the 3D view
- `SCREENSHOT_03_HISTORY_BEFORE_SAVE.png` — History List with the single `execute macro: …` block before save
- `SCREENSHOT_04_REOPEN1_PORTS_AND_TREE.png` — after reopen #1: tree (7 solids / materials / ports)
  and model with both ports; no error
- `SCREENSHOT_05_REOPEN1_HISTORY_NO_ERROR.png` — after reopen #1: history block present, no error dialog
- `SCREENSHOT_06_REOPEN2_PORTS_AND_TREE.png` — after reopen #2: ports and tree intact
- `SCREENSHOT_07_HISTORY_COMMANDS_FLAT.png` — recorded block contents (flat native commands only)

## Reviewer questions / uncertainties
1. Confirm that this flat Structure-Macro pattern is accepted as the replay-safe template to
   convert G1–G4.
2. The project was saved with no solver results (none exist — build only). Confirm the
   `Save results` dialog option is irrelevant for this build-only pass.

## Conclusion
All replay-safe acceptance checks passed. `FINAL_STATUS=CST_G0_REPLAY_SAFE_BUILD_ONLY_PASS`.
This gate is ready for remote review. Per instruction, no further gate (G1–G4) was started and
no solver was authorized.
