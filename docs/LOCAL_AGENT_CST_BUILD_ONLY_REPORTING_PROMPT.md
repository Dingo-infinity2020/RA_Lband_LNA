# Local Agent Prompt — CST Build-Only Gate Reporting to GitHub

You are working on repository `Dingo-infinity2020/RA_Lband_LNA`.

Current hardware baseline: **RA-LNA-L1 V1.0F**. PCB geometry is frozen for pre-fabrication simulation review. Do not alter Gerbers, BOM/CPL, PCB geometry, or manufacturing files unless explicitly instructed in a later task.

Your current task is to execute **one CST build-only gate at a time**, beginning with G0, and upload a complete review package to GitHub so a remote reviewer can inspect the result without direct access to the CST workstation.

## Absolute safety / workflow rules

1. **BUILD ONLY. DO NOT RUN ANY SOLVER.**
   - Do not call or click `Solver.Start`, `FDSolver.Start`, Time Domain Solver, Frequency Domain Solver, Parameter Sweep, Optimizer, or any equivalent solve/start command.
   - Do not launch mesh adaptation or simulation.
2. Do not edit the manufacturing baseline or V1.0F Gerbers.
3. Do not silently modify the supplied gate macro to make it “look successful.” If a macro fails, preserve the original error and report it.
4. If a minimal compatibility patch is required for CST 2022 VBA/API syntax, create a clearly named patched copy and document the exact diff and reason. Never overwrite the original supplied macro without retaining provenance.
5. Execute gates sequentially. Do not proceed to the next gate until the current gate has been built, visually inspected, reported, committed, and explicitly approved by the user/reviewer.
6. Never force-push, rewrite history, delete previous gate evidence, or squash away failed attempts.
7. Do not commit CST cache/temp/autosave files or multi-GB result directories.

## Repository output layout

For each gate, create a new directory under:

`reports/cst_build_only/<gate>/<run_id>/`

For example:

`reports/cst_build_only/G0/20260913_113500/`

The directory should contain, where applicable:

- `REPORT.md` — mandatory human-readable report.
- `BUILD_LOG.txt` — full macro/build console output, including warnings/errors.
- `MACRO_USED.bas` — exact macro that was executed. If patched, this must be the patched copy and the report must name the original source macro.
- `MACRO_DIFF.patch` — mandatory if the supplied macro was changed.
- `MODEL_TREE.txt` — object/component/port/material tree or a manually exported equivalent.
- `PARAMETERS.txt` — all relevant CST project parameters and their final values.
- `SCREENSHOT_01_OVERVIEW.png` — mandatory overall 3D model screenshot.
- `SCREENSHOT_02_PORTS.png` — port placement/labels visible.
- `SCREENSHOT_03_STACKUP.png` — stack-up/material/thickness evidence where relevant.
- additional `SCREENSHOT_XX_*.png` files for anything that needs close inspection.
- `STATUS.json` — compact machine-readable status summary.

Do **not** commit the `.cst` project by default. If the project is small and the user explicitly asks for it, it may be uploaded separately. Otherwise keep the local project path recorded in `REPORT.md`.

## Required REPORT.md content

Use this structure:

```markdown
# <Gate> Build-Only Report

## Status
FINAL_STATUS=<PASS | PASS_WITH_WARNINGS | FAIL>
BUILD_ONLY_CONFIRMED=<YES | NO>
SOLVER_RUN=<NO | YES>

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F
- Gate macro source: <path/name>
- Macro actually executed: <path/name>
- CST version/build: <exact version if visible>
- OS / host: <brief identification>
- Run timestamp: <local ISO timestamp>
- Local CST project path: <path>

## Build result
- Macro completed: YES/NO
- CST project created/saved: YES/NO
- Number of components: <n or unknown>
- Number of solids/sheets: <n or unknown>
- Number of ports: <n>
- Frequency range configured: <range>
- Solver started: NO

## Geometry / topology checks
Describe each required object and whether it exists in the expected place. Include dimensions/coordinates when available.

## Port checks
For every port, record:
- name/number
- type
- terminal faces/objects
- orientation/polarity
- intended reference conductor
- visual sanity result

## Stack-up / materials
Record dielectric thicknesses, copper thicknesses, epsilon_r, loss tangent, and any simplifications.

## Warnings / errors
Copy the exact important warnings/errors. Do not paraphrase away errors.

## Compatibility patches
If none: `NONE`.
If any: explain every change and why it was required. Reference `MACRO_DIFF.patch`.

## Visual evidence
List each screenshot and what it proves.

## Reviewer questions / uncertainties
Explicitly list anything that the remote reviewer should inspect before allowing the next gate.

## Conclusion
State whether this gate is ready for remote review. Do not authorize the next gate yourself.
```

## STATUS.json schema

Use a simple object like:

```json
{
  "gate": "G0",
  "run_id": "20260913_113500",
  "final_status": "PASS",
  "build_only_confirmed": true,
  "solver_run": false,
  "macro_completed": true,
  "ports_count": 2,
  "frequency_range_ghz": [0.5, 3.0],
  "compatibility_patch_applied": false,
  "review_required": true
}
```

## Screenshot requirements

Screenshots must be useful engineering evidence, not decorative captures.

For G0 specifically, capture at minimum:
1. full 3D model overview with axes/grid if useful;
2. both discrete ports clearly visible/labeled;
3. PCB stack-up or layer/material geometry from a side/section-like angle;
4. CST navigation/model tree showing expected objects/components.

For later gates, add close-ups of SMA/PCB launch, RF trace transitions, lumped elements, bias path, and full-board input/output spatial relationship as applicable.

## Git workflow

After creating the report package:

1. `git status` and confirm no unrelated files are staged.
2. Add only the current gate's report/evidence files.
3. Commit with message:
   - `CST G0 build-only report: <PASS/FAIL summary>`
   - analogous wording for later gates.
4. Push to `origin/main` unless the repository state indicates a different instructed branch.
5. Record the resulting commit SHA in the final local response.
6. Do not start the next gate after pushing.

## G0 stop condition

For the first run, execute **G0 only**. Once the G0 report and screenshots are pushed, stop and report:

- `FINAL_STATUS`
- Git commit SHA
- report path
- whether any macro patch was required
- whether any solver was run (must be NO)

Then wait for review/approval before G1.
