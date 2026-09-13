# G0 Build-Only Report — structure-macro re-record attempt

Run ID: `20260913_115800` (fix attempt 1 for the save-integrity defect of run `20260913_105328`)

## Status
FINAL_STATUS=FAIL
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> Purpose of this run: make the G0 model survive reopen by recording it through a structure
> macro (`Macros → Make VBA Macro` + `Macros → Run Macro`). The history **was** recorded, but
> reopening failed during history replay because the recorded block contains calls to the
> macro's private helper subs. Follow-up fix: flatten `Sub Main` to native CST commands only
> (see `docs/V1.0F_CST_SAVE_INTEGRITY_FINDING.md`).

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F
- Gate macro source: `G0_ENV_PREFLIGHT_BUILD_ONLY.bas` (patched) with the `FileNew` line removed
  → local `builds/structure_macros/G0_structure.bas`
- Macro actually executed: `G0_structure.bas`,
  SHA256 `c1387ccf50352976366cb54f9b23f37fc6f8bb1e63f7c21d13263525be275727`
  (copy in this package as `MACRO_USED.bas`)
- CST version/build: CST Studio Suite 2022
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 11:58–12:17 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G0_PREFLIGHT_BUILD.cst`
  (this run overwrote the run `20260913_105328` save; the on-disk `.cst` is the run-B save)

## Build result
- Macro completed: YES (completion MsgBox shown and dismissed; model built in a fresh project)
- CST project created/saved: YES (`Save As` over the existing G0 `.cst`, 33,986 B)
- Number of components: 3 (`PCB`, `Planes`, `Top`)
- Number of solids/sheets: 7 brick solids
- Number of ports: 2 (`port1`, `port2`) — present in session and at save time
- Frequency range configured: 0.5–3.0 GHz
- Solver started: NO

## Geometry / topology checks
Same macro body as run `20260913_105328` (identical parameters, stack, TRACE brick, ports);
only the `FileNew` line was removed because a structure macro is executed inside an
already-open fresh project. Geometry verified visually in-session; no unintended overlaps.

## Port checks
- `port1` at (1.2, 3), `port2` at (6.8, 3): discrete S-parameter 50 Ω ports on the
  TRACE→L2 GND gap, exactly as in run `20260913_105328`.
- At save time `Model\3D\Model.dsn` reported `Number of ports: 2`; both port markers are
  visible in `SCREENSHOT_03_SAVED_WITH_HISTORY.png`.
- After the failed reopen, the on-disk `Model.dsn` currently reports `Number of ports: 0`.

## Stack-up / materials
Unchanged from run `20260913_105328` (JLC04161H-3313; er=4.1, tanD=0.018; PEC copper).

## Warnings / errors
1. **History recording worked.** The History List shows one block
   `execute macro: RA_LNA_G0_ENV_PREFLIGHT_BUILD`; `Model.mod` grew from 209 B to 1,432 B;
   the project also stores the macro source (`RA_LNA_G0_ENV_PREFLIGHT_BUILD.mcs`, 7,620 B).
2. **Reopen failed** during "Processing history information":
   ```
   CST MICROWAVE STUDIO - History Error: Expecting an existing scalar var. (SetCommonUnitsAndMaterials)
   ```
   The recorded block stores the top-level `Sub Main` statements verbatim, including calls to
   the private helper subs (`SetCommonUnitsAndMaterials`, `BuildStack`, `AddBrickPEC`,
   `AddDiscretePortToL2`, `SetOpenBoundaries`) and the final `MsgBox`. History replay cannot
   resolve those private names, and the native commands inside the helper subs are not expanded.
3. After dismissing the error the model tree was empty (ports lost again). The project was
   closed without saving; the on-disk `.cst` remains the run-B save.

## Compatibility patches
NONE for this run. (Removing the `FileNew` line is a workflow change required for structure
macros, not an API patch; no RF geometry or parameter was changed.)

## Visual evidence
- `SCREENSHOT_01_RUN_MACRO_MENU.png` — `Macros → Run Macro → RA_LNA_G0_ENV_PREFLIGHT_BUILD`
  (the execution path that records history)
- `SCREENSHOT_02_HISTORY_BLOCK.png` — History List with the single recorded block
- `SCREENSHOT_03_SAVED_WITH_HISTORY.png` — saved project (title bar `RA_LNA_G0_PREFLIGHT_BUILD`),
  history entry present, ports visible in session
- `SCREENSHOT_04_REOPEN_HISTORY_ERROR.png` — exact replay error on reopen (Details expanded)
- `SCREENSHOT_05_REOPEN_EMPTY_MODEL.png` — empty model tree after the failed replay

## Reviewer questions / uncertainties
1. Confirm the proposed fix — flatten `Sub Main` so it contains only native CST commands
   (inline the helper subs; unroll loops/expressions as required; drop the trailing `MsgBox`) —
   before the next G0 re-run.
2. Decide whether the final re-run should keep or remove the completion MsgBox. If kept, it will
   pop up on every history replay when the project is opened.

## Conclusion
Not approvable. The history-recording mechanism is identified and works, but the recorded block
is not replay-safe. A flattened, replay-safe structure macro is required; see
`docs/V1.0F_CST_SAVE_INTEGRITY_FINDING.md`.
