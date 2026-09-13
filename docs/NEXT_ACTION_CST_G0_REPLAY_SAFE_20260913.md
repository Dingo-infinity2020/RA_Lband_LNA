# Next action — CST G0 replay-safe structure-macro validation

Date: 2026-09-13
Reviewer decision: **HOLD G1–G4 and all solvers. Fix G0 persistence first.**

## Review of the latest push

The latest G0 evidence is useful and the failure is real, not cosmetic.

Observed sequence:

1. The first build-only G0 macro built the intended geometry and two discrete ports in-session.
2. Because it was executed from the ordinary VBA Macro Editor, the saved project did not contain replayable modeling history for the ports/lumped objects; geometry survived but ports disappeared after reopen.
3. Fix attempt 1 correctly switched to a CST Structure Macro and produced a history block, but the history replay failed because the recorded `Sub Main` contained calls to private helper procedures such as `SetCommonUnitsAndMaterials` and `BuildStack`.
4. Therefore the current blocker is **CST model persistence/history replay**, not RF geometry and not the PCB baseline.

The proposed remedy is approved: use a deliberately flattened Structure Macro whose `Sub Main` contains only native CST commands.

Authoritative candidate macro for the next run:

`source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas`

Do not modify G1–G4 yet.

---

## Exact next run: G0 only

### Absolute rules

- BUILD ONLY.
- DO NOT start any solver.
- DO NOT start mesh adaptation, optimizer, parameter sweep, or frequency/time-domain simulation.
- DO NOT alter V1.0F Gerber/BOM/CPL/PCB geometry.
- DO NOT overwrite previous failed G0 evidence or project files.
- DO NOT proceed to G1 after this run, even if G0 passes.

### Procedure

1. Pull latest `main`.
2. In CST Studio Suite 2022, create/open a **fresh empty Microwave Studio project using the GUI**.
3. Create a new VBA macro with CST's `Macros -> Make VBA Macro` workflow and make it a **Structure Macro**.
4. Use the exact contents of:

   `source/cst/G0_REPLAY_SAFE_STRUCTURE_V2.bas`

   Do not add `FileNew`, `NewMWS`, helper subs, loops, `MsgBox`, solver calls, or convenience wrappers.
5. Execute it through the **Structure Macro / Run Macro path**, not the ordinary VBA editor run path.
6. Before saving, verify in-session:
   - components: `PCB`, `Planes`, `Top`;
   - seven brick solids total;
   - material `FR4_RA_LNA` exists;
   - `port1` and `port2` both exist;
   - frequency range is 0.5–3.0 GHz;
   - no solver/result tree has been created by a solve.
7. Save as a NEW file, for example:

   `RA_LNA_G0_PREFLIGHT_REPLAYSAFE_V2.cst`

8. Record SHA256 and file size.
9. Close the project completely.
10. Reopen the saved `.cst`.
11. Reopen acceptance checks:
    - no `Processing history information` error;
    - geometry is present;
    - both ports are present;
    - `FR4_RA_LNA` exists;
    - history list is present/replayable;
    - frequency range remains 0.5–3.0 GHz;
    - solver was not run.
12. Save nothing during this verification unless CST requires it; avoid mutating the evidence project unnecessarily.
13. Close and reopen the SAME file a **second time** and repeat the port/history sanity check. This second reopen is required to rule out a one-time transient state.

### Optional offline integrity check

After CST is closed, inspect the saved `.cst` container non-destructively if convenient:

- record `Model/3D/Model.mod` size;
- record whether `Model.dsn` reports two ports;
- search `Model.mod` for unresolved helper names such as:
  - `SetCommonUnitsAndMaterials`
  - `BuildStack`
  - `AddBrickPEC`
  - `AddDiscretePortToL2`
  - `SetOpenBoundaries`

Expected result: none of those helper names should appear in the replay history produced by the new flat macro.

---

## Required evidence package

Create a new run directory:

`reports/cst_build_only/G0/<new_run_id>/`

Include at minimum:

- `REPORT.md`
- `BUILD_LOG.txt`
- `MACRO_USED.bas`
- `STATUS.json`
- `SCREENSHOT_01_BUILT_OVERVIEW.png`
- `SCREENSHOT_02_BUILT_PORTS_AND_TREE.png`
- `SCREENSHOT_03_HISTORY_BEFORE_SAVE.png`
- `SCREENSHOT_04_REOPEN1_PORTS_AND_TREE.png`
- `SCREENSHOT_05_REOPEN1_HISTORY_NO_ERROR.png`
- `SCREENSHOT_06_REOPEN2_PORTS_AND_TREE.png`

If any error appears, capture it exactly and stop.

### REPORT.md must explicitly state

- whether the macro was executed as a Structure Macro;
- whether any local edit was made to the authoritative macro;
- port count before save, after reopen #1, and after reopen #2;
- whether history replay showed any warning/error;
- CST file size + SHA256;
- `Model.mod` size if inspected;
- `SOLVER_RUN=NO`;
- the exact commit SHA of the macro used.

### Verdict rules

Only declare:

`FINAL_STATUS=CST_G0_REPLAY_SAFE_BUILD_ONLY_PASS`

if ALL are true:

- build completes;
- two ports exist before save;
- two ports exist after first reopen;
- two ports exist after second reopen;
- no history replay error occurs;
- model geometry/materials survive reopen;
- solver was never run.

Otherwise use:

`FINAL_STATUS=CST_G0_REPLAY_SAFE_BUILD_ONLY_HOLD`

and stop.

---

## What happens after G0 passes

Do not independently run G1–G4.

After the G0 PASS evidence is pushed, the next reviewer action will be:

1. accept or reject the flat-Structure-Macro pattern;
2. convert G1–G4 to replay-safe versions using the validated pattern;
3. rebuild/reopen-review each gate sequentially;
4. only after all build-only gates are persistent and visually accepted will any solver be authorized.

## Current project state

- PCB baseline: **RA-LNA-L1 V1.0F**
- PCB geometry: **frozen**
- Fabrication: **HOLD**
- CST G0 first pass: **FAIL — persistence defect**
- CST G0 structure-macro attempt 1: **FAIL — helper calls not replay-safe**
- Next action: **run `G0_REPLAY_SAFE_STRUCTURE_V2.bas` as a Structure Macro and prove two clean reopen cycles**
- G1–G4: **HOLD**
- Solver authorization: **NO**
