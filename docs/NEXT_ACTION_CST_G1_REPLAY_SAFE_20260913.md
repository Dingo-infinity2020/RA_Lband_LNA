# Next action — CST G1 replay-safe build-only validation

Date: 2026-09-13
Reviewer decision: **G0 accepted. Authorize G1 BUILD-ONLY only. G2–G4 and all solvers remain HOLD.**

## Review decision on G0

Run `reports/cst_build_only/G0/20260913_130311/` is accepted as:

`FINAL_STATUS=CST_G0_REPLAY_SAFE_BUILD_ONLY_PASS`

The evidence is sufficient to establish the flat CST Structure-Macro pattern as replay-safe for geometry + discrete ports:

- exact authoritative macro used, no local edits;
- 7 brick solids and 2 ports before save;
- 2 ports after reopen #1;
- 2 ports after reopen #2;
- no history-replay error;
- saved `Model.mod` contains replayable native commands and no unresolved helper names;
- solver/sweep/optimizer/mesh adaptation were not run.

G0 therefore closes the original persistence blocker for **geometry + discrete ports**.

G1 is intentionally the next checkpoint because it adds the first `LumpedElement` (`C1_100pF`) and the parameterized SMA taper. This must be proven replay-safe before converting/running the larger G2–G4 models.

---

## Authoritative G1 macro

Use exactly:

`source/cst/G1_REPLAY_SAFE_STRUCTURE_V2.bas`

This is a flattened Structure Macro derived from the original G1 build-only topology. It contains no helper procedures, loops, completion dialogs, project-creation command, or solve-start command.

Expected nominal object counts after a successful build:

- Brick solids: **31**
- Cylindrical vias: **7**
- Lumped elements: **1** (`C1_100pF`)
- Discrete ports: **2**
- Frequency range: **0.5–3.0 GHz**

Expected key objects:

- `J1_SIG`
- `J1_TAPER_0` … `J1_TAPER_15`
- `J1_GND_LO`, `J1_GND_HI`
- `J1_V1` … `J1_V4`
- `RF_IN_1`
- `C1_PAD1`, `C1_PAD2`
- `C1_100pF`
- `RF_IN_2`
- `U1_PIN2_PAD`
- `U1_GND34`
- `U1_EP`, `U1_EP_A`, `U1_EP_B`
- `port1`, `port2`

---

## Exact G1 procedure

### Absolute rules

- BUILD ONLY.
- DO NOT run any solver.
- DO NOT run mesh adaptation, optimizer, parameter sweep, transient/frequency-domain simulation, or any solve command.
- DO NOT edit V1.0F PCB/Gerber/BOM/CPL.
- DO NOT locally modify the authoritative G1 macro. If it fails, capture the failure and stop.
- DO NOT proceed to G2 after this task even if G1 passes.

### Run

1. Pull latest `main`.
2. Create a **fresh empty Microwave Studio project through the GUI**.
3. Create a new **Structure Macro** using `Macros -> Make VBA Macro`.
4. Paste the exact contents of `source/cst/G1_REPLAY_SAFE_STRUCTURE_V2.bas`.
5. Save the macro and run it through `Macros -> Run Macro`.
6. Do not use the ordinary VBA editor execution path.

### Pre-save checks

Verify all of the following before saving:

- 31 brick solids;
- 7 via cylinders;
- `FR4_RA_LNA`, PEC and Vacuum materials exist;
- `C1_100pF` exists under Lumped Elements;
- `port1` and `port2` exist;
- port 1 is at the left SMA-side reference, port 2 at the U1 input reference;
- all 16 taper steps exist and narrow monotonically toward the microstrip end;
- C1 pads are separated by the lumped capacitor, not shorted by copper;
- U1 EP and its two 0.30 mm vias exist;
- frequency range is 0.5–3.0 GHz;
- there are no solver results.

Save as a NEW file, for example:

`RA_LNA_G1_INPUT_REPLAYSAFE_V2.cst`

Record file size and SHA256.

### Reopen-integrity checks

Close the project completely, then reopen the saved file twice.

After **reopen #1** verify:

- no `Processing history information` error;
- 31 brick solids remain;
- 7 vias remain;
- `C1_100pF` remains;
- both ports remain;
- materials and frequency range remain;
- history is present and replayable.

Close without mutation and perform **reopen #2**. Repeat at minimum:

- `C1_100pF` present;
- 2 ports present;
- geometry tree present;
- no history error.

The second reopen is mandatory.

---

## Required screenshots/evidence

Create:

`reports/cst_build_only/G1/<new_run_id>/`

Include at minimum:

- `REPORT.md`
- `BUILD_LOG.txt`
- `MACRO_USED.bas`
- `STATUS.json`
- `SCREENSHOT_01_BUILT_OVERVIEW.png`
- `SCREENSHOT_02_INPUT_LAUNCH_CLOSEUP.png`
- `SCREENSHOT_03_C1_LUMPED_AND_PORTS.png`
- `SCREENSHOT_04_HISTORY_BEFORE_SAVE.png`
- `SCREENSHOT_05_REOPEN1_TREE_PORTS_LUMPED.png`
- `SCREENSHOT_06_REOPEN1_HISTORY_NO_ERROR.png`
- `SCREENSHOT_07_REOPEN2_TREE_PORTS_LUMPED.png`

If any macro/API/history error occurs, capture it exactly and stop.

### REPORT.md must state

- exact macro source path and introducing commit SHA;
- whether any local edit occurred;
- brick/via/lumped/port counts before save;
- lumped-element count after reopen #1 and #2;
- port count after reopen #1 and #2;
- whether all 16 taper bricks exist;
- whether C1 pad gap is visually present;
- CST file size and SHA256;
- `Model.mod` size if inspected;
- `SOLVER_RUN=NO`.

### PASS condition

Use:

`FINAL_STATUS=CST_G1_REPLAY_SAFE_BUILD_ONLY_PASS`

only if all are true:

- build succeeds with the expected topology;
- `C1_100pF` exists before save and after both reopen cycles;
- both ports exist before save and after both reopen cycles;
- no history replay error occurs;
- taper/launch geometry visually matches intent;
- no solver/sweep/optimizer/mesh adaptation was run.

Otherwise:

`FINAL_STATUS=CST_G1_REPLAY_SAFE_BUILD_ONLY_HOLD`

and stop.

---

## After G1

Do not run G2–G4 automatically.

If G1 passes, the reviewer will then promote the same flat Structure-Macro pattern to the larger G2/G3/G4 models. G2 and G3 contain multiple lumped R/L/C elements, so G1 is the required persistence checkpoint first.

## Project state

- PCB baseline: **RA-LNA-L1 V1.0F**
- PCB geometry: **frozen**
- Fabrication: **HOLD**
- CST G0: **PASS — replay-safe geometry + ports verified**
- CST G1: **AUTHORIZED FOR BUILD-ONLY VALIDATION**
- CST G2–G4: **HOLD**
- Solver authorization: **NO**
