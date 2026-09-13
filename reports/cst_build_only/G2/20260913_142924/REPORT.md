# G2 Build-Only Report — replay-safe structure-macro validation (PASS)

Run ID: `20260913_142924` (G2 replay-safe re-run, flattened Structure Macro V2)

## Status
FINAL_STATUS=CST_G2_REPLAY_SAFE_BUILD_ONLY_PASS
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> Two full close/reopen cycles were verified: all geometry (58 bricks + 24 vias), materials,
> history, all seven lumped elements and both discrete ports survive with no history-replay
> error. No solver, sweep, optimizer or mesh adaptation was started. This run follows the
> reviewer instruction in `docs/NEXT_ACTION_CST_G2_REPLAY_SAFE_20260913.md`.

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F (geometry frozen)
- Gate macro source: `source/cst/G2_REPLAY_SAFE_STRUCTURE_V2.bas` (authoritative, as provided)
- Introducing commit: `9d45e8165d754b84a23969694c8cb3f55b03e046` ("Add replay-safe flattened CST G2 structure macro")
- Macro actually executed: exact contents of the above file, retained here as `MACRO_USED.bas`
  - macro file SHA256: `e82068f38ce2baa2c4474cf06150129c99942733fe389e4ed54f87649820c246`
  - **no local edit was made to the authoritative macro** (pasted verbatim)
- CST version/build: CST Studio Suite 2022 (Version 2022.5 — Jun 03 2022, per `Model.mod` header)
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 14:29–14:49 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G2_OUTPUT_REPLAYSAFE_V2.cst`
- Execution method: fresh empty MWS project created via the GUI; macro created with
  `Macros → Make VBA Macro` and marked **Structure Macro**; executed via `Macros → Run Macro`
  (not the ordinary VBA editor run path)

## Structure-macro confirmation
- Executed as a Structure Macro: **YES** (`Macros → Make VBA Macro…`, "Structure Macro" selected).
- Local edits to the authoritative macro: **NONE**.
- No project-creation command, helper subs, loops, `MsgBox` or solver-start command (flat macro).

## Build result (pre-save counts)
- Macro completed: YES
- CST project created/saved: YES — new file `RA_LNA_G2_OUTPUT_REPLAYSAFE_V2.cst`
- Brick solids: **58** (verified by expanded tree and by `Model.mod`: `With Brick` count = 58)
- Via cylinders: **24** (verified by expanded Vias tree and by `Model.mod`: `With Cylinder` count = 24)
  - List: C3_GND_VIA, C4_GND_VIA, C5_GND_VIA, C8_GND_VIA, GF_L1…GF_L7 (7), GF_U1…GF_U5 (5),
    J2_V1…J2_V4 (4), J3_GND_V1, J3_GND_V2, U1_EP_A, U1_EP_B
- Lumped elements: **7** (verified in tree and `Model.mod`: `With LumpedElement` count = 7):
  1. `L1_18nH` (18 nH bias choke)
  2. `C5_CAP`
  3. `C3_CAP`
  4. `C4_CAP`
  5. `R3_0R`
  6. `C8_10uF`
  7. `C2_100pF` (output DC block)
- Discrete ports: **2** — `port1` (U1 pin-7 / RF_OUT reference), `port2` (right launch / J2 reference);
  both present in tree; red markers "1" and "2" visible in 3D view.
- Frequency range configured: 0.5–3.0 GHz (`Model.mod`: `fmin = 0.5 fmax = 3.0`)
- Solver started: NO. No result data exists (build only).

## Key geometry checks (visual + macro/`Model.mod` cross-check)
- Right output launch: `J2_SIG` + all **16** `J2_TAPER_*` bricks exist
  (`Model.mod` `J2_TAPER_` count = 16) and widen monotonically toward the SMA signal land.
- Output RF line (`RF_OUT_LINE`) continuous from the C2 output side into the right-launch taper region.
- `C2_PAD1`/`C2_PAD2`: 0.30 mm copper gap retained; bridged only by lumped `C2_100pF`
  (no copper short — visually confirmed in screenshots 02/03).
- `L1_PAD_RF`/`L1_PAD_VDD`: gap retained; bridged only by `L1_18nH`.
- `R3_PAD1`/`R3_PAD2`: gap retained; bridged only by `R3_0R`.
- C5/C3/C4: each VDD_LOCAL-to-own-ground branch bridged through its lumped capacitor (C5_CAP/C3_CAP/C4_CAP),
  not through a copper short.
- C8: VIN/GND pads separated, bridged only by `C8_10uF`.
- Ground fence: all **12** `GF_*` vias exist (GF_L1…GF_L7, GF_U1…GF_U5; `Model.mod` `GF_` count = 12).
- U1: `U1_EP` ground paddle and both 0.30 mm EP vias (`U1_EP_A`, `U1_EP_B`) exist.
- VIN bus and `J3_5V` with `J3_GND`, `J3_GND_V1`, `J3_GND_V2` present.
- Old deleted SMA solder-land boundary drill hits were NOT reintroduced.
- Materials: `FR4_RA_LNA` (er=4.1, tanD=0.018), `PEC`, `Vacuum`.

## Port checks
| Port | Type | Reference | Visual sanity |
|---|---|---|---|
| `port1` | Discrete port, S-parameter, 50 Ω | U1 pin-7 / RF_OUT pad area | red marker "1" visible near C2/U1 pin7 |
| `port2` | Discrete port, S-parameter, 50 Ω | right launch (J2) | red marker "2" visible at right launch |

Both ports are present in the tree and visible in the 3D view before save and after both reopens.

## Reopen-integrity checks
### Reopen #1 (after full close)
- No `Processing history information` error.
- 58 brick solids remain (tree: PCB/Planes/Top/Vias components present).
- 24 via cylinders remain (Vias tree list complete).
- All **7** lumped elements remain (lumped count = 7).
- Both ports remain (port count = 2).
- Materials and frequency range remain; history block `execute macro: RA_LNA_G2_REPLAYSAFE_V2`
  present and replayable.

### Reopen #2 (after full close, no mutation)
- No history error.
- All 7 lumped elements present (lumped count = 7).
- Both ports present (port count = 2).
- Geometry tree present (Components: PCB/Planes/Top/Vias; Materials).
- `.cst` and `Model.mod` modification times unchanged (14:45:54) — the verification did not
  mutate the evidence project.

## Warnings / errors
- None from the macro or history replay. No history replay error on either reopen; Messages pane free of errors.
- Operational note (not a build issue): the first `Save As` attempt was rejected by the OS dialog
  because the typed path lost its backslashes (keyboard/IME artifact). The path was re-entered via
  clipboard paste; the save then completed normally. This affected only the GUI save dialog, not the
  macro, the model or the recorded history.

## Compatibility patches
NONE. The macro was used exactly as provided.

## Offline integrity check (project closed, non-destructive file inspection)
- `RA_LNA_G2_OUTPUT_REPLAYSAFE_V2.cst`: size **72,859 B**, SHA256
  `c199504fa3bfb275dd149427829a25f8c4943d5aed6885737960f0fedd7f7fb6`
- `Model/3D/Model.mod`: size **28,332 B**
- `Model/3D/Model.dsn`: `Number of ports: 2`
- `Model.mod` contains **zero** occurrences of: `SetCommonUnitsAndMaterials`, `BuildStack`,
  `Sub Main`, `MsgBox`
- `Model.mod` command counts: `With Brick` 58, `With Cylinder` 24, `With LumpedElement` 7,
  `J2_TAPER_` 16, `GF_` 12, all seven lumped names exactly 1× each, `PortNumber "1"` 1,
  `PortNumber "2"` 1, frequency range fmin 0.5 / fmax 3.0

## Visual evidence
- `SCREENSHOT_01_BUILT_OVERVIEW.png` — built model overview before save (whole board, both ports)
- `SCREENSHOT_02_OUTPUT_LAUNCH_CLOSEUP.png` — right output launch close-up (J2 taper, port2, fence)
- `SCREENSHOT_03_C2_AND_U1_PIN7.png` — C2_100pF, port1 (U1 pin7), pad gap and long RF line
- `SCREENSHOT_04_BIAS_NETWORK_LUMPED_TREE.png` — bias network area with Lumped tree (7 elements)
- `SCREENSHOT_05_VIA_FENCE_AND_RIGHT_LAUNCH.png` — ground-fence vias and right launch (medium view)
- `SCREENSHOT_06_HISTORY_BEFORE_SAVE.png` — History List with the single `execute macro: …` block before save
- `SCREENSHOT_07_REOPEN1_TREE_PORTS_LUMPED.png` — after reopen #1: full tree with all 7 lumped elements and both ports
- `SCREENSHOT_08_REOPEN1_HISTORY_NO_ERROR.png` — after reopen #1: history block present, no error dialog
- `SCREENSHOT_09_REOPEN2_TREE_PORTS_LUMPED.png` — after reopen #2: all 7 lumped elements and both ports intact
- `SCREENSHOT_10_VIAS_24_TREE.png` — expanded Vias tree showing all 24 via cylinders

## Modeling note
The C3/C5/C4/C8 values in this gate are idealized lumped screening models (1 uF / 10 uF not
trusted as ideal RF capacitors at GHz). Per reviewer note this does not block the build-only
persistence gate; RF parasitics will be treated in the later bias-network simulation stage.

## Reviewer questions / uncertainties
1. Confirm the flat Structure-Macro pattern is accepted for G2 (7 lumped elements + full output/bias topology).
2. Confirm the idealized C3/C4/C5/C8 models are acceptable for the G2 build-only gate as stated in the task.

## Conclusion
All G2 replay-safe acceptance checks passed. `FINAL_STATUS=CST_G2_REPLAY_SAFE_BUILD_ONLY_PASS`.
This gate is ready for remote review. Per instruction, no further gate (G3–G4) was started and
no solver was authorized.
